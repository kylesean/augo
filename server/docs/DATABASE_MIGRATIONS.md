# Database Migrations

This project uses [Alembic](https://alembic.sqlalchemy.org/) for database schema management.

## Quick Reference

```bash
# Generate new migration
make db-migrate MSG="add_new_table"

# Apply migrations
make db-upgrade

# Rollback
make db-downgrade

# Check current version
make db-current
```

## Migration Structure

```
alembic/versions/
├── 0001_extensions.py           # pgvector, uuid-ossp
├── 0002_create_users.py         # users, user_settings
├── 0003_create_sessions.py
├── 0004_create_storage.py
├── 0005_create_financial_accounts.py
├── 0006_create_transactions.py  # + comments, shares, recurring
├── 0007_create_budgets.py       # budgets, periods, settings
├── 0008_create_shared_spaces.py
├── 0009_create_notifications.py
├── 0010_create_searchable_messages.py
├── 0011_create_forecast_tables.py
├── 0012_create_financial_settings.py
└── 0013_stored_procedures.py    # rebuild_account_snapshots()
```

## Workflow

### Adding a New Table

```bash
# 1. Create migration file
cd server
uv run alembic revision -m "create_invoices_table"

# 2. Edit the generated file
# Add op.create_table(), indexes, constraints

# 3. Apply
make db-upgrade
```

### Modifying an Existing Table

```bash
# 1. Create migration
uv run alembic revision -m "add_status_to_invoices"

# 2. Edit - example:
def upgrade():
    op.add_column('invoices', sa.Column('status', sa.String(20)))
    op.create_index('ix_invoices_status', 'invoices', ['status'])

def downgrade():
    op.drop_index('ix_invoices_status')
    op.drop_column('invoices', 'status')

# 3. Apply
make db-upgrade
```

### Rolling Back

```bash
# Rollback last migration
make db-downgrade

# Rollback multiple
uv run alembic downgrade -3

# Rollback to specific version
uv run alembic downgrade 0010
```

## Excluded Tables

These tables are managed externally:

| Tables | Managed By |
|--------|-----------|
| `checkpoints`, `checkpoint_*` | LangGraph |
| `longterm_memory`, `mem0*` | Mem0 |

See [alembic/env.py](file:///home/kylesean/projects/python/augo/server/alembic/env.py) → `include_object()` for the filter.

## Fresh Database Setup

```bash
# 1. Create database
createdb augo

# 2. Run migrations
cd server && uv run alembic upgrade head

# 3. Initialize external components
PYTHONPATH=. python scripts/bootstrap.py
```
