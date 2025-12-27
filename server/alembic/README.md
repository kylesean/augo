# Database Migrations with Alembic

This directory contains database migration scripts managed by Alembic.

## Quick Start

### Create a new migration

```bash
# Auto-generate migration from model changes
alembic revision --autogenerate -m "description of changes"

# Create empty migration
alembic revision -m "description of changes"
```

### Apply migrations

```bash
# Upgrade to latest version
alembic upgrade head

# Upgrade by one version
alembic upgrade +1

# Upgrade to specific revision
alembic upgrade <revision_id>
```

### Rollback migrations

```bash
# Downgrade by one version
alembic downgrade -1

# Downgrade to specific revision
alembic downgrade <revision_id>

# Downgrade to base (remove all migrations)
alembic downgrade base
```

### View migration history

```bash
# Show current revision
alembic current

# Show migration history
alembic history

# Show pending migrations
alembic history --verbose
```

## Migration Best Practices

1. **Always review auto-generated migrations** - Alembic's autogenerate is helpful but not perfect
2. **Test migrations in development first** - Never run untested migrations in production
3. **Write reversible migrations** - Always implement both `upgrade()` and `downgrade()`
4. **Keep migrations small** - One logical change per migration
5. **Add comments** - Explain complex migrations
6. **Backup before migrating** - Always backup production database before running migrations

## Environment Configuration

Alembic reads database configuration from environment variables via `app/core/config.py`:

- `POSTGRES_HOST` - Database host
- `POSTGRES_PORT` - Database port
- `POSTGRES_DB` - Database name
- `POSTGRES_USER` - Database user
- `POSTGRES_PASSWORD` - Database password

## Initial Migration

The initial migration (`001_initial_schema.py`) creates all base tables:

- Users and authentication
- Conversations and messages
- Transactions and financial data
- Attachments and file storage
- Notifications

This migration is based on the existing PHP Hyperf application schema.

## Adding New Models

When adding new SQLModel models:

1. Import the model in `alembic/env.py`
2. Run `alembic revision --autogenerate -m "add new model"`
3. Review the generated migration
4. Test the migration
5. Apply to database with `alembic upgrade head`

## Troubleshooting

### Migration conflicts

If you have migration conflicts:

```bash
# View current state
alembic current

# View history
alembic history

# Merge branches if needed
alembic merge -m "merge branches" <rev1> <rev2>
```

### Reset migrations (development only)

```bash
# Drop all tables
alembic downgrade base

# Reapply all migrations
alembic upgrade head
```

### Manual SQL execution

If you need to run manual SQL:

```python
def upgrade():
    op.execute("YOUR SQL HERE")
```
