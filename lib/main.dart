import 'dart:ui';
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'widgets/neon_avatar.dart';

void main() {
  runApp(const PulsoApp());
}

class PulsoApp extends StatelessWidget {
  const PulsoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: PulsoTheme.dark(),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> pulse;
  final TextEditingController textController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {'mine': false, 'text': 'Ei! Como você está?', 'time': '21:35'},
    {'mine': true, 'text': 'Estou bem! E você?', 'time': '21:36'},
  ];

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    pulse = Tween(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    super.initState();
  }

  void sendPulse() {
    if (textController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'mine': true,
        'text': textController.text.trim(),
        'time': TimeOfDay.now().format(context),
      });
    });

    textController.clear();
    controller.forward().then((_) => controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A5CFF),
              Color(0xFF3D7BFF),
              Color(0xFF1BC9FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              topBar(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final m = messages[i];
                    return Bubble(m['mine'], m['text'], m['time']);
                  },
                ),
              ),
              inputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: const [
          NeonAvatar(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Breno',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                Text('Online agora',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.lock, color: Colors.white70),
          SizedBox(width: 12),
          Icon(Icons.settings, color: Colors.white70),
        ],
      ),
    );
  }

  Widget inputBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFF0F1722).withOpacity(0.85),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ScaleTransition(
                  scale: pulse,
                  child: GestureDetector(
                    onTap: sendPulse,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6A5CFF),
                            Color(0xFF1BC9FF),
                          ],
                        ),
                      ),
                      child: const Icon(Icons.send,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final bool mine;
  final String text;
  final String time;

  const Bubble(this.mine, this.text, this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          gradient: mine
              ? const LinearGradient(colors: [
                  Color(0xFF6A5CFF),
                  Color(0xFF1BC9FF),
                ])
              : null,
          color: mine ? null : const Color(0xFF101720),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 4),
            Text(time,
                style:
                    const TextStyle(color: Colors.white54, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}