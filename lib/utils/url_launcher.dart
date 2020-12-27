import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:fluffychat/views/discover_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'matrix_identifier_string_extension.dart';

class UrlLauncher {
  final String url;
  final BuildContext context;
  const UrlLauncher(this.context, this.url);

  void launchUrl() {
    if (url.startsWith(AppConfig.inviteLinkPrefix) ||
        {'#', '@', '!', '+', '\$'}.contains(url[0])) {
      return openMatrixToUrl();
    }
    launch(url);
  }

  void openMatrixToUrl() async {
    final matrix = Matrix.of(context);
    // The identifier might be a matrix.to url and needs escaping. Or, it might have multiple
    // identifiers (room id & event id), or it might also have a query part.
    // All this needs parsing.
    final identityParts = url.parseIdentifierIntoParts();
    if (identityParts == null) {
      return; // no match, nothing to do
    }
    if (identityParts.primaryIdentifier.sigil == '#' ||
        identityParts.primaryIdentifier.sigil == '!') {
      // we got a room! Let's open that one
      final roomIdOrAlias = identityParts.primaryIdentifier;
      final event = identityParts.secondaryIdentifier;
      final query = identityParts.queryString;
      var room = matrix.client.getRoomByAlias(roomIdOrAlias) ??
          matrix.client.getRoomById(roomIdOrAlias);
      var roomId = room?.id;
      // we make the servers a set and later on convert to a list, so that we can easily
      // deduplicate servers added via alias lookup and query parameter
      var servers = <String>{};
      if (room == null && roomIdOrAlias.sigil == '#') {
        // we were unable to find the room locally...so resolve it
        final response = await showFutureLoadingDialog(
          context: context,
          future: () =>
              matrix.client.requestRoomAliasInformations(roomIdOrAlias),
        );
        if (response.error == null) {
          roomId = response.result.roomId;
          servers.addAll(response.result.servers);
          room = matrix.client.getRoomById(roomId);
        }
      }
      if (query != null) {
        // the query information might hold additional servers to try, so let's try them!
        // as there might be multiple "via" tags we can't just use Uri.splitQueryString, we need to do our own thing
        for (final parameter in query.split('&')) {
          final index = parameter.indexOf('=');
          if (index == -1) {
            continue;
          }
          if (Uri.decodeQueryComponent(parameter.substring(0, index)) !=
              'via') {
            continue;
          }
          servers.add(Uri.decodeQueryComponent(parameter.substring(index + 1)));
        }
      }
      if (room != null) {
        // we have the room, so....just open it!
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(
              context, ChatView(room.id, scrollToEventId: event)),
          (r) => r.isFirst,
        );
        return;
      }
      if (roomIdOrAlias.sigil == '!') {
        if (await showOkCancelAlertDialog(
              context: context,
              title: 'Join room $roomIdOrAlias',
            ) ==
            OkCancelResult.ok) {
          roomId = roomIdOrAlias;
          final response = await showFutureLoadingDialog(
            context: context,
            future: () => matrix.client.joinRoomOrAlias(
              roomIdOrAlias,
              servers: servers.isNotEmpty ? servers.toList() : null,
            ),
          );
          if (response.error != null) return;
          // wait for two seconds so that it probably came down /sync
          await showFutureLoadingDialog(
              context: context,
              future: () => Future.delayed(const Duration(seconds: 2)));
          await Navigator.pushAndRemoveUntil(
            context,
            AppRoute.defaultRoute(
                context, ChatView(response.result, scrollToEventId: event)),
            (r) => r.isFirst,
          );
        }
      } else {
        await Navigator.of(context).pushAndRemoveUntil(
          AppRoute.defaultRoute(
            context,
            DiscoverView(alias: roomIdOrAlias),
          ),
          (r) => r.isFirst,
        );
      }
    } else if (identityParts.primaryIdentifier.sigil == '@') {
      final user = User(
        identityParts.primaryIdentifier,
        room: Room(id: '', client: matrix.client),
      );
      var roomId = matrix.client.getDirectChatFromUserId(user.id);
      if (roomId != null) {
        await Navigator.pushAndRemoveUntil(
          context,
          AppRoute.defaultRoute(context, ChatView(roomId)),
          (r) => r.isFirst,
        );
        return;
      }

      if (await showOkCancelAlertDialog(
            context: context,
            title: 'Message user ${user.id}',
          ) ==
          OkCancelResult.ok) {
        roomId = (await showFutureLoadingDialog(
          context: context,
          future: () => user.startDirectChat(),
        ))
            .result;
        Navigator.of(context).pop();

        if (roomId != null) {
          await Navigator.pushAndRemoveUntil(
            context,
            AppRoute.defaultRoute(context, ChatView(roomId)),
            (r) => r.isFirst,
          );
        }
      }
    }
  }
}
