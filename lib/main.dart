import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:starter/routes/routes.dart';
import 'package:starter/themes/themes.dart';
import 'bloc/settings/settings_cubit.dart';
import 'bloc/settings/settings_state.dart';
import 'localizations/localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConnectivityResult _connectivityResult;
  late bool _connect;

  @override
  void initState() {
    super.initState();
    _connect = true;

    _checkConnectivity();

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
        _connect = result != ConnectivityResult.none;
      });
    });
  }

  // Bağlantıyı kontrol eden yardımcı metot
  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
      _connect = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(SettingsState()),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Starter',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLanguages
                .map((e) => Locale(e, ""))
                .toList(),
            locale: Locale(state.language, ""),
            themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            routerConfig: routes,
            builder: (context, router) {
              return WillPopScope(
                onWillPop: () async => !_connect,
                child: Stack(
                  children: [
                    router!,
                    if (!_connect)
                      AlertDialog(
                        title: Text('Bağlantı Hatası'),
                        content: Text(
                            'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.'),
                        actions: [
                          TextButton(
                            child: Text('Kapat'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
