import 'package:flutter/material.dart';
import 'package:rivezni/data/models/subject.dart';
import 'package:rivezni/features/flashcards_management/widgets/add_flashcard_form.dart';

void showAddFlashcardDialog({required BuildContext context, required Subject subject}) {
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
          child: AddFlashcardForm(subject: subject),
        ),
      );
    },
  );
}
