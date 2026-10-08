<p align="center"><img src="assets/logo-cim.png" width="88" alt="Codex Instance Manager logo"></p>

# Codex Instance Manager

A small Windows launcher for named Codex desktop instances with separate accounts and desktop shortcuts.

[Download for Windows](https://github.com/artizandevs/codex-instance-manager/releases/latest/download/Codex-Instance-Manager.zip) · [Website](https://cim.rtzn.pt/) · [Report an issue](https://github.com/artizandevs/codex-instance-manager/issues)

![The simple Windows instance manager](https://raw.githubusercontent.com/artizandevs/codex-instance-manager/main/docs/assets/manager-preview.png)

## What it does

- Keeps your default Codex window outside the manager.
- Opens additional instances with their own login, settings, chats, and databases.
- Creates named desktop shortcuts. No repository or branch setup is required.
- Optionally copies the main window's local projects and chats into an instance.
- Optionally lets an instance consult the main window's guidance and memory files.

Independent, unofficial community software, not affiliated with or endorsed by OpenAI. Desktop profile isolation and history importing use undocumented or experimental mechanisms that may change after Codex updates.

## Install and use

Requires Windows 11, the Codex desktop app installed for your Windows user, and Windows PowerShell 5.1. WPF and PowerShell come with Windows. No Git, Node.js, Python, or extra runtime is required for the manager.

1. Download and extract the ZIP from [Releases](https://github.com/artizandevs/codex-instance-manager/releases/latest).
2. Run `Install.cmd` inside the extracted `Codex-Instance-Manager` folder.
3. Open **Codex Instance Manager** from your desktop.
4. Choose **New instance**, enter a name, and choose **Save** or **Open Codex**.
5. Sign into the intended account on first use. Complete initial sign-ins one at a time and check the account in each window.

Save creates a desktop shortcut; Open Codex also saves and launches. Shortcuts use the instance's latest settings. The manager uses the CIM logo; instance shortcuts retain the plain black logo.

Installation is per-user at `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\app`. The ZIP contains readable, unsigned PowerShell scripts. `Install.cmd` uses a process-scoped execution-policy override, without changing machine policy. No administrator installation is required.

## Copy main projects and chats

Select an instance and choose **Copy main projects & chats** before opening it, or close that instance first. Your main window can remain open. This is an explicit, optional local import; launching a shortcut does not import anything automatically.

The importer reads the main local project catalog and non-archived local conversations, snapshots their transcript files, and registers them with the instance's own Codex backend. It copies required history ancestors so paginated conversations retain their context. Project names, folder paths, and chat membership are preserved. Account/cloud project metadata, authentication, browser state, and main databases are not copied.

Copies continue independently. Chat IDs are retained within each separate profile. Repeating the import adds newly created main chats without overwriting existing copies or their progress. It does not synchronize new turns in already imported chats. Missing transcripts are skipped and counted; backend incompatibility stops the import with an error. Partial imports can be retried.

Important limits:

- Cloud ChatGPT chats are account-bound and are not imported. This does not reproduce open tabs, pinned/sidebar ordering, remote environments, plugins, or automations.
- Local projects refer to the **same folders on disk**; project files are not duplicated. Concurrent edits affect the same files unless you choose separate folders inside Codex yourself.
- Snapshots contain saved conversation context. Continuing one under another account can send that context to that account's model provider. Import only context you want that account to use.
- Wait for active turns to finish for a complete snapshot. A partially written final transcript record is excluded.
- Imported chats start with workspace-write permissions and on-request approval. The importer submits no model turn; review the instance's settings before continuing work.

## Optional main guidance and memories

**Consult main guidance and memories** is off by default. Enabling it adds guidance telling the instance to read relevant main memory files and consult main skills on demand. Main guidance refreshes when the instance launches; memories are read in place, not copied or linked. New instance memories remain separate.

This is instruction-based read-only use, not a Windows permissions boundary. The same Windows user can access these folders, and relevant context may enter that account's model context. Start a new chat after changing the guidance option.

## Storage and updates

| Item | Location |
| --- | --- |
| Main Codex home | `%USERPROFILE%\.codex` |
| Installed manager | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\app` |
| Named instances | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\instances.json` |
| Instance state | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\profiles\<id>` |
| Import tracking | Each instance's `codex-home\cim-imports.json` |

To update, extract a newer ZIP and run `Install.cmd`. Existing logins and instance folders are preserved. Updating from 0.1.x saves an `instances.json.before-simple-launcher.bak` backup and removes the old repository, branch, worktree, prompt, and chat-launch settings from the active registry. Existing project folders and worktrees remain on disk.

Fresh installs begin with no instances, except when legacy Account 2/3 folders from `CodexMultiAccount` are detected. Removing an instance removes its manager entry and keeps its data and shortcut. Renaming can leave the old shortcut, which still refers to the same instance ID.

## Compatibility and verification

The installed app is resolved at runtime. Isolation uses `CODEX_HOME`, `CODEX_SQLITE_HOME`, and the undocumented `CODEX_ELECTRON_USER_DATA_PATH`. Import uses the bundled Codex app-server and experimental project methods.

Local import was checked against Codex package `26.1002.7124.0`: transcript reading, project assignment, persistence across backend restarts, and importing without worker credentials. Automated tests cover profile migration, launch isolation, transcript snapshots, history dependencies, pagination, and repeat-import protection. The WPF preview uses fictitious account names and paths. Simultaneous OAuth callbacks and cross-account model continuation still need wider live testing across app versions.

The launcher includes no telemetry, auto-updater, or cloud-sync service and does not bypass account limits or authentication. Codex remains a separate application with its own behavior and settings.

## Development

```powershell
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File .\src\Manager.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Test.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Build-Release.ps1
```

The static website is in `docs/`, published by GitHub Pages from `main:/docs`. Windows CI checks and packages the launcher; a `v*` tag publishes a release ZIP and checksum.

See [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), and [CHANGELOG.md](CHANGELOG.md). Licensed under [MIT](LICENSE).

Upstream references: [Local projects](https://learn.chatgpt.com/docs/projects), [Codex state locations](https://learn.chatgpt.com/docs/config-file/environment-variables), and [global guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md).
