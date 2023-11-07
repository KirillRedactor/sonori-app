import 'package:get_it/get_it.dart';
import 'package:musicplayer_app/classes/firebaseclass.dart';
import 'package:musicplayer_app/classes/music_player_class.dart';
import 'package:musicplayer_app/classes/settings_class.dart';

MusicPlayerClass get mpc => GetIt.I<MusicPlayerClass>();
FirabaseClass get fc => GetIt.I<FirabaseClass>();
SettingsClass get settings => GetIt.I<SettingsClass>();
