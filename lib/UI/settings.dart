import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_firestore/Auth%20Screens/login.dart';
import 'package:todo_firestore/Auth%20Screens/signup.dart';
import 'package:todo_firestore/Custom%20Widgets/auth_text_field.dart';
import 'package:todo_firestore/Custom%20Widgets/password_text_field.dart';
import 'package:todo_firestore/Custom%20Widgets/toast.dart';
import 'package:todo_firestore/Utils/colors.dart';
import 'package:todo_firestore/Utils/push_replace.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController deleteEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DatabaseReference db = FirebaseDatabase.instance.ref('TodoList');
  final ref = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  final deleteRef = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 70,
            child: FutureBuilder(
                future: ref,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 2, color: black)),
                        child: Center(
                          child: Text(
                            snapshot.data!['name'].toString().substring(0, 1),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        snapshot.data!['name'],
                        style: GoogleFonts.poppins(color: black, fontSize: 20),
                      ),
                      subtitle: Text(
                        snapshot.data!['email'],
                        style: GoogleFonts.poppins(color: black, fontSize: 10),
                      ),
                      trailing: Text(
                        'Current User',
                        style: GoogleFonts.ubuntuMono(fontSize: 12),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          const SizedBox(
            width: 300,
            child: Divider(thickness: 2),
          ),
          // Logout ListTile
          ListTile(
            leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.lightBlue),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                    color: Colors.white,
                  ),
                )),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                  fontSize: 20, color: appcolor, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right_outlined),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                              color: Colors.blueAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                auth.signOut().then((value) {
                                  pushReplace(context, const Login());
                                  ToastPopUp().toast('Logout successfully',
                                      Colors.green, Colors.white);
                                }).onError((error, v) {
                                  ToastPopUp().toast(error.toString(),
                                      Colors.green, Colors.white);
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Ok'))
                        ],
                      );
                    });
              },
            ),
          ),
          // Delete Account ListTile
          ListTile(
            leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.lightBlue),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
            title: Text(
              'Delete',
              style: GoogleFonts.poppins(
                  fontSize: 20, color: appcolor, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right_outlined),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Delete Account',
                          style: GoogleFonts.poppins(
                              color: Colors.blueAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Are you sure you want to delete your account?',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('NO')),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Enter Email and Password to delete your account',
                                          style: GoogleFonts.poppins(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SimpleAuthTextField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter your Email';
                                                }
                                                return null;
                                              },
                                              myController:
                                                  deleteEmailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              labelText: 'Email',
                                            ),
                                            const SizedBox(height: 10),
                                            PasswordTextField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter your Password';
                                                }
                                                return null;
                                              },
                                              myController: passwordController,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              labelText: 'Password',
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              if (deleteEmailController
                                                      .text.isEmpty ||
                                                  passwordController
                                                      .text.isEmpty) {
                                                ToastPopUp().toast(
                                                    'All fields are required',
                                                    Colors.red,
                                                    Colors.white);
                                                return;
                                              }

                                              try {
                                                User user = auth.currentUser!;

                                                DocumentSnapshot userDoc =
                                                    await deleteRef
                                                        .doc(user.uid)
                                                        .get();
                                                if (deleteEmailController.text
                                                        .trim()
                                                        .toLowerCase() ==
                                                    userDoc
                                                        .get('email')
                                                        .toString()
                                                        .trim()
                                                        .toLowerCase()) {
                                                  AuthCredential credential =
                                                      EmailAuthProvider
                                                          .credential(
                                                    email: deleteEmailController
                                                        .text
                                                        .trim(),
                                                    password: passwordController
                                                        .text
                                                        .trim(),
                                                  );

                                                  await user
                                                      .reauthenticateWithCredential(
                                                          credential)
                                                      .then((value) async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Users')
                                                        .doc(user.uid)
                                                        .delete();

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('TodoList')
                                                        .doc(user.uid)
                                                        .delete();

                                                    await user
                                                        .delete()
                                                        .then((value) {
                                                      ToastPopUp().toast(
                                                          'Account deleted successfully',
                                                          Colors.red,
                                                          Colors.white);

                                                      deleteEmailController
                                                          .clear();
                                                      passwordController
                                                          .clear();

                                                      auth.signOut();

                                                      pushReplace(context,
                                                          const Signup());
                                                    }).catchError((error) {
                                                      ToastPopUp().toast(
                                                          'Error deleting authentication account: $error',
                                                          Colors.red,
                                                          Colors.white);
                                                    });
                                                  }).catchError((error) {
                                                    ToastPopUp().toast(
                                                        'Reauthentication failed: $error',
                                                        Colors.red,
                                                        Colors.white);
                                                  });
                                                } else {
                                                  ToastPopUp().toast(
                                                      'Email does not match',
                                                      Colors.red,
                                                      Colors.white);
                                                }
                                              } catch (e) {
                                                ToastPopUp().toast('Error: $e',
                                                    Colors.red, Colors.white);
                                              }
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text('Yes'))
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
