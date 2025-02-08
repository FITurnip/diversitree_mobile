import 'package:diversitree_mobile/core/styles.dart';
import 'package:diversitree_mobile/views/home/gabung_workspace.dart';
import 'package:diversitree_mobile/views/home/pengguna.dart';
import 'package:diversitree_mobile/views/home/workspace_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  // Update the constructor to accept workspaceTable as a parameter
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String ?selectedValue;
  List<Widget> _homepageOptions = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _homepageOptions = <Widget>[
      WorkspaceList(),
      GabungWorkspace(),
      Pengguna(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (selectedIndex) {
          setState(() {
            _selectedIndex = selectedIndex;
          });
        },
        
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0 ? Icon(Icons.home_rounded) : Icon(Icons.home_outlined),
            label: 'Beranda'
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1 ? Icon(Icons.qr_code_scanner_rounded) : Icon(Icons.qr_code_scanner_outlined),
            label: 'Gabung'
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2 ? Icon(Icons.person_rounded) : Icon(Icons.person_outline_rounded),
            label: 'Pengguna'
          ),
        ],

        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
      ),
      backgroundColor: Colors.white,
      body: _homepageOptions.elementAt(_selectedIndex),
    );
  }
}