import 'package:easy_localization/easy_localization.dart';
import 'package:eight_queens_puzzle/utils/app_colors.dart';
import 'package:flutter/material.dart';

AlertDialog buildHelpDialog(BuildContext context) {
  return AlertDialog(
      title: Row(children: [
        const Icon(Icons.help),
        const SizedBox(width: 20.0),
        Text('how_to_play'.tr())
      ]),
      content: Text('rules'.tr()),
      actionsPadding: const EdgeInsets.only(right: 10),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.indigo),
                // foregroundColor: MaterialStateProperty.all(Colors.white),
                mouseCursor: MaterialStateMouseCursor.clickable),
            child: Padding(
                padding: const EdgeInsets.all(8.0), child: Text('ok'.tr())))
      ]);
}
