import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JogoDaVelha(),
    );
  }
}

class JogoDaVelha extends StatefulWidget {
  @override
  _JogoDaVelhaState createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<String> board = List.filled(9, "");
  bool isPlayerX = true;
  String result = "";
  bool isSinglePlayer = true;

  void _resetGame() {
    setState(() {
      board = List.filled(9, "");
      isPlayerX = true;
      result = "";
    });
  }

  void _makeMove(int index) {
    if (board[index] == "" && result == "") {
      setState(() {
        board[index] = isPlayerX ? "X" : "O";
        if (_checkWinner()) {
          result = "${isPlayerX ? "X" : "O"} venceu!";
        } else if (!board.contains("")) {
          result = "Empate!";
        } else {
          isPlayerX = !isPlayerX;
          if (isSinglePlayer && !isPlayerX) {
            _makeComputerMove();
          }
        }
      });
    }
  }

  void _makeComputerMove() {
    Random random = Random();
    int index = random.nextInt(9);
    while (board[index] != "") {
      index = random.nextInt(9);
    }
    _makeMove(index);
  }

  bool _checkWinner() {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] != "" &&
          board[condition[0]] == board[condition[1]] &&
          board[condition[1]] == board[condition[2]]) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Jogo da Velha"),
        backgroundColor: Colors.teal,
        actions: [
          Switch(
            value: isSinglePlayer,
            onChanged: (value) {
              setState(() {
                _resetGame();
                isSinglePlayer = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(isSinglePlayer ? "1 Jogador" : "2 Jogadores"),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: isWideScreen ? 600 : screenWidth * 0.9,
          child: Column(
            children: [
              // Tela de status do jogo
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    result.isEmpty
                        ? "Vez de ${isPlayerX ? "X" : "O"}"
                        : result,
                    style: TextStyle(
                      fontSize: isWideScreen ? 32 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              // Tabuleiro do jogo
              Expanded(
                flex: 4,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _makeMove(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          board[index],
                          style: TextStyle(
                            fontSize: isWideScreen ? 48 : 32,
                            fontWeight: FontWeight.bold,
                            color: board[index] == "X"
                                ? Colors.teal
                                : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Botão de reiniciar
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Reiniciar Jogo",
                    style: TextStyle(
                      fontSize: isWideScreen ? 24 : 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
