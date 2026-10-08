# Contributing

Open an issue with a concrete bug or proposed change, or submit a focused pull request. Include your Windows version, Codex package version, and steps to reproduce when reporting compatibility problems. Keep account emails, tokens, memory contents, private repository paths, and startup prompts out of reports.

Run `scripts/Test.ps1` on Windows before submitting changes. Changes to profile handling must preserve the main home and isolate worker authentication and databases. Changes to Git handling must preserve existing work, reject mismatched worktrees, and avoid implicit resets, switches, merges, or deletion.

UI changes should include a rendered preview using `src/Manager.ps1 -RenderPreview -PreviewPath <absolute-png-path> -DataRoot <temporary-folder>`. The preview uses fictitious paths; never commit your live instance registry or profile folders.

Keep dependencies small: the launcher currently uses only Windows PowerShell, WPF, Git, and built-in Windows shortcut support. Documentation and the Pages website should accurately describe tested behavior and known limitations.
