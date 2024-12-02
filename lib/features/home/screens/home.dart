import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/auth_provider.dart';
import 'package:rivezni/core/providers/subject_provider.dart';
import 'package:rivezni/features/flashcards_management/screens/flashcards_home.dart';
import 'package:rivezni/features/home/widgets/show_add_subject_dialog.dart';
import 'package:rivezni/features/home/widgets/show_delete_subject_Dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final subjectProvider = Provider.of<SubjectProvider>(context, listen: false);

      if (authProvider.isLoggedIn) {
        subjectProvider.getSubjects(authProvider.user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectProvider>(
      builder: (context, subjectProvider, _) {
        return Scaffold(
          body: Center(
            child: subjectProvider.loading
                ? const CircularProgressIndicator()
                : subjectProvider.subjects.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.folder, size: 100, color: Colors.grey),
                          SizedBox(height: 20),
                          Text(
                            "No subjects yet!",
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Create a folder of a subject to get started.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                        ],
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12.0,
                          crossAxisSpacing: 12.0,
                          childAspectRatio: 3 / 4,
                        ),
                        padding: const EdgeInsets.all(16.0),
                        itemCount: subjectProvider.subjects.length,
                        itemBuilder: (context, index) {
                          final subject = subjectProvider.subjects[index];
                          final subjectColor = Color(int.parse(subject.color.replaceFirst('#', '0xFF')));

                          return GestureDetector(
                            onLongPress: () => showDeleteSubjectDialog(context: context, id: subject.id),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FlashcardsHome(subject: subject),
                              ),
                            ),
                            child: Card(
                              elevation: 6.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              color: subjectColor,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    /*const Icon(
                                      Icons.folder_rounded,
                                      size: 50,
                                      color: Colors.white70,
                                    ),*/
                                    Image.asset(
                                      'assets/images/folder.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      subject.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
            onPressed: () => showAddSubjectDialog(context: context),
            tooltip: "Add Subject",
            child: const Icon(Icons.add, color: Colors.white, size: 35),
          ),
        );
      },
    );
  }
}
