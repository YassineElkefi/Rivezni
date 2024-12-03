import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/subject_provider.dart';
import 'package:rivezni/shared/widgets/toast.dart';

class DeleteSubjectAlert extends StatelessWidget {
  final int id;

  const DeleteSubjectAlert(this.id, {Key? key}) : super(key: key);

  Widget _button(
      BuildContext context, SubjectProvider subjectProvider) {
    return ElevatedButton(
      onPressed: () {
          subjectProvider.deleteSubject(id).then((_) {
            Navigator.of(context).pop();
            showToast(message: "Subject Deleted!");
          }).catchError((error) {
            Navigator.of(context).pop();
            showToast(message: "Error: $error");
          });

      },

      style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  
        minimumSize: const Size(100, 50),
      ),
      child: const Text("Confirm"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectProvider>(
      builder: (context, subjectProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Are you sure you want to delete this subject?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _button(context, subjectProvider),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
