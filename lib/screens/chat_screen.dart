import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/chat_list_item.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  int _lastRenderedMessageCount = 0;
  String? _lastRenderedChatId;

  @override
  void initState() {
    super.initState();
    // Create initial chat if none exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ChatProvider>();
      if (provider.isAuthenticated &&
          provider.currentChat == null &&
          provider.chats.isEmpty) {
        provider.createNewChat();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleAutoScroll(ChatProvider provider) {
    final chatId = provider.currentChat?.id;
    if (!_scrollController.hasClients) return;

    final hasNewChat = chatId != _lastRenderedChatId;
    final hasNewMessages =
        provider.messages.length != _lastRenderedMessageCount;

    if (!hasNewChat && !hasNewMessages) return;

    _lastRenderedChatId = chatId;
    _lastRenderedMessageCount = provider.messages.length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Consumer<ChatProvider>(
          builder: (context, provider, child) {
            return Text(
              provider.currentChat?.title ?? 'AI Chat Bot',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        actions: [
          if (user?.photoURL != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user!.photoURL!),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                child: Text(
                  (user?.displayName?.isNotEmpty ?? false)
                      ? user!.displayName![0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              context.read<ChatProvider>().createNewChat();
            },
            tooltip: 'New Chat',
          ),
        ],
      ),
      drawer: _buildDrawer(context, user),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.currentChat == null) {
            return _buildEmptyState();
          }

          _scheduleAutoScroll(provider);

          return Column(
            children: [
              // Messages list
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: provider.messages.isEmpty
                      ? _buildEmptyChat(key: const ValueKey('empty_chat'))
                      : ListView.builder(
                          key: ValueKey(provider.currentChat?.id),
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          itemCount: provider.messages.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(
                              key: ValueKey(provider.messages[index].id),
                              message: provider.messages[index],
                            );
                          },
                        ),
                ),
              ),

              // Error message
              if (provider.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.error!,
                          style: const TextStyle(color: AppTheme.errorColor),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          provider.clearError();
                        },
                        color: AppTheme.errorColor,
                      ),
                    ],
                  ),
                ),

              // Message input
              MessageInput(
                onSendMessage: (text) {
                  provider.sendMessage(text);
                },
                isLoading: provider.isLoading,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, User? user) {
    return Drawer(
      backgroundColor: AppTheme.surfaceColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryColor),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: (user?.photoURL != null)
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    backgroundColor: AppTheme.surfaceColor,
                    child: user?.photoURL == null
                        ? Text(
                            (user?.displayName?.isNotEmpty ?? false)
                                ? user!.displayName![0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'User',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Your Chats',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.read<ChatProvider>().createNewChat();
                    Navigator.pop(context);
                  },
                  tooltip: 'New Chat',
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.chats.isEmpty) {
                  return const Center(
                    child: Text(
                      'No chats yet',
                      style: TextStyle(color: AppTheme.textSecondaryColor),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.chats.length,
                  itemBuilder: (context, index) {
                    final chat = provider.chats[index];
                    return ChatListItem(
                      chat: chat,
                      isSelected: provider.currentChat?.id == chat.id,
                      onTap: () {
                        provider.selectChat(chat);
                        Navigator.pop(context);
                      },
                      onDelete: () {
                        provider.deleteChat(chat.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthService>().signOut();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppTheme.textSecondaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No chat selected',
            style: TextStyle(fontSize: 18, color: AppTheme.textSecondaryColor),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ChatProvider>().createNewChat();
            },
            icon: const Icon(Icons.add),
            label: const Text('Start New Chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat({Key? key}) {
    return Center(
      key: key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 64,
            color: AppTheme.primaryColor.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'Start a conversation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Ask me anything! I\'m here to help.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
