import 'package:dota2_invoker/widgets/game_ui_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/custom_animated_dialog.dart';
import '../../../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_strings.dart';
import '../../../providers/timer_provider.dart';
import '../../../widgets/leaderboard_with_timer.dart';

class WithTimerView extends StatefulWidget {
  const WithTimerView({Key? key}) : super(key: key);

  @override
  State<WithTimerView> createState() => _WithTimerViewState();
}

class _WithTimerViewState extends State<WithTimerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _bodyView(),
    );
  }

  Widget _bodyView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            trueCounter(),
            timerCounter(),
            GameUIWidget(gameType: GameType.Timer),
            showLeaderBoardButton(),
          ],
        ),
      ),
    );
  }

  Widget trueCounter(){
    return Container(
      width: double.infinity,
      height: context.dynamicHeight(0.12),
      child: Center(
        child: Text(
          context.watch<TimerProvider>().getCorrectCombinationCount.toString(),
          style: TextStyle(fontSize: context.sp(36), color: Colors.green,),
        ),
      ),
    );
  }

  Widget timerCounter() {
    var countdownValue = context.watch<TimerProvider>().getCountdownValue;
    return Card(
      color: Color(0xFF303030),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.square(
            dimension: context.dynamicWidth(0.14),
            child: CircularProgressIndicator(
              color: Colors.amber,
              backgroundColor: Colors.blue,
              valueColor: countdownValue <=10 
                ? AlwaysStoppedAnimation<Color>(Colors.red) 
                : AlwaysStoppedAnimation<Color>(Colors.amber),
              value: countdownValue / 60,
              strokeWidth: 4,
            ),
          ),
          Text(countdownValue.toString(), style: TextStyle(fontSize: context.sp(24)),),
        ],
      ),
    );
  }

  Widget showLeaderBoardButton() {
    bool isStart = context.read<TimerProvider>().isStart;
    return !isStart 
      ? CustomButton(
          text: AppStrings.leaderboard, 
          padding: EdgeInsets.only(top: context.dynamicHeight(0.02)),
          onTap: () => CustomAnimatedDialog.showCustomDialog(
            title: AppStrings.leaderboard,
            content: Card(
              color: AppColors.resultCardBg, 
              child: LeaderboardWithTimer(),
            ),
            action: TextButton(
              child: Text(AppStrings.back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
        )
      : SizedBox.shrink();
  }


}