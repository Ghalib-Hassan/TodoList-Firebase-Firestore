import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:todo_firestore/UI/add_task.dart';
import 'package:todo_firestore/UI/all_tasks.dart';
import 'package:todo_firestore/UI/settings.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              colorLineSelected: Colors.black,
              name: 'Home',
              baseStyle: GoogleFonts.fahkwang(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              selectedStyle: GoogleFonts.fahkwang(fontSize: 50)),
          const AddData()),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'All Tasks',
            baseStyle: GoogleFonts.fahkwang(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
            selectedStyle: GoogleFonts.fahkwang(fontSize: 40)),
        const AllTasks(),
      ),
      // ScreenHiddenDrawer(
      //   ItemHiddenMenu(
      //       name: 'Checked Tasks',
      //       baseStyle: GoogleFonts.fahkwang(
      //           fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
      //       selectedStyle: GoogleFonts.fahkwang(fontSize: 40)),
      //   CheckedScreen(),
      // ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Settings',
            baseStyle: GoogleFonts.fahkwang(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            selectedStyle: GoogleFonts.fahkwang(fontSize: 50)),
        const SettingsScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      styleAutoTittleName: GoogleFonts.daiBannaSil(
          color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
      backgroundColorAppBar: Colors.blue,
      backgroundColorMenu: Colors.lightBlue,
      screens: _pages,
      initPositionSelected: 0,
    );
  }
}
