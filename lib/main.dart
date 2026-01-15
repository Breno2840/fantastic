import 'package:flutter/material.dart';

void main() {
  runApp(const PulsoApp());
}

class PulsoApp extends StatelessWidget {
  const PulsoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pulso',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.light,
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [
    Message(
      text: 'Oi! Tudo bem?',
      isSentByMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      avatar: '🎨',
    ),
    Message(
      text: 'Tudo ótimo! Olha só esse app novo que estou testando',
      isSentByMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 9)),
    ),
    Message(
      text: 'Que legal! Material You está incrível mesmo',
      isSentByMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 8)),
      avatar: '🎨',
    ),
    Message(
      text: 'Sim! Adorei o design fluido e moderno',
      isSentByMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  bool _isTyping = false;

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            text: _messageController.text,
            isSentByMe: true,
            time: DateTime.now(),
          ),
        );
      });
      _messageController.clear();
      
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      // Simula uma resposta
      setState(() => _isTyping = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
            _messages.add(
              Message(
                text: 'Mensagem recebida! 👍',
                isSentByMe: false,
                time: DateTime.now(),
                avatar: '🎨',
              ),
            );
          });
          Future.delayed(const Duration(milliseconds: 100), () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      });
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}min';
    } else if (difference.inDays < 1) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 3,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              '🎨',
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Breno',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'online',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final showAvatar = !message.isSentByMe &&
                    (index == _messages.length - 1 ||
                        _messages[index + 1].isSentByMe);

                return _buildMessageBubble(message, showAvatar, colorScheme, theme);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTypingDot(0),
                      const SizedBox(width: 4),
                      _buildTypingDot(1),
                      const SizedBox(width: 4),
                      _buildTypingDot(2),
                    ],
                  ),
                ),
              ),
            ),
          _buildMessageInput(colorScheme, theme),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value - delay).clamp(0.0, 1.0);
        final opacity = (animValue * 2).clamp(0.3, 1.0);
        
        return Opacity(
          opacity: opacity,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(
    Message message,
    bool showAvatar,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 8,
        left: message.isSentByMe ? 48 : 0,
        right: message.isSentByMe ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment:
            message.isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isSentByMe) ...[
            SizedBox(
              width: 32,
              child: showAvatar
                  ? CircleAvatar(
                      radius: 16,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        message.avatar ?? '👤',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isSentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: message.isSentByMe
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(24),
                      topRight: const Radius.circular(24),
                      bottomLeft: Radius.circular(message.isSentByMe ? 24 : 4),
                      bottomRight: Radius.circular(message.isSentByMe ? 4 : 24),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: message.isSentByMe
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
                  child: Text(
                    _formatTime(message.time),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Mensagem',
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {},
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file_rounded),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: _sendMessage,
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
              child: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class Message {
  final String text;
  final bool isSentByMe;
  final DateTime time;
  final String? avatar;

  Message({
    required this.text,
    required this.isSentByMe,
    required this.time,
    this.avatar,
  });
}