import 'package:dota2_invoker_game/constants/locale_keys.g.dart';
import 'package:dota2_invoker_game/enums/local_storage_keys.dart';
import 'package:dota2_invoker_game/extensions/context_extension.dart';
import 'package:dota2_invoker_game/extensions/string_extension.dart';
import 'package:dota2_invoker_game/providers/app_context_provider.dart';
import 'package:dota2_invoker_game/services/app_services.dart';
import 'package:dota2_invoker_game/utils/app_updater.dart';
import 'package:dota2_invoker_game/widgets/app_dialogs.dart';
import 'package:dota2_invoker_game/widgets/dialog_contents/app_update_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tuple/tuple.dart';
import 'package:user_messaging_platform/user_messaging_platform.dart';

import 'combo/combo_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_paths.dart';
import '../../constants/app_strings.dart';
import '../../enums/elements.dart';
import '../../extensions/widget_extension.dart';
import '../../services/user_manager.dart';
import '../../utils/ads_helper.dart';
import '../../widgets/menu_button.dart';
import '../../widgets/settings_button.dart';
import '../../widgets/talent_tree.dart';
import '../../widgets/user_info.dart';
import 'boss_mode/boss_mode_view.dart';
import 'challanger/challanger_view.dart';
import 'training/training_view.dart';
import 'time_trial/time_trial_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  //iOS installation was not performed.
  void updateConsent() async {
    // Make sure to continue with the latest consent info.
    var info = await UserMessagingPlatform.instance.requestConsentInfoUpdate();
    // Show the consent form if consent is required.
    if (info.consentStatus == ConsentStatus.required) {
      // `showConsentForm` returns the latest consent info, after the consent from has been closed.
      info = await UserMessagingPlatform.instance.showConsentForm();
    }
  }

  void updateApp() {
    //item1 hasUpdate
    //item2 forceUpdate
    final Tuple2<bool, bool> hasUpdate = AppUpdater.instance.checkUpdate();
    if (hasUpdate.item1) {
      showUpdateDialog(hasUpdate.item2);
    }
  }

  void showUpdateDialog(bool forceUpdate) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppUpdateDialog(forceUpdate: forceUpdate),
    ); 
  }

  void showInfoMessage() {
    final bool showInfoMessage = AppServices.instance.localStorageService.getValue<bool>(LocalStorageKey.showInfoMessageV142) ?? true;
    if (showInfoMessage) {
      AppDialogs.showScaleDialog(
        content: Text(LocaleKeys.InfoMessages_patchMessage.locale),
        action: OutlinedButton(
          onPressed: () async {
            await AppServices.instance.localStorageService.setValue<bool>(LocalStorageKey.showInfoMessageV142, false);
            if (mounted) Navigator.pop(context);
          },
          child: Text(LocaleKeys.commonGeneral_close.locale),
        ),
      );
    }
  }

  void init() async {
    Future.microtask(() {
      context.read<AppContextProvider>().setAppContext(context);
      updateConsent();
      updateApp();
      showInfoMessage();
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _bodyView(context),
      bottomNavigationBar: const AdBanner(),
    );
  }

  Widget _bodyView(BuildContext context) {
    final user = context.watch<UserManager>().user;
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          children: [
            Row(
              children: [
                UserStatus(user: user).wrapAlign(Alignment.topLeft).wrapExpanded(flex: 2),
                TalentTree(user: user).wrapExpanded(),
                const SettingsButton().wrapAlign(Alignment.topRight).wrapExpanded(),
              ],
            ).wrapExpanded(flex: 3),

            ...menuBtns.animate(interval: 200.ms, delay: 600.ms)
              .fadeIn(curve: Curves.easeOutExpo, duration: 1000.ms)
              .blurXY(begin: 32, duration: 1000.ms)
              .slideX(begin: -0.4, duration: 1000.ms)
              .shimmer(duration: 2400.ms)
              .then(delay: 1000.ms)
              .animate(onPlay: (controller) => controller.repeat(), interval: 200.ms)
              .shimmer(size: 0.5, duration: 1000.ms, delay: 5000.ms),
              
            if (!context.isSmallPhone) const Spacer(),
            SizedBox(
              width: double.infinity,
              child: const Text(AppStrings.appVersionStr).wrapPadding(EdgeInsets.all(context.isSmallPhone ? 4 : 8)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get menuBtns => [
    MenuButton( 
      color: AppColors.quasColor,
      imagePath: ImagePaths.quas,
      title: LocaleKeys.mainMenu_titleTraining.locale,
      navigatePage: const TrainingView(),
    ),
    MenuButton(
      color: AppColors.wexColor,
      imagePath: ImagePaths.wex,
      title: LocaleKeys.mainMenu_titleWithTimer.locale,
      navigatePage: const TimeTrialView(),
    ),
    MenuButton(
      color: AppColors.exortColor,
      imagePath: ImagePaths.exort,
      title: LocaleKeys.mainMenu_titleChallenger.locale,
      navigatePage: const ChallangerView(),
    ),
    MenuButton(
      color: AppColors.comboBtnColor,
      imagePath: ImagePaths.icCombo,
      title: LocaleKeys.mainMenu_titleCombo.locale,
      navigatePage: const ComboView(),
    ),
    MenuButton(
      color: AppColors.white,
      imagePath: Elements.invoke.getImage,
      title: LocaleKeys.mainMenu_titleBossMode.locale,
      bannerTitle: 'Beta',
      animType: AnimType.Rotation,
      fit: BoxFit.contain,
      navigatePage: const BossModeView(),
    ),
  ];
}
