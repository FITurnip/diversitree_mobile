import 'package:diversitree_mobile/components/diversitree_app_bar.dart';
import 'package:diversitree_mobile/core/auth_service.dart';
import 'package:diversitree_mobile/views/pengguna/login.dart';
import 'package:diversitree_mobile/views/pengguna/register.dart';
import 'package:flutter/material.dart';
import 'package:diversitree_mobile/core/styles.dart';

class Pengguna extends StatefulWidget {
  @override
  _PenggunaState createState() => _PenggunaState();
}

class _PenggunaState extends State<Pengguna> {
  bool ?isLoggedIn;
  Future<void> setAuthCondition() async {
    setState(() {
      isLoggedIn = null;
    });

    bool loggedInStatus = await AuthService.checkAuth();
    setState(() {
      isLoggedIn = loggedInStatus;
    });

    print("isLoggedIn ${isLoggedIn}");

    if (isLoggedIn == true) {
      Map<String, dynamic> userData = AuthService.getCurrentUserData();
      print(userData);
      namaPenggunaController.text = userData["name"];
      emailController.text = userData["email"];
    } else if (isLoggedIn == false) {
      // If the user is logged out, clear the input fields
      namaPenggunaController.clear();
      emailController.clear();
    }
  }

  // Controllers for input fields
  final TextEditingController namaPenggunaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // User data
  Map<String, String> dataPengguna = {
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

  Future<void> logout() async {
    try {
      await AuthService.logout(); // Log the user out asynchronously
      print("Logout successful");
      await setAuthCondition();  // Update the UI after logout
    } catch (e) {
      print("Error during logout: $e");
    }
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
                logout();
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
  void initState() {
    super.initState();
    setAuthCondition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DiversitreeAppBar(
        titleText: "Pengguna",
        actions: [
          if(isLoggedIn == true)
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoggedIn == null ?
              CircularProgressIndicator(color: AppColors.primary,)
              : isLoggedIn == true ?
              Column(
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
                  _buildTextField("Password Baru", passwordController, "password", obscureText: true),
                  _buildTextField("Konfirmasi Password baru", confirmPasswordController, "confirmation_password", obscureText: true),
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
              )
              : Column(
                children: [
                  Container(
                    height: 200,
                    child: Image.asset('storage/Logo_Default.png', height: 160,),
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(onAuth: setAuthCondition,)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      ),
                      child: Text('Masuk', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
        
                  const SizedBox(height: 8,),
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(onAuth: setAuthCondition),
                          ),
                        );
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
                ],
              ),
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