import 'package:dota2_invoker_game/utils/formatted_date.dart';
import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../constants/app_strings.dart';
import '../enums/local_storage_keys.dart';
import '../models/boss_battle_result.dart';
import '../models/user_model.dart';
import '../screens/profile/achievements/achievement_manager.dart';
import '../services/app_services.dart';
import '../utils/id_generator.dart';
import '../widgets/game_ui_widget.dart';

class UserManager extends ChangeNotifier {
  UserManager._();
  static UserManager? _instance;
  static UserManager get instance => _instance ??= UserManager._();

  final snappableKey = GlobalKey<SnappableState>();

  late UserModel? _userModel;
  UserModel get user => _userModel!;

  void setUser(UserModel user){
    user.lastPlayed = getFormattedDate;
    _userModel = user;
  }

  bool isLoggedIn() {
    final user = AppServices.instance.firebaseAuthService.currentUser;
    return user == null ? false : true;
  }

  UserModel createUser() {
    final guest = UserModel.guest(username: AppStrings.guest+idGenerator());
    return guest;
  }

  String? getUserFromLocal() {
    return AppServices.instance.localStorageService.getValue<String>(LocalStorageKey.userRecords);
  }

  Future<UserModel?> getUserFromDb(String uid) async {
    return AppServices.instance.databaseService.getUserRecords(uid);
  }

  Future<void> setAndSaveUserToLocale(UserModel user) async {
    await AppServices.instance.localStorageService.setValue<String>(
      LocalStorageKey.userRecords, 
      user.toJson(),
    );
    setUser(user);
    notifyListeners();
  }

  Future<UserModel> fetchOrCreateUser() async {
    final localData = getUserFromLocal();
    if (localData != null) {
      setUser(UserModel.fromJson(localData));
      return user;
    } 
    else {
      //create new userModel and save to locale
      final createdUser = createUser();
      await setAndSaveUserToLocale(createdUser);
      //I can't change the initial const values (achievement & talentTree) ​​so I create the User model from scratch
      final savedUser = UserModel.fromJson(getUserFromLocal()!);
      await setAndSaveUserToLocale(savedUser);
      return savedUser;
    }
  }

  Map<String, dynamic> getBestBossScore(String bossName) {
    return user.bestBossScores?[bossName] as Map<String, dynamic>? ?? {};
  }

  void updateBestBossTimeScore(String bossName, int value, BossBattleResult model) async {
    user.bestBossScores ??= {}; // null check
    user.bestBossScores?.putIfAbsent(bossName, () => model.toMap());
    if (isLoggedIn() && user.bestBossScores![bossName]['name'].toString().startsWith('Guest')) {
      user.bestBossScores![bossName]['name'] = user.username;
    }
    if ((user.bestBossScores?[bossName]['time'] as int? ?? 0) < value) return;
    if (user.bestBossScores!.containsKey(bossName)) {
      user.bestBossScores?[bossName] = model.toMap();
    }
    await setAndSaveUserToLocale(user);
  }

  int getBestScore(GameType gameType) {
    switch (gameType) {
      case GameType.Training: return 0;
      case GameType.Challanger: return user.bestChallengerScore;
      case GameType.Timer: return user.bestTimerScore;
      case GameType.Combo: return user.bestComboScore;
    }
  }  
  
  void setBestScore(GameType gameType, int score) async {
    if (getBestScore(gameType) >= score) return;
    switch (gameType) {
      case GameType.Training: break;
      case GameType.Challanger: 
        user.bestChallengerScore = score;
        break;
      case GameType.Timer:
        user.bestTimerScore = score;
        break;
      case GameType.Combo:
        user.bestComboScore = score;
        break;
    }
    await setAndSaveUserToLocale(user);
  }

  ///Game System

  //Level System
  double get getNextLevelExp => user.level * 25;
  double get _getCurrentExp   => user.exp;
  double get _expMultiplier   => user.expMultiplier;
  double expCalc(int exp) => exp * _expMultiplier;
  final int _maxLevel = 30;

  void addExp(int exp) async {
    final currExp = _getCurrentExp + expCalc(exp);
    _levelUp(currExp);
    await setAndSaveUserToLocale(user);
  }

  void _levelUp(double exp) {
    if (user.level == _maxLevel) return;
    
    var currExp = exp;
    while (currExp >= getNextLevelExp) {
      currExp -= getNextLevelExp;
      user.level++;
      enableTalents();
      if (user.level >= _maxLevel) {
        user.level = _maxLevel;
        user.exp = getNextLevelExp;
        return;
      }
    }
    AchievementManager.instance.updateLevel();
    user.exp = currExp;
  }

  //Talent Tree
  final _treeLevels = const [10, 15, 20, 25];
  List<int> get treeLevels => _treeLevels;

  void enableTalents() {
    final level = user.level;

    //Return true if user level is in skill tree level array and talent is not active
    user.talentTree ??= {};
    if (!treeLevels.contains(level)) return;
    user.talentTree?.putIfAbsent(level.toString(), () => false);
    if (user.talentTree?['$level'] == true) return;

    switch (level) {
      case 10: break; ///[maxMana += UserManager.instance.user.level >= 10 ? 400] in BossProvider
      case 15: user.challangerLife = 1; break;
      case 20: user.expMultiplier += 2; break;
      case 25: break; ///[baseDamage *= (UserManager.instance.user.level >= 30 ? 2 : 1)] in BossProvider
      default: break;
    }
    
    //active current talent
    user.talentTree?['$level'] = true;
  }

  //Sync Data
  DateTime lastSyncedDate = DateTime.now().subtract(const Duration(minutes: 5));
  final waitSyncDuration = const Duration(minutes: 5);
  void updateSyncedDate () {
    lastSyncedDate = DateTime.now();
  }

}
