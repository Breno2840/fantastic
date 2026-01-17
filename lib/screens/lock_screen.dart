import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/cyber_painter.dart';
import 'chat_screen.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _passController = TextEditingController();
  int _attemptCount = 0;
  bool _isLocked = false;
  bool _isCooldownActive = false;

  void _verifyAccess() {
    if (_isLocked || _isCooldownActive) return;

    const masterKey = String.fromEnvironment('MASTER_KEY', defaultValue: 'NOT_SET');
    final inputKey = _passController.text;

    _isCooldownActive = true;
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isCooldownActive = false;
      });
    });

    if (inputKey == masterKey && masterKey != 'NOT_SET') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    } else {
      _attemptCount++;
      _passController.clear();

      if (_attemptCount >= 5) {
        _isLocked = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("ACESSO BLOQUEADO: TENTE NOVAMENTE EM 3 MINUTOS."),
            backgroundColor: Colors.red,
          ),
        );
        Future.delayed(const Duration(minutes: 3), () {
          setState(() {            _isLocked = false;
            _attemptCount = 0;
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("ACESSO NEGADO: CHAVE INCORRETA"),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                    enabled: !_isLocked && !_isCooldownActive,
                    style: const TextStyle(color: AppColors.neonCyan),
                    decoration: InputDecoration(
                      hintText: "INSIRA A CHAVE AES-256",
                      filled: true,
                      fillColor: AppColors.surface,
                      prefixIcon: const Icon(Icons.vpn_key, color: AppColors.neonCyan),
                      enabledBorder: OutlineInputBorder(                        borderSide: BorderSide(color: AppColors.neonCyan.withOpacity(0.3)),
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