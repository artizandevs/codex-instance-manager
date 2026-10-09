param(
    [string]$Launch = '',
    [string]$DataRoot = (Join-Path $env:LOCALAPPDATA 'OpenAI\CodexInstanceManager'),
    [switch]$Install,
    [switch]$RenderPreview,
    [string]$PreviewPath = ''
)
$ErrorActionPreference = 'Stop'
$script:DataRoot = $DataRoot
. (Join-Path $PSScriptRoot 'Core.ps1')
try {
    Initialize-Store
    if ($Install) {
        foreach ($profile in @(Get-Store)) { Prepare-Profile $profile; New-DesktopShortcut $profile }
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath('DesktopDirectory')) 'Codex Instance Manager.lnk'))
        $shortcut.TargetPath = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
        $shortcut.Arguments = '-NoProfile -STA -WindowStyle Hidden -ExecutionPolicy Bypass -File ' + (Quote-Argument (Join-Path $PSScriptRoot 'Manager.ps1'))
        $shortcut.WorkingDirectory = $PSScriptRoot
        $iconPath = Join-Path $PSScriptRoot 'assets\manager-transparent.ico'
        if (-not (Test-Path -LiteralPath $iconPath)) { $iconPath = Join-Path (Split-Path -Parent $PSScriptRoot) 'assets\manager-transparent.ico' }
        $shortcut.IconLocation = $(if (Test-Path -LiteralPath $iconPath) { $iconPath + ',0' } else { (Get-AppExecutable) + ',0' })
        $shortcut.Save()
        Write-Output 'Installed the manager and saved instance shortcuts. No Codex windows opened.'
        exit
    }
    if ($Launch) {
        $profile = @(Get-Store | Where-Object { $_.Id -eq $Launch }) | Select-Object -First 1
        if (-not $profile) { throw 'That instance is no longer in the registry.' }
        Launch-Profile $profile
        exit
    }
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
    . (Join-Path $PSScriptRoot 'UI.ps1')
} catch {
    if ($RenderPreview -or $Install) { throw }
    Add-Type -AssemblyName PresentationFramework
    [Windows.MessageBox]::Show($_.Exception.Message, 'Codex Instance Manager', 'OK', 'Error') | Out-Null
    exit 1
}
