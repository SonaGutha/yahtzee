import 'package:flutter/material.dart';
import 'package:mp2/models/scorecard.dart';

class FinalScoreWidget extends StatelessWidget {
  const FinalScoreWidget({
    super.key,
    required this.scoreCard,
  });

  final ScoreCard scoreCard;

  @override
  Widget build(BuildContext context) {
    //Displays the sum of dice values for selected score categories.
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Current Score : ${scoreCard.total.toString()}',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
          )
        ],
      ),
    );
  }
}
