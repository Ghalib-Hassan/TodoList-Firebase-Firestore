import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_firestore/Firebase%20Services/splash_service.dart';
import 'package:todo_firestore/Utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SplashService().isLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              transform: Matrix4.rotationZ(0.2),
              child: Image.asset(
                  semanticLabel: 'Todo Image', height: 100, 'Images/To-do.jpg'),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
                text: TextSpan(
                    style:
                        GoogleFonts.roboto(color: Colors.white, fontSize: 23),
                    children: [
                  TextSpan(
                      text: 'Welcome to your Own\n',
                      style: GoogleFonts.mateSc(fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: 'ToDo List',
                      style: GoogleFonts.poppins(
                          fontSize: 30, fontWeight: FontWeight.bold))
                ]))
          ],
        ),
      ),
    );
  }
}
