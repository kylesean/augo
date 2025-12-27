// class ChatMessageList extends ConsumerWidget {
//   const ChatMessageList({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final chatState = ref.watch(chatHistoryProvider);
//     if (chatState.isLoadingHistory) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (chatState.historyError != null) {
//       return Center(child: Text(chatState.historyError!));
//     }
//     // ... Return your ListView.builder to render chatState.messages
//     // If the list is empty, you can display a welcome screen
//   }
// }
