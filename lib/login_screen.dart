import 'dart:async';
import 'package:deals_dray/const/const.dart';
import 'package:deals_dray/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'otb_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedIndex = 0;
  final TextEditingController _inputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.16,
                        width: width * 0.4,
                        child: Image.asset(
                          'assets/images/dealsdray_logo.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(50),
                    selectedBorderColor: secondaryColor,
                    selectedColor: Colors.white,
                    fillColor: secondaryColor,
                    color: Colors.grey.shade800,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? secondaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              bottomLeft: Radius.circular(50.0)),
                        ),
                        child: Center(
                          child: Text('Phone',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? secondaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0)),
                        ),
                        child: Center(
                          child: Text('Email',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                    isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                    onPressed: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                  SizedBox(height: 40),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Glad to see you!',
                          style: TextStyle(
                              fontSize: width * 0.09,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.01),
                        _selectedIndex == 0
                            ? Text(
                                'Please provide your phone number',
                                style: TextStyle(
                                    fontSize: width * 0.045,
                                    color: primaryColor),
                              )
                            : Text(
                                'Please provide your email',
                                style: TextStyle(
                                    fontSize: width * 0.045,
                                    color: primaryColor),
                              ),
                        SizedBox(height: height * 0.05),
                        TextFormField(
                          controller: _inputController,
                          decoration: InputDecoration(
                            labelText: _selectedIndex == 0 ? 'Phone' : 'Email',
                            labelStyle: TextStyle(
                                fontSize: width * 0.045, color: primaryColor),
                          ),
                          keyboardType: _selectedIndex == 0
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                          validator: (value) {
                            if (_selectedIndex == 0) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              final regex = RegExp(r'^[0-9]{10}$');
                              if (!regex.hasMatch(value)) {
                                return 'Please enter a valid 10-digit phone number';
                              }
                            }
                            return null; // No error
                          },
                        ),
                        SizedBox(height: height * 0.05),
                        GestureDetector(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: _isLoading ? null : _sendCode,
                            splashFactory: InkRipple.splashFactory,
                            splashColor: secondaryColor.withOpacity(0.3),
                            child: Ink(
                              width: double.maxFinite,
                              height: height * 0.07,
                              decoration: BoxDecoration(
                                color: _isLoading
                                    ? secondaryColor.withOpacity(0.4)
                                    : secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        'SEND CODE',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.045),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Start the timer
      _timer = Timer(Duration(seconds: 7), () {
        if (_isLoading) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationScreen()),
          );
          _inputController.clear();
          setState(() {
            _isLoading = false;
          });
        }
      });

      String input = _inputController.text;

      final url = Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/otp');

      final body = jsonEncode({
        "mobileNumber": '+91-$input',
        "deviceId": '',
      });

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          String userId = responseData['data']['userId'];
          String deviceId = responseData['data']['deviceId'];

          if (_timer!.isActive) {
            _timer?.cancel();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OtpVerificationScreen(input, deviceId, userId),
              ),
            );
            _inputController.clear();
          }
        } else {
          if (_timer!.isActive) {
            _timer?.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegistrationScreen()),
            );
            _inputController.clear();
          }
        }
      } catch (e) {
        if (_timer!.isActive) {
          _timer?.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send OTP. Please try again.')),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
