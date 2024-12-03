import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/flashcard_provider.dart';
import 'package:rivezni/data/models/flashcard.dart';
import 'package:rivezni/data/models/subject.dart';
import 'package:rivezni/shared/widgets/toast.dart';

class AddFlashcardForm extends StatefulWidget {
  final Subject subject;
  

  const AddFlashcardForm({Key? key, required this.subject}) : super(key: key);

  @override
  _AddFlashcardFormState createState() => _AddFlashcardFormState();
}

class _AddFlashcardFormState extends State<AddFlashcardForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flashcardQuestionController = TextEditingController();
  final TextEditingController _flashcardAnswerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardProvider>(builder: (context, flashcardProvider, _) {
      final subjectColor = Color(int.parse(widget.subject.color.replaceFirst('#', '0xFF')));

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Add a Flashcard",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _flashcardQuestionController,
                  
                  decoration: InputDecoration(
                    
                    labelText: "Flashcard Question",
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the flashcard question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _flashcardAnswerController,
                  decoration: InputDecoration(
                    focusColor: subjectColor,
                    labelText: "Flashcard Answer",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the flashcard answer';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String flashcardQuestion = _flashcardQuestionController.text;
                String flashcardAnswer = _flashcardAnswerController.text;

                Flashcard flashcard = Flashcard(
                  question: flashcardQuestion,
                  answer: flashcardAnswer,
                  subjectId: widget.subject.id!,
                );

                flashcardProvider.addFlashcard(flashcard);
                Navigator.of(context).pop();
                _flashcardQuestionController.clear();
                _flashcardAnswerController.clear();

                showToast(message: "Flashcard Added!");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: subjectColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Add Flashcard",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      );
    });
  }
}
