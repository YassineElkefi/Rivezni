import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/auth_provider.dart';
import 'package:rivezni/core/providers/subject_provider.dart';
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
                  ? const Text("Create a folder of a subject!")
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: subjectProvider.subjects.length,
                      itemBuilder: (context, index) {
                        final subject = subjectProvider.subjects[index];
                        final subjectColor = Color(int.parse(subject.color.replaceFirst('#', '0xFF')));

                        return GestureDetector(
                          onLongPress: () => showDeleteSubjectDialog(context: context, id: subject.id),
                          onTap: () => print("You clicked on ${subject.name}"),
                          child: Container(
                            color: subjectColor,
                            child: Center(
                              child: Text(
                                subject.name,
                                style: const TextStyle(fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showAddSubjectDialog(context: context),
            ),
        );
      },
    );
  }
}
