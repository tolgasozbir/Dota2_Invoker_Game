import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/app_scaffold.dart';
import 'achievement_manager.dart';
import 'widgets/achievement_widget.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: false,
      appbar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.achievements),
      ),
      body: _bodyView()
    );
  }

  Widget _bodyView() {
    AchievementManager.instance.initAchievements();
    var achievements = AchievementManager.instance.achievements;
    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: achievements.length,
        itemBuilder: (BuildContext context, int index) {
          var achievement = achievements[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 1200),
            child: SlideAnimation(
              horizontalOffset: 300,//index.isEven ? 300 : -300,
                child: FadeInAnimation(
                  child: AchievementWidget(achievement: achievement),
                ),
            ),
          );
        },
      ),
    );
  }
}
