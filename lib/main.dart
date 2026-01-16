import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

void main() {
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
  static const Color surface = Color(0xFF121212);
  static const Color neonGreen = Color(0xFF00FF41);
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color errorRed = Color(0xFFFF003C);
  static const Color textPrimary = Color(0xFFE0E0E0);
}

class CryptoMessengerApp extends StatelessWidget {
  const CryptoMessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghost Protocol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Courier', 
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonGreen,
          secondary: AppColors.neonCyan,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Courier',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: AppColors.neonGreen,
          ),
        ),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Conexão segura estabelecida.', 'isMe': false, 'time': '10:00'},
    {'text': 'A chave privada foi gerada?', 'isMe': true, 'time': '10:01'},
    {'text': 'Sim. Algoritmo AES-256 ativo. Ninguém está ouvindo.', 'isMe': false, 'time': '10:02'},
    {'text': 'Envie o payload.', 'isMe': true, 'time': '10:02'},
  ];

  late AnimationController _gridController;

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _gridController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _controller.text,
        'isMe': true,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
      _controller.clear();
    });
    
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.lock_outline, color: AppColors.neonGreen, size: 18),
            SizedBox(width: 8),
            Text("GHOST_PROTOCOL"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: AppColors.neonCyan),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gridController,
              builder: (context, child) {
                return CustomPaint(
                  painter: CyberGridPainter(offset: _gridController.value),
                );
              },
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return MessageBubble(
                      text: msg['text'],
                      isMe: msg['isMe'],
                      time: msg['time'],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.9),
        border: Border(
          top: BorderSide(color: AppColors.neonGreen.withOpacity(0.3), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: AppColors.neonCyan.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonCyan.withOpacity(0.1),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.neonCyan),
                  cursorColor: AppColors.neonGreen,
                  decoration: const InputDecoration(
                    hintText: "Digite o comando...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    prefixIcon: Icon(Icons.terminal, color: AppColors.neonGreen),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _sendMessage,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.neonGreen.withOpacity(0.1),
          border: Border.all(color: AppColors.neonGreen),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonGreen.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
        ),
        child: const Icon(Icons.send_rounded, color: AppColors.neonGreen),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMe ? AppColors.neonCyan : AppColors.neonGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black, 
              border: Border.all(color: color.withOpacity(0.6), width: 1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(0),
                topRight: const Radius.circular(0),
                bottomLeft: isMe ? const Radius.circular(0) : const Radius.circular(12),
                bottomRight: isMe ? const Radius.circular(12) : const Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: color.withOpacity(0.9),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 2, left: 2),
            child: Text(
              time,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CyberGridPainter extends CustomPainter {
  final double offset;

  CyberGridPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonGreen.withOpacity(0.05)
      ..strokeWidth = 1.0;

    const double gridSize = 40.0;
    
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    double shift = offset * gridSize;
    for (double y = -gridSize; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y + shift),
        Offset(size.width, y + shift),
        paint,
      );
    }
    
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
      stops: const [0.6, 1.0],
    );
    
    final paintVignette = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paintVignette);
  }

  @override
  bool shouldRepaint(covariant CyberGridPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
