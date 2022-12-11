import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.pink[500],
            body: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/info-logo.png', width: 300, height: 300),
                const SizedBox(width: double.infinity, height: 20),
                Hero(
                  tag: 'loginButton',
                  child: TextButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        foregroundColor: Colors.white),
                    onPressed: controller.isLoading
                        ? null
                        : controller.checkHomeserverAction,
                    child: controller.isLoading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context)!.welcomeMessage),
                  ),
                )
              ],
            ))));
  }
}
