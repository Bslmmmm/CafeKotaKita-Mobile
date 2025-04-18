import 'package:flutter/material.dart';
import 'dart:async';
import '../../../Constant/constants.dart';
import 'package:flutter/services.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({Key? key}) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  int _seconds = 60;
  Timer? _timer;

  bool _otpSuccess = false;
  bool _otpFailed = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _seconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  void _onKeyPressed(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        _controllers[index - 1].clear();
      }
    }
  }

  void _verifyOtp() {
    String enteredOtp = _controllers.map((e) => e.text).join();
    if (enteredOtp == '123456') {
      setState(() {
        _otpSuccess = true;
        _otpFailed = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("OTP berhasil diverifikasi!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog
                Navigator.pushNamed(
                    context, '/reset'); // navigasi ke reset password
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else {
      setState(() {
        _otpSuccess = false;
        _otpFailed = true;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Gagal"),
          content: const Text("Kode OTP salah. Silakan coba lagi."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) => _onKeyPressed(index, event),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (value) => _onOtpChanged(index, value),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: kPrimaryLightColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: defaultPadding),
            TextButton(
              onPressed: _seconds == 0
                  ? () {
                      // Logic resend OTP
                      startTimer();
                    }
                  : null,
              child: Text(
                _seconds == 0
                    ? "Resend OTP"
                    : "Resend OTP in 00:${_seconds.toString().padLeft(2, '0')}",
                style: TextStyle(
                    color: _seconds == 0 ? kPrimaryColor : Colors.grey),
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: const Text("Verify OTP"),
            ),
            const SizedBox(height: defaultPadding),
            if (_otpSuccess)
              const Icon(Icons.check_circle, color: Colors.green, size: 32),
            if (_otpFailed)
              const Icon(Icons.cancel, color: Colors.red, size: 32),
          ],
        ),
      ),
    );
  }
}
