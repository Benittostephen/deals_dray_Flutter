import 'dart:convert';
import 'package:deals_dray/const/const.dart';
import 'package:http/http.dart' as http;
import 'package:deals_dray/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  final String deviceId;
  final String userId;

  OtpVerificationScreen(this.mobileNumber, this.deviceId, this.userId);

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int secondsRemaining = 120;
  bool enableResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
        startTimer();
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  Future<void> _verifyOtp() async {
    String otp = _otpController.text;

    final url =
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp/verification');

    final body = jsonEncode({
      "otp": otp,
      "deviceId": widget.deviceId,
      "userId": widget.userId,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductScreen()),
        );
      } else {
        // Handle error
        final responseData = jsonDecode(response.body);
        _showErrorDialog(context, responseData['message']);
      }
    } catch (e) {
      _showErrorDialog(context, 'Failed to verify OTP. Please try again.');
    }
  }

  void _resendOtp() {
    setState(() {
      secondsRemaining = 120;
      enableResend = false;
    });
    startTimer();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/icons/back.png',
            scale: width * 0.045,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.07),
              Image.asset('assets/icons/otp.png', height: height * 0.13),
              SizedBox(height: height * 0.05),
              Text(
                'OTP Verification',
                style: TextStyle(
                    fontSize: width * 0.088, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'We have sent a unique OTP number to your mobile +91-${widget.mobileNumber}',
                style: TextStyle(
                    fontSize: width * 0.047, color: Colors.grey.shade600),
              ),
              SizedBox(height: height * 0.05),
              PinCodeTextField(
                keyboardType: TextInputType.phone,
                appContext: context,
                length: 4,
                controller: _otpController,
                onChanged: (value) {
                  if (value.length == 4) {
                    _verifyOtp();
                  }
                },
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10.0),
                    fieldHeight: height * 0.06,
                    fieldWidth: width * 0.13,
                    selectedColor: secondaryColor,
                    inactiveColor: Colors.grey),
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(secondsRemaining % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: width * 0.055),
                  ),
                  GestureDetector(
                    onTap: enableResend ? _resendOtp : null,
                    child: Text(
                      'SEND AGAIN',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor:
                              enableResend ? Colors.grey.shade900 : Colors.grey,
                          color:
                              enableResend ? Colors.grey.shade900 : Colors.grey,
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
