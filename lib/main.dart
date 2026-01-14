import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const PulsoApp());
}

class PulsoApp extends StatelessWidget {
  const PulsoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
    controller.forward().then((_) => controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
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
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: const [
                    Bubble(false, 'Ei! Como você está?', '21:35'),
                    Bubble(true, 'Estou bem! E você?', '21:36'),
                    Bubble(true, 'Tenho novidades para te contar!', '21:36'),
                    Bubble(false, 'Sério? Me conta!', '21:37'),
                  ],
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
        children: [
          neonAvatar(),
          const SizedBox(width: 12),
          const Expanded(
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
          const Icon(Icons.lock, color: Colors.white70),
          const SizedBox(width: 12),
          const Icon(Icons.settings, color: Colors.white70),
        ],
      ),
    );
  }

  Widget neonAvatar() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6A5CFF),
            Color(0xFF1BC9FF),
          ],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0xFF6A5CFF), blurRadius: 12),
        ],
      ),
      child: const Center(
        child: Icon(Icons.person_outline, color: Colors.white),
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
                const Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
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
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
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