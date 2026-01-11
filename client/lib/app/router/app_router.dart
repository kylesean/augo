import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_step_1_page.dart';
import '../../features/auth/pages/register_step_2_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/chat/pages/ai_chat_page.dart';
import '../../features/layout/pages/bottom_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/profile/pages/appearance_settings_page.dart';
import '../../features/finance/pages/financial_accounts_page.dart';
import '../../features/finance/pages/account_sources_page.dart';
import '../../features/finance/pages/account_edit_page.dart';
import '../../features/finance/pages/account_add_page.dart';

import '../../features/finance/pages/account_type_picker_page.dart';
import '../../features/finance/pages/account_detail_page.dart';
import '../../features/finance/pages/recurring_transaction_page.dart';
import '../../features/finance/pages/recurring_transaction_list_page.dart';
import '../../features/budget/pages/budget_overview_page.dart';
import '../../features/budget/pages/budget_form_page.dart';
import '../../features/budget/pages/budget_detail_page.dart';

import '../../features/home/pages/transaction_detail_page.dart';
import '../../features/profile/pages/language_settings_page.dart';
import '../../features/profile/pages/speech_settings_page.dart';
import '../../features/report/pages/report_page.dart';
import '../../features/shared_space/pages/shared_space_list_page.dart';
import '../../features/shared_space/pages/shared_space_detail_page.dart';
import '../../features/shared_space/pages/invite_success_page.dart';
import '../../features/shared_space/pages/notification_list_page.dart';
import '../../features/shared_space/models/shared_space_models.dart';
import '../../features/profile/pages/currency_settings_page.dart';
import '../../features/profile/pages/amount_settings_page.dart';
import '../../features/server/pages/server_setup_page.dart';
import '../../core/services/server_config_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final isServerConfigured = ref.watch(isServerConfiguredProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    redirect: (BuildContext context, GoRouterState state) {
      final authStatus = authState.status;
      final String location = state.matchedLocation;
      final List<String> publicRoutes = [
        '/login',
        '/register',
        '/register/step2',
        '/forgot-password',
      ];

      if (location.startsWith('/server-setup')) {
        return null;
      }
      if (!isServerConfigured) {
        return '/server-setup';
      }
      final bool isPublicRoute = publicRoutes.any(
        (route) => location.startsWith(route),
      );
      if (isPublicRoute) {
        if (authStatus == AuthStatus.authenticated) {
          return '/home';
        }
        return null;
      }
      if (authStatus == AuthStatus.loading ||
          authStatus == AuthStatus.initial) {
        return null;
      }
      final bool loggedIn = authStatus == AuthStatus.authenticated;
      if (!loggedIn) {
        return '/login';
      }
      return null;
    },

    routes: [
      GoRoute(
        path: '/server-setup',
        name: 'serverSetup',
        builder: (context, state) {
          final isReconfiguring =
              state.uri.queryParameters['reconfigure'] == 'true';
          return ServerSetupPage(isReconfiguring: isReconfiguring);
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'registerStep1',
        builder: (context, state) => const RegisterStep1Page(),
        routes: [
          GoRoute(
            path: 'step2',
            name: 'registerStep2',
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>?;
              final contact = args?['contact'] as String?;
              final verificationCode = args?['verificationCode'] as String?;
              if (contact == null || verificationCode == null) {
                return const Scaffold(
                  body: Center(
                    child: Text(
                      "Registration flow error, missing required information.",
                    ),
                  ),
                );
              }
              return RegisterStep2Page(
                contact: contact,
                verificationCode: verificationCode,
              );
            },
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'transaction/:transactionId',
                    name: 'transactionDetail',
                    builder: (context, state) {
                      final transactionId =
                          state.pathParameters['transactionId']!;
                      return TransactionDetailPage(
                        transactionId: transactionId,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/finance',
                name: 'finance',
                builder: (context, state) {
                  return const FinancialAccountsPage();
                },
                routes: [
                  GoRoute(
                    path: 'accounts',
                    name: 'financialAccounts',
                    builder: (context, state) => const AccountSourcesPage(),
                    routes: [
                      GoRoute(
                        path: 'type-picker',
                        name: 'financialAccountTypePicker',
                        builder: (context, state) =>
                            const AccountTypePickerPage(),
                      ),
                      GoRoute(
                        path: 'add',
                        name: 'financialAccountAdd',
                        builder: (context, state) {
                          final args = state.extra as FinancialAccountAddArgs?;
                          if (args == null) {
                            return const Scaffold(
                              body: Center(
                                child: Text('Account information missing'),
                              ),
                            );
                          }
                          return FinancialAccountAddPage(args: args);
                        },
                      ),
                      GoRoute(
                        path: 'edit',
                        name: 'financialAccountEdit',
                        builder: (context, state) {
                          final args = state.extra as FinancialAccountEditArgs?;
                          if (args == null) {
                            return const Scaffold(
                              body: Center(
                                child: Text('Account information missing'),
                              ),
                            );
                          }
                          return FinancialAccountEditPage(args: args);
                        },
                        routes: [],
                      ),
                      GoRoute(
                        path: 'detail',
                        name: 'financialAccountDetail',
                        builder: (context, state) {
                          final args =
                              state.extra as FinancialAccountDetailArgs?;
                          if (args == null) {
                            return const Scaffold(
                              body: Center(
                                child: Text('Account information missing'),
                              ),
                            );
                          }
                          return FinancialAccountDetailPage(args: args);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'recurring-transactions',
                    name: 'recurringTransactions',
                    builder: (context, state) =>
                        const RecurringTransactionListPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: 'recurringTransactionNew',
                        builder: (context, state) =>
                            const RecurringTransactionPage(),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        name: 'recurringTransactionEdit',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return RecurringTransactionPage(editId: id);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'budgets',
                    name: 'budgetOverview',
                    builder: (context, state) => const BudgetOverviewPage(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        name: 'budgetNew',
                        builder: (context, state) => const BudgetFormPage(),
                      ),
                      GoRoute(
                        path: ':id',
                        name: 'budgetDetail',
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return BudgetDetailPage(budgetId: id);
                        },
                        routes: [
                          GoRoute(
                            path: 'edit',
                            name: 'budgetEdit',
                            builder: (context, state) {
                              final id = state.pathParameters['id']!;
                              return BudgetFormPage(editId: id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai',
                name: 'ai',
                builder: (context, state) {
                  return const AIChatPage(conversationId: null);
                },
                routes: [
                  GoRoute(
                    path: ':conversationId',
                    name: 'conversation',
                    builder: (context, state) {
                      return AIChatPage(
                        conversationId: state.pathParameters['conversationId'],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/report',
                name: 'report',
                builder: (context, state) => const ReportPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'appearance',
                    name: 'appearanceSettings',
                    builder: (context, state) => const AppearanceSettingsPage(),
                  ),
                  GoRoute(
                    path: 'language',
                    name: 'languageSettings',
                    builder: (context, state) => const LanguageSettingsPage(),
                  ),
                  GoRoute(
                    path: 'speech-settings',
                    name: 'speechSettings',
                    builder: (context, state) => const SpeechSettingsPage(),
                  ),
                  GoRoute(
                    path: 'currency',
                    name: 'currencySettings',
                    builder: (context, state) => const CurrencySettingsPage(),
                  ),
                  GoRoute(
                    path: 'amount-style',
                    name: 'amountStyleSettings',
                    builder: (context, state) => const AmountSettingsPage(),
                  ),
                  // Shared space routes
                  GoRoute(
                    path: 'shared-space',
                    name: 'sharedSpaceList',
                    builder: (context, state) => const SharedSpaceListPage(),
                    routes: [
                      GoRoute(
                        path: 'invite-success',
                        name: 'inviteSuccess',
                        builder: (context, state) {
                          final space = state.extra as SharedSpace;
                          return InviteSuccessPage(space: space);
                        },
                      ),
                      GoRoute(
                        path: ':spaceId',
                        name: 'sharedSpaceDetail',
                        builder: (context, state) {
                          final spaceId = state.pathParameters['spaceId']!;
                          return SharedSpaceDetailPage(spaceId: spaceId);
                        },
                        routes: [
                          GoRoute(
                            path: 'settings',
                            name: 'sharedSpaceSettings',
                            builder: (context, state) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('Space Settings'),
                                ),
                                body: const Center(
                                  child: Text(
                                    'Space settings page under development...',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationListPage(),
      ),
      GoRoute(
        path: '/join-space',
        name: 'joinSpace',
        redirect: (context, state) {
          final code = state.uri.queryParameters['code'];
          if (code != null) {
            return '/profile/shared-space?join_code=$code';
          }
          return '/profile/shared-space';
        },
      ),
    ],
  );
});
