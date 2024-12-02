import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/flashcard_provider.dart';
import 'package:rivezni/data/models/flashcard.dart';
import 'package:rivezni/shared/widgets/toast.dart';

class AddFlashcardForm extends StatefulWidget {

    final int subjectId;

  const AddFlashcardForm({Key? key, required this.subjectId}) : super(key: key);
  
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
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add a Flashcard",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _flashcardQuestionController,
                decoration: const InputDecoration(
                  labelText: "Flashcard Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the flashcard name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
                            TextFormField(
                controller: _flashcardAnswerController,
                decoration: const InputDecoration(
                  labelText: "Flashcard Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the flashcard name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {

                    String flashcardQuestion = _flashcardQuestionController.text;
                    String flashcardAnswer = _flashcardAnswerController.text;

                    Flashcard flashcard = Flashcard(question: flashcardQuestion, answer: flashcardAnswer, subjectId: widget.subjectId);

                    flashcardProvider.addFlashcard(flashcard);

                    Navigator.of(context).pop();
                    _flashcardQuestionController.clear();
                    _flashcardAnswerController.clear();

                    showToast(message: "Flashcard Added!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Submit"),
              ),


            ],
          ),
        ),
      );
    });
  }
}
