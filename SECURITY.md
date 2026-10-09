# Security

Do not attach `auth.json`, access tokens, browser profiles, SQLite state, memory contents, or your complete instance folder to an issue.

For sensitive reports, use the repository's **Security > Report a vulnerability** flow when available. If private reporting is unavailable, open a public issue asking for a private contact channel without including exploit details or personal data.

Profile isolation separates application state; it is not a security sandbox between Windows users or processes. This launcher neither enforces account policies nor overrides Codex permission settings.

This release is experimental. Compatibility depends on an undocumented desktop profile override and should be checked after app updates.

The manager does not copy conversations or credentials between profiles. Previous imports are preserved as existing user data on update. Do not publish transcript files or old import manifests in bug reports.
