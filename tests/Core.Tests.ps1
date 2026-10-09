$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $root 'src\Core.ps1')
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
Prepare-Profile $worker; Prepare-Profile $other
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
Assert-Rejected { Prepare-Profile $invalid } 'Worker could write into main home'
Save-Profile $worker
$duplicate = New-Profile $worker.Name 'duplicate'
Assert-Rejected { Save-Profile $duplicate } 'Duplicate instance name accepted'
# Upgrade a version-2 profile without touching user config, credentials or chats.
Write-TextFile (Join-Path $script:MainHome 'AGENTS.md') 'Main guidance sentinel'
Write-TextFile (Join-Path $worker.CodexHome 'config.toml') 'User configuration sentinel'
Write-TextFile (Join-Path $worker.CodexHome 'auth.json') 'Worker auth sentinel'
Write-TextFile (Join-Path $worker.CodexHome 'sessions\keep.jsonl') 'Existing conversation sentinel'
$userGuidance = "User heading`r`n`r`n"
$managed = '<!-- codex-shared-brain:start -->Main guidance sentinel<!-- codex-shared-brain:end -->'
$userTail = "`r`nUser footer`r`n"
foreach ($name in @('AGENTS.md','AGENTS.override.md')) {
    Write-TextFile (Join-Path $worker.CodexHome $name) ($userGuidance + $managed + $userTail)
}
$worker | Add-Member NoteProperty ShareBrain $true
Write-TextFile $script:StorePath (@{Version=2;Instances=@($worker)} | ConvertTo-Json -Depth 8)
$fakeMain = $script:MainHome
Initialize-Store
$script:MainHome = $fakeMain
$worker = @(Get-Store)[0]
Assert (-not $worker.PSObject.Properties['ShareBrain']) 'Sharing option survived migration'
Assert (Test-Path -LiteralPath ($script:StorePath + '.before-launcher-only.bak')) 'Launcher-only backup missing'
Assert (([IO.File]::ReadAllText($script:StorePath) | ConvertFrom-Json).Version -eq 3) 'Wrong registry version'
Prepare-Profile $worker; Prepare-Profile $worker
foreach ($name in @('AGENTS.md','AGENTS.override.md')) {
    Assert ([IO.File]::ReadAllText((Join-Path $worker.CodexHome $name)) -eq ($userGuidance + $userTail)) 'User guidance changed or managed sharing survived'
}
Assert ([IO.File]::ReadAllText((Join-Path $worker.CodexHome 'config.toml')) -eq 'User configuration sentinel') 'User config overwritten'
Assert ([IO.File]::ReadAllText((Join-Path $worker.CodexHome 'auth.json')) -eq 'Worker auth sentinel') 'Worker credentials overwritten'
Assert ([IO.File]::ReadAllText((Join-Path $worker.CodexHome 'sessions\keep.jsonl')) -eq 'Existing conversation sentinel') 'Existing chats changed'
Assert ([IO.File]::ReadAllText((Join-Path $script:MainHome 'AGENTS.md')) -eq 'Main guidance sentinel') 'Main guidance changed'
Assert (-not (Test-Path -LiteralPath (Join-Path $other.CodexHome 'AGENTS.md'))) 'New instance gained unsolicited guidance'
Assert (-not (Test-Path -LiteralPath (Join-Path $worker.CodexHome 'memories'))) 'Main memories copied or linked'
Assert ([IO.File]::ReadAllText((Join-Path $other.CodexHome 'config.toml')).Contains('cli_auth_credentials_store = "file"')) 'Fresh credentials do not stay in profile'
$desktopFixture = Join-Path $script:DataRoot 'desktop'
[IO.Directory]::CreateDirectory($desktopFixture) | Out-Null
New-DesktopShortcut $worker $desktopFixture
$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($worker.Shortcut)
Assert ($shortcut.IconLocation.EndsWith('assets\instance-transparent.ico,0')) 'Shortcut uses old icon'
Assert ($shortcut.Arguments.Contains('-Launch "worker"')) 'Shortcut lost instance identity'
Assert (-not (Test-Path -LiteralPath (Join-Path $root 'src\Library.ps1'))) 'Obsolete importer is packaged'
Write-Output 'PASS: registry migrations, data preservation, isolated launch, user-owned settings, sharing retirement, and shortcut target/icon.'
