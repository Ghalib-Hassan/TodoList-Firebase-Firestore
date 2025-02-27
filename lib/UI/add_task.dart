import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_firestore/Custom%20Widgets/button.dart';
import 'package:todo_firestore/Custom%20Widgets/toast.dart';
import 'package:todo_firestore/Utils/colors.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const Image(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fitHeight,
            alignment: Alignment.centerLeft,
            image: AssetImage('Images/Main.jpg')),
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Center(
                child: GlassContainer(
                  width: 300,
                  borderGradient: const LinearGradient(
                      colors: [Colors.black, Colors.white]),
                  blur: 900,
                  radius: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Transform(
                          transform: Matrix4.rotationZ(0.2),
                          child: Image.asset(
                              semanticLabel: 'Todo Image',
                              height: 100,
                              'Images/To-do.jpg'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GlassText(
                          'Focus on your day',
                          style: GoogleFonts.maitree(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: GlassText(
                            'Get things done with My Day, a \nlist that refreshes every day',
                            style: GoogleFonts.mateSc(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.roboto(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Try typing title 'Utility bill'",
                    hintStyle: GoogleFonts.roboto(fontSize: 15),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 5,
                  style: GoogleFonts.roboto(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Try typing 'Pay utilities bill by Friday 6pm'",
                    hintStyle: GoogleFonts.roboto(fontSize: 15),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                horizontalPadding: 10,
                buttonText: 'Add Record',
                buttonWidth: 300,
                buttonHeight: 55,
                buttonColor: lightGrey,
                buttonFontSize: 30,
                buttonFontWeight: FontWeight.bold,
                buttonRadius: 10,
                textColor: white,
                isLoading: isLoading,
                onPressed: () {
                  if (titleController.text.trim().isEmpty ||
                      descriptionController.text.trim().isEmpty) {
                    ToastPopUp().toast("Textfield's should not be empty",
                        Colors.red, Colors.white);
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    db.collection('TodoList').doc(id).set({
                      'id': id,
                      'uid': auth.currentUser!.uid,
                      'Title': titleController.text.toString().trim(),
                      'Description':
                          descriptionController.text.toString().trim(),
                    }).then((value) {
                      titleController.clear();
                      descriptionController.clear();
                      setState(() {
                        isLoading = false;
                      });
                      ToastPopUp()
                          .toast('Data Added', Colors.green, Colors.white);
                    }).onError((error, v) {
                      setState(() {
                        isLoading = false;
                      });
                      print("Error adding document: $error");
                      ToastPopUp().toast(
                          'Failed to Add Data', Colors.red, Colors.white);
                    });
                  }
                },
              ),
            ],
          ),
        )
      ],
    ));
  }
}
