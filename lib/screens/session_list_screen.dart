// lib/screens/session_list_screen.dart
// Modern session list screen with card-based layout

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';
import '../languages/languages.dart';
import '../core/theme/app_spacing.dart';

class SessionListScreen extends StatefulWidget {
  const SessionListScreen({Key? key}) : super(key: key);

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  bool _isSelectionMode = false;
  Set<String> _selectedSessions = {};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedSessions.clear();
    });
  }

  void _toggleSessionSelection(String sessionId) {
    setState(() {
      if (_selectedSessions.contains(sessionId)) {
        _selectedSessions.remove(sessionId);
      } else {
        _selectedSessions.add(sessionId);
      }
    });
  }

  void _deleteSelectedSessions(BuildContext context) {
    if (_selectedSessions.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Languages.titleDeleteSessions),
        content: Text(
          '${_selectedSessions.length} ${Languages.confirmDeleteSessions}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(Languages.labelCancel),
          ),
          FilledButton(
            onPressed: () {
              for (var sessionId in _selectedSessions) {
                chatProvider.deleteSession(sessionId);
              }
              _selectedSessions.clear();
              setState(() {
                _isSelectionMode = false;
              });
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(Languages.labelDelete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text(
                '${_selectedSessions.length} ${Languages.labelSelectedSessions}')
            : const Text(Languages.titleSessionList),
        centerTitle: true,
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.select_all),
              tooltip: Languages.tooltipSelectAll,
              onPressed: () {
                final chatProvider =
                    Provider.of<ChatProvider>(context, listen: false);
                setState(() {
                  _selectedSessions = Set.from(chatProvider.sessionIds);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: Languages.tooltipDeleteSelected,
              onPressed: _selectedSessions.isEmpty
                  ? null
                  : () => _deleteSelectedSessions(context),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: Languages.tooltipDeleteSessions,
              onPressed: () => _toggleSelectionMode(),
            ),
          ],
        ],
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleSelectionMode,
              )
            : null,
      ),
      floatingActionButton: !_isSelectionMode
          ? FloatingActionButton.extended(
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .createNewSession();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('New Chat'),
            )
          : null,
      body: SafeArea(
        top: false,
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            final sessionIds = chatProvider.sessionIds;
            final sessions = chatProvider.sessions;
            final currentSessionId = chatProvider.currentSessionId;

            if (sessionIds.isEmpty) {
              return _buildEmptyState(theme);
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: sessionIds.length,
              itemBuilder: (context, index) {
                final sessionId = sessionIds[index];
                final messages = sessions[sessionId] ?? [];
                final isSelected = _selectedSessions.contains(sessionId);
                final isActive = sessionId == currentSessionId;

                String sessionTitle = Languages.labelNewSession;
                String sessionPreview = '';
                String formattedDate = '';
                int messageCount = messages.length;

                if (messages.isNotEmpty) {
                  final botMsgWithTitle = messages.firstWhere(
                    (msg) =>
                        msg.role == MessageRole.assistant && msg.title != null,
                    orElse: () => messages.first,
                  );

                  sessionTitle = botMsgWithTitle.title ?? 'Chat ${index + 1}';

                  final lastMsg = messages.last;
                  sessionPreview = lastMsg.content.length > 60
                      ? '${lastMsg.content.substring(0, 60)}...'
                      : lastMsg.content;

                  formattedDate = _formatMessageDate(lastMsg.timestamp);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _buildSessionCard(
                    context: context,
                    sessionId: sessionId,
                    title: sessionTitle,
                    preview: sessionPreview,
                    date: formattedDate,
                    messageCount: messageCount,
                    isActive: isActive,
                    isSelected: isSelected,
                    isSelectionMode: _isSelectionMode,
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleSessionSelection(sessionId);
                      } else {
                        chatProvider.switchSession(sessionId);
                        Navigator.pop(context);
                      }
                    },
                    onLongPress: () {
                      if (!_isSelectionMode) {
                        _toggleSelectionMode();
                        _toggleSessionSelection(sessionId);
                      }
                    },
                    onDelete: () {
                      chatProvider.deleteSession(sessionId);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withAlpha(51),
                  theme.colorScheme.secondary.withAlpha(51),
                ],
              ),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            Languages.labelNoSessions,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start a new conversation',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard({
    required BuildContext context,
    required String sessionId,
    required String title,
    required String preview,
    required String date,
    required int messageCount,
    required bool isActive,
    required bool isSelected,
    required bool isSelectionMode,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
    required VoidCallback onDelete,
  }) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(sessionId),
      direction:
          isSelectionMode ? DismissDirection.none : DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(Languages.titleDeleteSession),
            content: const Text(Languages.confirmDeleteSession),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(Languages.labelCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error),
                child: const Text(Languages.labelDelete),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) => onDelete(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: AppSpacing.borderRadiusLg,
          child: AnimatedContainer(
            duration: AppSpacing.animFast,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : (isActive
                      ? theme.colorScheme.surfaceContainerHigh
                      : theme.colorScheme.surface),
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : (isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.5)
                        : theme.colorScheme.outline.withValues(alpha: 0.1)),
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Selection checkbox
                if (isSelectionMode) ...[
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onTap(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],

                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Icon(
                    Icons.chat_rounded,
                    color: isActive
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: AppSpacing.borderRadiusSm,
                              ),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        preview.isEmpty ? 'No messages yet' : preview,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 12,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            date.isEmpty ? 'Just now' : date,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Icon(
                            Icons.message_outlined,
                            size: 12,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$messageCount messages',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Chevron
                if (!isSelectionMode)
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.outline,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat.Hm().format(date);
    } else if (difference.inDays == 1) {
      return Languages.labelYesterday;
    } else if (difference.inDays < 7) {
      return DateFormat.E('tr').format(date);
    } else {
      return DateFormat.yMd('tr').format(date);
    }
  }
}
