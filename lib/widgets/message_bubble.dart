import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const MessageBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final color = isMe ? AppColors.neonCyan : AppColors.neonGreen;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(isMe ? 15 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 15),
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
          ),
        ),
        child: Text(text, style: TextStyle(color: color)),
      ),
    );
  }
}
