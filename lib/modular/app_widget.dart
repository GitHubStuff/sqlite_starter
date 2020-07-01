
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mode_theme/mode_theme.dart';
import 'package:sqlite_developer/sqlite_developer.dart';
import 'package:sqlite_controller/sqlite_controller.dart' as SQL;

import '../modules/initial_screen.dart';
import 'logging_bloc_delegate.dart';
import '../resources/constants.dart' as Constants;
import '../resources/app_localizations.dart';
import '../bloc_providers/bloc/initial_bloc.dart';

class AppWidget extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (!Foundation.kReleaseMode) {
      BlocSupervisor.delegate = LoggingBlocDelegate();
    }
    return _blocProviders(context);
  }

  Widget _blocProviders(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InitialBloc>(create: (context) {
          final servicesBloc = Modular.get<InitialBloc>();
          return servicesBloc;
        }),
      ],
      child: _modeTheme(context),
    );
  }

  ModeTheme _modeTheme(BuildContext context) {
    return ModeTheme(
      themeDataFunction: (brightness) {
        textColorDarkMode[TextKeys.caption] = Colors.yellowAccent;
        ModeDefiniation.buttonModeColor = ModeColor(
          light: Colors.lightBlueAccent,
          dark: Colors.blueGrey,
        );
        ModeDefiniation.primaryModeColor = ModeColor(
          light: Colors.blueAccent,
          dark: Colors.grey,
        );
        return (brightness == Brightness.light) ? ModeTheme.light : ModeTheme.dark;
      },
      defaultBrightness: Brightness.dark,
      themedWidgetBuilder: (context, theme) {
        return _materialApp(context, theme);
      },
    );
  }

  Widget _materialApp(BuildContext context, ThemeData themeData) {
    return MaterialApp(
      home: SqliteScreenWidget(
            childWidget: InitialScreen(),
            sqliteIdentity: SQL.SQLiteIdentity(databaseName: 'flutter_sqlite_developer.db'),
            enabled: true,
          ),
      title: 'FHCP',
      theme: themeData,
      initialRoute: Constants.initalRoute,
      onGenerateRoute: Modular.generateRoute,
      navigatorKey: Modular.navigatorKey,
      supportedLocales: [
        Locale('en'),
        Locale('es'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
