import 'package:flutter/material.dart';
import 'package:rivezni/features/home/widgets/delete_subject_alert.dart';

void showDeleteSubjectDialog({required BuildContext context, required int id}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DeleteSubjectAlert(id),
        ),
      );
    },
  );
}
