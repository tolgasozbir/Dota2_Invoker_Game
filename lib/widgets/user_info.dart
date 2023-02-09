import 'package:dota2_invoker/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';

class UserStatus extends StatelessWidget {
  UserStatus({Key? key}) : super(key: key);

  final boxDecoration = BoxDecoration(
    color: AppColors.buttonSurfaceColor,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(
      color: Colors.black,
      width: 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          margin: EdgeInsets.all(8.0),
          decoration: boxDecoration,
          child: Icon(
            FontAwesomeIcons.userSecret, 
            shadows: [
              Shadow(
                color: Colors.black, 
                blurRadius: 32
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Guest"),
            SliderTheme(
              child: Slider(
                value: 32,
                max: 100,
                min: 0,
                onChanged: (double value) {},
              ),
              data: SliderTheme.of(context).copyWith(
                thumbShape: SliderComponentShape.noThumb,
                overlayShape: SliderComponentShape.noThumb,
                activeTrackColor: AppColors.expBarColor,
                inactiveTrackColor: AppColors.expBarColor.withOpacity(0.5),
              ),
            ).wrapPadding(EdgeInsets.symmetric(vertical: 8)),
            Row(
              children: [
                Text("Level 1"),
                Spacer(),
                Text("25/100")
              ],
            )
          ],
        ).wrapPadding(EdgeInsets.only(top: 8)).wrapExpanded(),
      ],
    );
  }
}