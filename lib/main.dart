import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';

import 'components/matrix.dart';
import 'views/chat_list.dart';
import 'views/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Matrix(
      clientName: "FluffyWeb",
      child: MaterialApp(
        title: 'FluffyWeb',
        theme: ThemeData(
          primaryColor: Color(0xFF5625BA),
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          popupMenuTheme: PopupMenuThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 1,
            textTheme: TextTheme(
              title: TextStyle(color: Colors.black),
            ),
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: Builder(
          builder: (BuildContext context) => StreamBuilder<LoginState>(
            stream:
                Matrix.of(context).client.connection.onLoginStateChanged.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              if (Matrix.of(context).client.isLogged()) return ChatListView();
              return LoginPage();
            },
          ),
        ),
      ),
    );
  }
}
