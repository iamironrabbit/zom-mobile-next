import 'package:fluffychat/components/dialogs/adaptive_flat_button.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class PermissionSliderDialog extends StatefulWidget {
  const PermissionSliderDialog({Key key, this.initialPermission = 0})
      : super(key: key);

  Future<int> show(BuildContext context) => PlatformInfos.isCupertinoStyle
      ? showCupertinoDialog<int>(context: context, builder: (context) => this)
      : showDialog<int>(context: context, builder: (context) => this);

  final int initialPermission;
  @override
  _PermissionSliderDialogState createState() => _PermissionSliderDialogState();
}

class _PermissionSliderDialogState extends State<PermissionSliderDialog> {
  int _permission;
  @override
  void initState() {
    _permission = widget.initialPermission;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final slider = PlatformInfos.isCupertinoStyle
        ? CupertinoSlider(
            value: _permission.toDouble(),
            onChanged: (d) => setState(() => _permission = d.round()),
            max: 100.0,
            min: 0.0,
          )
        : Slider(
            value: _permission.toDouble(),
            onChanged: (d) => setState(() => _permission = d.round()),
            max: 100.0,
            min: 0.0,
          );
    final title = Text(
      L10n.of(context).setPermissionsLevel,
      textAlign: TextAlign.center,
    );
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Level: ' +
            (_permission == 100
                ? '$_permission (${L10n.of(context).admin})'
                : _permission >= 50
                    ? '$_permission (${L10n.of(context).moderator})'
                    : _permission.toString())),
        Container(
          height: 56,
          child: slider,
        ),
      ],
    );
    final buttons = [
      AdaptiveFlatButton(
        child: Text(L10n.of(context).cancel),
        onPressed: () => Navigator.of(context).pop<int>(null),
      ),
      AdaptiveFlatButton(
        child: Text(L10n.of(context).confirm),
        onPressed: () => Navigator.of(context).pop<int>(_permission),
      ),
    ];
    if (PlatformInfos.isCupertinoStyle) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: buttons,
      );
    }
    return AlertDialog(
      title: title,
      content: content,
      actions: buttons,
    );
  }
}
