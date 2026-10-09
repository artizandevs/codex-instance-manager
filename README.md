<p align="center"><img src="assets/logo-cim.png" width="88" alt="Codex Instance Manager logo"></p>

# Codex Instance Manager

A small Windows launcher for named Codex desktop instances with separate accounts and desktop shortcuts.

[Download for Windows](https://github.com/artizandevs/codex-instance-manager/releases/latest/download/Codex-Instance-Manager.zip) · [Website](https://cim.rtzn.pt/) · [Report an issue](https://github.com/artizandevs/codex-instance-manager/issues)

![The simple Windows instance manager](https://raw.githubusercontent.com/artizandevs/codex-instance-manager/main/docs/assets/manager-preview.png)

## What it does

- Keeps your default Codex window outside the manager.
- Opens additional instances with their own login, settings, chats, and databases.
- Creates named desktop shortcuts. No repository or branch setup is required.
- Leaves projects, chats, preferences, and guidance for you to configure inside each instance.

Independent, unofficial community software, not affiliated with or endorsed by OpenAI. Desktop profile isolation uses an undocumented mechanism that may change after Codex updates.

## Install and use

Requires Windows 11, the Codex desktop app installed for your Windows user, and Windows PowerShell 5.1. WPF and PowerShell come with Windows. No Git, Node.js, Python, or extra runtime is required for the manager.

1. Download and extract the ZIP from [Releases](https://github.com/artizandevs/codex-instance-manager/releases/latest).
2. Run `Install.cmd` inside the extracted `Codex-Instance-Manager` folder.
3. Open **Codex Instance Manager** from your desktop.
4. Choose **New instance**, enter a name, and choose **Save** or **Open Codex**.
5. Sign into the intended account on first use. Complete initial sign-ins one at a time and check the account in each window.

Save creates a desktop shortcut; Open Codex also saves and launches. Shortcuts use the instance's latest settings. The manager uses the CIM logo; instance shortcuts retain the plain black logo.

Installation is per-user at `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\app`. The ZIP contains readable, unsigned PowerShell scripts. `Install.cmd` uses a process-scoped execution-policy override, without changing machine policy. No administrator installation is required.

## Independent configuration

The manager only creates and opens instances. Sign in and set up your projects, chats, preferences, and guidance in each Codex window. It does not import chats, copy projects, share memories, synchronize settings, or submit prompts.

New instances start independently. The only initial configuration written by the launcher selects a file credential store so authentication stays in the instance's own profile. Existing `config.toml` files are never overwritten.

## Storage and updates

| Item | Location |
| --- | --- |
| Main Codex home | `%USERPROFILE%\.codex` |
| Installed manager | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\app` |
| Named instances | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\instances.json` |
| Instance state | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\profiles\<id>` |

To update, extract a newer ZIP and run `Install.cmd`. Existing logins, chats, user configuration, and instance folders are preserved. Version 0.3.0 removes the importer and shared-guidance option, backs up the registry as `instances.json.before-launcher-only.bak`, and removes only the previous manager's marked shared-guidance block from instance guidance files. Imported conversations already on disk are kept. No main Codex data is edited. Updating from 0.1.x saves an `instances.json.before-simple-launcher.bak` backup and removes the old repository, branch, worktree, prompt, and chat-launch settings from the active registry. Existing project folders and worktrees remain on disk.

Fresh installs begin with no instances, except when legacy Account 2/3 folders from `CodexMultiAccount` are detected. Removing an instance removes its manager entry and keeps its data and shortcut. Renaming can leave the old shortcut, which still refers to the same instance ID.

## Compatibility and verification

The installed app is resolved at runtime. Isolation uses `CODEX_HOME`, `CODEX_SQLITE_HOME`, and the undocumented `CODEX_ELECTRON_USER_DATA_PATH`. No app-server import APIs are used.

Automated tests cover registry migration, user-data preservation, isolated launch arguments and environment, removal of managed guidance, and shortcut identity. Icons are built from the high-resolution transparent logos at 16, 24, 32, 48, 64, 128, and 256 pixels. The WPF preview uses fictitious account names and paths. Simultaneous OAuth callbacks still need wider live testing across app versions.

The launcher includes no telemetry, auto-updater, or cloud-sync service and does not bypass account limits or authentication. Codex remains a separate application with its own behavior and settings.

## Development

```powershell
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File .\src\Manager.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Test.ps1
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File .\scripts\Build-Icons.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Build-Release.ps1
```

The static website is in `docs/`, published by GitHub Pages from `main:/docs`. Windows CI checks and packages the launcher; a `v*` tag publishes a release ZIP and checksum.

The website uses self-hosted Umami for page views and download, navigation, FAQ, section, and scroll events. This is website-only analytics; the launcher remains telemetry-free. See [the event reference](docs/ANALYTICS.md) for properties and measurement limits.

See [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), and [CHANGELOG.md](CHANGELOG.md). Licensed under [MIT](LICENSE).

Upstream references: [Local projects](https://learn.chatgpt.com/docs/projects), [Codex state locations](https://learn.chatgpt.com/docs/config-file/environment-variables), and [global guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md).
