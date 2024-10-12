import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_logic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048游戏',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic game;

  @override
  void initState() {
    super.initState();
    game = GameLogic();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _handleSwipe(Direction.up);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _handleSwipe(Direction.down);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _handleSwipe(Direction.left);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _handleSwipe(Direction.right);
      }
    }
  }

  void _handleSwipe(Direction direction) {
    if (game.move(direction)) {
      setState(() {});
      if (game.hasWon()) {
        _showWinDialog();
      } else if (game.isGameOver()) {
        _showGameOverDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('恭喜!'),
          content: Text('你赢了! 得分: ${game.score}'),
          actions: <Widget>[
            TextButton(
              child: Text('继续游戏'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('重新开始'),
              onPressed: () {
                setState(() {
                  game.reset();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('游戏结束'),
          content: Text('你的得分是: ${game.score}'),
          actions: <Widget>[
            TextButton(
              child: Text('重新开始'),
              onPressed: () {
                setState(() {
                  game.reset();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: Text('2048游戏'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('分数: ${game.score}', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dy < 0) {
                    _handleSwipe(Direction.up);
                  } else {
                    _handleSwipe(Direction.down);
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx < 0) {
                    _handleSwipe(Direction.left);
                  } else {
                    _handleSwipe(Direction.right);
                  }
                },
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      int row = index ~/ 4;
                      int col = index % 4;
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black.withOpacity(0.2)),
                          color: _getTileColor(game.board[row][col]),
                        ),
                        child: Center(
                          child: Text(
                            game.board[row][col] != 0 ? '${game.board[row][col]}' : '',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: game.board[row][col] > 4 ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    game.reset();
                  });
                },
                child: Text('重新开始'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return Color(0xFFEEE4DA);
      case 4:
        return Color(0xFFEDE0C8);
      case 8:
        return Color(0xFFF2B179);
      case 16:
        return Color(0xFFF59563);
      case 32:
        return Color(0xFFF67C5F);
      case 64:
        return Color(0xFFF65E3B);
      case 128:
        return Color(0xFFEDCF72);
      case 256:
        return Color(0xFFEDCC61);
      case 512:
        return Color(0xFFEDC850);
      case 1024:
        return Color(0xFFEDC53F);
      case 2048:
        return Color(0xFFEDC22E);
      default:
        return Color(0xFFCDC1B4);
    }
  }
}
