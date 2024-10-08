import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_firestore/Custom%20Widgets/toast.dart';
import 'package:todo_firestore/Utils/colors.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  _AllTasksState createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Set<String> selectedItems = {};
  late Stream<QuerySnapshot> db;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance
        .collection('TodoList')
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: db,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Unexpected Error occurred!'),
                );
              } else if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No Tasks Found',
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 15),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        int colorIndex = index % colors.length;

                        return GestureDetector(
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: colors[colorIndex],
                              ),
                              child: Center(
                                child: Text(
                                  snapshot.data!.docs[index]['Title']
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight:
                                        colors[colorIndex] == Colors.black
                                            ? FontWeight.bold
                                            : FontWeight.w600,
                                    color: colors[colorIndex] == Colors.black
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]['Title'],
                              style: GoogleFonts.ubuntuMono(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              snapshot.data!.docs[index]['Description'],
                              style: GoogleFonts.ubuntuMono(fontSize: 17),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    if (snapshot.data!.docs[index]['Title'] ==
                                            null ||
                                        snapshot.data!.docs[index]
                                                ['Description'] ==
                                            null ||
                                        snapshot.data!.docs[index]['id'] ==
                                            null) {
                                      ToastPopUp().toast('Some data is missing',
                                          Colors.red, Colors.white);
                                      return;
                                    }

                                    titleController.text = snapshot
                                        .data!.docs[index]['Title']
                                        .toString();
                                    descriptionController.text = snapshot
                                        .data!.docs[index]['Description']
                                        .toString();
                                    String id = snapshot.data!.docs[index]['id']
                                        .toString();

                                    if (value == 'Edit') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          titleController.text = snapshot
                                              .data!.docs[index]['Title'];
                                          descriptionController.text = snapshot
                                              .data!.docs[index]['Description'];
                                          return AlertDialog(
                                            title: const Text('Edit Task'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: titleController,
                                                  decoration: const InputDecoration(
                                                      hintText: 'Title'),
                                                ),
                                                TextField(
                                                  controller:
                                                      descriptionController,
                                                  decoration: const InputDecoration(
                                                      hintText: 'Description'),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (titleController.text
                                                          .trim()
                                                          .isEmpty ||
                                                      descriptionController.text
                                                          .trim()
                                                          .isEmpty) {
                                                    ToastPopUp().toast(
                                                        'Please fill all fields',
                                                        Colors.red,
                                                        Colors.white);
                                                    return;
                                                  } else {
                                                    String taskId = snapshot
                                                        .data!.docs[index].id;

                                                    FirebaseFirestore.instance
                                                        .collection('TodoList')
                                                        .doc(taskId)
                                                        .update({
                                                      'Title':
                                                          titleController.text,
                                                      'Description':
                                                          descriptionController
                                                              .text
                                                    }).then((_) {
                                                      ToastPopUp().toast(
                                                          'Data updated successfully',
                                                          Colors.green,
                                                          Colors.white);
                                                      Navigator.pop(context);
                                                    }).catchError((error) {
                                                      ToastPopUp().toast(
                                                          error.toString(),
                                                          Colors.red,
                                                          Colors.white);
                                                    });
                                                  }
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (value == 'Delete') {
                                      FirebaseFirestore.instance
                                          .collection('TodoList')
                                          .doc(id)
                                          .delete()
                                          .then((v) {
                                        ToastPopUp().toast(
                                            'Data deleted successfully',
                                            Colors.green,
                                            Colors.white);
                                      }).onError((error, v) {
                                        ToastPopUp().toast(error.toString(),
                                            Colors.red, Colors.white);
                                      });
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                          value: 'Edit', child: Text('Edit')),
                                      const PopupMenuItem<String>(
                                          value: 'Delete',
                                          child: Text('Delete')),
                                    ];
                                  },
                                  icon: const Icon(Icons.more_vert),
                                  offset: const Offset(0, 50),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    ));
  }
}
