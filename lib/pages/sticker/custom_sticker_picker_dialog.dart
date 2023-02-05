import 'package:fluffychat/pages/sticker/sticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../chat/events/image_bubble.dart';

class CustomStickerPickerDialog extends StatefulWidget {
  final Map<String, List<Sticker>> stickerMap;
  final Room room;
  const CustomStickerPickerDialog(
      {required this.stickerMap, required this.room, Key? key})
      : super(key: key);

  @override
  CustomStickerPickerDialogState createState() =>
      CustomStickerPickerDialogState();
}

class CustomStickerPickerDialogState extends State<CustomStickerPickerDialog> {
  String? searchFilter;

  @override
  Widget build(BuildContext context) {
    //TODO: add await to wait for loading of sticker
    final stickerPacks = widget.stickerMap;
    final packSlugs = widget.stickerMap.keys.toList();
    // ignore: prefer_function_declarations_over_variables
    final packBuilder = (BuildContext context, int packIndex) {
      final pack = stickerPacks[packSlugs[packIndex]]!;
      final filteredImagePackImageEntried = [];
      for (final element in pack) {
        filteredImagePackImageEntried.add(element.name);
      }
      if (searchFilter?.isNotEmpty ?? false) {
        filteredImagePackImageEntried.removeWhere(
            (e) => !e.toLowerCase().contains(searchFilter!.toLowerCase()));
      }
      final imageKeys = filteredImagePackImageEntried;
      if (imageKeys.isEmpty) {
        return Container();
      }
      final packName = packSlugs[packIndex];
      return Column(
        children: <Widget>[
          if (packIndex != 0) const SizedBox(height: 20),
          if (packName != 'user')
            ListTile(
              title: Text(packName),
            ),
          const SizedBox(height: 6),
          GridView.builder(
            itemCount: imageKeys.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int imageIndex) {
              final image = pack[imageIndex];
              final stickerEvent = Event(
                type: EventTypes.Message,
                content: {
                  'url': image.url,
                  'body': image.emoticon,
                  'msgtype': MessageTypes.Text,
                },
                originServerTs: DateTime.now(),
                room: widget.room,
                eventId: 'fake_event',
                senderId: widget.room.client.userID!,
              );
              return InkWell(
                key: ValueKey(image.emoticon),
                onTap: () {
                  // copy the image
                  //final imageCopy = image.toString();
                  Navigator.of(context, rootNavigator: false).pop(image);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: ImageBubble(
                    stickerEvent,
                    tapToView: false,
                    fit: BoxFit.contain,
                    width: 100,
                    height: 100,
                  ),
                ),
              );
            },
          ),
        ],
      );
    };

    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: Navigator.of(context, rootNavigator: false).pop,
              ),
              title: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: L10n.of(context)!.search,
                  suffix: const Icon(Icons.search_outlined),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (s) => setState(() => searchFilter = s),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              packBuilder,
              childCount: packSlugs.length,
            )),
          ],
        ),
      ),
    );
  }
}
