// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'messages';

  static m0(username) => "${username} accepted the invitation";

  static m1(username) => "${username} activated end to end encryption";

  static m2(username, targetName) => "${username} banned ${targetName}";

  static m3(username) => "${username} changed the chat avatar";

  static m4(username, description) => "${username} changed the chat description to: \'${description}\'";

  static m5(username, chatname) => "${username} changed the chat name to: \'${chatname}\'";

  static m6(username) => "${username} changed the chat permissions";

  static m7(username, displayname) => "${username} changed the displayname to: ${displayname}";

  static m8(username) => "${username} changed the guest access rules";

  static m9(username, rules) => "${username} changed the guest access rules to: ${rules}";

  static m10(username) => "${username} changed the history visibility";

  static m11(username, rules) => "${username} changed the history visibility to: ${rules}";

  static m12(username) => "${username} changed the join rules";

  static m13(username, joinRules) => "${username} changed the join rules to: ${joinRules}";

  static m14(username) => "${username} changed the profile avatar";

  static m15(username) => "${username} changed the room aliases";

  static m16(username) => "${username} changed the invitation link";

  static m17(count) => "${count} participants";

  static m18(username) => "${username} created the chat";

  static m19(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m20(year, month, day) => "${year}-${month}-${day}";

  static m21(month, day) => "${month}-${day}";

  static m22(fileName) => "Download ${fileName}";

  static m23(displayname) => "Group with ${displayname}";

  static m24(username, targetName) => "${username} has withdrawn the invitation for ${targetName}";

  static m25(groupName) => "Invite contact to ${groupName}";

  static m26(username, targetName) => "${username} invited ${targetName}";

  static m27(username) => "${username} joined the chat";

  static m28(username, targetName) => "${username} kicked ${targetName}";

  static m29(username, targetName) => "${username} kicked and banned ${targetName}";

  static m30(count) => "Load ${count} more participants";

  static m31(fileName) => "Play ${fileName}";

  static m32(username) => "${username} redacted an event";

  static m33(username) => "${username} rejected the invitation";

  static m34(username) => "Removed by ${username}";

  static m35(username) => "Seen by ${username}";

  static m36(username, count) => "Seen by ${username} and ${count} others";

  static m37(username, username2) => "Seen by ${username} and ${username2}";

  static m38(username) => "${username} sent a file";

  static m39(username) => "${username} sent a picture";

  static m40(username) => "${username} sent a sticker";

  static m41(username) => "${username} sent a video";

  static m42(username) => "${username} sent an audio";

  static m43(username) => "${username} shared the location";

  static m44(hours12, hours24, minutes, suffix) => "${hours12}:${minutes} ${suffix}";

  static m45(username, targetName) => "${username} unbanned ${targetName}";

  static m46(type) => "Unknown event \'${type}\'";

  static m47(unreadEvents) => "${unreadEvents} unread messages";

  static m48(unreadEvents, unreadChats) => "${unreadEvents} unread messages in ${unreadChats} chats";

  static m49(username, count) => "${username} and ${count} others are typing...";

  static m50(username, username2) => "${username} and ${username2} are typing...";

  static m51(username) => "${username} is typing...";

  static m52(username) => "${username} left the chat";

  static m53(username, type) => "${username} sent a ${type} event";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "(Optional) Group name" : MessageLookupByLibrary.simpleMessage("(Optional) Group name"),
    "About" : MessageLookupByLibrary.simpleMessage("About"),
    "Add a group description" : MessageLookupByLibrary.simpleMessage("Add a group description"),
    "Admin" : MessageLookupByLibrary.simpleMessage("Admin"),
    "Already have an account?" : MessageLookupByLibrary.simpleMessage("Already have an account?"),
    "Anyone can join" : MessageLookupByLibrary.simpleMessage("Anyone can join"),
    "Archive" : MessageLookupByLibrary.simpleMessage("Archive"),
    "Archived Room" : MessageLookupByLibrary.simpleMessage("Archived Room"),
    "Are guest users allowed to join" : MessageLookupByLibrary.simpleMessage("Are guest users allowed to join"),
    "Authentication" : MessageLookupByLibrary.simpleMessage("Authentication"),
    "Avatar has been changed" : MessageLookupByLibrary.simpleMessage("Avatar has been changed"),
    "Ban from chat" : MessageLookupByLibrary.simpleMessage("Ban from chat"),
    "Banned" : MessageLookupByLibrary.simpleMessage("Banned"),
    "Change the name of the group" : MessageLookupByLibrary.simpleMessage("Change the name of the group"),
    "Changelog" : MessageLookupByLibrary.simpleMessage("Changelog"),
    "Chat details" : MessageLookupByLibrary.simpleMessage("Chat details"),
    "Choose a username" : MessageLookupByLibrary.simpleMessage("Choose a username"),
    "Close" : MessageLookupByLibrary.simpleMessage("Close"),
    "Confirm" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "Connection attempt failed" : MessageLookupByLibrary.simpleMessage("Connection attempt failed"),
    "Contact has been invited to the group" : MessageLookupByLibrary.simpleMessage("Contact has been invited to the group"),
    "Content viewer" : MessageLookupByLibrary.simpleMessage("Content viewer"),
    "Copied to clipboard" : MessageLookupByLibrary.simpleMessage("Copied to clipboard"),
    "Copy" : MessageLookupByLibrary.simpleMessage("Copy"),
    "Could not decrypt message" : MessageLookupByLibrary.simpleMessage("Could not decrypt message"),
    "Could not set avatar" : MessageLookupByLibrary.simpleMessage("Could not set avatar"),
    "Could not set displayname" : MessageLookupByLibrary.simpleMessage("Could not set displayname"),
    "Create" : MessageLookupByLibrary.simpleMessage("Create"),
    "Create account now" : MessageLookupByLibrary.simpleMessage("Create account now"),
    "Create new group" : MessageLookupByLibrary.simpleMessage("Create new group"),
    "Delete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "Delete message" : MessageLookupByLibrary.simpleMessage("Delete message"),
    "Discard picture" : MessageLookupByLibrary.simpleMessage("Discard picture"),
    "Displayname has been changed" : MessageLookupByLibrary.simpleMessage("Displayname has been changed"),
    "Donate" : MessageLookupByLibrary.simpleMessage("Donate"),
    "Edit displayname" : MessageLookupByLibrary.simpleMessage("Edit displayname"),
    "Empty chat" : MessageLookupByLibrary.simpleMessage("Empty chat"),
    "Encryption algorithm" : MessageLookupByLibrary.simpleMessage("Encryption algorithm"),
    "End-to-end encryption settings" : MessageLookupByLibrary.simpleMessage("End-to-end encryption settings"),
    "Enter a group name" : MessageLookupByLibrary.simpleMessage("Enter a group name"),
    "Enter a username" : MessageLookupByLibrary.simpleMessage("Enter a username"),
    "FluffyChat" : MessageLookupByLibrary.simpleMessage("FluffyChat"),
    "Forward" : MessageLookupByLibrary.simpleMessage("Forward"),
    "Friday" : MessageLookupByLibrary.simpleMessage("Friday"),
    "From joining" : MessageLookupByLibrary.simpleMessage("From joining"),
    "From the invitation" : MessageLookupByLibrary.simpleMessage("From the invitation"),
    "Group" : MessageLookupByLibrary.simpleMessage("Group"),
    "Group description" : MessageLookupByLibrary.simpleMessage("Group description"),
    "Group description has been changed" : MessageLookupByLibrary.simpleMessage("Group description has been changed"),
    "Group is public" : MessageLookupByLibrary.simpleMessage("Group is public"),
    "Guests are forbidden" : MessageLookupByLibrary.simpleMessage("Guests are forbidden"),
    "Guests can join" : MessageLookupByLibrary.simpleMessage("Guests can join"),
    "Help" : MessageLookupByLibrary.simpleMessage("Help"),
    "Homeserver is not compatible" : MessageLookupByLibrary.simpleMessage("Homeserver is not compatible"),
    "Invite contact" : MessageLookupByLibrary.simpleMessage("Invite contact"),
    "Invited" : MessageLookupByLibrary.simpleMessage("Invited"),
    "Invited users only" : MessageLookupByLibrary.simpleMessage("Invited users only"),
    "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/" : MessageLookupByLibrary.simpleMessage("It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/"),
    "Kick from chat" : MessageLookupByLibrary.simpleMessage("Kick from chat"),
    "Leave" : MessageLookupByLibrary.simpleMessage("Leave"),
    "Left the chat" : MessageLookupByLibrary.simpleMessage("Left the chat"),
    "License" : MessageLookupByLibrary.simpleMessage("License"),
    "Loading... Please wait" : MessageLookupByLibrary.simpleMessage("Loading... Please wait"),
    "Login" : MessageLookupByLibrary.simpleMessage("Login"),
    "Logout" : MessageLookupByLibrary.simpleMessage("Logout"),
    "Make an admin" : MessageLookupByLibrary.simpleMessage("Make an admin"),
    "Make sure the identifier is valid" : MessageLookupByLibrary.simpleMessage("Make sure the identifier is valid"),
    "Message will be removed for all participants" : MessageLookupByLibrary.simpleMessage("Message will be removed for all participants"),
    "Moderator" : MessageLookupByLibrary.simpleMessage("Moderator"),
    "Monday" : MessageLookupByLibrary.simpleMessage("Monday"),
    "Mute chat" : MessageLookupByLibrary.simpleMessage("Mute chat"),
    "New message in FluffyChat" : MessageLookupByLibrary.simpleMessage("New message in FluffyChat"),
    "New private chat" : MessageLookupByLibrary.simpleMessage("New private chat"),
    "No rooms found..." : MessageLookupByLibrary.simpleMessage("No rooms found..."),
    "None" : MessageLookupByLibrary.simpleMessage("None"),
    "Not supported in web" : MessageLookupByLibrary.simpleMessage("Not supported in web"),
    "Oops something went wrong..." : MessageLookupByLibrary.simpleMessage("Oops something went wrong..."),
    "Open camera" : MessageLookupByLibrary.simpleMessage("Open camera"),
    "Participating user devices" : MessageLookupByLibrary.simpleMessage("Participating user devices"),
    "Password" : MessageLookupByLibrary.simpleMessage("Password"),
    "Please be aware that you need Pantalaimon to use end-to-end encryption for now." : MessageLookupByLibrary.simpleMessage("Please be aware that you need Pantalaimon to use end-to-end encryption for now."),
    "Please choose a username" : MessageLookupByLibrary.simpleMessage("Please choose a username"),
    "Please enter a matrix identifier" : MessageLookupByLibrary.simpleMessage("Please enter a matrix identifier"),
    "Please enter your password" : MessageLookupByLibrary.simpleMessage("Please enter your password"),
    "Please enter your username" : MessageLookupByLibrary.simpleMessage("Please enter your username"),
    "Rejoin" : MessageLookupByLibrary.simpleMessage("Rejoin"),
    "Remove" : MessageLookupByLibrary.simpleMessage("Remove"),
    "Remove exile" : MessageLookupByLibrary.simpleMessage("Remove exile"),
    "Remove message" : MessageLookupByLibrary.simpleMessage("Remove message"),
    "Revoke all permissions" : MessageLookupByLibrary.simpleMessage("Revoke all permissions"),
    "Saturday" : MessageLookupByLibrary.simpleMessage("Saturday"),
    "Search for a chat" : MessageLookupByLibrary.simpleMessage("Search for a chat"),
    "Secure your account with a password" : MessageLookupByLibrary.simpleMessage("Secure your account with a password"),
    "Send a message" : MessageLookupByLibrary.simpleMessage("Send a message"),
    "Send file" : MessageLookupByLibrary.simpleMessage("Send file"),
    "Send image" : MessageLookupByLibrary.simpleMessage("Send image"),
    "Set a profile picture" : MessageLookupByLibrary.simpleMessage("Set a profile picture"),
    "Set group description" : MessageLookupByLibrary.simpleMessage("Set group description"),
    "Set invitation link" : MessageLookupByLibrary.simpleMessage("Set invitation link"),
    "Settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "Share" : MessageLookupByLibrary.simpleMessage("Share"),
    "Sign up" : MessageLookupByLibrary.simpleMessage("Sign up"),
    "Source code" : MessageLookupByLibrary.simpleMessage("Source code"),
    "Start your first chat :-)" : MessageLookupByLibrary.simpleMessage("Start your first chat :-)"),
    "Sunday" : MessageLookupByLibrary.simpleMessage("Sunday"),
    "Tap to show menu" : MessageLookupByLibrary.simpleMessage("Tap to show menu"),
    "This room has been archived." : MessageLookupByLibrary.simpleMessage("This room has been archived."),
    "Thursday" : MessageLookupByLibrary.simpleMessage("Thursday"),
    "Try to send again" : MessageLookupByLibrary.simpleMessage("Try to send again"),
    "Tuesday" : MessageLookupByLibrary.simpleMessage("Tuesday"),
    "Unmute chat" : MessageLookupByLibrary.simpleMessage("Unmute chat"),
    "Username" : MessageLookupByLibrary.simpleMessage("Username"),
    "Visibility of the chat history" : MessageLookupByLibrary.simpleMessage("Visibility of the chat history"),
    "Visible for all participants" : MessageLookupByLibrary.simpleMessage("Visible for all participants"),
    "Visible for everyone" : MessageLookupByLibrary.simpleMessage("Visible for everyone"),
    "Wednesday" : MessageLookupByLibrary.simpleMessage("Wednesday"),
    "Who is allowed to join this group" : MessageLookupByLibrary.simpleMessage("Who is allowed to join this group"),
    "Write a message..." : MessageLookupByLibrary.simpleMessage("Write a message..."),
    "Yes" : MessageLookupByLibrary.simpleMessage("Yes"),
    "You" : MessageLookupByLibrary.simpleMessage("You"),
    "You are invited to this chat" : MessageLookupByLibrary.simpleMessage("You are invited to this chat"),
    "You are no longer participating in this chat" : MessageLookupByLibrary.simpleMessage("You are no longer participating in this chat"),
    "You cannot invite yourself" : MessageLookupByLibrary.simpleMessage("You cannot invite yourself"),
    "You have been banned from this chat" : MessageLookupByLibrary.simpleMessage("You have been banned from this chat"),
    "You won\'t be able to disable the encryption anymore. Are you sure?" : MessageLookupByLibrary.simpleMessage("You won\'t be able to disable the encryption anymore. Are you sure?"),
    "Your own username" : MessageLookupByLibrary.simpleMessage("Your own username"),
    "acceptedTheInvitation" : m0,
    "activatedEndToEndEncryption" : m1,
    "alias" : MessageLookupByLibrary.simpleMessage("alias"),
    "bannedUser" : m2,
    "changedTheChatAvatar" : m3,
    "changedTheChatDescriptionTo" : m4,
    "changedTheChatNameTo" : m5,
    "changedTheChatPermissions" : m6,
    "changedTheDisplaynameTo" : m7,
    "changedTheGuestAccessRules" : m8,
    "changedTheGuestAccessRulesTo" : m9,
    "changedTheHistoryVisibility" : m10,
    "changedTheHistoryVisibilityTo" : m11,
    "changedTheJoinRules" : m12,
    "changedTheJoinRulesTo" : m13,
    "changedTheProfileAvatar" : m14,
    "changedTheRoomAliases" : m15,
    "changedTheRoomInvitationLink" : m16,
    "countParticipants" : m17,
    "createdTheChat" : m18,
    "dateAndTimeOfDay" : m19,
    "dateWithYear" : m20,
    "dateWithoutYear" : m21,
    "download" : m22,
    "groupWith" : m23,
    "hasWithdrawnTheInvitationFor" : m24,
    "inviteContactToGroup" : m25,
    "invitedUser" : m26,
    "is typing..." : MessageLookupByLibrary.simpleMessage("is typing..."),
    "joinedTheChat" : m27,
    "kicked" : m28,
    "kickedAndBanned" : m29,
    "loadCountMoreParticipants" : m30,
    "play" : m31,
    "redactedAnEvent" : m32,
    "rejectedTheInvitation" : m33,
    "removedBy" : m34,
    "seenByUser" : m35,
    "seenByUserAndCountOthers" : m36,
    "seenByUserAndUser" : m37,
    "sentAFile" : m38,
    "sentAPicture" : m39,
    "sentASticker" : m40,
    "sentAVideo" : m41,
    "sentAnAudio" : m42,
    "sharedTheLocation" : m43,
    "timeOfDay" : m44,
    "title" : MessageLookupByLibrary.simpleMessage("FluffyChat"),
    "unbannedUser" : m45,
    "unknownEvent" : m46,
    "unreadMessages" : m47,
    "unreadMessagesInChats" : m48,
    "userAndOthersAreTyping" : m49,
    "userAndUserAreTyping" : m50,
    "userIsTyping" : m51,
    "userLeftTheChat" : m52,
    "userSentUnknownEvent" : m53
  };
}
