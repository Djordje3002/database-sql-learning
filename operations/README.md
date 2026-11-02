# Database Operations

> **English** · [Srpski](README.sr.md)

Database work is not complete when a query runs locally. This operational track teaches the habits that protect data when a schema evolves, a deployment fails, or recovery is needed.

| Runbook | Use it when |
| --- | --- |
| [Backup, restore, and recovery](backup-and-restore.md) | planning backups or proving recovery works |
| [Migrations and safe deployment](migrations-and-deployment.md) | changing schema or shipping application code |

## Non-negotiable rules

1. A backup is not a backup until a restore has succeeded in an isolated environment.
2. Every destructive action needs a confirmed target, an owner, and a recovery path.
3. Schema changes are version-controlled migrations, never undocumented manual production edits.
4. Backward-compatible expand → migrate → contract changes reduce deployment risk.
5. Production credentials are least-privilege, rotated secrets; never put them in source code or logs.

Start with the [backup and restore runbook](backup-and-restore.md), then follow the [migration guide](migrations-and-deployment.md).
