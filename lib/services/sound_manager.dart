import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

import '../constants/app_strings.dart';

class SoundManager {

  static SoundManager? _instance;
  static SoundManager get instance {
    if (_instance != null) {
      return _instance!;
    }
    _instance = SoundManager._();
    return _instance!;
  }

  SoundManager._();

  AudioPlayer? _player;
  final _cache = AudioCache();
  final Random _rnd = Random();

  double _volume = 100;
  double get getVolume => _volume;
  void setVolume(double value) {
    _volume = value;
  }

  void _playSound({required String fileName, double volume = 0.35, bool nonstop = true}) async {
    if (!nonstop) {
      _player?.stop();
    }
    _player = await _cache.play(fileName, volume: volume * getVolume/100);
  }

  void playHorn() {
    var horns = [
      SoundPaths.horn_dire,
      SoundPaths.horn_radiant,
    ];
    var sound = horns[_rnd.nextInt(horns.length)];
    _playSound(fileName: sound);
  }

  void playMeepMerp() {
    _playSound(fileName: SoundPaths.meepMerp);
  }  
  
  void playInvoke() {
    _playSound(fileName: SoundPaths.invoke);
  }

  void playItemSound(String itemName) {
    _playSound(fileName: SoundPaths.itemSounds+"/$itemName.mpeg");
  }

  void playItemBuyingSound() {
    _playSound(fileName: SoundPaths.itemBuying);
  }  
  
  void playItemSellingSound() {
    _playSound(fileName: SoundPaths.itemSelling);
  }
  
  void playWelcomeShopSound() {
    int soundNum = _rnd.nextInt(6) + 1;
    String sound = SoundPaths.shopWelcome+"$soundNum.mpeg";
    _playSound(fileName: sound);
  }  
  
  void playLeaveShopSound() {
    int soundNum = _rnd.nextInt(5) + 1;
    String sound = SoundPaths.shopLeave+"$soundNum.mpeg";
    _playSound(fileName: sound);
  }

  DateTime lastPlayedCdTime = DateTime.now();
  void playAbilityOnCooldownSound() {
    if (!(DateTime.now().difference(lastPlayedCdTime) > Duration(seconds: 1))) return;
    lastPlayedCdTime = DateTime.now();
    int soundNum = _rnd.nextInt(9) + 1;
    String sound = SoundPaths.abilityOnCooldown+"$soundNum.mpeg";
    _playSound(fileName: sound);
  }  
  
  DateTime lastPlayedNoManaTime = DateTime.now();
  void playNoManaSound() {
    if (!(DateTime.now().difference(lastPlayedNoManaTime) > Duration(seconds: 1))) return;
    lastPlayedNoManaTime = DateTime.now();
    int soundNum = _rnd.nextInt(9) + 1;
    String sound = SoundPaths.notEnoughMana+"$soundNum.mpeg";
    _playSound(fileName: sound);
  }

  void playLoadingSound(){
    _playSound(
      fileName: _loadingSound[_rnd.nextInt(_loadingSound.length)], 
      volume: 0.40,
    );
  }

  void failCombinationSound(){
    _playSound(fileName: _failSound[_rnd.nextInt(_failSound.length)],);
  }

  void ggSound(){
    _playSound(fileName: _ggSound[_rnd.nextInt(_ggSound.length)],);
  }

  void trueCombinationSound(String combination){
    switch (combination) {
      case 'qqq': _playSound(fileName: _coldSnapSound[_rnd.nextInt(_coldSnapSound.length)],); break;
      case 'qqw': _playSound(fileName: _ghostWalkSound[_rnd.nextInt(_ghostWalkSound.length)],); break;
      case 'qqe': _playSound(fileName: _iceWallSound[_rnd.nextInt(_iceWallSound.length)],); break;
      case 'www': _playSound(fileName: _emp[_rnd.nextInt(_emp.length)],); break;
      case 'wwq': _playSound(fileName: _tornado[_rnd.nextInt(_tornado.length)],); break;
      case 'wwe': _playSound(fileName: _alacrity[_rnd.nextInt(_alacrity.length)],); break;
      case 'eee': _playSound(fileName: _sunStrike[_rnd.nextInt(_sunStrike.length)],); break;
      case 'eeq': _playSound(fileName: _forgeSpirit[_rnd.nextInt(_forgeSpirit.length)],); break;
      case 'eew': _playSound(fileName: _chaosMeteor[_rnd.nextInt(_chaosMeteor.length)],); break;
      case 'qwe': _playSound(fileName: _blast[_rnd.nextInt(_blast.length)],); break;
      default : failCombinationSound();
    }
  }

