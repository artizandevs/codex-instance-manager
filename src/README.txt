Codex Instance Manager for Windows 11

Run Install.cmd to install for the current Windows user. No administrator
installation or additional runtime is needed. Open the desktop shortcut
"Codex Instance Manager". Open your default Codex window normally; this manager
only lists and launches additional instances. Existing
Account 2/3 profiles are imported only when found. Add other named instances.

Select an instance or click New instance. Set its name, repository and optional
Git worktree. Browse loads local/remote branches. Choose test as the base and
a distinct working branch, or leave working branch blank for a generated name.
Save creates a missing worktree and a desktop shortcut. Existing worktrees
must belong to the selected repository and use the selected working branch.
The launcher never switches, resets, rebases, commits or deletes your branches.
Ignored files, dependencies and databases are not copied; set up a new worktree
as needed. Use different development-server ports for parallel workers.

Save & launch opens the correct profile with a local project and new chat draft.
The prompt is prefilled; press Send in Codex to begin. Alternatively enter an
existing local chat ID/link. That chat must exist in the selected instance's
own local history. A main-account chat cannot be opened by a different account.
Launches pass links directly to the app executable, not Windows' global URL
handler. The latest saved settings are used by each desktop shortcut.

Your default window retains %USERPROFILE%\.codex and its desktop profile. Workers
retain independent credentials and state. Shared main knowledge is optional
and OFF by default for new workers. If enabled, workers consult main knowledge
through global AGENTS instructions. Read context can enter that worker's model
context. New worker memories are not merged automatically.
Shared knowledge is instruction-based read-only use, not a Windows ACL boundary.
Main global guidance is refreshed into workers at launch; memories are consulted
in place. Start new chats to load changed global instructions.

Storage: %LOCALAPPDATA%\OpenAI\CodexInstanceManager
The app folder holds this launcher. instances.json holds names and project
assignments. Additional profile folders contain credentials; do not commit them.
Previous Account 2/3 folders under CodexMultiAccount are reused when found.
Upgrades retire the previous Main manager entry and its generated desktop
shortcut, with a registry backup. Your default Codex data stays in place.
Removing an instance removes only its manager entry and keeps all files.
Changes to a saved name can leave an old desktop shortcut; it still references
the same instance ID. The refreshed shortcut has the new name.

The app's CODEX_ELECTRON_USER_DATA_PATH desktop override is undocumented and
could change after updates. The launcher resolves the current Store app path
each time. Browser sign-ins should be completed sequentially and each account
checked in its own app window. First-time sign-in may delay startup navigation;
run the shortcut again after login if necessary.

This is an unofficial community tool, not affiliated with or endorsed by
OpenAI. Simultaneous sign-ins and browser callbacks still need wider live
testing. The launcher does not bypass account limits or permissions.

Website: https://cim.rtzn.pt/
Source: https://github.com/artizandevs/codex-instance-manager
License: MIT (see LICENSE in the download)

Supported new-chat links: https://learn.chatgpt.com/docs/app/commands
Shared guidance: https://learn.chatgpt.com/docs/agent-configuration/agents-md
