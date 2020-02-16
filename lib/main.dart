import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n/i18n.dart';
import 'views/sign_up.dart';
import 'components/ThemeSwitcher.dart';
import 'components/matrix.dart';
import 'views/chat_list.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Matrix(
      clientName: "FluffyChat",
      child: Builder(
        builder: (BuildContext context) => ThemeSwitcherWidget(
          child: Builder(
            builder: (BuildContext context) => MaterialApp(
              title: 'FluffyChat',
              theme: ThemeSwitcherWidget.of(context).themeData,
              localizationsDelegates: [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en'), // English
                const Locale('de'), // German
              ],
              home: FutureBuilder<LoginState>(
                future:
                    Matrix.of(context).client.onLoginStateChanged.stream.first,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (Matrix.of(context).client.isLogged()) {
                    return ChatListView();
                  }
                  return SignUp();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
