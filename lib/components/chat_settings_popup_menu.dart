import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'matrix.dart';

class ChatSettingsPopupMenu extends StatefulWidget {
  final Room room;
  final bool displayChatDetails;
  const ChatSettingsPopupMenu(this.room, this.displayChatDetails, {Key key})
      : super(key: key);

  @override
  _ChatSettingsPopupMenuState createState() => _ChatSettingsPopupMenuState();
}

class _ChatSettingsPopupMenuState extends State<ChatSettingsPopupMenu> {
  StreamSubscription notificationChangeSub;

  @override
  void dispose() {
    notificationChangeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notificationChangeSub ??= Matrix.of(context)
        .client
        .onAccountData
        .stream
        .where((u) => u.type == 'm.push_rules')
        .listen(
          (u) => setState(() => null),
        );
    var items = <PopupMenuEntry<String>>[
      widget.room.pushRuleState == PushRuleState.notify
          ? PopupMenuItem<String>(
              value: 'mute',
              child: Text(L10n.of(context).muteChat),
            )
          : PopupMenuItem<String>(
              value: 'unmute',
              child: Text(L10n.of(context).unmuteChat),
            ),
      PopupMenuItem<String>(
        value: 'call',
        child: Text(L10n.of(context).videoCall),
      ),
      PopupMenuItem<String>(
        value: 'leave',
        child: Text(L10n.of(context).leave),
      ),
    ];
    if (widget.displayChatDetails) {
      items.insert(
        0,
        PopupMenuItem<String>(
          value: 'details',
          child: Text(L10n.of(context).chatDetails),
        ),
      );
    }
    return PopupMenuButton(
      onSelected: (String choice) async {
        switch (choice) {
          case 'leave':
            var confirmed = await showOkCancelAlertDialog(
              context: context,
              title: L10n.of(context).areYouSure,
            );
            if (confirmed == OkCancelResult.ok) {
              final success = await showFutureLoadingDialog(
                  context: context, future: () => widget.room.leave());
              if (success.error == null) {
                await AdaptivePageLayout.of(context)
                    .pushNamedAndRemoveAllOthers('/');
              }
            }
            break;
          case 'mute':
            await showFutureLoadingDialog(
                context: context,
                future: () =>
                    widget.room.setPushRuleState(PushRuleState.mentions_only));
            break;
          case 'unmute':
            await showFutureLoadingDialog(
                context: context,
                future: () =>
                    widget.room.setPushRuleState(PushRuleState.notify));
            break;
          case 'details':
            if (AdaptivePageLayout.of(context).viewDataStack.length < 3) {
              await AdaptivePageLayout.of(context)
                  .pushNamed('/rooms/${widget.room.id}/details');
            }

            break;
        }
      },
      itemBuilder: (BuildContext context) => items,
    );
  }
}
