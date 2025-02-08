import 'package:diversitree_mobile/components/diversitree_app_bar.dart';
import 'package:diversitree_mobile/core/auth_service.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/views/pengguna/register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Future<void> Function() onAuth;
  Login({required this.onAuth});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers for input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // User data
  Map<String, String> dataPengguna = {
    "email": "",
    "password": "",
  };

  @override
  void dispose() {
    // Dispose controllers to free resources
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _updateUserData(String key, String value) {
    setState(() {
      dataPengguna[key] = value;
    });
  }

  Future<void> login() async {
    try {
      await AuthService.login(dataPengguna);
      print("login successful");
      await widget.onAuth();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error during login: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      appBar: DiversitreeAppBar(titleText: 'Masuk'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                    width: 120,
                    height: 120, 
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ),
              
              SizedBox(height: 36),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    _buildTextField("Email", emailController, "email", keyboardType: TextInputType.emailAddress),
                    _buildTextField("Password", passwordController, "password", obscureText: true),
                    const SizedBox(height: 24,),
                    Container(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Transparent background
                          foregroundColor: AppColors.primary, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.primary, width: 2), // Border color and width
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                        ),
                        child: Text(
                          'Masuk',
                          style: TextStyle(color: AppColors.primary, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    
    
              const SizedBox(height: 24,),
              
              Wrap(
                spacing: 8, // Ensures no extra spacing between elements
                children: [
                  Text('Belum memiliki akun?', style: TextStyle(fontSize: 16)),
                  TextButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero), // Removes default padding
                      minimumSize: WidgetStateProperty.all(Size(0, 0)), // Ensures no extra space
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap area to text only
                    ),
                    onPressed: () async {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(onAuth: widget.onAuth,),
                        ),
                      );
                    },
                    child: Text(
                      'Registrasi',
                      style: TextStyle(color: AppColors.primary, fontSize: 16),
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

  Widget _buildTextField(String label, TextEditingController controller, String key,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      height: 48,
      width: 280,
      margin: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14, color: AppColors.secondary),
          floatingLabelStyle: TextStyle(color: AppColors.secondary),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondary),
          ),
        ),
        onChanged: (value) => _updateUserData(key, value),
      ),
    );
  }
}