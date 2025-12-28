// features/chat/providers/welcome_guide_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:augo/i18n/strings.g.dart';

part 'welcome_guide_provider.g.dart';

/// 时段枚举
enum TimeSlot { morning, midday, afternoon, evening, night }

/// 场景化建议模型
class ContextualSuggestion {
  final String emoji;
  final String Function() titleGetter;
  final String Function() promptGetter;
  final String Function() descriptionGetter;

  const ContextualSuggestion({
    required this.emoji,
    required this.titleGetter,
    required this.promptGetter,
    required this.descriptionGetter,
  });

  String get title => titleGetter();
  String get prompt => promptGetter();
  String get description => descriptionGetter();
}

/// 欢迎引导状态
class WelcomeGuideState {
  final TimeSlot timeSlot;
  final String greeting;
  final String subtitle;
  final List<ContextualSuggestion> suggestions;

  const WelcomeGuideState({
    required this.timeSlot,
    required this.greeting,
    required this.subtitle,
    required this.suggestions,
  });
}

/// 根据小时数获取时段
TimeSlot _getTimeSlot(int hour) {
  if (hour >= 5 && hour < 11) {
    return TimeSlot.morning;
  } else if (hour >= 11 && hour < 14) {
    return TimeSlot.midday;
  } else if (hour >= 14 && hour < 18) {
    return TimeSlot.afternoon;
  } else if (hour >= 18 && hour < 22) {
    return TimeSlot.evening;
  } else {
    return TimeSlot.night;
  }
}

/// 根据时段获取问候语
String _getGreeting(TimeSlot slot) {
  switch (slot) {
    case TimeSlot.morning:
      return t.greeting.morning;
    case TimeSlot.midday:
      return t.chat.welcome.midday.greeting;
    case TimeSlot.afternoon:
      return t.greeting.afternoon;
    case TimeSlot.evening:
      return t.greeting.evening;
    case TimeSlot.night:
      return t.chat.welcome.night.greeting;
  }
}

/// 根据时段获取副标题
String _getSubtitle(TimeSlot slot) {
  switch (slot) {
    case TimeSlot.morning:
      return t.chat.welcome.morning.subtitle;
    case TimeSlot.midday:
      return t.chat.welcome.midday.subtitle;
    case TimeSlot.afternoon:
      return t.chat.welcome.afternoon.subtitle;
    case TimeSlot.evening:
      return t.chat.welcome.evening.subtitle;
    case TimeSlot.night:
      return t.chat.welcome.night.subtitle;
  }
}

