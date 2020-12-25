import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/encryption/utils/bootstrap.dart';
import 'package:fluffychat/components/dialogs/adaptive_flat_button.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../matrix.dart';

class BootstrapDialog extends StatefulWidget {
  Future<bool> show(BuildContext context) => PlatformInfos.isCupertinoStyle
      ? showCupertinoDialog(context: context, builder: (context) => this)
      : showDialog(context: context, builder: (context) => this);

  @override
  _BootstrapDialogState createState() => _BootstrapDialogState();
}

class _BootstrapDialogState extends State<BootstrapDialog> {
  Bootstrap bootstrap;

  @override
  Widget build(BuildContext context) {
    bootstrap ??= Matrix.of(context)
        .client
        .encryption
        .bootstrap(onUpdate: () => setState(() => null));

    final buttons = <AdaptiveFlatButton>[];
    Widget body;

    switch (bootstrap.state) {
      case BootstrapState.loading:
        body = LinearProgressIndicator();
        break;
      case BootstrapState.askWipeSsss:
        body = Text('Wipe chat backup?');
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).yes),
          onPressed: () => bootstrap.wipeSsss(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(L10n.of(context).no),
          onPressed: () => bootstrap.wipeSsss(false),
        ));
        break;
      case BootstrapState.askUseExistingSsss:
        body = Text('Use existing chat backup?');
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).yes),
          onPressed: () => bootstrap.useExistingSsss(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(L10n.of(context).no),
          onPressed: () => bootstrap.useExistingSsss(false),
        ));
        break;
      case BootstrapState.askBadSsss:
        body = Text('SSSS bad - continue nevertheless? DATALOSS!!!');
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).yes),
          onPressed: () => bootstrap.ignoreBadSecrets(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(L10n.of(context).no),
          onPressed: () => bootstrap.ignoreBadSecrets(false),
        ));
        break;
      case BootstrapState.askUnlockSsss:
        final widgets = <Widget>[Text('Unlock old SSSS')];
        for (final entry in bootstrap.oldSsssKeys.entries) {
          final keyId = entry.key;
          final key = entry.value;
          widgets.add(Flexible(child: _AskUnlockOldSsss(keyId, key)));
        }
        body = Column(
          children: widgets,
          mainAxisSize: MainAxisSize.min,
        );
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).confirm),
          onPressed: () => bootstrap.unlockedSsss(),
        ));
        break;
      case BootstrapState.askNewSsss:
        body = Text('Please set a long passphrase to secure your backup.');
        buttons.add(AdaptiveFlatButton(
            child: Text('Enter a new passphrase'),
            onPressed: () async {
              final input =
                  await showTextInputDialog(context: context, textFields: [
                DialogTextField(
                  minLines: 1,
                  maxLines: 1,
                  obscureText: true,
                )
              ]);
              if (input?.isEmpty ?? true) return;
              await bootstrap.newSsss(input.single);
            }));
        break;
      case BootstrapState.openExistingSsss:
        body = Text('Please enter your passphrase!');
        buttons.add(AdaptiveFlatButton(
            child: Text('Enter passphrase'),
            onPressed: () async {
              final input =
                  await showTextInputDialog(context: context, textFields: [
                DialogTextField(
                  minLines: 1,
                  maxLines: 1,
                  obscureText: true,
                )
              ]);
              if (input?.isEmpty ?? true) return;
              final valid = await showFutureLoadingDialog(
                context: context,
                future: () =>
                    bootstrap.newSsssKey.unlock(keyOrPassphrase: input.single),
              );
              if (valid.error == null) bootstrap.openExistingSsss();
            }));
        break;
      case BootstrapState.askWipeCrossSigning:
        body = Text('Wipe cross-signing?');
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).yes),
          onPressed: () => bootstrap.wipeCrossSigning(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(L10n.of(context).no),
          onPressed: () => bootstrap.wipeCrossSigning(false),
        ));
        break;
      case BootstrapState.askSetupCrossSigning:
        body = Text('Set up cross-signing?');
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).yes),
          onPressed: () => bootstrap.askSetupCrossSigning(
            setupMasterKey: true,
            setupSelfSigningKey: true,
            setupUserSigningKey: true,
          ),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(L10n.of(context).no),
          onPressed: () => bootstrap.askSetupCrossSigning(),
        ));
        break;
      case BootstrapState.askWipeOnlineKeyBackup:
        body = Text('Wipe chat backup?');
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).yes),
          onPressed: () => bootstrap.wipeOnlineKeyBackup(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(L10n.of(context).no),
          onPressed: () => bootstrap.wipeOnlineKeyBackup(false),
        ));
        break;
      case BootstrapState.askSetupOnlineKeyBackup:
        body = Text('Set up chat backup?');
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).yes),
          onPressed: () => bootstrap.askSetupOnlineKeyBackup(true),
        ));
        buttons.add(AdaptiveFlatButton(
          textColor: Theme.of(context).textTheme.bodyText1.color,
          child: Text(L10n.of(context).no),
          onPressed: () => bootstrap.askSetupOnlineKeyBackup(false),
        ));
        break;
      case BootstrapState.error:
        body = ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.error_outline, color: Colors.red),
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        );
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).close),
          onPressed: () => Navigator.of(context).pop<bool>(false),
        ));
        break;
      case BootstrapState.done:
        body = ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Chat backup has been initialized!'),
        );
        buttons.add(AdaptiveFlatButton(
          child: Text(L10n.of(context).close),
          onPressed: () => Navigator.of(context).pop<bool>(false),
        ));
        break;
    }

    final title = Text('Chat backup');
    if (PlatformInfos.isCupertinoStyle) {
      return CupertinoAlertDialog(
        title: title,
        content: body,
        actions: buttons,
      );
    }
    return AlertDialog(
      title: title,
      content: body,
      actions: buttons,
    );
  }
}

class _AskUnlockOldSsss extends StatefulWidget {
  final String keyId;
  final OpenSSSS ssssKey;
  _AskUnlockOldSsss(this.keyId, this.ssssKey);

  @override
  _AskUnlockOldSsssState createState() => _AskUnlockOldSsssState();
}

class _AskUnlockOldSsssState extends State<_AskUnlockOldSsss> {
  bool valid = false;
  TextEditingController textEditingController = TextEditingController();
  String input;

  void checkInput(BuildContext context) async {
    if (input == null) {
      return;
    }

    valid = (await showFutureLoadingDialog(
          context: context,
          future: () => widget.ssssKey.unlock(keyOrPassphrase: input),
        ))
            .error ==
        null;
    setState(() => null);
  }

  @override
  Widget build(BuildContext build) {
    if (valid) {
      return Row(
        children: <Widget>[
          Text(widget.keyId),
          Text('unlocked'),
        ],
        mainAxisSize: MainAxisSize.min,
      );
    }
    return Row(
      children: <Widget>[
        Text(widget.keyId),
        Flexible(
          child: TextField(
            controller: textEditingController,
            autofocus: false,
            autocorrect: false,
            onSubmitted: (s) {
              input = s;
              checkInput(context);
            },
            minLines: 1,
            maxLines: 1,
            obscureText: true,
            decoration: InputDecoration(
              hintText: L10n.of(context).passphraseOrKey,
              prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
              suffixStyle: TextStyle(color: Theme.of(context).primaryColor),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          elevation: 5,
          textColor: Colors.white,
          child: Text(L10n.of(context).submit),
          onPressed: () {
            input = textEditingController.text;
            checkInput(context);
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}
