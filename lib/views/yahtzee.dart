import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';

import 'package:mp2/models/scorecard.dart';
import 'package:provider/provider.dart';

import 'dice_display_widget.dart';
import 'final_score_widget.dart';

class Yahtzee extends StatelessWidget {
  const Yahtzee({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Dice(5), child: const SinglePlayerGame());
  }
}

class SinglePlayerGame extends StatefulWidget {
  const SinglePlayerGame({super.key});

  @override
  State<SinglePlayerGame> createState() => _SinglePlayerGameState();
}

class _SinglePlayerGameState extends State<SinglePlayerGame> {
  late Dice dice;
  final scoreCard = ScoreCard();
  int rollsLeft = 3;
  bool rollsButtonDisabled = false;
  bool showAlertDialog = false;
  List<bool> showPickButton = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];

  @override
  void initState() {
    super.initState();
    dice = Provider.of<Dice>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: scoreCard.completed
          ? gameEndAlert()
          : Center(
              child: Consumer<Dice>(builder: (context, dice, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DiceDisplayWidget(
                        dice: dice,
                        scoreCard: scoreCard), // displays the dices and values
                    rollButtonRow(), // displays dice roll button with number of rolls left
                    scoreCardDetailsDisplay(dice), // displays score card
                    FinalScoreWidget(
                        scoreCard:
                            scoreCard) // displays the total of the selected score card categories
                  ],
                );
              }),
            ),
    );
  }

// displays the score card categoies and a button to select the score categories
  Padding scoreCardDetailsDisplay(Dice dice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                categoryDisplay(),
                registerScoreValues(dice),
              ],
            )
          ],
        ),
      ),
    );
  }

  //Displays pick button for all score categories based on the showPickButton flag and
  //registers the score based on the players selection
  Center registerScoreValues(Dice dice) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < showPickButton.length; i++)
              for (final category in ScoreCategory.values)
                if (i + 1 == category.num)
                  registerScoreValuesContainer(i, category, dice)
          ]),
    );
  }

//Displays the names of the 13 score categories for the Yahtzee game
  Center categoryDisplay() {
    return Center(
      child: Column(
        children: [
          for (final category in ScoreCategory.values)
            Container(
              width: 120,
              height: 25,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 1.0, // Border width
                ),
                // Border radius
              ),
              child: SizedBox(
                height: 25,
                width: 120,
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  //This method displays then 'pick' button, which on pressed stores the value of the selected category.
  //Once a category is selected, 'pick' button will not be displayed but a score for the selected category is displayed on thenscreen.
  Container registerScoreValuesContainer(
      int i, ScoreCategory category, Dice dice) {
    return Container(
        width: 120,
        height: 25,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // Border color
            width: 1.0, // Border width
          ),
          // Border radius
        ),
        child: SizedBox(
          height: 25,
          child: showPickButton[i]
              ? TextButton(
                  child: const Text(
                    "Pick",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(240, 4, 141, 205)),
                    textAlign: TextAlign.left,
                  ),
                  onPressed: () {
                    storeScoreValues(i, category, dice);
                  })
              : Text(
                  scoreCard[category].toString(),
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
        ));
  }

//stores the sum of dice values for the selected score category
  void storeScoreValues(int i, ScoreCategory category, Dice dice) {
    return setState(() {
      showPickButton[i] = false;
      scoreCard.registerScore(category,
          dice.values); //stores the dice values for the selected category
      rollsButtonDisabled =
          false; //Once a category is selected, roll dice is enabled again.
      rollsLeft = 3; // Once a category is selected, resets the rolls left
      dice.clear(); // clears out the previous dice values
    });
  }

// Pops up a alert with then final score of the current game and a button to start a new game
  Center gameEndAlert() {
    return Center(
      child: AlertDialog(
          title: const Text('Game Over!'),
          content: Text('Final Score : ${scoreCard.total}'),
          actions: <Widget>[
            TextButton(
              onPressed: resetGame,
              child: const Text('Play Again'),
            ),
          ]),
    );
  }

// Row to display roll dice button with number of rolls left. When roll count is not exhausted,
// roll dice button is enabled. Roll dice button is disabled when the dice is rolled 3 times.
  Center rollButtonRow() => Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: rollsButtonDisabled ? null : rollDice,
              child: Text(
                rollsButtonDisabled ? 'Out of Rolls!' : 'Roll Dice($rollsLeft)',
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      );

// Method to roll the dice 3 times and disables the role dice button when out of rolls
  void rollDice() => {
        setState(() {
          if (rollsLeft > 0) {
            dice.roll();
            rollsLeft--;
          }
          if (rollsLeft == 0) {
            rollsButtonDisabled = true;
          }
        })
      };

  // Method to reset the game and clears out the dice values and score card from the previous game
  void resetGame() {
    setState(() {
      dice.clear(); //clearing out the dice values from the previous game
      rollsLeft = 3; // resetting the  rolls count for the new game
      scoreCard
          .clear(); //clearing out the score card values from the previous game
      showPickButton = [
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true
      ]; // flag value reset to true for the new game
    });
  }
}
