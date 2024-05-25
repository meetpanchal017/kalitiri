import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CardType { spades, hearts, clubs, diamonds }

enum CardRank { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }

class Card {
  final CardType type;
  final CardRank rank;

  Card(this.type, this.rank);

  @override
  String toString() {
    return '${rankToString()} ${typeToString()}';
  }

  String typeToString() {
    switch (type) {
      case CardType.spades:
        return '♠';
      case CardType.hearts:
        return '♥';
      case CardType.clubs:
        return '♣';
      case CardType.diamonds:
        return '♦';
    }
  }

  String rankToString() {
    switch (rank) {
      case CardRank.ace:
        return 'ace';
      case CardRank.two:
        return '2';
      case CardRank.three:
        return '3';
      case CardRank.four:
        return '4';
      case CardRank.five:
        return '5';
      case CardRank.six:
        return '6';
      case CardRank.seven:
        return '7';
      case CardRank.eight:
        return '8';
      case CardRank.nine:
        return '9';
      case CardRank.ten:
        return '10';
      case CardRank.jack:
        return 'jack';
      case CardRank.queen:
        return 'queen';
      case CardRank.king:
        return 'king';
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<Card>> cards = Utils.getCardForPlayer;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
          () {
        isLoading = false;
        setState(() {});
      },
    );
  }

  String? selectedCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('shuffling...'),
          ],
        ),
      )
          : Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              alignment: Alignment.bottomCenter,
              height: 144,
              width: 344,
              child: Stack(
                children: List.generate(
                  13,
                      (index) {
                    Card card = cards[0][index];

                    String cardName = '${card.type.name}${card.rankToString()}';
                    return Positioned(
                      left: index * 22,
                      width: 80,
                      height: 120,
                      bottom: selectedCard == cardName ? 24 : 0,
                      child: GestureDetector(
                        onTap: () {
                          selectedCard = cardName;
                          setState(() {});
                        },
                        child: SvgPicture.asset(
                          'assets/cards/${card.rankToString()}_of_${card.type.name}.svg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24)
          ],
        ),
      ),
    );
  }
}

class Utils {
  static List<List<Card>> get getCardForPlayer {
    List<Card> deck = [];
    for (var type in CardType.values) {
      for (var rank in CardRank.values) {
        deck.add(Card(type, rank));
      }
    }

    deck.shuffle();

    List<List<Card>> playerHands = List.generate(4, (_) => []);

    int currentPlayer = 0;
    for (var card in deck) {
      playerHands[currentPlayer].add(card);
      currentPlayer = (currentPlayer + 1) % 4;
    }

    for (int i = 0; i < playerHands.length; i++) {
      List<Card> sortedHand = List.from(playerHands[i])
        ..sort((a, b) {
          if (a.type.index != b.type.index) {
            return a.type.index.compareTo(b.type.index);
          } else {
            return a.rank.index.compareTo(b.rank.index);
          }
        });
      playerHands[i] = sortedHand;
    }
    //
    // for (int i = 0; i < playerHands.length; i++) {
    //   print('Player ${i + 1} Hand:');
    //   List<Card> sortedHand = List.from(playerHands[i])
    //     ..sort((a, b) {
    //       if (a.type.index != b.type.index) {
    //         return a.type.index.compareTo(b.type.index);
    //       } else {
    //         return a.rank.index.compareTo(b.rank.index);
    //       }
    //     });
    //   for (var card in sortedHand) {
    //     print(card);
    //   }
    //   print('=====================');
    // }

    return playerHands;
  }
}
