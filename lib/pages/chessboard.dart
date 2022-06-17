import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:eight_queens_puzzle/components/dialog.dart';
import 'package:eight_queens_puzzle/utils/app_colors.dart';
import 'package:eight_queens_puzzle/utils/generate_random_solution.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Chessboard extends StatefulWidget {
  final numberOfQueens = 8;

  const Chessboard({Key? key}) : super(key: key);

  @override
  State<Chessboard> createState() => _ChessboardState();
}

class _ChessboardState extends State<Chessboard> {
  bool isSnackBarActive = false;
  int queensOnBoard = 0;
  int numberOfHelpButtonPressed = 0;
  int numberOfSolution = 0;
  List solutions = [];
  List board = [
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
  ];

  GenerateRandomSolution generateRandomSolution = GenerateRandomSolution();

  @override
  void initState() {
    solutions = generateRandomSolution.start(widget.numberOfQueens);
    numberOfSolution = solutions.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return (width >= 600)
        ? _buildHorizontalContent(height)
        : _buildVerticalContent(width);
  }

  Widget _buildHorizontalContent(double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
            width: 0.4 * height,
            height: 0.8 * height,
            child: _buildQueenHorizontal()),
        SizedBox(
            width: 0.8 * height,
            height: 0.8 * height,
            child: _buildChessboard()),
        _buildActionButtonsVertically(),
      ],
    );
  }

  Widget _buildVerticalContent(double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 0.85 * width,
          height: 0.4 * width,
          child: _buildQueenVertical(),
        ),
        SizedBox(
          width: 0.85 * width,
          height: 0.85 * width,
          child: _buildChessboard(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
          child: _buildActionButtonsHorizontally(),
        ),
      ],
    );
  }

  Widget _buildQueenHorizontal() {
    var n = widget.numberOfQueens;
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: n ~/ 4),
      itemCount: n,
      itemBuilder: _buildQueen,
    );
  }

  Widget _buildQueenVertical() {
    var n = widget.numberOfQueens;
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: n ~/ 2),
      itemCount: n,
      itemBuilder: _buildQueen,
    );
  }

  Widget _buildChessboard() {
    int n = widget.numberOfQueens;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.darkGrey, width: 5.0),
          borderRadius: BorderRadius.circular(10.0)),
      child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: n),
          itemCount: n * n,
          itemBuilder: _buildBoardItem),
    );
  }

  Widget _buildActionButtonsVertically() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
            onPressed: _resetPuzzlePressed,
            tooltip: 'reset'.tr(),
            icon: const Icon(Icons.refresh)),
        const SizedBox(height: 20.0),
        _buildActionButton(
            onPressed: _solvePuzzlePressed,
            tooltip: 'reset_with_help'.tr(),
            icon: const Icon(Icons.plus_one)),
        const SizedBox(height: 20.0),
        _buildActionButton(
            onPressed: _helpPressed,
            tooltip: 'help'.tr(),
            icon: const Icon(Icons.question_mark)),
        const SizedBox(height: 20.0),
        _buildActionButton(
            onPressed: _goToSourcePressed,
            tooltip: 'source_code'.tr(),
            icon: const Icon(Icons.source_outlined)),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildActionButtonsHorizontally() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
            onPressed: _resetPuzzlePressed,
            tooltip: 'reset'.tr(),
            icon: const Icon(Icons.refresh)),
        const SizedBox(height: 20.0),
        _buildActionButton(
            onPressed: _solvePuzzlePressed,
            tooltip: 'reset_with_help'.tr(),
            icon: const Icon(Icons.plus_one)),
        const SizedBox(height: 20.0),
        _buildActionButton(
            onPressed: _helpPressed,
            tooltip: 'help'.tr(),
            icon: const Icon(Icons.question_mark)),
        const SizedBox(height: 20.0),
        _buildActionButton(
            onPressed: _goToSourcePressed,
            tooltip: 'source_code'.tr(),
            icon: const Icon(Icons.source_outlined)),
      ],
    );
  }

  Widget _buildQueen(BuildContext context, int index) {
    Color color = (widget.numberOfQueens - queensOnBoard > index)
        ? AppColors.darkGrey
        : AppColors.lightGrey;
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: SvgPicture.asset(
        'assets/icons/queen.svg',
        color: color,
      ),
    );
  }

  Widget _buildBoardItem(BuildContext context, int index) {
    int row = index ~/ board.length;
    int column = index % board.length;
    return GestureDetector(
      onTap: () => _chessBoardItemPressed(row, column),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.darkGrey),
        ),
        child: MouseRegion(
          cursor: MaterialStateMouseCursor.clickable,
          child: _buildItem(row, column),
        ),
      ),
    );
  }

  Widget _buildItem(int row, int column) {
    switch (board[row][column]) {
      case 'E': // Queen with threaten
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: SvgPicture.asset(
            'assets/icons/queen.svg',
            color: AppColors.error,
          ),
        );

      case 'Q': // Queen
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: SvgPicture.asset('assets/icons/queen.svg',
              color: AppColors.darkGrey),
        );

      default: // Empty
        return Container(
          color: ((row % 2 == 0 && column % 2 == 0) ||
                  (row % 2 != 0 && column % 2 != 0))
              ? AppColors.grey
              : AppColors.white,
        );
    }
  }

  Widget _buildActionButton(
      {required String tooltip,
      required Function() onPressed,
      required Icon icon}) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: icon,
    );
  }

  void _chessBoardItemPressed(int row, int column) {
    int n = widget.numberOfQueens;
    if (queensOnBoard >= n &&
        board[row][column] != 'E' &&
        board[row][column] != 'Q') return;
    if (board[row][column] != 'Q' && board[row][column] != 'E') {
      if (kDebugMode) {
        print("Queen: [$row, $column];");
      }

      board[row][column] = (board[row][column] == 'X') ? 'E' : 'Q';

      queensOnBoard++;
      findThreaten(row, column);
    } else {
      numberOfHelpButtonPressed = 0;
      board[row][column] = '';
      queensOnBoard--;
      setState(() {});
      clearThreaten();
    }

    if (queensOnBoard == n && !board.any((element) => element.contains('E'))) {
      showYouWin();
    }
    setState(() {});
  }

  void findThreaten(int row, int column) {
    int i = row - 1, j = column + 1;
    int n = widget.numberOfQueens;
    while (i >= 0 && j < n) {
      board[i][j] = (board[i][j] == 'Q' || board[i][j] == 'E') ? 'E' : 'X';
      i--;
      j++;
    }
    i = row + 1;
    j = column - 1;
    while (i < n && j >= 0) {
      board[i][j] = (board[i][j] == 'Q' || board[i][j] == 'E') ? 'E' : 'X';
      i++;
      j--;
    }

    i = row + 1;
    j = column + 1;
    while (i < 8 && j < 8) {
      board[i][j] = (board[i][j] == 'Q' || board[i][j] == 'E') ? 'E' : 'X';
      i++;
      j++;
    }

    i = row - 1;
    j = column - 1;
    while (i >= 0 && j >= 0) {
      board[i][j] = (board[i][j] == 'Q' || board[i][j] == 'E') ? 'E' : 'X';
      i--;
      j--;
    }

    for (i = 0; i < n; i++) {
      if (i != column) {
        board[row][i] =
            (board[row][i] == 'Q' || board[row][i] == 'E') ? 'E' : 'X';
      }

      if (i != row) {
        board[i][column] =
            (board[i][column] == 'Q' || board[i][column] == 'E') ? 'E' : 'X';
      }
    }
    setState(() {});
  }

  void clearThreaten() {
    int n = widget.numberOfQueens;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        board[i][j] = (board[i][j] == 'X' || board[i][j] == '') ? '' : 'Q';
      }
    }

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (board[i][j] == 'Q' || board[i][j] == 'E') {
          findThreaten(i, j);
        }
      }
    }
    setState(() {});
  }

  void _resetPuzzlePressed() {
    int n = widget.numberOfQueens;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        board[i][j] = '';
      }
    }
    queensOnBoard = 0;
    numberOfHelpButtonPressed = 0;
    setState(() {});
  }

  void _solvePuzzlePressed() {
    numberOfHelpButtonPressed++;

    List<List<int>> chessboard = [];
    int n = widget.numberOfQueens;

    if (numberOfHelpButtonPressed > n) numberOfHelpButtonPressed = 0;

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        board[i][j] = '';
      }
    }
    queensOnBoard = 0;

    var rng = Random();
    chessboard = solutions[rng.nextInt(numberOfSolution)];
    for (int i = 0;
        i < numberOfHelpButtonPressed && numberOfHelpButtonPressed <= n;
        i++) {
      for (int j = 0; j < n; j++) {
        if (chessboard[i][j] == 1) {
          board[i][j] = 'Q';
          queensOnBoard++;
          findThreaten(i, j);
          if (numberOfHelpButtonPressed == n) showYouWin();
        }
      }
    }
    setState(() {});
  }

  void _helpPressed() {
    showDialog(
        context: context, builder: (context) => buildHelpDialog(context));
  }

  void _goToSourcePressed() async{
    Uri url = Uri.parse('https://github.com/karimi1064?tab=repositories');
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'could_not_launch_this_app'.tr();
  }

  void showYouWin() {
    if (!isSnackBarActive) {
      isSnackBarActive = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text('you_win'.tr(), textAlign: TextAlign.center)),
        backgroundColor: AppColors.darkGrey,
      ))
          .closed
          .then((SnackBarClosedReason reason) {
        isSnackBarActive = false;
      });
    }
  }
}
