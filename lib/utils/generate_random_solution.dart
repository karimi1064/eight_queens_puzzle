class GenerateRandomSolution {
  List<List<List<int>>> solutions = [];

  List start(int n) {
    checkSolution(n);
    return solutions;
  }

  bool checkSolution(int n) {
    List<List<int>> board = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
    ];

    if (solution(board, 0, n) == false) {
      return false;
    }
    findSolution(board);
    return true;
  }

  bool solution(List<List<int>> board, int col, int n) {
    if (col >= n) {
      return true;
    }

    for (int i = 0; i < n; i++) {
      if (isOk(board, i, col, n)) {
        board[i][col] = 1;
        if (solution(board, col + 1, n)) //Go for the other columns recursively
        {
          return true;
        }
        board[i][col] = 0;
      }
    }
    return false;
  }

  bool isOk(List<List<int>> board, int row, int col, int n) {
    for (int i = 0; i < col; i++) {
      if (board[row][i] == 1) {
        return false;
      }
    }

    for (int i = row, j = col; i >= 0 && j >= 0; i--, j--) {
      if (board[i][j] == 1) {
        return false; //check whether there is queen in the left upper diagonal or not
      }
    }
    for (int i = row, j = col; j >= 0 && i < n; i++, j--) {
      if (board[i][j] == 1) {
        return false; //check whether there is queen in the left lower diagonal or not
      }
    }
    return true;
  }

  findSolution(List<List<int>> board) {
    solutions.add(board);
  }
}
