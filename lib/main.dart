import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) =>
      StreamProvider.value(
        initialData: CurrentUser.initial,
        value: FirebaseAuth.instance.onAuthStateChanged
            .map((user) => CurrentUser.create(user)),
        child: Consumer<CurrentUser>(
          builder: (context, user, _) =>
              MaterialApp(
                title: 'Pinfo',
                theme: Theme.of(context).copyWith(
                  brightness: Brightness.light,
                  primaryColor: Colors.white,
                  accentColor: kAccentColorLight,
                  appBarTheme: AppBarTheme.of(context).copyWith(
                    brightness: Brightness.light,
                    iconTheme: IconThemeData(
                      color: kIconTintLight,
                    ),
                  ),
                  scaffoldBackgroundColor: Colors.white,
                  bottomAppBarColor: kBottomAppBarColorLight,
                  primaryTextTheme: Theme
                      .of(context)
                      .primaryTextTheme
                      .copyWith(
                    headline6: const TextStyle(
                      color: kIconTintLight,
                    ),
                  ),
                ),
                home: user.isInitialValue
                    ? Scaffold(
                  body: SizedBox(),
                )
                    : user.data != null ? HomeScreen() : LoginScreen(),
                routes: {'/settings': (_) => SettingsScreen()},
                onGenerateRoute: _generateRoute,
              ),
        ),
      );

  Route _generateRoute(RouteSettings settings) {
    try {
      return _doGenerateRoute(settings);
    } catch (e, s) {
      debugPrint('failed to generate route for $settings: $e $s');
      return null;
    }
  }

  Route _doGenerateRoute(RouteSettings settings) {
    if (settings.name?.isEmpty != true) return null;

    final uri = Uri.parse(settings.name);
    final path = uri.path ?? '';
    switch (path) {
      case '/note':
        {
          final note = (settings.arguments as Map ?? {})['note'];
          return _buildRoute(settings, (_) => NoteEditor(note: note));
        }
      default
        return null;
    }
  }

  Route _buildRoute(RouteSettings settings, WidgetBuilder builder) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: builder,
      );
}
