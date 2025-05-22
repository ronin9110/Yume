import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yume/Screens/Music%20Player/music_player.dart';
import 'package:yume/Utlities/Auth/user_provider.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Online/songs_provider_yt.dart';
import 'package:yume/Screens/Before%20Login%20Pages/login_page.dart';
import 'package:yume/Screens/Before%20Login%20Pages/recovery_pass_page.dart';
import 'package:yume/Screens/Before%20Login%20Pages/signin_page.dart';
import 'package:yume/Screens/Music%20Room/create_room.dart';
import 'package:yume/Screens/Music%20Room/music_room_search_page.dart';
import 'package:yume/Screens/Music%20Room/music_room_page.dart';
import 'package:yume/Utlities/mainNavBar.dart';
import 'package:yume/Screens/profile_page.dart';
import 'package:yume/Screens/settings_page.dart';
import 'package:yume/Screens/Before%20Login%20Pages/welcome_page.dart';
import 'Utlities/Auth/firebase_options.dart';
import 'package:yume/Theme/theme_provider.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/Local%20Storage/songs_provider.dart';
import 'package:yume/Utlities/Music%20Player%20Comp/Services/song_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

SongHandler _songHandler = SongHandler();

Future<void> main() async {
  
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(dotenv.env["CLIENT_ID"]);
  _songHandler = await AudioService.init(
    builder: () => SongHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.dum.app',
      androidNotificationChannelName: 'Yume',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SongsProvider()..loadSongs(_songHandler, 'local'),
        ),
        ChangeNotifierProvider(
          create: (context) => SongsProviderYT()..loadSongs(_songHandler),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? light, ColorScheme? dark) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).themeData,
          home: Scaffold(
            body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MainNavBar(songHandler: _songHandler);
                }
                return WelcomePage();
              },
            ),
          ),
          routes: {
            LogInPage.routeName: (context) => const LogInPage(),
            SignInPage.routeName: (context) => const SignInPage(),
            RecoveryPass.routeName: (context) => const RecoveryPass(),
            SettingsPage.routeName: (context) => const SettingsPage(),
            ProfilePage.routeName: (context) => const ProfilePage(),
            WelcomePage.routeName: (context) => const WelcomePage(),
            CreateRoom.routeName: (context) =>
                CreateRoom(songHandler: _songHandler),
            LocalVoiceRoom.routeName: (context) =>
                LocalVoiceRoom(songHandler: _songHandler),
            VoiceroomSearchPage.routeName: (context) =>
                VoiceroomSearchPage(songHandler: _songHandler),
            MainNavBar.routeName: (context) =>
                MainNavBar(songHandler: _songHandler),
            MusicPlayer.routeName: (context) => MusicPlayer(
                songHandler: _songHandler,
                isLast: false,
                onTap: () {},
                playlist: "")
          },
        );
      },
    );
  }
}
