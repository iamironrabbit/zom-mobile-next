//@dart=2.12

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix/matrix.dart';
import 'package:video_player/video_player.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/add_story/add_story_view.dart';
import 'package:fluffychat/pages/add_story/invite_story_page.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_file_extension.dart';
import 'package:fluffychat/utils/resize_image.dart';
import 'package:fluffychat/utils/room_send_file_extension.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/matrix_sdk_extensions.dart/client_stories_extension.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({Key? key}) : super(key: key);

  @override
  AddStoryController createState() => AddStoryController();
}

class AddStoryController extends State<AddStoryPage> {
  final TextEditingController controller = TextEditingController();
  late Color backgroundColor;
  late Color backgroundColorDark;
  MatrixFile? image;
  MatrixFile? video;

  VideoPlayerController? videoPlayerController;

  bool get hasMedia => image != null || video != null;

  void updateColors() => hasMedia
      ? null
      : setState(() {
          backgroundColor = controller.text.color;
          backgroundColorDark = controller.text.darkColor;
        });

  void importMedia() async {
    final picked = await FilePickerCross.importFromStorage(
      type: FileTypeCross.image,
    );
    final fileName = picked.fileName;
    if (fileName == null) return;
    setState(() {
      image = MatrixFile(bytes: picked.toUint8List(), name: fileName);
    });
  }

  void capturePhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      image = MatrixFile(bytes: bytes, name: picked.name);
    });
  }

  void captureVideo() async {
    final picked = await ImagePicker().pickVideo(
      source: ImageSource.camera,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();

    setState(() {
      video = MatrixFile(bytes: bytes, name: picked.name);
      videoPlayerController = VideoPlayerController.file(File(picked.path))
        ..setLooping(true);
    });
  }

  void postStory() async {
    if (video == null && image == null && controller.text.isEmpty) return;
    final client = Matrix.of(context).client;
    var storiesRoom = await client.getStoriesRoom(context);

    // Invite contacts if necessary
    final undecided = await showFutureLoadingDialog(
      context: context,
      future: () => client.getUndecidedContactsForStories(storiesRoom),
    );
    final result = undecided.result;
    if (result == null) return;
    if (result.isNotEmpty) {
      final created = await showDialog<bool>(
        context: context,
        useRootNavigator: false,
        builder: (context) => InviteStoryPage(storiesRoom: storiesRoom),
      );
      if (created != true) return;
      storiesRoom ??= await client.getStoriesRoom(context);
    }

    // Post story
    final postResult = await showFutureLoadingDialog(
      context: context,
      future: () async {
        if (storiesRoom == null) throw ('Stories room is null');
        var video = this.video?.detectFileType;
        if (video != null) {
          video = await video.resizeVideo();
          await storiesRoom.sendFileEventWithThumbnail(
            video,
            extraContent: {'body': controller.text},
          );
          return;
        }
        var image = this.image?.detectFileType;
        if (image != null) {
          image = await image.resizeImage();
          await storiesRoom.sendFileEventWithThumbnail(
            image,
            extraContent: {'body': controller.text},
          );
          return;
        }
        await storiesRoom.sendTextEvent(controller.text);
      },
    );
    if (postResult.error == null) {
      VRouter.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    final text = Matrix.of(context).client.userID!;
    backgroundColor = text.color;
    backgroundColorDark = text.darkColor;

    final shareContent = Matrix.of(context).shareContent;
    // ignore: unnecessary_null_comparison
    if (shareContent != null) {
      image = shareContent.tryGet<MatrixFile>('file');
      controller.text = shareContent.tryGet<String>('body') ?? '';
      if (shareContent.tryGet<String>('msgtype') == MessageTypes.Image) {
        Event(
          content: shareContent,
          type: EventTypes.Message,
          room: Room(id: '!tmproom', client: Matrix.of(context).client),
          eventId: 'tmpevent',
          senderId: '@tmpsender:example',
          originServerTs: DateTime.now(),
        ).downloadAndDecryptAttachment().then((file) {
          setState(() {
            image = file;
          });
        });
      } else if (shareContent.tryGet<String>('msgtype') == MessageTypes.Video) {
        Event(
          content: shareContent,
          type: EventTypes.Message,
          room: Room(id: '!tmproom', client: Matrix.of(context).client),
          eventId: 'tmpevent',
          senderId: '@tmpsender:example',
          originServerTs: DateTime.now(),
        ).downloadAndDecryptAttachment().then((file) {
          setState(() {
            video = file;
          });
        });
      }
      Matrix.of(context).shareContent = null;
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AddStoryView(this);
}
