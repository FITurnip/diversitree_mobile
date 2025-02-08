import 'package:diversitree_mobile/components/diversitree_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:diversitree_mobile/core/styles.dart';

class Pengguna extends StatefulWidget {
  @override
  _PenggunaState createState() => _PenggunaState();
}

class _PenggunaState extends State<Pengguna> {
  // Controllers for input fields
  final TextEditingController namaPenggunaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // User data
  Map<String, String> dataPengguna = {
    "id": "",
    "nama": "",
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keluar'),
          content: Text('Keluar dari akun ini?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Keluar',
                style: TextStyle(
                  color: AppColors.danger
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Batalkan',
                style: TextStyle(
                  color: AppColors.secondary
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSimpanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Simpan Permanen'),
          content: Text('Anda yakin ingin menyimpan data terbaru?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Ya',
                style: TextStyle(
                  color: AppColors.primary
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Tidak',
                style: TextStyle(
                  color: AppColors.secondary
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DiversitreeAppBar(
        titleText: "Pengguna",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.exit_to_app, color: AppColors.danger,), // Logout icon
              onPressed: () {
                _showLogoutDialog(context);
              }, // Logout action
            ),
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                    Icons.person,
                    size: 80, // Adjust the icon size
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 36),
              _buildTextField("Nama Lengkap", namaPenggunaController, "nama"),
              _buildTextField("Email", emailController, "email", keyboardType: TextInputType.emailAddress),
              _buildTextField("Password", passwordController, "password", obscureText: true),
              _buildTextField("Konfirmasi Password", confirmPasswordController, "confirmation_password", obscureText: true),
              SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    _showSimpanDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  ),
                  child: Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
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