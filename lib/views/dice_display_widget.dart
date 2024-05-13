import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

class DiceDisplayWidget extends StatelessWidget {
  final Dice dice;
  final ScoreCard scoreCard;

  const DiceDisplayWidget(
      {super.key, required this.dice, required this.scoreCard});
  @override
  Widget build(BuildContext context) {
    //Row which display all 5 dices used in the Yahtzee game

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      //Added below condition for display purpose, when dice is not rolled, empty containers are displayed
      if (dice.values.isEmpty)
        for (int i = 0; i < 5; i++)
          Container(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2.0, // Border width
                ),
              ))
      else
        // iterates through the dice values and displays it on the screen
        for (int i = 0; i < dice.values.length; i++) diceDisplay(i)
    ]);
  }

  // Returns gesture detector which toggles between dice held state and also displays the dice container with images
  GestureDetector diceDisplay(int i) {
    return GestureDetector(
        onTap: () {
          dice.toggleHold(i);
        },
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            alignment: Alignment.center,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: dice.isHeld(i) ? Colors.blue : Colors.white,
              border: Border.all(
                color: Colors.black, // Border color
                width: 2.0, // Border width
              ),
            ),
            child: Image.asset(
              'assets/images/dice${dice[i]}.png',
              fit: BoxFit.contain,
              width: 90,
              height: 90,
            ),
          ),
          Container(
              alignment: Alignment.center,
              child: Text(
                dice[i].toString(),
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Colors.brown,
                ),
              ))
        ]));
  }
}
