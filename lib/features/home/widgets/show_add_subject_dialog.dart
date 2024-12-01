import 'package:flutter/material.dart';
import 'package:rivezni/features/home/widgets/add_subject_form.dart';

void showAddSubjectDialog({required context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            borderRadius: BorderRadius.circular(20),
          ),
          child: AddSubjectForm(),
        ),
      );
    },
  );
}
