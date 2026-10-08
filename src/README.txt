Codex Instance Manager for Windows 11

Run Install.cmd, then open the Codex Instance Manager desktop shortcut.
Choose New instance, name it, and click Save or Open Codex.
Save creates a desktop shortcut. Sign into the intended account on first use.
Keep your main Codex window open normally; it is not managed by this tool.

Copy main projects & chats optionally imports independent local snapshots.
Close the selected additional instance before copying; main can stay open.
Copies retain local project folders and chat context. Repeating the import
adds new chats, without overwriting conversations already continued here.
There is no live synchronization. Cloud ChatGPT chats and open tabs cannot
be imported. Project entries use the same disk folders, not duplicate files.
No main credentials, browser state or databases are copied. Chat context can
be sent to the selected account's model provider when you continue a chat.

Consult main guidance and memories is optional and off by default.
It adds guidance to read relevant main knowledge in place. This is an
instruction rule, not a Windows security boundary. New memories stay separate.

Updates preserve existing account folders and worktrees. Old branch/repo/
startup settings are retired with an instances.json backup. Removing an
instance removes its manager entry and keeps its files and shortcut.

Storage: %LOCALAPPDATA%\OpenAI\CodexInstanceManager
Profile folders contain private account data; do not publish them.

This unofficial community tool uses undocumented desktop isolation and
experimental import APIs. Codex updates can change compatibility.
Complete initial account sign-ins one at a time and check each account.
No prompts are submitted by the launcher or importer.

Website: https://cim.rtzn.pt/
Source: https://github.com/artizandevs/codex-instance-manager
License: MIT. Read README.md for details and compatibility limits.
