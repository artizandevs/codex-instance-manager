$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $root 'src\Core.ps1')
. (Join-Path $root 'src\Library.ps1')
$script:DataRoot = Join-Path $root ('work\test-' + [guid]::NewGuid().ToString('N'))
function Assert($Condition, $Message) { if (-not $Condition) { throw $Message } }
function Assert-Rejected([scriptblock]$Action, $Message) {
    $rejected = $false; try { & $Action | Out-Null } catch { $rejected = $true }; Assert $rejected $Message
}
Initialize-Store; Save-Store @()
$legacy = New-Profile 'Old worker' 'old-worker'
$legacy | Add-Member NoteProperty Repo (Join-Path $script:DataRoot 'old repo')
$legacy | Add-Member NoteProperty Workspace (Join-Path $script:DataRoot 'old worktree')
$legacy | Add-Member NoteProperty Branch 'codex/old'
$legacy | Add-Member NoteProperty Prompt 'Never launch this old draft'
Write-TextFile (Join-Path $legacy.Workspace 'keep.txt') 'Existing work remains untouched.'
$legacyMain = New-Profile 'Main' 'main' 'main' (Join-Path $script:DataRoot 'default-data')
Write-TextFile (Join-Path $legacyMain.CodexHome 'keep.txt') 'Default data remains untouched.'
Write-TextFile $script:StorePath (@{Version=1;Instances=@($legacy,$legacyMain)} | ConvertTo-Json -Depth 8)
Initialize-Store
$migrated = @(Get-Store)
Assert ($migrated.Count -eq 1 -and $migrated[0].Id -eq $legacy.Id) 'Worker migration failed'
Assert (-not $migrated[0].PSObject.Properties['Repo']) 'Old project settings survived migration'
Assert (Test-Path ($script:StorePath + '.before-simple-launcher.bak')) 'Migration backup missing'
Assert ([IO.File]::ReadAllText((Join-Path $legacy.Workspace 'keep.txt')).StartsWith('Existing')) 'Old worktree changed'
Assert ([IO.File]::ReadAllText((Join-Path $legacyMain.CodexHome 'keep.txt')).StartsWith('Default')) 'Default data changed'
Save-Store @(); Initialize-Store
Assert (@(Get-Store).Count -eq 0) 'An empty store gained unwanted profiles'
$script:MainHome = Join-Path $script:DataRoot 'fake main'
$worker = New-Profile 'Account with spaces & apostrophe' 'worker'
$other = New-Profile 'Other account' 'other'
Prepare-Brain $worker; Prepare-Brain $other
Assert ($worker.CodexHome -ne $other.CodexHome -and $worker.DesktopData -ne $other.DesktopData) 'Profiles share state folders'
foreach ($key in @('CODEX_ACCESS_TOKEN','OPENAI_API_KEY','CODEX_APP_SERVER_WS_URL','CODEX_APP_TOOLS_PIPE_PATH')) { [Environment]::SetEnvironmentVariable($key,'test-only-sentinel','Process') }
try {
    $plan = Get-LaunchPlan $worker 'C:\Program Files\Example\ChatGPT.exe'
    foreach ($key in @('CODEX_ACCESS_TOKEN','OPENAI_API_KEY','CODEX_APP_SERVER_WS_URL','CODEX_APP_TOOLS_PIPE_PATH')) { Assert (-not $plan.EnvironmentVariables.ContainsKey($key)) 'An inherited credential or connection override leaked' }
    Assert ($plan.EnvironmentVariables['CODEX_HOME'] -eq $worker.CodexHome -and $plan.EnvironmentVariables['CODEX_SQLITE_HOME'] -eq $worker.SqliteHome) 'Wrong worker environment'
    Assert ($plan.Arguments -eq (Quote-Argument ('--user-data-dir=' + $worker.DesktopData))) 'Launch includes old chat/project arguments'
} finally { foreach ($key in @('CODEX_ACCESS_TOKEN','OPENAI_API_KEY','CODEX_APP_SERVER_WS_URL','CODEX_APP_TOOLS_PIPE_PATH')) { [Environment]::SetEnvironmentVariable($key,$null,'Process') } }
Assert-Rejected { Get-LaunchPlan $legacyMain 'C:\Example\ChatGPT.exe' } 'Main launch allowed'
$invalid = New-Profile 'Invalid' 'invalid'; $invalid.CodexHome = $script:MainHome
Assert-Rejected { Prepare-Brain $invalid } 'Worker could write into main home'
Save-Profile $worker
$duplicate = New-Profile $worker.Name 'duplicate'
Assert-Rejected { Save-Profile $duplicate } 'Duplicate instance name accepted'
Write-TextFile (Join-Path $script:MainHome 'AGENTS.md') 'Main guidance sentinel'
Write-TextFile (Join-Path $script:MainHome 'memories\memory_summary.md') 'Main memory sentinel'
Write-TextFile (Join-Path $worker.CodexHome 'AGENTS.md') 'Worker guidance sentinel'
$worker.ShareBrain = $true; Prepare-Brain $worker; Prepare-Brain $worker
$guidance = [IO.File]::ReadAllText((Join-Path $worker.CodexHome 'AGENTS.md'))
Assert ($guidance.Contains('Worker guidance sentinel') -and $guidance.Contains('Main guidance sentinel')) 'Guidance lost'
Assert (([regex]::Matches($guidance,'codex-shared-brain:start')).Count -eq 1) 'Guidance duplicated'
$worker.ShareBrain = $false; Prepare-Brain $worker
Assert (-not [IO.File]::ReadAllText((Join-Path $worker.CodexHome 'AGENTS.md')).Contains('Main guidance sentinel')) 'Sharing could not be disabled'
Assert (-not (Test-Path (Join-Path $worker.CodexHome 'memories'))) 'Main memory store copied or linked'
$inputPath = Join-Path $script:DataRoot 'snapshot-source.jsonl'; $outputPath = Join-Path $script:DataRoot 'snapshot-target.jsonl'
Write-TextFile $inputPath "{`"ok`":true}`n{`"unfinished`":"
Assert (Copy-TranscriptSnapshot $inputPath $outputPath) 'Snapshot failed'
Assert ([IO.File]::ReadAllText($outputPath) -eq "{`"ok`":true}`n") 'Partial JSONL record copied'
Write-TextFile $outputPath "Worker continuation`n"
Assert (-not (Copy-TranscriptSnapshot $inputPath $outputPath)) 'Repeat import overwrote an existing chat'
Assert ([IO.File]::ReadAllText($outputPath).StartsWith('Worker continuation')) 'Worker continuation was overwritten'
# Mock only the installed backend for CI; exercise the actual import workflow.
$parentId='11111111-1111-4111-8111-111111111111'; $chatId='22222222-2222-4222-8222-222222222222'
foreach ($id in @($parentId,$chatId)) {
    $meta = @{type='session_meta';payload=@{id=$id}}
    if ($id -eq $chatId) { $meta.payload.history_base = @{thread_id=$parentId} }
    Write-TextFile (Join-Path $script:MainHome "sessions\rollout-$id.jsonl") (($meta | ConvertTo-Json -Depth 8 -Compress) + "`n")
}
Write-TextFile (Join-Path $script:MainHome 'auth.json') 'Main auth sentinel'
Write-TextFile (Join-Path $worker.CodexHome 'auth.json') 'Worker auth sentinel'
$index = Get-TranscriptIndex $script:MainHome
Assert (@(Get-SnapshotDependencies $chatId $index).Count -eq 2) 'History ancestry lost'
Assert-Rejected { Get-SnapshotDependencies 'missing' $index } 'Missing history accepted'
$assignmentThreads = @(
    [pscustomobject]@{id='folder-chat';cwd='C:\Projects\APP\nested\src';projectId=$null},
    [pscustomobject]@{id='unrelated';cwd='C:\Projects\app-extra';projectId=$null}
)
$assignmentProjects = @(
    @{id='outer';roots=@(@{path='C:\Projects\app'})},
    @{id='inner';roots=@(@{path='C:\Projects\app\nested'})}
)
Resolve-MainProjectAssignments $assignmentThreads $assignmentProjects (Join-Path $script:DataRoot 'absent-state.json')
Assert ($assignmentThreads[0].projectId -eq 'inner') 'Closest project folder was not selected'
Assert (-not $assignmentThreads[1].projectId) 'A similar folder name got the wrong project'
function Get-AppExecutable { Join-Path $script:DataRoot 'fake-app\ChatGPT.exe' }
Write-TextFile (Join-Path $script:DataRoot 'fake-app\resources\codex.exe') 'Backend fixture'
function Assert-InstanceClosed($Profile) {}
function Start-LibraryServer($Executable,$HomePath,$SqlitePath) { [pscustomobject]@{Home=$HomePath} }
function Stop-LibraryServer($Client) {}
$script:Requests = New-Object Collections.ArrayList
function Invoke-LibraryRequest($Client,$Method,$Parameters) {
    [void]$script:Requests.Add(@{Method=$Method;Parameters=$Parameters;Main=($Client.Home -eq $script:MainHome)})
    switch ($Method) {
        'project/list' { @{data=@(@{id='project-1';name='Local project';roots=@(@{path=$script:DataRoot});metadata=@{private_account='must not copy'}})} }
        'thread/list' {
            if ($Parameters.cursor) { @{data=@();nextCursor=$null} }
            else { @{data=@(@{id=$chatId;path=$index[$chatId];name='Local chat';projectId='project-1'});nextCursor='page-two'} }
        }
        default { @{} }
    }
}
$first = Import-MainLibrary $worker
Assert ($first.Chats -eq 1 -and $first.Projects -eq 1 -and $first.Skipped -eq 0) 'Import counts incorrect'
$copyIndex = Get-TranscriptIndex $worker.CodexHome
Assert ($copyIndex.ContainsKey($chatId) -and $copyIndex.ContainsKey($parentId)) 'Chat or history ancestor not copied'
Write-TextFile $copyIndex[$chatId] ([IO.File]::ReadAllText($copyIndex[$chatId]) + "Worker new turn`n")
$again = Import-MainLibrary $worker
Assert ($again.Chats -eq 0) 'Repeat import duplicated chats'
Assert ([IO.File]::ReadAllText($copyIndex[$chatId]).Contains('Worker new turn')) 'Repeat import discarded worker progress'
$importRequests = @($script:Requests | Where-Object Method -eq 'project/import')
Assert ($importRequests[0].Parameters.threads[0] -eq $chatId) 'Project membership lost'
Assert ($importRequests[1].Parameters.threads.Count -eq 0) 'Repeat import reassigned existing chats'
Assert (-not $importRequests[0].Parameters.ContainsKey('metadata')) 'Cloud/account metadata copied'
Assert (@($script:Requests | Where-Object { $_.Main -and $_.Method -notin @('project/list','thread/list') }).Count -eq 0) 'Importer wrote to main backend'
Assert (@($script:Requests | Where-Object { $_.Method -like 'turn/*' -or $_.Method -like 'account/*' }).Count -eq 0) 'Importer started a turn or account action'
Assert ([IO.File]::ReadAllText((Join-Path $script:MainHome 'auth.json')) -eq 'Main auth sentinel') 'Main credentials changed'
Assert ([IO.File]::ReadAllText((Join-Path $worker.CodexHome 'auth.json')) -eq 'Worker auth sentinel') 'Worker credentials overwritten'
Write-Output 'PASS: migration preserves data, isolated launch, guidance, snapshot integrity, history dependencies, pagination, project membership, repeat imports and credential preservation.'
