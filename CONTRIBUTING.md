# Contributing

Open an issue with a concrete bug or proposed change, or submit a focused pull request. Include your Windows version, Codex package version, and steps to reproduce when reporting compatibility problems. Keep account emails, tokens, memory contents, private repository paths, and startup prompts out of reports.

Run `scripts/Test.ps1` on Windows before submitting changes. Changes to profile handling must preserve the main home and isolate worker authentication and databases. Import changes must preserve independent histories, reject incomplete or missing dependencies, and never overwrite existing conversations or copy authentication/database state.

UI changes should include a rendered preview using `src/Manager.ps1 -RenderPreview -PreviewPath <absolute-png-path> -DataRoot <temporary-folder>`. The preview uses fictitious paths; never commit your live instance registry or profile folders.

Keep dependencies small: the launcher currently uses only Windows PowerShell, WPF, the installed Codex backend, and built-in Windows shortcut support. Documentation and the Pages website should accurately describe tested behavior and known limitations.
