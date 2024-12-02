import 'package:flutter/material.dart';
import 'package:rivezni/data/models/flashcard.dart';

class FlashcardDetailPage extends StatefulWidget {
  final List<Flashcard> flashcards;
  final int initialIndex;

  const FlashcardDetailPage(
      {Key? key, required this.flashcards, required this.initialIndex})
      : super(key: key);

  @override
  _FlashcardDetailPageState createState() => _FlashcardDetailPageState();
}

class _FlashcardDetailPageState extends State<FlashcardDetailPage> {
  late PageController _pageController;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = widget.flashcards[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Question N° ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      flashcard.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _toggleAnswer,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: _showAnswer
                              ? Colors.green.shade100
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0),
                          border: _showAnswer
                              ? Border.all(color: Colors.green, width: 2.0)
                              : Border.all(color: Colors.transparent),
                        ),
                        child: Text(
                          _showAnswer
                              ? flashcard.answer
                              : "Tap to see the answer",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: _showAnswer
                                ? Colors.black
                                : Colors.green.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
