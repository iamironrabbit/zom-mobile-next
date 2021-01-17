import 'dart:math';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/components/sentry_switch_list_tile.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/localized_exception_extension.dart';

class HomeserverPicker extends StatefulWidget {
  @override
  _HomeserverPickerState createState() => _HomeserverPickerState();
}

class _HomeserverPickerState extends State<HomeserverPicker> {
  final TextEditingController _controller =
      TextEditingController(text: AppConfig.defaultHomeserver);

  bool _isLoading = false;

  void _checkHomeserverAction(BuildContext context) async {
    var homeserver = _controller.text;

    if (!homeserver.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }

    setState(() => _isLoading = true);
    try {
      await Matrix.of(context).client.checkHomeserver(homeserver);
      await AdaptivePageLayout.of(context)
          .pushNamed(AppConfig.enableRegistration ? '/signup' : '/login');
    } catch (e) {
      // ignore: unawaited_futures
      FlushbarHelper.createError(
              title: L10n.of(context).noConnectionToTheServer,
              message: (e as Object).toLocalizedString(context))
          .show(context);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          child: Material(
            color: Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.circular(32),
            child: TextField(
              controller: _controller,
              autocorrect: false,
              readOnly: !AppConfig.allowOtherHomeservers,
              decoration: InputDecoration(
                prefixText: 'https://',
                suffix: Icon(Icons.domain_outlined),
                contentPadding: EdgeInsets.only(
                  left: 24,
                  right: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                labelText: L10n.of(context).changeTheHomeserver,
                hintText: AppConfig.defaultHomeserver,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  max((MediaQuery.of(context).size.width - 600) / 2, 0)),
          child: ListView(
            children: [
              Hero(
                tag: 'loginBanner',
                child: Image.asset('assets/banner.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppConfig.applicationWelcomeMessage ??
                      L10n.of(context).welcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Hero(
                tag: 'loginButton',
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: RaisedButton(
                    elevation: 7,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: _isLoading
                        ? LinearProgressIndicator()
                        : Text(
                            L10n.of(context).connect.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                    onPressed: _isLoading
                        ? null
                        : () => _checkHomeserverAction(context),
                  ),
                ),
              ),
              SentrySwitchListTile(),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  FlatButton(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      L10n.of(context).about,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () => showAboutDialog(
                      context: context,
                      children: [
                        RaisedButton(
                          child: Text(L10n.of(context).sourceCode),
                          onPressed: () => launch(AppConfig.sourceCodeUrl),
                        ),
                        RaisedButton(
                          child: Text(L10n.of(context).help),
                          onPressed: () => launch(AppConfig.supportUrl),
                        ),
                      ],
                      applicationIcon: Image.asset('assets/logo.png',
                          width: 100, height: 100),
                      applicationName: AppConfig.applicationName,
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      L10n.of(context).privacy,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () => launch(AppConfig.privacyUrl),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
