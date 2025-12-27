from enum import Enum


class TransactionCategory(str, Enum):
    """Transaction Category Keys (Standardized)"""

    # --- 1. EXPENSE ---
    FOOD_DINING = "FOOD_DINING"
    SHOPPING_RETAIL = "SHOPPING_RETAIL"
    TRANSPORTATION = "TRANSPORTATION"
    HOUSING_UTILITIES = "HOUSING_UTILITIES"
    PERSONAL_CARE = "PERSONAL_CARE"
    ENTERTAINMENT = "ENTERTAINMENT"
    EDUCATION = "EDUCATION"
    MEDICAL_HEALTH = "MEDICAL_HEALTH"
    INSURANCE = "INSURANCE"
    SOCIAL_GIFTING = "SOCIAL_GIFTING"
    FINANCIAL_TAX = "FINANCIAL_TAX"
    OTHERS = "OTHERS"

    # --- 2. INCOME ---
    SALARY_WAGE = "SALARY_WAGE"
    BUSINESS_TRADE = "BUSINESS_TRADE"
    INVESTMENT_RETURNS = "INVESTMENT_RETURNS"
    GIFT_BONUS = "GIFT_BONUS"
    REFUND_REBATE = "REFUND_REBATE"

    # --- 3. TRANSFER ---
    GENERAL_TRANSFER = "GENERAL_TRANSFER"
    DEBT_REPAYMENT = "DEBT_REPAYMENT"


# Category Groupings
EXPENSE_CATEGORIES = [
    TransactionCategory.FOOD_DINING,
    TransactionCategory.SHOPPING_RETAIL,
    TransactionCategory.TRANSPORTATION,
    TransactionCategory.HOUSING_UTILITIES,
    TransactionCategory.PERSONAL_CARE,
    TransactionCategory.ENTERTAINMENT,
    TransactionCategory.EDUCATION,
    TransactionCategory.MEDICAL_HEALTH,
    TransactionCategory.INSURANCE,
    TransactionCategory.SOCIAL_GIFTING,
    TransactionCategory.FINANCIAL_TAX,
    TransactionCategory.OTHERS,
]

INCOME_CATEGORIES = [
    TransactionCategory.SALARY_WAGE,
    TransactionCategory.BUSINESS_TRADE,
    TransactionCategory.INVESTMENT_RETURNS,
    TransactionCategory.GIFT_BONUS,
    TransactionCategory.REFUND_REBATE,
]

TRANSFER_CATEGORIES = [
    TransactionCategory.GENERAL_TRANSFER,
    TransactionCategory.DEBT_REPAYMENT,
]