/// 根据时段获取场景化建议
List<ContextualSuggestion> _getSuggestionsForSlot(TimeSlot slot) {
  switch (slot) {
    case TimeSlot.morning:
      return [
        ContextualSuggestion(
          emoji: '🥐',
          titleGetter: () => t.chat.welcome.morning.breakfast.title,
          promptGetter: () => t.chat.welcome.morning.breakfast.prompt,
          descriptionGetter: () => t.chat.welcome.morning.breakfast.description,
        ),
        ContextualSuggestion(
          emoji: '📊',
          titleGetter: () => t.chat.welcome.morning.yesterdayReview.title,
          promptGetter: () => t.chat.welcome.morning.yesterdayReview.prompt,
          descriptionGetter: () =>
              t.chat.welcome.morning.yesterdayReview.description,
        ),
        ContextualSuggestion(
          emoji: '💡',
          titleGetter: () => t.chat.welcome.morning.todayBudget.title,
          promptGetter: () => t.chat.welcome.morning.todayBudget.prompt,
          descriptionGetter: () =>
              t.chat.welcome.morning.todayBudget.description,
        ),
      ];

    case TimeSlot.midday:
      return [
        ContextualSuggestion(
          emoji: '🍜',
          titleGetter: () => t.chat.welcome.midday.lunch.title,
          promptGetter: () => t.chat.welcome.midday.lunch.prompt,
          descriptionGetter: () => t.chat.welcome.midday.lunch.description,
        ),
        ContextualSuggestion(
          emoji: '📈',
          titleGetter: () => t.chat.welcome.midday.weeklyExpense.title,
          promptGetter: () => t.chat.welcome.midday.weeklyExpense.prompt,
          descriptionGetter: () =>
              t.chat.welcome.midday.weeklyExpense.description,
        ),
        ContextualSuggestion(
          emoji: '💰',
          titleGetter: () => t.chat.welcome.midday.checkBalance.title,
          promptGetter: () => t.chat.welcome.midday.checkBalance.prompt,
          descriptionGetter: () =>
              t.chat.welcome.midday.checkBalance.description,
        ),
      ];

    case TimeSlot.afternoon:
      return [
        ContextualSuggestion(
          emoji: '☕',
          titleGetter: () => t.chat.welcome.afternoon.quickRecord.title,
          promptGetter: () => t.chat.welcome.afternoon.quickRecord.prompt,
          descriptionGetter: () =>
              t.chat.welcome.afternoon.quickRecord.description,
        ),
        ContextualSuggestion(
          emoji: '📊',
          titleGetter: () => t.chat.welcome.afternoon.analyzeSpending.title,
          promptGetter: () => t.chat.welcome.afternoon.analyzeSpending.prompt,
          descriptionGetter: () =>
              t.chat.welcome.afternoon.analyzeSpending.description,
        ),
        ContextualSuggestion(
          emoji: '🎯',
          titleGetter: () => t.chat.welcome.afternoon.budgetProgress.title,
          promptGetter: () => t.chat.welcome.afternoon.budgetProgress.prompt,
          descriptionGetter: () =>
              t.chat.welcome.afternoon.budgetProgress.description,
        ),
      ];

    case TimeSlot.evening:
      return [
        ContextualSuggestion(
          emoji: '🍽️',
          titleGetter: () => t.chat.welcome.evening.dinner.title,
          promptGetter: () => t.chat.welcome.evening.dinner.prompt,
          descriptionGetter: () => t.chat.welcome.evening.dinner.description,
        ),
        ContextualSuggestion(
          emoji: '📋',
          titleGetter: () => t.chat.welcome.evening.todaySummary.title,
          promptGetter: () => t.chat.welcome.evening.todaySummary.prompt,
          descriptionGetter: () =>
              t.chat.welcome.evening.todaySummary.description,
        ),
        ContextualSuggestion(
          emoji: '📆',
          titleGetter: () => t.chat.welcome.evening.tomorrowPlan.title,
          promptGetter: () => t.chat.welcome.evening.tomorrowPlan.prompt,
          descriptionGetter: () =>
              t.chat.welcome.evening.tomorrowPlan.description,
        ),
      ];

    case TimeSlot.night:
      return [
        ContextualSuggestion(
          emoji: '📝',
          titleGetter: () => t.chat.welcome.night.makeupRecord.title,
          promptGetter: () => t.chat.welcome.night.makeupRecord.prompt,
          descriptionGetter: () =>
              t.chat.welcome.night.makeupRecord.description,
        ),
        ContextualSuggestion(
          emoji: '📊',
          titleGetter: () => t.chat.welcome.night.monthlyReview.title,
          promptGetter: () => t.chat.welcome.night.monthlyReview.prompt,
          descriptionGetter: () =>
              t.chat.welcome.night.monthlyReview.description,
        ),
        ContextualSuggestion(
          emoji: '🌙',
          titleGetter: () => t.chat.welcome.night.financialThinking.title,
          promptGetter: () => t.chat.welcome.night.financialThinking.prompt,
          descriptionGetter: () =>
              t.chat.welcome.night.financialThinking.description,
        ),
      ];
  }
}

/// 欢迎引导 Provider - 根据当前时段返回问候语和场景化建议
@riverpod
WelcomeGuideState welcomeGuide(Ref ref) {
  final hour = DateTime.now().hour;
  final slot = _getTimeSlot(hour);

  return WelcomeGuideState(
    timeSlot: slot,
    greeting: _getGreeting(slot),
    subtitle: _getSubtitle(slot),
    suggestions: _getSuggestionsForSlot(slot),
  );
}
