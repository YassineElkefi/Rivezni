import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/flashcard_provider.dart';
import 'package:rivezni/data/models/flashcard.dart';
import 'package:rivezni/features/flashcards_management/screens/flashcard_detail.dart';

void showFlashcardDetails(
    {required context, required Flashcard flashcard, required int initialIndex}) {
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
