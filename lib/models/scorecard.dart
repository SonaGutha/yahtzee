import 'package:collection/collection.dart';

enum ScoreCategory {
  ones("Ones", 1),
  twos("Twos", 2),
  threes("Threes", 3),
  fours("Fours", 4),
  fives("Fives", 5),
  sixes("Sixes", 6),
  threeOfAKind("Three of a Kind", 7),
  fourOfAKind("Four of a Kind", 8),
  fullHouse("Full House", 9),
  smallStraight("Small Straight", 10),
  largeStraight("Large Straight", 11),
  yahtzee("Yahtzee", 12),
  chance("Chance", 13);

  const ScoreCategory(this.name, this.num);

  final String name;
  final int num; // added a numeric value to each category
}

class ScoreCard {
  final Map<ScoreCategory, int?> _scores = {
    for (var category in ScoreCategory.values) category: null
  };

  int? operator [](ScoreCategory category) => _scores[category];

  bool get completed => _scores.values.whereNotNull().length == _scores.length;

  int get total => _scores.values.whereNotNull().sum;

  void clear() {
    _scores.forEach((key, value) {
      _scores[key] = null;
    });
  }

  void registerScore(ScoreCategory category, List<int> dice) {
    final uniqueVals = Set.from(dice);

    if (_scores[category] != null) {
      throw Exception('Category $category already has a score');
    }

    switch (category) {
      case ScoreCategory.ones:
        _scores[category] = dice.where((d) => d == 1).sum;
        break;

      case ScoreCategory.twos:
        _scores[category] = dice.where((d) => d == 2).sum;
        break;

      case ScoreCategory.threes:
        _scores[category] = dice.where((d) => d == 3).sum;
        break;

      case ScoreCategory.fours:
        _scores[category] = dice.where((d) => d == 4).sum;
        break;

      case ScoreCategory.fives:
        _scores[category] = dice.where((d) => d == 5).sum;
        break;

      case ScoreCategory.sixes:
        _scores[category] = dice.where((d) => d == 6).sum;
        break;

      case ScoreCategory.threeOfAKind:
        if (dice.any((d) => dice.where((d2) => d2 == d).length >= 3)) {
          _scores[category] = dice.sum;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.fourOfAKind:
        if (dice.any((d) => dice.where((d2) => d2 == d).length >= 4)) {
          _scores[category] = dice.sum;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.fullHouse:
        if (uniqueVals.length == 2 &&
            uniqueVals.any((d) => dice.where((d2) => d2 == d).length == 3)) {
          _scores[category] = 25;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.smallStraight:
        if (uniqueVals.containsAll([1, 2, 3, 4]) ||
            uniqueVals.containsAll([2, 3, 4, 5]) ||
            uniqueVals.containsAll([3, 4, 5, 6])) {
          _scores[category] = 30;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.largeStraight:
        if (uniqueVals.containsAll([1, 2, 3, 4, 5]) ||
            uniqueVals.containsAll([2, 3, 4, 5, 6])) {
          _scores[category] = 40;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.yahtzee:
        if (dice.length == 5 && uniqueVals.length == 1) {
          _scores[category] = 50;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.chance:
        _scores[category] = dice.sum;
        break;
    }
  }
}
