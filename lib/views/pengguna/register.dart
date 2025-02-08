import 'package:diversitree_mobile/components/diversitree_app_bar.dart';
import 'package:diversitree_mobile/core/auth_service.dart';
import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/views/pengguna/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Future<void> Function() onAuth;
  Register({required this.onAuth});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controllers for input fields
  final TextEditingController namaPenggunaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // User data
  Map<String, String> dataPengguna = {
    "name": "",
    "email": "",
    "password": "",
    "confirmation_password": "",
  };

  @override
  void dispose() {
    // Dispose controllers to free resources
    namaPenggunaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateUserData(String key, String value) {
    setState(() {
      dataPengguna[key] = value;
    });
  }

  Future<void> register() async {
    try {
      await AuthService.register(dataPengguna);
      print("register successful");
      await widget.onAuth();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error during register: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DiversitreeAppBar(titleText: 'Buat Akun Baru'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 120, // Width of the icon container
                  height: 120, // Height of the icon container
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary, // Background color
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 80, // Adjust the icon size
                      color: Colors.white,
                    ),
                  ),
                ),
              SizedBox(height: 36),
              _buildTextField("Nama Lengkap", namaPenggunaController, "name"),
              _buildTextField("Email", emailController, "email", keyboardType: TextInputType.emailAddress),
              _buildTextField("Password", passwordController, "password", obscureText: true),
              _buildTextField("Konfirmasi Password", confirmPasswordController, "confirmation_password", obscureText: true),
              const SizedBox(height: 24,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    register();
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
                    'Buat Akun Baru',
                    style: TextStyle(color: AppColors.primary, fontSize: 16),
                  ),
                ),
              ),
    
    
              const SizedBox(height: 24,),
              
              Wrap(
                spacing: 8, // Ensures no extra spacing between elements
                children: [
                  Text('Sudah memiliki akun?', style: TextStyle(fontSize: 16)),
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
                          builder: (context) => Login(onAuth: widget.onAuth),
                        ),
                      );
                    },
                    child: Text(
                      'Masuk',
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