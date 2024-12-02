import 'package:flutter/material.dart';
import 'package:rivezni/features/flashcards_management/widgets/add_flashcard_form.dart';

void showAddFlashcardDialog({required context, required int subjectId}) {
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
          child: AddFlashcardForm(subjectId: subjectId,),
        ),
      );
    },
  );
}
