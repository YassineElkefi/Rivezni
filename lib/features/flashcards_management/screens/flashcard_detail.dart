import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/flashcard_provider.dart';
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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    print("--------initial index-----${widget.initialIndex}");

    _currentIndex = widget.initialIndex;
    print("--------current index-----${_currentIndex}");
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

  void _deleteFlashcard(FlashcardProvider flashcardProvider) {
    if (widget.flashcards.isNotEmpty) {
      flashcardProvider.deleteFlashcard(widget.flashcards[_currentIndex].id!);
      setState(() {
        widget.flashcards.removeAt(_currentIndex);
        if (_currentIndex == 0) {
          Navigator.pop(context);
        } else {
            _pageController.jumpToPage(_currentIndex - 1);
          
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardProvider>(
        builder: (context, flashcardProvider, _) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                ),
                onPressed: () {
                  _deleteFlashcard(flashcardProvider);
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.flashcards.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final flashcard = widget.flashcards[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
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
              ),
            ),
          ],
        ),
      );
    });
  }
}
