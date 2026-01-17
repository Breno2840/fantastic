import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'secrets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF050505),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const CryptoMessengerApp());
}

class AppColors {
  static const Color background = Color(0xFF050505);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color textPrimary = Color(0xFFE0E0E0);
}

class CryptoMessengerApp extends StatelessWidget {
  const CryptoMessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Message',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Courier',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.neonGreen,
          brightness: Brightness.dark,
          primary: AppColors.neonGreen,
          surface: AppColors.surface,
        ),
      ),
      home: const LockScreen(),
    );
  }
}

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _passController = TextEditingController();

  void _verifyAccess() {
    if (_passController.text == AppSecrets.masterKey) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ACESSO NEGADO: CHAVE INCORRETA"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: CyberGridPainter())),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security, size: 80, color: AppColors.neonGreen),
                  const SizedBox(height: 24),
                  const Text(
                    "SISTEMA CRIPTOGRAFADO",
                    style: TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.neonCyan),
                    decoration: InputDecoration(
                      hintText: "INSIRA A CHAVE AES-256",
                      filled: true,
                      fillColor: AppColors.surface,
                      prefixIcon: const Icon(Icons.vpn_key, color: AppColors.neonCyan),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.neonCyan.withOpacity(0.3)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.neonCyan),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _verifyAccess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      ),
                      child: const Text("DECRIPTAR ACESSO", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    String msg = _controller.text;
    _controller.clear();
    await _firestore.collection('messages').add({
      'text': msg,
      'senderId': 'user_temp_id', 
      'timestamp': FieldValue.serverTimestamp(),
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        title: const Text("SECURE_MESSAGE", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: AppColors.neonGreen)),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: CyberGridPainter())),
          Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.neonGreen));
                    }
                    var docs = snapshot.data?.docs ?? [];
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 110, 16, 16),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var data = docs[index].data() as Map<String, dynamic>;
                        return MessageBubble(
                          text: data['text'] ?? '',
                          isMe: data['senderId'] == 'user_temp_id',
                        );
                      },
                    );
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.8),
        border: Border(top: BorderSide(color: AppColors.neonGreen.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Mensagem criptografada...",
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _sendMessage,
              backgroundColor: AppColors.neonGreen,
              shape: const CircleBorder(),
              child: const Icon(Icons.send_rounded, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

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

class CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.neonGreen.withOpacity(0.03)..strokeWidth = 1.0;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
