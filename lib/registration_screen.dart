import 'package:deals_dray/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'const/const.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String referralCode = _referralCodeController.text;

      final url =
          Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/email/referral');

      final body = jsonEncode({
        "email": email,
        "password": password,
        "referralCode": referralCode.isNotEmpty ? referralCode : null,
        "userId": "62a833766ec5dafd6780fc85"
      });

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductScreen()),
          );
          _emailController.clear();
          _passwordController.clear();
          _referralCodeController.clear();
        } else {
          print(response.statusCode);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductScreen()),
          );
          _emailController.clear();
          _passwordController.clear();
          _referralCodeController.clear();
        }
      } catch (e) {
        _showErrorDialog('Failed to register. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon:
                    Image.asset('assets/icons/back.png', height: height * 0.03),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Container(
                color: Colors.red,
                height: height * 0.17,
                width: width * 0.41,
                child: Image.asset(
                  'assets/images/dealsdray_logo.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's Begin!",
                      style: TextStyle(
                          fontSize: width * 0.08, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      'Please enter your credentials to proceed',
                      style: TextStyle(
                          fontSize: width * 0.04, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 70),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        labelStyle:
                            TextStyle(fontSize: 20, color: primaryColor),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final regex = RegExp(
                            r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                        if (!regex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null; // No error
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Create Password',
                        labelStyle:
                            TextStyle(fontSize: 20, color: primaryColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null; // No error
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _referralCodeController,
                      decoration: InputDecoration(
                        labelText: 'Referral Code (Optional)',
                        labelStyle:
                            TextStyle(fontSize: 20, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 70,
                  width: 80,
                  child: FloatingActionButton(
                    onPressed: _isLoading ? null : _register,
                    backgroundColor: secondaryColor,
                    child: (_isLoading)
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))
                        : Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
