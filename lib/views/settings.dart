import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/components/dialogs/bootstrap_dialog.dart';
import 'package:fluffychat/views/settings_3pid.dart';
import 'package:fluffychat/views/settings_notifications.dart';
import 'package:fluffychat/views/settings_style.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';

import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/views/settings_devices.dart';
import 'package:fluffychat/views/settings_ignore_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger_flutter/logger_flutter.dart';

import '../components/adaptive_page_layout.dart';
import '../components/content_banner.dart';
import '../components/dialogs/simple_dialogs.dart';
import '../components/matrix.dart';
import '../utils/app_route.dart';
import '../app_config.dart';
import '../config/setting_keys.dart';
import 'chat_list.dart';
import 'settings_emotes.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<dynamic> profileFuture;
  dynamic profile;
  Future<bool> crossSigningCachedFuture;
  bool crossSigningCached;
  Future<bool> megolmBackupCachedFuture;
  bool megolmBackupCached;

  void logoutAction(BuildContext context) async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    var matrix = Matrix.of(context);
    await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(matrix.client.logout());
  }

  void _changePasswordAccountAction(BuildContext context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).changePassword,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).pleaseEnterYourPassword,
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        ),
        DialogTextField(
          hintText: L10n.of(context).chooseAStrongPassword,
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        ),
      ],
    );
    if (input == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context)
          .client
          .changePassword(input.last, oldPassword: input.first),
    );
    await FlushbarHelper.createSuccess(
            message: L10n.of(context).passwordHasBeenChanged)
        .show(context);
  }

  void _deleteAccountAction(BuildContext context) async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).warning,
          message: L10n.of(context).deactivateAccountWarning,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    if (await showOkCancelAlertDialog(
            context: context, title: L10n.of(context).areYouSure) ==
        OkCancelResult.cancel) {
      return;
    }
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).pleaseEnterYourPassword,
      textFields: [
        DialogTextField(
          obscureText: true,
          hintText: '******',
          minLines: 1,
          maxLines: 1,
        )
      ],
    );
    if (input == null) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context).client.deactivateAccount(
            auth: AuthenticationPassword(
              password: input.single,
              user: Matrix.of(context).client.userID,
              identifier: AuthenticationUserIdentifier(
                  user: Matrix.of(context).client.userID),
            ),
          ),
    );
  }

  void setJitsiInstanceAction(BuildContext context) async {
    const prefix = 'https://';
    var input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).editJitsiInstance,
      textFields: [
        DialogTextField(
          initialText: AppConfig.jitsiInstance.replaceFirst(prefix, ''),
          prefixText: prefix,
        ),
      ],
    );
    if (input == null) return;
    var jitsi = prefix + input.single;
    if (!jitsi.endsWith('/')) {
      jitsi += '/';
    }
    final matrix = Matrix.of(context);
    await matrix.store.setItem(SettingKeys.jitsiInstance, jitsi);
    AppConfig.jitsiInstance = jitsi;
  }

  void setDisplaynameAction(BuildContext context) async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).editDisplayname,
      textFields: [
        DialogTextField(
          initialText: profile?.displayname ??
              Matrix.of(context).client.userID.localpart,
        )
      ],
    );
    if (input == null) return;
    final matrix = Matrix.of(context);
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      matrix.client.setDisplayname(matrix.client.userID, input.single),
    );
    if (success != false) {
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  void setAvatarAction(BuildContext context) async {
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxWidth: 1600,
          maxHeight: 1600);
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final result =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (result == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName,
      );
    }
    final matrix = Matrix.of(context);
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      matrix.client.setAvatar(file),
    );
    if (success != false) {
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  Future<void> requestSSSSCache(BuildContext context) async {
    final handle = Matrix.of(context).client.encryption.ssss.open();
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).askSSSSCache,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).passphraseOrKey,
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        )
      ],
    );
    if (input != null) {
      final valid = await SimpleDialogs(context)
          .tryRequestWithLoadingDialog(Future.microtask(() async {
        // make sure the loading spinner shows before we test the keys
        await Future.delayed(Duration(milliseconds: 100));
        var valid = false;
        try {
          await handle.unlock(recoveryKey: input.single);
          valid = true;
        } catch (e, s) {
          SentryController.captureException(e, s);
        }
        return valid;
      }));

      if (valid == true) {
        await handle.maybeCacheAll();
        await showOkAlertDialog(
          context: context,
          message: L10n.of(context).cachedKeys,
        );
        setState(() {
          crossSigningCachedFuture = null;
          crossSigningCached = null;
          megolmBackupCachedFuture = null;
          megolmBackupCached = null;
        });
      } else {
        await showOkAlertDialog(
          context: context,
          message: L10n.of(context).incorrectPassphraseOrKey,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    profileFuture ??= client.ownProfile.then((p) {
      if (mounted) setState(() => profile = p);
      return p;
    });
    crossSigningCachedFuture ??=
        client.encryption.crossSigning.isCached().then((c) {
      if (mounted) setState(() => crossSigningCached = c);
      return c;
    });
    megolmBackupCachedFuture ??=
        client.encryption.keyManager.isCached().then((c) {
      if (mounted) setState(() => megolmBackupCached = c);
      return c;
    });
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).appBarTheme.color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                L10n.of(context).settings,
                style: TextStyle(
                    color: Theme.of(context)
                        .appBarTheme
                        .textTheme
                        .headline6
                        .color),
              ),
              background: ContentBanner(
                profile?.avatarUrl,
                height: 300,
                defaultIcon: Icons.account_circle_outlined,
                loading: profile == null,
                onEdit: () => setAvatarAction(context),
              ),
            ),
          ),
        ],
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                L10n.of(context).notifications,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.notifications_outlined),
              title: Text(L10n.of(context).notifications),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  SettingsNotificationsView(),
                ),
              ),
            ),
            ListTile(
              title: Text(
                L10n.of(context).chat,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).changeTheme),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  SettingsStyleView(),
                ),
              ),
              trailing: Icon(Icons.style_outlined),
            ),
            SwitchListTile(
              title: Text(L10n.of(context).renderRichContent),
              value: AppConfig.renderHtml,
              onChanged: (bool newValue) async {
                AppConfig.renderHtml = newValue;
                await Matrix.of(context)
                    .store
                    .setItem(SettingKeys.renderHtml, newValue.toString());
                setState(() => null);
              },
            ),
            SwitchListTile(
              title: Text(L10n.of(context).hideRedactedEvents),
              value: AppConfig.hideRedactedEvents,
              onChanged: (bool newValue) async {
                AppConfig.hideRedactedEvents = newValue;
                await Matrix.of(context).store.setItem(
                    SettingKeys.hideRedactedEvents, newValue.toString());
                setState(() => null);
              },
            ),
            SwitchListTile(
              title: Text(L10n.of(context).hideUnknownEvents),
              value: AppConfig.hideUnknownEvents,
              onChanged: (bool newValue) async {
                AppConfig.hideUnknownEvents = newValue;
                await Matrix.of(context).store.setItem(
                    SettingKeys.hideUnknownEvents, newValue.toString());
                setState(() => null);
              },
            ),
            ListTile(
              title: Text(L10n.of(context).emoteSettings),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  EmotesSettingsView(),
                ),
              ),
              trailing: Icon(Icons.insert_emoticon_outlined),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).account,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.edit_outlined),
              title: Text(L10n.of(context).editDisplayname),
              subtitle: Text(profile?.displayname ?? client.userID.localpart),
              onTap: () => setDisplaynameAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.phone_outlined),
              title: Text(L10n.of(context).editJitsiInstance),
              subtitle: Text(AppConfig.jitsiInstance),
              onTap: () => setJitsiInstanceAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.devices_other_outlined),
              title: Text(L10n.of(context).devices),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  DevicesSettingsView(),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.block_outlined),
              title: Text(L10n.of(context).ignoredUsers),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  SettingsIgnoreListView(),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.bug_report_outlined),
              title: Text(L10n.of(context).sendBugReports),
              onTap: () => SentryController.toggleSentryAction(context),
            ),
            Divider(thickness: 1),
            ListTile(
              trailing: Icon(Icons.security_outlined),
              title: Text(
                L10n.of(context).changePassword,
              ),
              onTap: () => _changePasswordAccountAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.email_outlined),
              title: Text(L10n.of(context).passwordRecovery),
              onTap: () => Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  Settings3PidView(),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.exit_to_app_outlined),
              title: Text(L10n.of(context).logout),
              onTap: () => logoutAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.delete_forever_outlined),
              title: Text(
                L10n.of(context).deleteAccount,
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _deleteAccountAction(context),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).encryption,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.compare_arrows_outlined),
              title: Text(client.encryption.crossSigning.enabled
                  ? L10n.of(context).crossSigningEnabled
                  : L10n.of(context).crossSigningDisabled),
              subtitle: client.encryption.crossSigning.enabled
                  ? Text(client.isUnknownSession
                      ? L10n.of(context).unknownSessionVerify
                      : L10n.of(context).sessionVerified +
                          ', ' +
                          (crossSigningCached == null
                              ? '⌛'
                              : (crossSigningCached
                                  ? L10n.of(context).keysCached
                                  : L10n.of(context).keysMissing)))
                  : null,
              onTap: () async {
                if (!client.encryption.crossSigning.enabled) {
                  return BootstrapDialog().show(context);
                }
                if (client.isUnknownSession) {
                  final input = await showTextInputDialog(
                    context: context,
                    title: L10n.of(context).askSSSSVerify,
                    textFields: [
                      DialogTextField(
                        hintText: L10n.of(context).passphraseOrKey,
                        obscureText: true,
                        minLines: 1,
                        maxLines: 1,
                      )
                    ],
                  );
                  if (input != null) {
                    final valid = await SimpleDialogs(context)
                        .tryRequestWithLoadingDialog(Future.microtask(() async {
                      // make sure the loading spinner shows before we test the keys
                      await Future.delayed(Duration(milliseconds: 100));
                      var valid = false;
                      try {
                        await client.encryption.crossSigning
                            .selfSign(recoveryKey: input.single);
                        valid = true;
                      } catch (_) {
                        try {
                          await client.encryption.crossSigning
                              .selfSign(passphrase: input.single);
                          valid = true;
                        } catch (_) {
                          valid = false;
                        }
                      }
                      return valid;
                    }));

                    if (valid == true) {
                      await showOkAlertDialog(
                        context: context,
                        message: L10n.of(context).verifiedSession,
                      );
                      setState(() {
                        crossSigningCachedFuture = null;
                        crossSigningCached = null;
                        megolmBackupCachedFuture = null;
                        megolmBackupCached = null;
                      });
                    } else {
                      await showOkAlertDialog(
                        context: context,
                        message: L10n.of(context).incorrectPassphraseOrKey,
                      );
                    }
                  }
                }
                if (!(await client.encryption.crossSigning.isCached())) {
                  await requestSSSSCache(context);
                }
              },
            ),
            ListTile(
              trailing: Icon(Icons.wb_cloudy_outlined),
              title: Text(client.encryption.keyManager.enabled
                  ? L10n.of(context).onlineKeyBackupEnabled
                  : L10n.of(context).onlineKeyBackupDisabled),
              subtitle: client.encryption.keyManager.enabled
                  ? Text(megolmBackupCached == null
                      ? '⌛'
                      : (megolmBackupCached
                          ? L10n.of(context).keysCached
                          : L10n.of(context).keysMissing))
                  : null,
              onTap: () async {
                if (!client.encryption.keyManager.enabled) {
                  return BootstrapDialog().show(context);
                }
                if (!(await client.encryption.keyManager.isCached())) {
                  await requestSSSSCache(context);
                }
              },
            ),
            ListTile(
              title: Text(L10n.of(context).yourPublicKey),
              onTap: () => showOkAlertDialog(
                context: context,
                title: L10n.of(context).yourPublicKey,
                message: client.fingerprintKey.beautified,
              ),
              trailing: Icon(Icons.vpn_key_outlined),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).about,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  LogConsole(
                    showCloseButton: true,
                  ),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.help_outlined),
              title: Text(L10n.of(context).help),
              onTap: () => launch(AppConfig.supportUrl),
            ),
            ListTile(
              trailing: Icon(Icons.privacy_tip_outlined),
              title: Text(L10n.of(context).privacy),
              onTap: () => launch(AppConfig.privacyUrl),
            ),
            ListTile(
              trailing: Icon(Icons.link_outlined),
              title: Text(L10n.of(context).license),
              onTap: () => showLicensePage(
                context: context,
                applicationIcon:
                    Image.asset('assets/logo.png', width: 100, height: 100),
                applicationName: AppConfig.applicationName,
              ),
            ),
            ListTile(
              trailing: Icon(Icons.code_outlined),
              title: Text(L10n.of(context).sourceCode),
              onTap: () => launch(AppConfig.sourceCodeUrl),
            ),
          ],
        ),
      ),
    );
  }
}
