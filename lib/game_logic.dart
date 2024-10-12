import 'dart:math';

enum Direction { up, down, left, right }

class GameLogic {
  late List<List<int>> board;
  late int score;
  late Random random;

  GameLogic() {
    board = List.generate(4, (_) => List.filled(4, 0));
    score = 0;
    random = Random();
    addNewTile();  // 添加第一个初始方块
    addNewTile();  // 添加第二个初始方块
  }

  void addNewTile() {
    List<List<int>> emptyTiles = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          emptyTiles.add([i, j]);
        }
      }
    }
    if (emptyTiles.isNotEmpty) {
      List<int> newTile = emptyTiles[random.nextInt(emptyTiles.length)];
      board[newTile[0]][newTile[1]] = random.nextInt(10) < 9 ? 2 : 4;
    }
  }

  bool move(Direction direction) {
    bool moved = false;
    List<List<int>> oldBoard = List.generate(4, (i) => List.from(board[i]));

    switch (direction) {
      case Direction.up:
        moved = _moveUp();
        break;
      case Direction.down:
        moved = _moveDown();
        break;
      case Direction.left:
        moved = _moveLeft();
        break;
      case Direction.right:
        moved = _moveRight();
        break;
    }

    if (moved) {
      addNewTile();
    }

    return moved;
  }

  bool _moveLeft() {
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = board[i];
      List<int> newRow = _mergeLine(row);
      board[i] = newRow;
      if (!moved && !listEquals(row, newRow)) {
        moved = true;
      }
    }
    return moved;
  }

  bool _moveRight() {
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = board[i].reversed.toList();
      List<int> newRow = _mergeLine(row);
      board[i] = newRow.reversed.toList();
      if (!moved && !listEquals(row, newRow)) {
        moved = true;
      }
    }
    return moved;
  }

  bool _moveUp() {
    return _moveVertical(false);
  }

  bool _moveDown() {
    return _moveVertical(true);
  }

  bool _moveVertical(bool reverse) {
    bool moved = false;
    for (int j = 0; j < 4; j++) {
      List<int> column = [board[0][j], board[1][j], board[2][j], board[3][j]];
      if (reverse) column = column.reversed.toList();
      List<int> newColumn = _mergeLine(column);
      if (reverse) newColumn = newColumn.reversed.toList();
      for (int i = 0; i < 4; i++) {
        board[i][j] = newColumn[i];
      }
      if (!moved && !listEquals(column, newColumn)) {
        moved = true;
      }
    }
    return moved;
  }

  List<int> _mergeLine(List<int> line) {
    List<int> newLine = [];
    for (int i = 0; i < line.length; i++) {
      if (line[i] != 0) {
        newLine.add(line[i]);
      }
    }
    for (int i = 0; i < newLine.length - 1; i++) {
      if (newLine[i] == newLine[i + 1]) {
        newLine[i] *= 2;
        score += newLine[i];
        newLine.removeAt(i + 1);
      }
    }
    while (newLine.length < 4) {
      newLine.add(0);
    }
    return newLine;
  }

  bool isGameOver() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) {
          return false;
        }
        if (j < 3 && board[i][j] == board[i][j + 1]) {
          return false;
        }
        if (i < 3 && board[i][j] == board[i + 1][j]) {
          return false;
        }
      }
    }
    return true;
  }

  void reset() {
    board = List.generate(4, (_) => List.filled(4, 0));
    score = 0;
    addNewTile();
    addNewTile();
  }

  bool hasWon() {
    for (var row in board) {
      if (row.contains(2048)) {
        return true;
      }
    }
    return false;
  }
}

bool listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
