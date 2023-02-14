import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';
import '../providers/game_provider.dart';
import '../screens/dashboard/loading_view.dart';
import '../services/sound_manager.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    required this.fadeInDuration,
    required this.color,
    required this.imagePath,
    required this.title,
    required this.navigatePage,
    this.primaryColor,
    this.isBtnExit = false,
    super.key, 
  }) : assert(isBtnExit == false);

  const MenuButton.exit({
    super.key, 
    required this.fadeInDuration, 
    required this.color, 
    this.primaryColor, 
    required this.imagePath, 
    required this.title, 
    this.navigatePage,
    this.isBtnExit = true,
  }) : assert(navigatePage == null), assert(isBtnExit == true);

  final Duration fadeInDuration;
  final Color color;
  final Color? primaryColor;
  final String imagePath;
  final String title;
  final Widget? navigatePage;
  final bool isBtnExit;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with SingleTickerProviderStateMixin {
  double _fadeInOpacity=0;
  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    _init();
    if (widget.isBtnExit) {
      controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 4000));
      animation = CurvedAnimation(parent: controller!, curve: Curves.linear);
      controller!.repeat();
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 400), (){
      setState(() => _fadeInOpacity = 1 );
    });
  }

  void _closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  void _goToGameScreen() {
    if (widget.navigatePage == null) return;
    SoundManager.instance.playSoundBegining();
    context.read<GameProvider>().resetTimer();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoadingView(page: widget.navigatePage!)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AnimatedOpacity(
        opacity: _fadeInOpacity, 
        duration: widget.fadeInDuration,
        child: button(context),
      ),
    );
  }

  SizedBox button(BuildContext context) {

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: widget.primaryColor ?? AppColors.buttonSurfaceColor,
      elevation: 10,
      shadowColor: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: widget.color),
      ),
    );

    return SizedBox(
      width: context.dynamicWidth(0.8),
      child:  ElevatedButton(
        style: buttonStyle,
        onPressed: widget.isBtnExit ? _closeApp : _goToGameScreen,
        child: buttonSurface(context),
      ),
    );
  }

  Row buttonSurface(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.isBtnExit) 
          RotationTransition(
            turns: animation!, 
            child: circleImage(context, BoxFit.contain),
          ) 
        else 
          circleImage(context, BoxFit.cover),
        Text(
          '${widget.title}  ',
          style: TextStyle(fontSize: context.sp(16)),
        ),
      ],
    );
  }

  Container circleImage(BuildContext context, BoxFit? fit) {
    return Container(
      height: context.dynamicHeight(0.1),
      width: context.dynamicWidth(0.12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(widget.imagePath),
        fit: fit,
        ),
      ),
    );
  }
}
