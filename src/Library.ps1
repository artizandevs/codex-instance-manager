# App-server imports are experimental; never share a live database or credentials.
function Start-LibraryServer([string]$Executable, [string]$HomePath, [string]$SqlitePath) {
    $info = New-Object Diagnostics.ProcessStartInfo
    $info.FileName = $Executable; $info.Arguments = 'app-server --listen stdio://'
    $info.WorkingDirectory = $HomePath; $info.UseShellExecute = $false; $info.CreateNoWindow = $true
    $info.RedirectStandardInput = $true; $info.RedirectStandardOutput = $true; $info.RedirectStandardError = $true
    $info.StandardOutputEncoding = $script:Utf8; $info.StandardErrorEncoding = $script:Utf8
    Clear-InheritedEnvironment $info
    $info.EnvironmentVariables['CODEX_HOME'] = $HomePath
    $info.EnvironmentVariables['CODEX_SQLITE_HOME'] = $SqlitePath
    $process = [Diagnostics.Process]::Start($info)
    $client = [pscustomobject]@{ Process = $process; ErrorTask = $process.StandardError.ReadToEndAsync(); NextId = 0 }
    try {
        [void](Invoke-LibraryRequest $client 'initialize' @{ clientInfo = @{name='cim';version='0.2.0'}; capabilities = @{experimentalApi=$true;explicitGatewayOauth=$true} })
        $process.StandardInput.WriteLine('{"method":"initialized"}')
        $client
    } catch { Stop-LibraryServer $client; throw }
}
function Stop-LibraryServer($Client) {
    if (-not $Client) { return }
    try {
        $Client.Process.StandardInput.Close()
        if (-not $Client.Process.WaitForExit(3000)) { $Client.Process.Kill(); [void]$Client.Process.WaitForExit(3000) }
    } finally { $Client.Process.Dispose() }
}
function Invoke-LibraryRequest($Client, [string]$Method, $Parameters) {
    $Client.NextId++
    $id = $Client.NextId
    $Client.Process.StandardInput.WriteLine((@{id=$id;method=$Method;params=$Parameters} | ConvertTo-Json -Depth 30 -Compress))
    $deadline = [DateTime]::UtcNow.AddSeconds(60)
    while ([DateTime]::UtcNow -lt $deadline) {
        $read = $Client.Process.StandardOutput.ReadLineAsync()
        $remaining = [Math]::Max(1, [int]($deadline - [DateTime]::UtcNow).TotalMilliseconds)
        if (-not $read.Wait($remaining)) { throw "Codex timed out during $Method. Close this instance and retry the import." }
        if ($null -eq $read.Result) { throw "Codex stopped during $Method. Update Codex and retry." }
        try { $message = $read.Result | ConvertFrom-Json } catch { continue }
        if ($message.method -and $null -ne $message.id) {
            # Importing history must never approve actions or start model turns.
            $Client.Process.StandardInput.WriteLine((@{id=$message.id;error=@{code=-32601;message='CIM imports history only.'}} | ConvertTo-Json -Compress))
        } elseif ($message.id -eq $id) {
            if ($message.error) {
                $exception = New-Object InvalidOperationException("Codex rejected $Method (code $($message.error.code)). Its import API may have changed. No login data was copied.")
                $exception.Data['ProtocolError'] = $message.error.message
                throw $exception
            }
            return $message.result
        }
    }
    throw "Codex timed out during $Method."
}
function Copy-TranscriptSnapshot([string]$Source, [string]$Destination) {
    if (Test-Path -LiteralPath $Destination) { return $false }
    [IO.Directory]::CreateDirectory((Split-Path -Parent $Destination)) | Out-Null
    $temporary = $Destination + '.' + [guid]::NewGuid().ToString('N') + '.tmp'
    $inputStream = $null; $outputStream = $null
    try {
        $inputStream = New-Object IO.FileStream($Source, [IO.FileMode]::Open, [IO.FileAccess]::Read, ([IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete))
        $outputStream = New-Object IO.FileStream($temporary, [IO.FileMode]::CreateNew, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
        # Bound the snapshot to the length at open, ignoring later live appends.
        $remaining = $inputStream.Length; $buffer = New-Object byte[] 65536
        while ($remaining -gt 0) {
            $count = $inputStream.Read($buffer, 0, [int][Math]::Min($buffer.Length, $remaining))
            if ($count -eq 0) { break }
            $outputStream.Write($buffer, 0, $count); $remaining -= $count
        }
        # Discard a partially written final JSONL record, including partial UTF-8.
        $end = $outputStream.Length
        while ($end -gt 0) {
            $outputStream.Position = $end - 1
            if ($outputStream.ReadByte() -eq 10) { break }
            $end--
        }
        if ($end -eq 0) { throw 'The source chat has no complete transcript records yet. Retry after its turn finishes.' }
        $outputStream.SetLength($end); $outputStream.Dispose(); $outputStream = $null
        [IO.File]::Move($temporary, $Destination)
        $true
    } finally {
        if ($inputStream) { $inputStream.Dispose() }; if ($outputStream) { $outputStream.Dispose() }
        if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary }
    }
}
function Get-LibraryPages($Client, [string]$Method, $Parameters) {
    $result = @(); $cursor = $null
    do {
        if ($cursor) { $Parameters['cursor'] = $cursor }
        $page = Invoke-LibraryRequest $Client $Method $Parameters
        $result += @($page.data); $cursor = $page.nextCursor
    } while ($cursor)
    $result
}
function Get-TranscriptIndex([string]$HomePath) {
    $index = @{}
    foreach ($folder in @('sessions','archived_sessions')) {
        $root = Join-Path $HomePath $folder
        if (-not (Test-Path -LiteralPath $root)) { continue }
        foreach ($file in Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.jsonl') {
            if ($file.Name -match '([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12})\.jsonl$') {
                $index[$Matches[1]] = $file.FullName
            }
        }
    }
    $index
}
function Get-SnapshotDependencies([string]$Id, $Index, $Visiting = $null) {
    if (-not $Visiting) { $Visiting = @{} }
    if ($Visiting.ContainsKey($Id)) { throw 'A chat has circular history dependencies.' }
    if (-not $Index.ContainsKey($Id)) { throw 'A required local transcript is unavailable.' }
    $Visiting[$Id] = $true
    $stream = $null; $reader = $null
    try {
        $stream = New-Object IO.FileStream($Index[$Id], [IO.FileMode]::Open, [IO.FileAccess]::Read, ([IO.FileShare]::ReadWrite -bor [IO.FileShare]::Delete))
        $reader = New-Object IO.StreamReader($stream, $script:Utf8)
        $record = $reader.ReadLine() | ConvertFrom-Json
        if ($record.type -ne 'session_meta' -or $record.payload.id -ne $Id) { throw 'A local transcript has an unexpected header.' }
        $baseId = $record.payload.history_base.thread_id
    } finally { if ($reader) { $reader.Dispose() } elseif ($stream) { $stream.Dispose() } }
    $result = @()
    if ($baseId) { $result += @(Get-SnapshotDependencies $baseId $Index $Visiting) }
    [void]$Visiting.Remove($Id)
    $result + @($Id)
}
function Read-ImportManifest([string]$Path) {
    $manifest = @{Version=1;Threads=@{}}
    if (Test-Path -LiteralPath $Path) {
        $stored = [IO.File]::ReadAllText($Path) | ConvertFrom-Json
        if ($stored.Version -ne 1) { throw 'Unsupported chat import manifest.' }
        foreach ($property in $stored.Threads.PSObject.Properties) { $manifest.Threads[$property.Name] = $property.Value }
    }
    $manifest
}
function Save-ImportManifest([string]$Path, $Manifest) {
    $temporary = $Path + '.tmp'
    Write-TextFile $temporary ($Manifest | ConvertTo-Json -Depth 10)
    Move-Item -LiteralPath $temporary -Destination $Path -Force
}
function Assert-InstanceClosed($Profile) {
    $running = @(Get-CimInstance Win32_Process -Filter "Name='ChatGPT.exe'" -OperationTimeoutSec 10 | Where-Object { $_.CommandLine -and $_.CommandLine.Contains($Profile.DesktopData) })
    if ($running.Count) { throw 'Close this additional Codex instance before copying chats. You can keep your main window open.' }
}
function Resolve-MainProjectAssignments($Threads, $Projects, [string]$StatePath) {
    $legacyAssignments = @{}; $aliases = @{}
    foreach ($project in $Projects) { $aliases[$project.id] = $project.id }
    if (Test-Path -LiteralPath $StatePath) {
        $state = [IO.File]::ReadAllText($StatePath) | ConvertFrom-Json
        foreach ($property in $state.'thread-project-assignments'.PSObject.Properties) { $legacyAssignments[$property.Name] = $property.Value }
        foreach ($property in $state.'local-projects'.PSObject.Properties) {
            $old = $property.Value
            foreach ($project in $Projects) {
                $oldRoots = @($old.rootPaths | ForEach-Object { $_.Replace('/','\').TrimEnd('\') })
                $roots = @($project.roots | ForEach-Object { $_.path.Replace('/','\').TrimEnd('\') })
                if ($oldRoots.Count -eq $roots.Count -and $oldRoots.Count -gt 0 -and -not @(Compare-Object $oldRoots $roots).Count) { $aliases[$property.Name] = $project.id }
            }
        }
    }
    foreach ($thread in $Threads) {
        if ($thread.projectId) { continue }
        $legacyId = $legacyAssignments[$thread.id]
        if ($legacyId -is [string] -and $aliases.ContainsKey($legacyId)) { $thread.projectId = $aliases[$legacyId]; continue }
        # Older desktop builds group unassigned local chats by working folder.
        $cwd = [string]$thread.cwd; $cwd = $cwd.Replace('/','\').TrimEnd('\')
        $best = $null; $length = 0
        foreach ($project in $Projects) {
            foreach ($root in $project.roots) {
                $path = $root.path.Replace('/','\').TrimEnd('\')
                if ($path.Length -gt $length -and ($cwd -eq $path -or $cwd.StartsWith($path + '\', [StringComparison]::OrdinalIgnoreCase))) { $best = $project.id; $length = $path.Length }
            }
        }
        if ($best) { $thread.projectId = $best }
    }
}
function Import-MainLibrary($Profile, [scriptblock]$Progress = {}) {
    Assert-WorkerProfile $Profile; Assert-InstanceClosed $Profile; Prepare-Brain $Profile
    $binary = Join-Path (Split-Path -Parent (Get-AppExecutable)) 'resources\codex.exe'
    if (-not (Test-Path -LiteralPath $binary)) { throw 'The installed Codex backend could not be found.' }
    $manifestPath = Join-Path $Profile.CodexHome 'cim-imports.json'
    $manifest = Read-ImportManifest $manifestPath
    $source = $null; $target = $null; $copied = 0; $skipped = 0; $projectCount = 0
    try {
        & $Progress 'Reading main local projects and chats...'
        # Respect a main sqlite_home setting without copying any other configuration.
        $mainSqlite = $script:MainHome
        $configPath = Join-Path $script:MainHome 'config.toml'
        if (Test-Path -LiteralPath $configPath) {
            foreach ($line in [IO.File]::ReadLines($configPath)) {
                if ($line -match '^\s*\[') { break }
                if ($line -match '^\s*sqlite_home\s*=\s*"([^"]+)"') { $mainSqlite = $Matches[1].Replace('\\','\') }
                elseif ($line -match "^\s*sqlite_home\s*=\s*'([^']+)'") { $mainSqlite = $Matches[1] }
            }
        }
        $source = Start-LibraryServer $binary $script:MainHome $mainSqlite
        $projects = @(Get-LibraryPages $source 'project/list' @{limit=100} | Where-Object { @($_.roots).Count -gt 0 })
        $threads = @(Get-LibraryPages $source 'thread/list' @{limit=100;archived=$false;useStateDbOnly=$true;modelProviders=@();sourceKinds=@('cli','vscode','appServer','exec','unknown')} | Where-Object { $_.path -and -not $_.parentThreadId -and $_.threadSource -ne 'aeon' })
        Resolve-MainProjectAssignments $threads $projects (Join-Path $script:MainHome '.codex-global-state.json')
        Stop-LibraryServer $source; $source = $null
        $index = Get-TranscriptIndex $script:MainHome
        $targetIndex = Get-TranscriptIndex $Profile.CodexHome
        $eligible = @{}; foreach ($thread in $threads) { $eligible[$thread.id] = $true }
        $target = Start-LibraryServer $binary $Profile.CodexHome $Profile.SqliteHome
        $number = 0
        foreach ($thread in $threads) {
            $number++; & $Progress "Copying local chat $number of $($threads.Count)..."
            if ($manifest.Threads.ContainsKey($thread.id)) { continue }
            try { $dependencies = @(Get-SnapshotDependencies $thread.id $index) } catch { $skipped++; continue }
            foreach ($id in $dependencies) {
                if ($targetIndex.ContainsKey($id)) { continue }
                $destination = Join-Path $Profile.CodexHome ('sessions\cim-imported\' + [IO.Path]::GetFileName($index[$id]))
                [void](Copy-TranscriptSnapshot $index[$id] $destination)
                $targetIndex[$id] = $destination
            }
            # Resume indexes the snapshot into this instance's own DB; it submits no turn.
            [void](Invoke-LibraryRequest $target 'thread/resume' @{threadId=$thread.id;excludeTurns=$true;approvalPolicy='on-request';sandbox='workspace-write'})
            if ($thread.name) { [void](Invoke-LibraryRequest $target 'thread/name/set' @{threadId=$thread.id;name=$thread.name}) }
            [void](Invoke-LibraryRequest $target 'thread/unsubscribe' @{threadId=$thread.id})
            $manifest.Threads[$thread.id] = [pscustomobject]@{ProjectAssigned=$false}
            Save-ImportManifest $manifestPath $manifest; $copied++
            foreach ($id in $dependencies) {
                if (-not $eligible.ContainsKey($id)) {
                    [void](Invoke-LibraryRequest $target 'thread/resume' @{threadId=$id;excludeTurns=$true;approvalPolicy='on-request';sandbox='workspace-write'})
                    [void](Invoke-LibraryRequest $target 'thread/archive' @{threadId=$id})
                    [void](Invoke-LibraryRequest $target 'thread/unsubscribe' @{threadId=$id})
                }
            }
        }
        foreach ($project in $projects) {
            & $Progress 'Copying local project entries...'
            # Do not copy account/cloud metadata. Folder paths refer to the same files.
            $assign = @($threads | Where-Object { $_.projectId -eq $project.id -and $manifest.Threads.ContainsKey($_.id) -and -not $manifest.Threads[$_.id].ProjectAssigned } | ForEach-Object { $_.id })
            [void](Invoke-LibraryRequest $target 'project/import' @{idempotencyKey=('cim-main-' + $project.id);name=$project.name;roots=@($project.roots | ForEach-Object { @{path=$_.path} });threads=$assign})
            foreach ($id in $assign) { $manifest.Threads[$id].ProjectAssigned = $true }
            Save-ImportManifest $manifestPath $manifest; $projectCount++
        }
        [pscustomobject]@{Chats=$copied;Projects=$projectCount;Skipped=$skipped}
    } finally { Stop-LibraryServer $target; Stop-LibraryServer $source }
}
