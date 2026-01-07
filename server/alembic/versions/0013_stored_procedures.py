"""Create stored procedures.

Revision ID: 0013
Revises: 0012
Create Date: 2026-01-01

Custom PostgreSQL functions for complex operations:
- rebuild_account_snapshots: Rebuild daily balance snapshots for a user
"""

from typing import Sequence, Union

from alembic import op


revision: str = "0013"
down_revision: Union[str, None] = "0012"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create stored procedures."""

    # =========================================================================
    # rebuild_account_snapshots - Rebuild daily balance snapshots for a user
    # =========================================================================
    op.execute("""
        CREATE OR REPLACE FUNCTION public.rebuild_account_snapshots(target_user_uuid uuid)
        RETURNS void
        LANGUAGE plpgsql
        AS $func$
        BEGIN
            -- 1. Clear old snapshots for this user
            DELETE FROM public.account_daily_snapshots
            WHERE user_uuid = target_user_uuid;

            -- 2. Rebuild snapshots from transactions
            INSERT INTO public.account_daily_snapshots (
                snapshot_date,
                account_id,
                user_uuid,
                currency,
                total_incoming,
                total_outgoing,
                balance
            )
            WITH
            date_bounds AS (
                SELECT
                    COALESCE(MIN(transaction_at::date), CURRENT_DATE - INTERVAL '1 year') as min_date,
                    CURRENT_DATE as max_date
                FROM public.transactions
                WHERE user_uuid = target_user_uuid
            ),
            date_series AS (
                SELECT generate_series(min_date, max_date, '1 day')::date as day_date
                FROM date_bounds
            ),
            daily_stats AS (
                SELECT
                    ds.day_date,
                    acct.id as account_id,
                    acct.currency_code,
                    COALESCE(SUM(CASE WHEN t.target_account_id = acct.id THEN t.amount ELSE 0 END), 0) as incoming,
                    COALESCE(SUM(CASE WHEN t.source_account_id = acct.id THEN t.amount ELSE 0 END), 0) as outgoing
                FROM public.financial_accounts acct
                CROSS JOIN date_series ds
                LEFT JOIN public.transactions t
                    ON (t.source_account_id = acct.id OR t.target_account_id = acct.id)
                    AND t.transaction_at::date = ds.day_date
                    AND t.status = 'CLEARED'
                WHERE acct.user_uuid = target_user_uuid
                GROUP BY ds.day_date, acct.id, acct.currency_code
            ),
            running_balance AS (
                SELECT
                    ds.day_date,
                    acct.id as account_id,
                    acct.user_uuid,
                    acct.currency_code,
                    COALESCE(s.incoming, 0) as daily_in,
                    COALESCE(s.outgoing, 0) as daily_out,
                    acct.initial_balance + SUM(COALESCE(s.incoming, 0) - COALESCE(s.outgoing, 0))
                        OVER (PARTITION BY acct.id ORDER BY ds.day_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                    as current_balance
                FROM date_series ds
                CROSS JOIN public.financial_accounts acct
                LEFT JOIN daily_stats s ON s.day_date = ds.day_date AND s.account_id = acct.id
                WHERE acct.user_uuid = target_user_uuid
            )
            SELECT
                day_date,
                account_id,
                user_uuid,
                currency_code,
                daily_in,
                daily_out,
                current_balance
            FROM running_balance;
        END;
        $func$;

        COMMENT ON FUNCTION public.rebuild_account_snapshots IS
            'Rebuild daily account balance snapshots for a specific user.
             Calculates running balances from transaction history.';
    """)


def downgrade() -> None:
    """Drop stored procedures."""
    op.execute("DROP FUNCTION IF EXISTS public.rebuild_account_snapshots(uuid)")
