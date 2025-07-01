// Default location: lib/screens/session_list_screen.dart
// Screen to display and manage chat sessions

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';

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
        title: const Text('Sohbetleri Sil'),
        content: Text('${_selectedSessions.length} sohbeti silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
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
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedSessions.length} sohbet seçildi')
            : const Text('Sohbet Listesi'),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.select_all),
              tooltip: 'Tümünü Seç',
              onPressed: () {
                final chatProvider = Provider.of<ChatProvider>(context, listen: false);
                setState(() {
                  // Tüm sohbetleri seç
                  _selectedSessions = Set.from(chatProvider.sessionIds);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Seçilenleri Sil',
              onPressed: _selectedSessions.isEmpty
                  ? null
                  : () => _deleteSelectedSessions(context),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Sohbetleri Sil',
              onPressed: () => _toggleSelectionMode(),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Yeni Sohbet',
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .createNewSession();
                Navigator.pop(context);
              },
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
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          final sessionIds = chatProvider.sessionIds;
          final sessions = chatProvider.sessions;
          final currentSessionId = chatProvider.currentSessionId;
          
          if (sessionIds.isEmpty) {
            return const Center(
              child: Text('Henüz hiç sohbet yok. Yeni bir sohbet oluşturun.'),
            );
          }
          
          return ListView.builder(
            itemCount: sessionIds.length,
            itemBuilder: (context, index) {
              final sessionId = sessionIds[index];
              final messages = sessions[sessionId] ?? [];
              final isSelected = _selectedSessions.contains(sessionId);
              
              // Get the first message title or use a default
              String sessionTitle = 'Yeni Sohbet';
              String sessionPreview = '';
              String formattedDate = '';
              
              if (messages.isNotEmpty) {
                // Try to find first bot message with a title
                final botMsgWithTitle = messages.firstWhere(
                  (msg) => msg.role == MessageRole.assistant && msg.title != null,
                  orElse: () => messages.first,
                );
                
                sessionTitle = botMsgWithTitle.title ?? 'Sohbet ${index + 1}';
                
                // Get preview from last message
                final lastMsg = messages.last;
                sessionPreview = lastMsg.content.length > 50
                    ? '${lastMsg.content.substring(0, 50)}...'
                    : lastMsg.content;
                
                // Format date based on how recent it is
                formattedDate = _formatMessageDate(lastMsg.timestamp);
              }
              
              if (_isSelectionMode) {
                // Seçim modunda listItem
                return ListTile(
                  title: Text(
                    sessionTitle,
                    style: TextStyle(
                      fontWeight: sessionId == currentSessionId
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    sessionPreview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSessionSelection(sessionId),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (sessionId == currentSessionId)
                        Container(
                          margin: const EdgeInsets.only(top: 4.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Aktif',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () => _toggleSessionSelection(sessionId),
                );
              } else {
                // Normal mod listItem
                return Dismissible(
                  key: Key(sessionId),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sohbeti Sil'),
                        content: const Text('Bu sohbeti silmek istediğinizden emin misiniz?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('İptal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Sil'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    chatProvider.deleteSession(sessionId);
                  },
                  child: ListTile(
                    title: Text(
                      sessionTitle,
                      style: TextStyle(
                        fontWeight: sessionId == currentSessionId
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      sessionPreview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (sessionId == currentSessionId)
                          Container(
                            margin: const EdgeInsets.only(top: 4.0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Aktif',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      chatProvider.switchSession(sessionId);
                      Navigator.pop(context);
                    },
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
  
  // Format message date based on how recent it is
  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      // Today - show time
      return DateFormat.Hm().format(date);
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Dün';
    } else if (difference.inDays < 7) {
      // This week - show day name
      return DateFormat.E('tr').format(date);
    } else {
      // Older - show date
      return DateFormat.yMd('tr').format(date);
    }
  }
}