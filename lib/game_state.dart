import 'package:firebase_auth/firebase_auth.dart';

class GameState {
  late int cols;
  late int rows;

  late List<List<int>> squares;
  int currentPlayer = 1;
  late List<int> nextRow;
  bool anticipatingMove = false;
  int winner = 0;

  Map<String, dynamic> toMap() {
    print("toMap");
    return <String, dynamic> {
      'squares': squaresAsArray(),
      'currentPlayer': currentPlayer,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
    };
  }

  List<int> squaresAsArray() {
    List<int> squaresArray = [];
    for (int i = 0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        squaresArray.add(squares[j][i]);
      }
    }
    return squaresArray;
  }

  static GameState fromMap(Map<String, dynamic> map) {
    var game = GameState();
    print('fromMap');
    var squaresArray = map['squares'];
    print(game.rows);
    for (int i = 0; i<squaresArray.length; i++) {
      // print('game[${game.squares.length}][${game.squares[0].length}]');
      // print('cols: ${game.cols}, rows ${game.rows}');
      print('i=$i, ${i % game.cols} : ${i ~/ game.cols}');
      game.squares[i % game.cols][i ~/ game.cols] = squaresArray[i];
    }
    game.currentPlayer = map['currentPlayer'];
    game.updateHeights();
    if (game.playerHasWon(-1)) game.winner = -1;
    else if (game.playerHasWon(1)) game.winner = 1;
    return game;
  }

  GameState() {
    initSquares(7, 6);
  }

  void initSquares(int cols, int rows) {
    this.cols = cols;
    this.rows = rows;
    this.nextRow = [];
    squares = List.generate(cols, (i) {
      nextRow.add(rows-1);
      return List<int>.generate(rows, (index) => 0);
    }, growable: false);
  }

  bool play(int col) {
    if (winner != 0) {
      winner = 0;
      initSquares(7, 6);
      return false;
    }
    if (nextRow[col] >= 0) {
      squares[col][nextRow[col]] = currentPlayer;
      checkGameState(currentPlayer);
      currentPlayer *= -1;
      nextRow[col]--;
      return true;
    }

    return false;
  }

  void checkGameState(int player) {
    if (playerHasWon(player)) {
      winner = player;
    }
  }

  bool playerHasWon(int player) {
    if (player != -1 && player != 1) return false;
    return playerMadeHorizontalRow(player) ||
        playerMadeVerticalRow(player) ||
        playerMadeDiagonalRow(player);
  }

  bool playerMadeDiagonalRow(int player) {
    for (int i = -2; i < cols + 2; i++) {
      if (isDiagonalRow(i, player)) return true;
    }
    return false;
  }

  void updateHeights() {
    print('up heights, cols:$cols, rows:$rows');
    for (int i = 0; i<cols; i++) {
      nextRow[i] = -1;
      for (int j = 1; j <= rows; j++) {
        if (squares[i][rows - j] == 0) {
          nextRow[i] = rows-j;
          break;
        }
      }
    }
  }

  bool playerMadeHorizontalRow(int player) {
    int count = 0;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (squares[j][i] == player) {
          count += 1;
          if (count == 4) {
            return true;
          }
        } else {
          count = 0;
        }
      }
    }
    return false;
  }

  bool playerMadeVerticalRow(int player) {
    int count = 0;
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (squares[i][j] == player) {
          count += 1;
          if (count == 4) {
            return true;
          }
        } else {
          count = 0;
        }
      }
    }
    return false;
  }

  /// check whether [player] formed a diagonal row on one of the
  /// diagonals crossing (x: [col], y: 0)
  bool isDiagonalRow(int col, int player) {
    int _col = col;
    int _row = 0;
    int count = 0;
    for (int dir = -1; dir <= 1; dir += 2) {
      _col = col;
      _row = 0;
      while (_row < 6 && _col >= -2 && _col <= cols + 2) {
        if (_col < 0 || _col >= cols) {
          _col += dir;
          _row += 1;
          continue;
        }
        ;
        if (squares[_col][_row] == player) {
          count += 1;
          if (count == 4) {
            return true;
          }
        } else {
          count = 0;
        }
        _col += dir;
        _row += 1;
      }
    }
    return false;
  }
}
