import '../models/exit_dialog_message.dart';
import 'locale_keys.g.dart';

class AppStrings {
  const AppStrings._();
  
  static const String appName = 'Invoker Challenge';
  static const String appVersion = 'Beta 1.3.1';
  static const String googlePlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.dota2.invoker.game';
  
  static const List<ExitDialogMessage> exitMessages = [
    ExitDialogMessage(
      title: LocaleKeys.exitGameDialogMessages_title1, 
      body: LocaleKeys.exitGameDialogMessages_body1, 
      word: LocaleKeys.exitGameDialogMessages_word1, 
      yes: LocaleKeys.exitGameDialogMessages_yes1, 
      no: LocaleKeys.exitGameDialogMessages_no1,
    ),
    ExitDialogMessage(
      title: LocaleKeys.exitGameDialogMessages_title2, 
      body: LocaleKeys.exitGameDialogMessages_body2, 
      word: LocaleKeys.exitGameDialogMessages_word2, 
      yes: LocaleKeys.exitGameDialogMessages_yes2, 
      no: LocaleKeys.exitGameDialogMessages_no2,
    ),
    ExitDialogMessage(
      title: LocaleKeys.exitGameDialogMessages_title3, 
      body: LocaleKeys.exitGameDialogMessages_body3, 
      word: LocaleKeys.exitGameDialogMessages_word3, 
      yes: LocaleKeys.exitGameDialogMessages_yes3, 
      no: LocaleKeys.exitGameDialogMessages_no3,
    ),
    ExitDialogMessage(
      title: LocaleKeys.exitGameDialogMessages_title4, 
      body: LocaleKeys.exitGameDialogMessages_body4, 
      word: LocaleKeys.exitGameDialogMessages_word4, 
      yes: LocaleKeys.exitGameDialogMessages_yes4, 
      no: LocaleKeys.exitGameDialogMessages_no4,
    ),
    ExitDialogMessage(
      title: LocaleKeys.exitGameDialogMessages_title5, 
      body: LocaleKeys.exitGameDialogMessages_body5, 
      word: LocaleKeys.exitGameDialogMessages_word5, 
      yes: LocaleKeys.exitGameDialogMessages_yes5, 
      no: LocaleKeys.exitGameDialogMessages_no5,
    ),
  ];

}
