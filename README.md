<p align="center"><img src="assets/logo-cim.png" width="88" alt="Codex Instance Manager logo"></p>

# Codex Instance Manager

A small Windows launcher for separate Codex desktop accounts, named instances, project worktrees, and desktop shortcuts.

[Download for Windows](https://github.com/artizandevs/codex-instance-manager/releases/latest/download/Codex-Instance-Manager.zip) · [Website](https://cim.rtzn.pt/) · [Report an issue](https://github.com/artizandevs/codex-instance-manager/issues)

![Instance manager showing a frontend worker](https://raw.githubusercontent.com/artizandevs/codex-instance-manager/main/docs/assets/manager-preview.png)

## What it does

- Manages additional instances while you keep the default Codex window open normally.
- Gives each additional instance its own desktop profile, login, sessions, configuration, and databases.
- Names your instances and creates desktop shortcuts that use their latest saved settings.
- Assigns a repository, base branch, working branch, and Git worktree to each instance.
- Opens a new chat with a project path and optional draft prompt, or an existing local chat in that profile.
- Optionally lets a worker consult the default window's guidance and memory files in `%USERPROFILE%\.codex`.

This is an independent, unofficial community tool. It is not affiliated with or endorsed by OpenAI. The desktop profile override is undocumented and may change after a Codex update.

## Install

Requirements: Windows 11, the Codex desktop app installed for your Windows user, Windows PowerShell 5.1, and Git for Windows when using worktrees. WPF and PowerShell are included with Windows; no Node.js, Python, or extra framework is required to run the manager.

1. Download the ZIP from [Releases](https://github.com/artizandevs/codex-instance-manager/releases/latest).
2. Extract it to a folder you control.
3. Run `Install.cmd` from the extracted `Codex-Instance-Manager` folder.
4. Open **Codex Instance Manager** on your desktop.

Installation is per-user under `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\app`. No administrator installation is required. The ZIP is an unsigned, readable PowerShell distribution. `Install.cmd` uses a process-scoped execution-policy override; it does not change the machine's execution-policy setting. Review the source before running it, as with any downloaded script.

## Create an instance

Click **New instance**, enter a name, and optionally browse to a Git repository. For isolated work, select **Use an isolated Git worktree**, choose a base branch, and enter a distinct working branch. Leave the working branch blank to generate a name, or leave the directory blank to use a managed location.

Click **Save instance** to create the worktree, prepare the profile, and create its shortcut. Click **Save & launch** to also open Codex. On first launch, sign in to the intended account. Complete initial sign-ins sequentially, checking the active account in each window. If first-time sign-in delays the startup chat, run the shortcut again after login.

The startup prompt is a draft; the launcher never submits it. You press **Send** in Codex. An existing chat ID must belong to the selected profile's local history. This tool does not transfer conversations between accounts.

### Working from the same base branch

For example, start three worktrees from `test`, using `codex/frontend`, `codex/api`, and `codex/tests` as their working branches. Merge their completed commits into `test` yourself. Git normally permits a named branch to be checked out in only one worktree at a time.

The manager creates or reuses matching worktrees. It does not reset, switch, rebase, commit, merge, push, or delete your branches. Ignored files, dependencies, environment files, and databases are not copied. Set up each worktree as needed and use different development-server ports for parallel workers.

## Shared main knowledge

Sharing is **off by default for new workers**. Enable it only when you want that worker's account to receive relevant context from your main instance.

When enabled, global `AGENTS.md` guidance tells the worker to read the main `memories/memory_summary.md`, search `memories/MEMORY.md` when relevant, and consult supporting notes or skills. Main global guidance is refreshed when the worker launches. Memory files are read in place; they are not copied or junctioned into the worker's home.

This is instruction-based read-only use, **not a Windows permissions boundary**. The same Windows user can access the files. Read context can be sent to the account/provider running the worker as part of its task. The manager does not share the main account's credentials, databases, browser state, or live conversations. New worker memories remain separate and are not automatically merged. Start a new chat after changing shared instructions so the new context can load.

## Storage and updating

| Item | Location |
| --- | --- |
| Main Codex home | `%USERPROFILE%\.codex` |
| Manager and source | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\app` |
| Names and project assignments | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\instances.json` |
| New instance homes | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\profiles\<id>` |
| Default worktrees | `%LOCALAPPDATA%\OpenAI\CodexInstanceManager\worktrees\<id>` |

The default window is not listed or launched by this manager. Fresh installations begin with no managed instances unless existing Account 2/3 homes from an earlier `CodexMultiAccount` setup are found. To update, extract a newer ZIP and run `Install.cmd`; saved worker profiles and worktrees are preserved. Upgrading from 0.1.0 retires the old Main entry and its manager-created desktop shortcut, saves a registry backup, and leaves the default Codex profile data in place. Removing a worker removes its registry entry, while keeping its credentials, files, worktree, and shortcut. A renamed instance can leave its previous shortcut, which still points to the same instance ID.

## Compatibility and limitations

- The desktop mechanism was inspected in package `OpenAI.Codex` version `26.1002.7124.0`. The launcher resolves the installed app path at runtime.
- It uses `CODEX_ELECTRON_USER_DATA_PATH` with a separate `CODEX_HOME`. The desktop override is undocumented; separate-window behavior, OAuth callbacks, shared-memory retrieval, and device-wide integrations still need testing across versions.
- The Git workflow, argument quoting, profile environment isolation, registry persistence, and guidance refresh have automated checks. A public UI preview is rendered from the WPF layout with fictitious paths.
- This tool does not bypass authentication, permissions, account limits, or plan restrictions.
- There is no auto-updater, cloud sync, or telemetry in this launcher. Codex itself remains a separate application with its own behavior and settings.

## Development

```powershell
# Run without installing
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File .\src\Manager.ps1

# Check source syntax and the core workflow using a temporary repository
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Test.ps1

# Produce the release ZIP and SHA-256 checksum
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Build-Release.ps1
```

The static website lives in `docs/` and is published by GitHub Pages from `main:/docs`. Windows CI runs the checks and builds a release artifact. Release automation publishes a ZIP when a `v*` tag is pushed.

See [CONTRIBUTING.md](CONTRIBUTING.md) for contributions, [SECURITY.md](SECURITY.md) for sensitive reports, and [CHANGELOG.md](CHANGELOG.md) for release notes. Licensed under [MIT](LICENSE).

Relevant upstream documentation: [Codex desktop links](https://learn.chatgpt.com/docs/app/commands), [global AGENTS guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md), and [Codex state locations](https://learn.chatgpt.com/docs/config-file/environment-variables).
