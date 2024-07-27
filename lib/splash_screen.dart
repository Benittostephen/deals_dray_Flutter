import 'package:deals_dray/const/const.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _sendDeviceDetails();
    _navigateToMain();
  }

  Future<void> _sendDeviceDetails() async {
    final url =
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "deviceType": "android",
      "deviceId": "C6179909526098",
      "deviceName": "Samsung-MT200",
      "deviceOSVersion": "2.3.6",
      "deviceIPAddress": "11.433.445.66",
      "lat": 9.9312,
      "long": 76.2673,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": "1.20.5",
        "installTimeStamp": "2022-02-10T12:33:30.696Z",
        "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
        "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
      }
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Device details sent successfully!');
      } else {
        print(
            'Failed to send device details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending device details: $e');
    }
  }

  void _navigateToMain() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomPaint(
                size: Size(50, 50), // Size of the circular loader
                painter: CircleLoaderPainter(controller: _controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleLoaderPainter extends CustomPainter {
  final Animation<double> controller;

  CircleLoaderPainter({required this.controller}) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2; // Radius of the circle
    final double ballRadius = 4.0; // Radius of each ball
    final int numBalls = 12; // Number of balls

    for (int i = 0; i < numBalls; i++) {
      final double angle =
          (i * 2 * pi / numBalls) + (controller.value * 2 * pi);
      final double x = radius + (radius - ballRadius) * cos(angle);
      final double y = radius + (radius - ballRadius) * sin(angle);

      canvas.drawCircle(
          Offset(x, y), ballRadius, Paint()..color = secondaryColor);
    }
  }

  @override
  bool shouldRepaint(CircleLoaderPainter oldDelegate) {
    return true;
  }
}
