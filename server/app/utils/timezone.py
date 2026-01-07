"""时区处理工具

多时区应用的最佳实践：
1. 数据库永远存储 UTC（naive datetime）
2. 用户输入时，从用户时区转换为 UTC
3. 返回给用户时，从 UTC 转换为用户时区
"""

from datetime import datetime
from typing import cast
from zoneinfo import ZoneInfo

# 默认时区
DEFAULT_TIMEZONE = "UTC"


class TimezoneHelper:
    """时区转换辅助类"""

    @staticmethod
    def user_to_utc(dt: datetime, user_timezone: str = DEFAULT_TIMEZONE) -> datetime:
        """将用户时区的时间转换为 UTC（用于存储）

        Args:
            dt: 用户时区的 datetime（可以是 naive 或 aware）
            user_timezone: 用户时区字符串，如 "Asia/Shanghai"

        Returns:
            UTC 时间（naive datetime，用于数据库存储）

        Example:
            >>> # 用户在北京时间 2025-12-02 21:00 创建记录
            >>> beijing_time = datetime(2025, 12, 2, 21, 0)
            >>> utc_time = TimezoneHelper.user_to_utc(beijing_time, "Asia/Shanghai")
            >>> print(utc_time)
            2025-12-02 13:00:00  # UTC 时间，存入数据库
        """
        # 如果已经是 aware，先转换为用户时区
        if dt.tzinfo is not None:
            user_tz = ZoneInfo(user_timezone)
            dt_in_user_tz = dt.astimezone(user_tz)
        else:
            # 如果是 naive，假定它是用户时区的时间
            user_tz = ZoneInfo(user_timezone)
            dt_in_user_tz = dt.replace(tzinfo=user_tz)

        # 转换为 UTC aware
        utc_aware = dt_in_user_tz.astimezone(ZoneInfo("UTC"))

        # 移除时区信息，返回 naive（用于数据库）
        return utc_aware.replace(tzinfo=None)

    @staticmethod
    def utc_to_user(dt: datetime, user_timezone: str = DEFAULT_TIMEZONE, as_string: bool = False) -> datetime | str:
        """将 UTC 时间转换为用户时区（用于展示）

        Args:
            dt: UTC 时间（naive datetime，从数据库读取）
            user_timezone: 用户时区字符串，如 "Asia/Shanghai"
            as_string: 是否返回 ISO 格式字符串

        Returns:
            用户时区的时间（aware datetime 或 ISO 字符串）

        Example:
            >>> # 从数据库读取 UTC 时间
            >>> utc_time = datetime(2025, 12, 2, 13, 0)
            >>> beijing_time = TimezoneHelper.utc_to_user(utc_time, "Asia/Shanghai")
            >>> print(beijing_time)
            2025-12-02 21:00:00+08:00  # 北京时间

            >>> # 返回字符串格式
            >>> time_str = TimezoneHelper.utc_to_user(utc_time, "Asia/Shanghai", as_string=True)
            >>> print(time_str)
            "2025-12-02T21:00:00+08:00"
        """
        # 标记为 UTC aware
        if dt.tzinfo is None:
            utc_aware = dt.replace(tzinfo=ZoneInfo("UTC"))
        else:
            utc_aware = dt.astimezone(ZoneInfo("UTC"))

        # 转换为用户时区
        user_tz = ZoneInfo(user_timezone)
        user_time = utc_aware.astimezone(user_tz)

        if as_string:
            return user_time.isoformat()

        return user_time

    @staticmethod
    def now_utc() -> datetime:
        """获取当前 UTC 时间（naive，用于数据库存储）

        Returns:
            当前 UTC 时间（naive datetime）
        """
        return datetime.now(ZoneInfo("UTC")).replace(tzinfo=None)

    @staticmethod
    def now_in_timezone(timezone: str = DEFAULT_TIMEZONE) -> datetime:
        """获取指定时区的当前时间（aware）

        Args:
            timezone: 时区字符串，如 "Asia/Shanghai"

        Returns:
            指定时区的当前时间（aware datetime）
        """
        tz = ZoneInfo(timezone)
        return datetime.now(tz)

    @staticmethod
    def parse_user_datetime(datetime_str: str, user_timezone: str = DEFAULT_TIMEZONE) -> datetime:
        """解析用户输入的时间字符串，转换为 UTC（用于存储）

        Args:
            datetime_str: 时间字符串，如 "2025-12-02T21:00:00" 或 "2025-12-02 21:00:00"
            user_timezone: 用户时区

        Returns:
            UTC 时间（naive datetime，用于数据库存储）

        Example:
            >>> # 用户在北京输入 "2025-12-02 21:00"
            >>> utc_time = TimezoneHelper.parse_user_datetime(
            ...     "2025-12-02 21:00:00",
            ...     "Asia/Shanghai"
            ... )
            >>> print(utc_time)
            2025-12-02 13:00:00  # UTC 时间
        """
        # 解析字符串
        dt_str = datetime_str.replace("T", " ").strip()
        dt = datetime.fromisoformat(dt_str)

        # 转换为 UTC
        return TimezoneHelper.user_to_utc(dt, user_timezone)

    @staticmethod
    def format_for_user(
        dt: datetime, user_timezone: str = DEFAULT_TIMEZONE, format_str: str = "%Y-%m-%d %H:%M:%S"
    ) -> str:
        """格式化时间为用户时区的字符串

        Args:
            dt: UTC 时间（naive datetime）
            user_timezone: 用户时区
            format_str: 格式化字符串

        Returns:
            格式化后的时间字符串

        Example:
            >>> utc_time = datetime(2025, 12, 2, 13, 0)
            >>> formatted = TimezoneHelper.format_for_user(
            ...     utc_time,
            ...     "Asia/Shanghai",
            ...     "%Y年%m月%d日 %H:%M"
            ... )
            >>> print(formatted)
            "2025年12月02日 21:00"
        """
        user_time = cast(datetime, TimezoneHelper.utc_to_user(dt, user_timezone))
        return user_time.strftime(format_str)


# 便捷函数
def to_utc(dt: datetime, user_timezone: str = DEFAULT_TIMEZONE) -> datetime:
    """快捷方式：用户时区 -> UTC"""
    return TimezoneHelper.user_to_utc(dt, user_timezone)


def from_utc(dt: datetime, user_timezone: str = DEFAULT_TIMEZONE) -> datetime:
    """快捷方式：UTC -> 用户时区"""
    return cast(datetime, TimezoneHelper.utc_to_user(dt, user_timezone))


def now_utc() -> datetime:
    """快捷方式：当前 UTC 时间"""
    return TimezoneHelper.now_utc()


def parse_with_zone(datetime_str: str, user_timezone: str = DEFAULT_TIMEZONE) -> tuple[datetime, str]:
    """快捷方式：解析时间并返回 UTC 时间和原始时区

    用于交易等需要记录原始时区的场景

    Args:
        datetime_str: 时间字符串
        user_timezone: 用户时区

    Returns:
        (UTC 时间, 原始时区) 的元组

    Example:
        >>> utc_time, zone = parse_with_zone("2025-12-02 21:00:00", "Asia/Shanghai")
        >>> # utc_time: 2025-12-02 13:00:00
        >>> # zone: "Asia/Shanghai"
    """
    utc_time = TimezoneHelper.parse_user_datetime(datetime_str, user_timezone)
    return utc_time, user_timezone
