import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_firestore/Utils/colors.dart';

class CheckedScreen extends StatefulWidget {
  const CheckedScreen({super.key});

  @override
  _CheckedScreenState createState() => _CheckedScreenState();
}

class _CheckedScreenState extends State<CheckedScreen> {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('TodoList');

  // List to keep track of selected tasks
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: todoCollection.where('completed', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            final tasks = snapshot.data!.docs;

            if (tasks.isEmpty) {
              return const Center(child: Text('No Task found'));
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                int colorIndex = index % colors.length;

                return CheckboxListTile(
                  value: selectedItems.contains(task['id']),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedItems.add(task['id']);
                      } else {
                        selectedItems.remove(task['id']);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: colors[colorIndex],
                        ),
                        child: Center(
                          child: Text(
                            task['Title']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: colors[colorIndex] == Colors.black
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: colors[colorIndex] == Colors.black
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task['Title'],
                          style: GoogleFonts.ubuntuMono(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    task['Description'],
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 17,
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading tasks'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
