import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/flashcard_provider.dart';
import 'package:rivezni/data/models/flashcard.dart';
import 'package:rivezni/data/models/subject.dart';
import 'package:rivezni/features/flashcards_management/screens/flashcard_detail.dart';
import 'package:rivezni/features/flashcards_management/widgets/show_add_flashcard_dialog.dart';

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

  Widget _card(Flashcard flashcard) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/flashcard.png',
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flashcard.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      flashcard.answer,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardProvider>(
        builder: (context, flashcardProvider, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
                            child: _card(flashcard),
                            onTap: () =>
                                _showFlashcardDetails(flashcard, index),
                          );
                        },
                      ),
                    ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
          onPressed: () => showAddFlashcardDialog(
              context: context, subjectId: widget.subject.id!),
          child: const Icon(Icons.add, color: Colors.white, size: 35),
        ),
      );
    });
  }

  void _showFlashcardDetails(Flashcard flashcard, int initialIndex) {
    final flashcardProvider =
        Provider.of<FlashcardProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: FlashcardDetailPage(
                flashcards: List<Flashcard>.from(flashcardProvider.flashcards),
                initialIndex: initialIndex,
              ),
            ),
          ),
        );
      },
    );
  }
}
