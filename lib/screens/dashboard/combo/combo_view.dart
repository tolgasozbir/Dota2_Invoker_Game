import 'package:flutter/material.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/dialog_contents/leaderboard_dialog.dart';
import '../../../widgets/game_ui_widget.dart';
import '../../../widgets/show_leaderboard_button.dart';

class ComboView extends StatefulWidget {
  const ComboView({super.key});

  @override
  State<ComboView> createState() => _ComboViewState();
}

class _ComboViewState extends State<ComboView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(
        resizeToAvoidBottomInset: false,
        body: _bodyView(),
      ),
    );
  }
  
  Widget _bodyView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const GameUIWidget(gameType: GameType.Combo),
          ShowLeaderBoardButton(
            title: AppStrings.leaderboard, 
            contentDialog: LeaderboardDialog(leaderboardType: LeaderboardType.Combo),
          ),
        ],
      ),
    );
  }

}
