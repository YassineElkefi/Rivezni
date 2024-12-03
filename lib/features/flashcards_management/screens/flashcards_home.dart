import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/flashcard_provider.dart';
import 'package:rivezni/data/models/subject.dart';
import 'package:rivezni/features/flashcards_management/widgets/flashcard_card.dart';
import 'package:rivezni/features/flashcards_management/widgets/show_add_flashcard_dialog.dart';
import 'package:rivezni/features/flashcards_management/widgets/show_flashcard_detail.dart';

class FlashcardsHome extends StatefulWidget {
  final Subject subject;


  const FlashcardsHome({Key? key, required this.subject}) : super(key: key);

  @override
  _FlashcardsHomeState createState() => _FlashcardsHomeState();
}

class _FlashcardsHomeState extends State<FlashcardsHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flashcardProvider =
          Provider.of<FlashcardProvider>(context, listen: false);
      flashcardProvider.getFlashcards(widget.subject);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardProvider>(
        builder: (context, flashcardProvider, _) {
          final subjectColor = Color(int.parse(widget.subject.color.replaceFirst('#', '0xFF')));

      return Scaffold(
        appBar: AppBar(
          backgroundColor: subjectColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => {
              Navigator.pop(context),
              flashcardProvider.flashcards = []
            },
          ),
          title: Text(widget.subject.name,
              style: const TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: flashcardProvider.loading
              ? const Center(child: CircularProgressIndicator())
              : flashcardProvider.flashcards.isEmpty
                  ? const Center(
                      child: Text(
                        "No flashcards available. Add some to get started!",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        itemCount: flashcardProvider.flashcards.length,
                        itemBuilder: (context, index) {
                          final flashcard = flashcardProvider.flashcards[index];
                          return GestureDetector(
                            child: card(flashcard: flashcard),
                            onTap: () =>
                                showFlashcardDetails(context: context, flashcard: flashcard, initialIndex: index),
                          );
                        },
                      ),
                    ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: subjectColor,
          onPressed: () => showAddFlashcardDialog(
              context: context, subject: widget.subject),
          child: const Icon(Icons.add, color: Colors.white, size: 35),
        ),
      );
    });
  }
}
