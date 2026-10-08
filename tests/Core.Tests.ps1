$ErrorActionPreference = 'Stop'
. (Join-Path (Split-Path -Parent $PSScriptRoot) 'src\Core.ps1')
$script:DataRoot = Join-Path (Split-Path -Parent $PSScriptRoot) ('work\test-' + [guid]::NewGuid().ToString('N'))
Initialize-Store
function Assert($Condition, $Message) { if (-not $Condition) { throw $Message } }
Assert (@(Get-Store | Where-Object { $_.Kind -eq 'main' -or $_.Id -eq 'main' }).Count -eq 0) 'Default window was added as a managed instance'
$legacyMain = New-Profile 'Main' 'main' 'main' (Join-Path $script:DataRoot 'untouched default home')
Write-TextFile (Join-Path $legacyMain.CodexHome 'sentinel.txt') 'keep default data'
$existingWorkers = @(Get-Store)
Save-Store @($existingWorkers + @($legacyMain))
Initialize-Store
Assert (@(Get-Store).Count -eq $existingWorkers.Count) 'Migration lost a worker or retained Main'
Assert (Test-Path -LiteralPath ($script:StorePath + '.before-workers-only.bak')) 'Migration registry backup missing'
Assert ([IO.File]::ReadAllText((Join-Path $legacyMain.CodexHome 'sentinel.txt')) -eq 'keep default data') 'Migration changed default profile data'
Save-Store @()
Initialize-Store
Assert (@(Get-Store).Count -eq 0) 'Empty instance registry was not preserved'
$repo = Join-Path $script:DataRoot "repo with spaces & apostrophe's"
[IO.Directory]::CreateDirectory($repo) | Out-Null
[void](Invoke-Git $repo @('init','-b','test'))
Write-TextFile (Join-Path $repo 'hello.txt') 'baseline'
[void](Invoke-Git $repo @('add','hello.txt'))
[void](Invoke-Git $repo @('-c','user.name=Launcher Test','-c','user.email=launcher@example.invalid','commit','-m','baseline'))
$baseCommit = (Invoke-Git $repo @('rev-parse','test')).Output
Write-TextFile (Join-Path $repo 'uncommitted.txt') 'must stay in the main checkout'
$worker = New-Profile 'Frontend & UI' 'testworker'
$worker.ShareBrain = $true
$worker.Repo = $repo; $worker.BaseBranch = 'test'; $worker.Branch = 'codex/frontend'
$worker.Workspace = Join-Path $script:DataRoot 'worktree with spaces'
Prepare-Workspace $worker
Assert ((Invoke-Git $worker.Workspace @('symbolic-ref','--short','HEAD')).Output -eq 'codex/frontend') 'Incorrect worktree branch'
Assert ((Invoke-Git $repo @('rev-parse','test')).Output -eq $baseCommit) 'Base branch moved'
Assert (-not (Test-Path -LiteralPath (Join-Path $worker.Workspace 'uncommitted.txt'))) 'Uncommitted content leaked into worktree'
Prepare-Workspace $worker
$wrong = $worker | ConvertTo-Json | ConvertFrom-Json; $wrong.Branch = 'wrong-branch'
$rejected = $false; try { Prepare-Workspace $wrong } catch { $rejected = $true }
Assert $rejected 'Existing worktree with mismatched branch was accepted'
$occupied = New-Profile 'Occupied' 'occupied'; $occupied.Repo = $repo; $occupied.Branch = 'test'
$rejected = $false; try { Prepare-Workspace $occupied } catch { $rejected = $true }
Assert $rejected 'Already checked-out branch was accepted'
$script:MainHome = Join-Path $script:DataRoot 'fake main brain'
Write-TextFile (Join-Path $script:MainHome 'AGENTS.md') 'Main guidance sentinel'
Write-TextFile (Join-Path $script:MainHome 'memories\memory_summary.md') 'Memory sentinel'
Write-TextFile (Join-Path $worker.CodexHome 'AGENTS.md') 'Worker guidance sentinel'
Prepare-Brain $worker; Prepare-Brain $worker
$guidance = [IO.File]::ReadAllText((Join-Path $worker.CodexHome 'AGENTS.md'))
Assert ($guidance.Contains('Worker guidance sentinel') -and $guidance.Contains('Main guidance sentinel')) 'Existing/inherited guidance lost'
Assert (([regex]::Matches($guidance,'codex-shared-brain:start')).Count -eq 1) 'Guidance duplicated on relaunch'
Assert ([IO.File]::ReadAllText((Join-Path $script:MainHome 'memories\memory_summary.md')) -eq 'Memory sentinel') 'Main memory changed'
Assert (-not (Test-Path -LiteralPath (Join-Path $worker.CodexHome 'memories'))) 'Main memory was linked or copied'
Save-Profile $worker
Assert (@(Get-Store | Where-Object { $_.Id -eq 'testworker' }).Count -eq 1) 'Registry persistence failed'
$worker.Prompt = "Check A&B, quote `"hello`" and line`nbreak."
$env:CODEX_ACCESS_TOKEN = 'nonsecret-test-sentinel'
$plan = Get-LaunchPlan $worker 'C:\Program Files\Example\ChatGPT.exe'
Assert (-not $plan.EnvironmentVariables.ContainsKey('CODEX_ACCESS_TOKEN')) 'Inherited account token was retained'
Assert ($plan.Arguments.Contains('codex://new?path=') -and $plan.Arguments.Contains('%26') -and $plan.Arguments.Contains('%0A')) 'Deep-link encoding failed'
Assert ($plan.EnvironmentVariables['CODEX_HOME'] -eq $worker.CodexHome) 'Worker home not isolated'
$rejected = $false; try { Get-LaunchPlan $legacyMain 'C:\Program Files\Example\ChatGPT.exe' } catch { $rejected = $true }
Assert $rejected 'Legacy Main launch was accepted'
Write-Output 'PASS: workers-only migration, empty registry, default data preservation, real Git worktrees, account isolation, prompt encoding, and shared guidance.'
