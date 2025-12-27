// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentTransactionFeedType)
const currentTransactionFeedTypeProvider =
    CurrentTransactionFeedTypeProvider._();

final class CurrentTransactionFeedTypeProvider
    extends $NotifierProvider<CurrentTransactionFeedType, TransactionFeedType> {
  const CurrentTransactionFeedTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTransactionFeedTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTransactionFeedTypeHash();

  @$internal
  @override
  CurrentTransactionFeedType create() => CurrentTransactionFeedType();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionFeedType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionFeedType>(value),
    );
  }
}

String _$currentTransactionFeedTypeHash() =>
    r'32e384260e29d1e2f3ecf4871720e92d80f4f2e3';

abstract class _$CurrentTransactionFeedType
    extends $Notifier<TransactionFeedType> {
  TransactionFeedType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TransactionFeedType, TransactionFeedType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionFeedType, TransactionFeedType>,
              TransactionFeedType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CurrentDisplayMonth)
const currentDisplayMonthProvider = CurrentDisplayMonthProvider._();

final class CurrentDisplayMonthProvider
    extends $NotifierProvider<CurrentDisplayMonth, DateTime> {
  const CurrentDisplayMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDisplayMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDisplayMonthHash();

  @$internal
  @override
  CurrentDisplayMonth create() => CurrentDisplayMonth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$currentDisplayMonthHash() =>
    r'841b72f2429c66886a2cddd9128c620b18d736cb';

abstract class _$CurrentDisplayMonth extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedDate)
const selectedDateProvider = SelectedDateProvider._();

final class SelectedDateProvider
    extends $NotifierProvider<SelectedDate, DateTime?> {
  const SelectedDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDateHash();

  @$internal
  @override
  SelectedDate create() => SelectedDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$selectedDateHash() => r'2924a8d0ca7f3568bf857536dfc19912050d24f5';

abstract class _$SelectedDate extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(totalExpense)
const totalExpenseProvider = TotalExpenseProvider._();

final class TotalExpenseProvider
    extends
        $FunctionalProvider<
          AsyncValue<TotalExpenseData>,
          TotalExpenseData,
          FutureOr<TotalExpenseData>
        >
    with $FutureModifier<TotalExpenseData>, $FutureProvider<TotalExpenseData> {
  const TotalExpenseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalExpenseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalExpenseHash();

  @$internal
  @override
  $FutureProviderElement<TotalExpenseData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TotalExpenseData> create(Ref ref) {
    return totalExpense(ref);
  }
}

String _$totalExpenseHash() => r'1f85f74a152ffb9ab61c0bed0905f7a52185df98';

@ProviderFor(calendarMonthData)
const calendarMonthDataProvider = CalendarMonthDataFamily._();

final class CalendarMonthDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<CalendarMonthData>,
          CalendarMonthData,
          FutureOr<CalendarMonthData>
        >
    with
        $FutureModifier<CalendarMonthData>,
        $FutureProvider<CalendarMonthData> {
  const CalendarMonthDataProvider._({
    required CalendarMonthDataFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'calendarMonthDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$calendarMonthDataHash();

  @override
  String toString() {
    return r'calendarMonthDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CalendarMonthData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CalendarMonthData> create(Ref ref) {
    final argument = this.argument as DateTime;
    return calendarMonthData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarMonthDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calendarMonthDataHash() => r'4efd50c45393d896f76fe15db3ee8c5ffbcb3b0c';

final class CalendarMonthDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CalendarMonthData>, DateTime> {
  const CalendarMonthDataFamily._()
    : super(
        retry: null,
        name: r'calendarMonthDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CalendarMonthDataProvider call(DateTime monthYear) =>
      CalendarMonthDataProvider._(argument: monthYear, from: this);

  @override
  String toString() => r'calendarMonthDataProvider';
}

@ProviderFor(transactionsForSelectedDate)
const transactionsForSelectedDateProvider =
    TransactionsForSelectedDateFamily._();

final class TransactionsForSelectedDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionModel>>,
          List<TransactionModel>,
          FutureOr<List<TransactionModel>>
        >
    with
        $FutureModifier<List<TransactionModel>>,
        $FutureProvider<List<TransactionModel>> {
  const TransactionsForSelectedDateProvider._({
    required TransactionsForSelectedDateFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'transactionsForSelectedDateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionsForSelectedDateHash();

  @override
  String toString() {
    return r'transactionsForSelectedDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<TransactionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TransactionModel>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return transactionsForSelectedDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsForSelectedDateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionsForSelectedDateHash() =>
    r'7ecacf8340fdd6f817319b9521a02fcd27848b04';

final class TransactionsForSelectedDateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TransactionModel>>, DateTime> {
  const TransactionsForSelectedDateFamily._()
    : super(
        retry: null,
        name: r'transactionsForSelectedDateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionsForSelectedDateProvider call(DateTime date) =>
      TransactionsForSelectedDateProvider._(argument: date, from: this);

  @override
  String toString() => r'transactionsForSelectedDateProvider';
}

@ProviderFor(TransactionFeed)
const transactionFeedProvider = TransactionFeedProvider._();

final class TransactionFeedProvider
    extends $NotifierProvider<TransactionFeed, TransactionFeedState> {
  const TransactionFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionFeedHash();

  @$internal
  @override
  TransactionFeed create() => TransactionFeed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionFeedState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionFeedState>(value),
    );
  }
}

String _$transactionFeedHash() => r'1c9199c9c7181ebdc71d0ba58eb8c6579cd9b764';

abstract class _$TransactionFeed extends $Notifier<TransactionFeedState> {
  TransactionFeedState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TransactionFeedState, TransactionFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionFeedState, TransactionFeedState>,
              TransactionFeedState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