  void spellCastTriggerSound(String combination){
    trueCombinationSound(combination);
    switch (combination) {
      case 'qqq': _coldSnapCastAndTrigger(); break;
      case 'qqw': _ghostWalkCast(); break;
      case 'qqe': _iceWallCast(); break;
      case 'www': _empCast(); break;
      case 'wwq': _tornadoCast(); break;
      case 'wwe': _alacrityCast(); break;
      case 'qwe': _deafeningBlastCast(); break;
      case 'eee': _sunStrikeCast(); break;
      case 'eeq': _forgeSpiritCast(); break;
      case 'eew': _chaosMeteorCast(); break;
      default : failCombinationSound();
    }
  }

  void _coldSnapCastAndTrigger() {
    var counter = 0;
    _playSound(volume: 0.15, fileName: SoundPaths.coldSnapCast);
    Timer.periodic(Duration(seconds: 1), (timer) {
      counter++;
      _playSound(volume: (0.15 - ((counter/100)*1.5)), fileName: SoundPaths.coldSnapTrigger);
      if (counter==5) timer.cancel();
    });
  }
  
  void _ghostWalkCast() {
    _playSound(volume: 0.2, fileName: SoundPaths.ghostWalkCast);
  }
  
  void _iceWallCast() {
    _playSound(volume: 0.15, fileName: SoundPaths.iceWallCast);
  }
  
  void _empCast() {
    _playSound(volume: 0.15, fileName: SoundPaths.empCast);
  }
  
  void _tornadoCast() {
    _playSound(volume: 0.2, fileName: SoundPaths.tornadoCast);
  }
  
  void _alacrityCast() {
    _playSound(volume: 0.15, fileName: SoundPaths.alacrityCast);
  }
  
  void _deafeningBlastCast() {
    _playSound(volume: 0.2, fileName: SoundPaths.deafeningBlastCast);
  }
  
  void _sunStrikeCast() {
    _playSound(volume: 0.2, fileName: SoundPaths.sunStrikeCast);
  }
  
  void _forgeSpiritCast() {
    _playSound(volume: 0.2, fileName: SoundPaths.forgeSpiritCast);
  }
  
  void _chaosMeteorCast() {
    _playSound(volume: 0.2, fileName: SoundPaths.chaosMeteorCast);
  }

  //spells
  final List<String> _coldSnapSound=[
    SoundPaths.cold_snap1,
    SoundPaths.cold_snap2,
    SoundPaths.cold_snap3,
  ];

  final List<String> _ghostWalkSound=[
    SoundPaths.ghost_walk1,
    SoundPaths.ghost_walk2,
    SoundPaths.ghost_walk3,
  ];

  final List<String> _iceWallSound=[
    SoundPaths.icewall1,
    SoundPaths.icewall2,
  ];

  final List<String> _emp=[
    SoundPaths.emp1,
    SoundPaths.emp2,
    SoundPaths.emp3,
  ];

  final List<String> _tornado=[
    SoundPaths.tornado1,
    SoundPaths.tornado2,
    SoundPaths.tornado3,
  ];

  final List<String> _alacrity=[
    SoundPaths.alacrity1,
    SoundPaths.alacrity2,
  ];

  final List<String> _sunStrike=[
    SoundPaths.sunstrike1,
    SoundPaths.sunstrike2,
    SoundPaths.sunstrike3,
  ];

  final List<String> _forgeSpirit=[
    SoundPaths.forge_spirit1,
    SoundPaths.forge_spirit2,
  ];

  final List<String> _chaosMeteor=[
    SoundPaths.meteor1,
    SoundPaths.meteor2,
  ];

  final List<String> _blast=[
    SoundPaths.blast1,
    SoundPaths.blast2,
    SoundPaths.blast3,
  ];

  //loading
  final List<String> _loadingSound=[
    SoundPaths.begin1,
    SoundPaths.begin2,
    SoundPaths.begin3,
    SoundPaths.begin4,
    SoundPaths.begin5,
  ];
  //fails
  final List<String> _failSound=[
    SoundPaths.fail1,
    SoundPaths.fail2,
    SoundPaths.fail3,
    SoundPaths.fail4,
    SoundPaths.fail5,
    SoundPaths.fail6,
    SoundPaths.fail7,
  ];
  //gg
  final List<String> _ggSound=[
    SoundPaths.gg1,
    SoundPaths.gg2,
    SoundPaths.gg3,
    SoundPaths.gg4,
  ];
}
