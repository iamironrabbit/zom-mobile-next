// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static m0(username) => "${username}が招待を承諾しました";

  static m1(username) => "${username}がエンドツーエンド暗号化を有効にしました";

  static m2(senderName) => "${senderName}は通話に出ました";

  static m3(username) => "${username}の検証リクエストを承認しますか？";

  static m4(username, targetName) => "${username}が${targetName}をBANしました";

  static m5(homeserver) => "デフォルトで${homeserver}に接続されます";

  static m6(username) => "${username}がチャットアバターを変更しました";

  static m7(username, description) =>
      "${username}がチャットの説明を「${description}」に変更しました";

  static m8(username, chatname) => "${username}がチャットの名前を「${chatname}」に変更しました";

  static m9(username) => "${username}がチャットの権限を変更しました";

  static m10(username, displayname) =>
      "${username}が表示名を「${displayname}」に変更しました";

  static m11(username) => "${username}がゲストのアクセスルールを変更しました";

  static m12(username, rules) => "${username}がゲストのアクセスルールを${rules}に変更しました";

  static m13(username) => "${username}が履歴の表示設定を変更しました";

  static m14(username, rules) => "${username}が履歴の表示設定を${rules}に変更しました";

  static m15(username) => "${username}が参加ルールを変更しました";

  static m16(username, joinRules) => "${username}が参加ルールを${joinRules}に変更しました";

  static m17(username) => "${username}がアバターを変更しました";

  static m18(username) => "${username}が部屋のエイリアスを変更しました";

  static m19(username) => "${username}が招待リンクを変更しました";

  static m20(error) => "メッセージを解読できませんでした: ${error}";

  static m21(count) => "${count}名の参加者";

  static m22(username) => "${username}がチャットを作成しました";

  static m23(date, timeOfDay) => "${date}, ${timeOfDay}";

  static m24(year, month, day) => "${year}/${month}/${day}";

  static m25(month, day) => "${month}-${day}";

  static m26(senderName) => "${senderName}は通話を切断しました";

  static m27(displayname) => "${displayname}とグループを作成する";

  static m28(username, targetName) => "${targetName}の招待を${username}が取り下げました";

  static m29(groupName) => "連絡先から${groupName}に招待する";

  static m30(username, link) =>
      "${username}がFluffyChatにあなたを招待しました. \n1. FluffyChatをインストールしてください: https://fluffychat.im \n2. 新しくアカウントを作成するかサインインしてください\n3. 招待リンクを開いてください: ${link}";

  static m31(username, targetName) => "${username}が${targetName}を招待しました";

  static m32(username) => "${username}がチャットに参加しました";

  static m33(username, targetName) => "${username}は${targetName}をキックしました";

  static m34(username, targetName) => "${username}は${targetName}をキックしBANしました";

  static m35(localizedTimeShort) => "最終アクティブ: ${localizedTimeShort}";

  static m36(count) => "あと${count}名参加者を読み込む";

  static m37(homeserver) => "${homeserver}にログインする";

  static m38(number) => "${number}選択されています";

  static m39(fileName) => "${fileName}を再生する";

  static m40(username) => "${username}がイベントを編集しました";

  static m41(username) => "${username}は招待を拒否しました";

  static m42(username) => "${username}によって削除されました";

  static m43(username) => "${username}が既読";

  static m44(username, count) => "${username}と他${count}名が既読";

  static m45(username, username2) => "${username}と${username2}が既読";

  static m46(username) => "${username}はファイルを送信しました";

  static m47(username) => "${username}は画像を送信しました";

  static m48(username) => "${username}はステッカーを送信しました";

  static m49(username) => "${username}は動画を送信しました";

  static m50(username) => "${username}は音声を送信しました";

  static m51(senderName) => "${senderName}は通話情報を送信しました";

  static m52(username) => "${username}は現在地を共有しました";

  static m53(senderName) => "${senderName}は通話を開始しました";

  static m54(hours12, hours24, minutes, suffix) =>
      "${hours24}:${minutes} ${suffix}";

  static m55(username, targetName) => "${username}が${targetName}のBANを解除しました";

  static m56(type) => "未知のイベント\'${type}\'";

  static m57(unreadCount) => "${unreadCount}の未読メッセージ";

  static m58(unreadEvents) => "${unreadEvents}件の未読メッセージ";

  static m59(unreadEvents, unreadChats) =>
      "${unreadChats}で${unreadEvents}件の未読メッセージ";

  static m60(username, count) => "${username}と他${count}名が入力しています...";

  static m61(username, username2) => "${username}と${username2}が入力しています...";

  static m62(username) => "${username}が入力しています...";

  static m63(username) => "${username}は退室しました";

  static m64(username, type) => "${username}は${type}イベントを送信しました";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "(Optional) Group name":
            MessageLookupByLibrary.simpleMessage("(任意)グループ名"),
        "About": MessageLookupByLibrary.simpleMessage("このアプリについて"),
        "Accept": MessageLookupByLibrary.simpleMessage("承諾する"),
        "Account": MessageLookupByLibrary.simpleMessage("アカウント"),
        "Account informations": MessageLookupByLibrary.simpleMessage("アカウント情報"),
        "Add a group description":
            MessageLookupByLibrary.simpleMessage("グループの説明を追加する"),
        "Admin": MessageLookupByLibrary.simpleMessage("管理者"),
        "Already have an account?":
            MessageLookupByLibrary.simpleMessage("アカウントをすでにお持ちですか？"),
        "Anyone can join": MessageLookupByLibrary.simpleMessage("誰でも参加できる"),
        "Archive": MessageLookupByLibrary.simpleMessage("アーカイブ"),
        "Archived Room": MessageLookupByLibrary.simpleMessage("アーカイブされた部屋"),
        "Are guest users allowed to join":
            MessageLookupByLibrary.simpleMessage("ゲストユーザーの参加を許可する"),
        "Are you sure?": MessageLookupByLibrary.simpleMessage("これでよろしいですか？"),
        "Authentication": MessageLookupByLibrary.simpleMessage("認証"),
        "Avatar has been changed":
            MessageLookupByLibrary.simpleMessage("アバターが変更されました"),
        "Ban from chat": MessageLookupByLibrary.simpleMessage("チャットからBANする"),
        "Banned": MessageLookupByLibrary.simpleMessage("BANされています"),
        "Block Device": MessageLookupByLibrary.simpleMessage("デバイスをブロックする"),
        "Cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "Change the homeserver":
            MessageLookupByLibrary.simpleMessage("ホームサーバーの変更"),
        "Change the name of the group":
            MessageLookupByLibrary.simpleMessage("グループの名前を変更する"),
        "Change the server": MessageLookupByLibrary.simpleMessage("サーバーを変更する"),
        "Change wallpaper": MessageLookupByLibrary.simpleMessage("壁紙を変更する"),
        "Change your style": MessageLookupByLibrary.simpleMessage("スタイルを変更する"),
        "Changelog": MessageLookupByLibrary.simpleMessage("変更履歴"),
        "Chat": MessageLookupByLibrary.simpleMessage("チャット"),
        "Chat details": MessageLookupByLibrary.simpleMessage("チャットの詳細"),
        "Choose a strong password":
            MessageLookupByLibrary.simpleMessage("強いパスワードを選択してください"),
        "Choose a username":
            MessageLookupByLibrary.simpleMessage("ユーザー名を選択してください"),
        "Close": MessageLookupByLibrary.simpleMessage("閉じる"),
        "Confirm": MessageLookupByLibrary.simpleMessage("確認"),
        "Connect": MessageLookupByLibrary.simpleMessage("接続"),
        "Connection attempt failed":
            MessageLookupByLibrary.simpleMessage("接続が失敗しました"),
        "Contact has been invited to the group":
            MessageLookupByLibrary.simpleMessage("連絡先に登録された人が招待されました"),
        "Content viewer": MessageLookupByLibrary.simpleMessage("コンテンツビューアー"),
        "Copied to clipboard":
            MessageLookupByLibrary.simpleMessage("クリップボードにコピーされました"),
        "Copy": MessageLookupByLibrary.simpleMessage("コピー"),
        "Could not set avatar":
            MessageLookupByLibrary.simpleMessage("アバターをセットできませんでした"),
        "Could not set displayname":
            MessageLookupByLibrary.simpleMessage("表示名をセットできませんでした"),
        "Create": MessageLookupByLibrary.simpleMessage("作成"),
        "Create account now":
            MessageLookupByLibrary.simpleMessage("アカウントを作成する"),
        "Create new group":
            MessageLookupByLibrary.simpleMessage("新しいグループを作成する"),
        "Currently active": MessageLookupByLibrary.simpleMessage("現在アクティブです"),
        "Dark": MessageLookupByLibrary.simpleMessage("ダーク"),
        "Delete": MessageLookupByLibrary.simpleMessage("削除"),
        "Delete message": MessageLookupByLibrary.simpleMessage("メッセージの削除"),
        "Deny": MessageLookupByLibrary.simpleMessage("拒否"),
        "Device": MessageLookupByLibrary.simpleMessage("デバイス"),
        "Devices": MessageLookupByLibrary.simpleMessage("デバイス"),
        "Discard picture": MessageLookupByLibrary.simpleMessage("画像を無視する"),
        "Displayname has been changed":
            MessageLookupByLibrary.simpleMessage("表示名が変更されました"),
        "Donate": MessageLookupByLibrary.simpleMessage("寄付する"),
        "Download file": MessageLookupByLibrary.simpleMessage("ファイルのダウンロード"),
        "Edit Jitsi instance":
            MessageLookupByLibrary.simpleMessage("Jitsiインスタンスを編集する"),
        "Edit displayname": MessageLookupByLibrary.simpleMessage("表示名を編集"),
        "Emote Settings": MessageLookupByLibrary.simpleMessage("Emote設定"),
        "Emote shortcode": MessageLookupByLibrary.simpleMessage("Emoteショートコード"),
        "Empty chat": MessageLookupByLibrary.simpleMessage("空のチャット"),
        "Encryption": MessageLookupByLibrary.simpleMessage("暗号化"),
        "Encryption algorithm":
            MessageLookupByLibrary.simpleMessage("暗号化アルゴリズム"),
        "Encryption is not enabled":
            MessageLookupByLibrary.simpleMessage("暗号化されていません"),
        "End to end encryption is currently in Beta! Use at your own risk!":
            MessageLookupByLibrary.simpleMessage(
                "エンドツーエンド暗号化は現在ベータ版です！これは自分自身の責任で行ってください！"),
        "End-to-end encryption settings":
            MessageLookupByLibrary.simpleMessage("エンドツーエンド暗号化設定"),
        "Enter a group name":
            MessageLookupByLibrary.simpleMessage("グループ名を入力してください"),
        "Enter a username":
            MessageLookupByLibrary.simpleMessage("ユーザー名を入力してください"),
        "Enter your homeserver":
            MessageLookupByLibrary.simpleMessage("ホームサーバーを入力してください"),
        "File name": MessageLookupByLibrary.simpleMessage("ファイル名"),
        "File size": MessageLookupByLibrary.simpleMessage("ファイルサイズ"),
        "FluffyChat": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "Forward": MessageLookupByLibrary.simpleMessage("進む"),
        "Friday": MessageLookupByLibrary.simpleMessage("金曜日"),
        "From joining": MessageLookupByLibrary.simpleMessage("参加時点から閲覧可能"),
        "From the invitation":
            MessageLookupByLibrary.simpleMessage("招待時点から閲覧可能"),
        "Group": MessageLookupByLibrary.simpleMessage("グループ"),
        "Group description": MessageLookupByLibrary.simpleMessage("グループの説明"),
        "Group description has been changed":
            MessageLookupByLibrary.simpleMessage("グループの説明が変更されました"),
        "Group is public":
            MessageLookupByLibrary.simpleMessage("グループは公開されています"),
        "Guests are forbidden":
            MessageLookupByLibrary.simpleMessage("ゲストは許可されていません"),
        "Guests can join": MessageLookupByLibrary.simpleMessage("ゲストが許可されています"),
        "Help": MessageLookupByLibrary.simpleMessage("ヘルプ"),
        "Homeserver is not compatible":
            MessageLookupByLibrary.simpleMessage("このホームサーバーは互換性がありません"),
        "How are you today?": MessageLookupByLibrary.simpleMessage("お元気ですか？"),
        "ID": MessageLookupByLibrary.simpleMessage("ID"),
        "Identity": MessageLookupByLibrary.simpleMessage("アイデンティティ"),
        "Invite contact": MessageLookupByLibrary.simpleMessage("連絡先から招待する"),
        "Invited": MessageLookupByLibrary.simpleMessage("招待されました"),
        "Invited users only":
            MessageLookupByLibrary.simpleMessage("招待されたユーザーのみ"),
        "It seems that you have no google services on your phone. That\'s a good decision for your privacy! To receive push notifications in FluffyChat we recommend using microG: https://microg.org/":
            MessageLookupByLibrary.simpleMessage(
                "あなたのスマホにはグーグルサービスがないようですね。プライバシーを保護するための良い選択です！Push通知を受け取るにはmicroGを使うことを推奨しています: https://microg.org/"),
        "Join room": MessageLookupByLibrary.simpleMessage("部屋に参加"),
        "Kick from chat": MessageLookupByLibrary.simpleMessage("チャットからキックする"),
        "Last seen IP": MessageLookupByLibrary.simpleMessage("最終IP"),
        "Leave": MessageLookupByLibrary.simpleMessage("退室する"),
        "Left the chat": MessageLookupByLibrary.simpleMessage("退室しました"),
        "License": MessageLookupByLibrary.simpleMessage("ライセンス"),
        "Light": MessageLookupByLibrary.simpleMessage("ライト"),
        "Load more...": MessageLookupByLibrary.simpleMessage("更に読み込む..."),
        "Loading... Please wait":
            MessageLookupByLibrary.simpleMessage("読み込み中...お待ちください"),
        "Login": MessageLookupByLibrary.simpleMessage("ログイン"),
        "Logout": MessageLookupByLibrary.simpleMessage("ログアウト"),
        "Make a moderator": MessageLookupByLibrary.simpleMessage("モデレータにする"),
        "Make an admin": MessageLookupByLibrary.simpleMessage("管理者にする"),
        "Make sure the identifier is valid":
            MessageLookupByLibrary.simpleMessage("識別子が正しいか確認してください"),
        "Message will be removed for all participants":
            MessageLookupByLibrary.simpleMessage("メッセージはすべての参加者から消去されます"),
        "Moderator": MessageLookupByLibrary.simpleMessage("モデレータ"),
        "Monday": MessageLookupByLibrary.simpleMessage("月曜日"),
        "Mute chat": MessageLookupByLibrary.simpleMessage("チャットのミュート"),
        "New message in FluffyChat":
            MessageLookupByLibrary.simpleMessage("FluffyChatに新しいメッセージがあります"),
        "New private chat":
            MessageLookupByLibrary.simpleMessage("新しいプライベートチャット"),
        "No emotes found. 😕":
            MessageLookupByLibrary.simpleMessage("Emoteは見つかりませんでした😕"),
        "No permission": MessageLookupByLibrary.simpleMessage("権限がありません"),
        "No rooms found...":
            MessageLookupByLibrary.simpleMessage("部屋は見つかりませんでした..."),
        "None": MessageLookupByLibrary.simpleMessage("なし"),
        "Not supported in web":
            MessageLookupByLibrary.simpleMessage("ウェブではサポートされていません"),
        "Oops something went wrong...":
            MessageLookupByLibrary.simpleMessage("おっと、何かがうまくいきませんでした..."),
        "Open app to read messages":
            MessageLookupByLibrary.simpleMessage("アプリを開いてメッセージを確認してください"),
        "Open camera": MessageLookupByLibrary.simpleMessage("カメラを開く"),
        "Participating user devices":
            MessageLookupByLibrary.simpleMessage("ユーザーの使用しているデバイス"),
        "Password": MessageLookupByLibrary.simpleMessage("パスワード"),
        "Pick image": MessageLookupByLibrary.simpleMessage("画像を選択してください"),
        "Pin": MessageLookupByLibrary.simpleMessage("ピン"),
        "Please be aware that you need Pantalaimon to use end-to-end encryption for now.":
            MessageLookupByLibrary.simpleMessage(
                "現時点では、エンドツーエンドの暗号化を使用するにはPantalaimonが必要であることに注意してください。"),
        "Please choose a username":
            MessageLookupByLibrary.simpleMessage("ユーザー名を選択してください"),
        "Please enter a matrix identifier":
            MessageLookupByLibrary.simpleMessage("Matrix識別子を入力してください"),
        "Please enter your password":
            MessageLookupByLibrary.simpleMessage("パスワードを入力してください"),
        "Please enter your username":
            MessageLookupByLibrary.simpleMessage("ユーザー名を入力してください"),
        "Public Rooms": MessageLookupByLibrary.simpleMessage("公開された部屋"),
        "Recording": MessageLookupByLibrary.simpleMessage("録音中"),
        "Reject": MessageLookupByLibrary.simpleMessage("拒否"),
        "Rejoin": MessageLookupByLibrary.simpleMessage("再参加"),
        "Remove": MessageLookupByLibrary.simpleMessage("消去"),
        "Remove all other devices":
            MessageLookupByLibrary.simpleMessage("他のデバイスをすべて削除"),
        "Remove device": MessageLookupByLibrary.simpleMessage("デバイスの削除"),
        "Remove exile": MessageLookupByLibrary.simpleMessage("追放を取り消し"),
        "Remove message": MessageLookupByLibrary.simpleMessage("メッセージを削除"),
        "Render rich message content":
            MessageLookupByLibrary.simpleMessage("リッチメッセージをレンダリングする"),
        "Reply": MessageLookupByLibrary.simpleMessage("返信"),
        "Request permission": MessageLookupByLibrary.simpleMessage("権限を要求する"),
        "Request to read older messages":
            MessageLookupByLibrary.simpleMessage("過去のメッセージを読む権限を要求する"),
        "Revoke all permissions":
            MessageLookupByLibrary.simpleMessage("すべての権限を取り消す"),
        "Room has been upgraded":
            MessageLookupByLibrary.simpleMessage("部屋はアップグレードされました"),
        "Saturday": MessageLookupByLibrary.simpleMessage("土曜日"),
        "Search for a chat": MessageLookupByLibrary.simpleMessage("チャットを検索する"),
        "Seen a long time ago": MessageLookupByLibrary.simpleMessage("ずいぶん前"),
        "Send": MessageLookupByLibrary.simpleMessage("送信"),
        "Send a message": MessageLookupByLibrary.simpleMessage("メッセージを送信"),
        "Send file": MessageLookupByLibrary.simpleMessage("ファイルを送信"),
        "Send image": MessageLookupByLibrary.simpleMessage("画像の送信"),
        "Set a profile picture":
            MessageLookupByLibrary.simpleMessage("プロフィール画像を設定する"),
        "Set group description":
            MessageLookupByLibrary.simpleMessage("グループの説明を設定する"),
        "Set invitation link":
            MessageLookupByLibrary.simpleMessage("招待リンクを設定する"),
        "Set status": MessageLookupByLibrary.simpleMessage("ステータスの設定"),
        "Settings": MessageLookupByLibrary.simpleMessage("設定"),
        "Share": MessageLookupByLibrary.simpleMessage("共有"),
        "Sign up": MessageLookupByLibrary.simpleMessage("サインアップ"),
        "Skip": MessageLookupByLibrary.simpleMessage("スキップ"),
        "Source code": MessageLookupByLibrary.simpleMessage("ソースコード"),
        "Start your first chat :-)":
            MessageLookupByLibrary.simpleMessage("初めてのチャットを開始してください(^_^)"),
        "Submit": MessageLookupByLibrary.simpleMessage("送信"),
        "Sunday": MessageLookupByLibrary.simpleMessage("日曜日"),
        "System": MessageLookupByLibrary.simpleMessage("システム"),
        "Tap to show menu":
            MessageLookupByLibrary.simpleMessage("メニューを表示するにはタップしてください"),
        "The encryption has been corrupted":
            MessageLookupByLibrary.simpleMessage("暗号が破損しています"),
        "They Don\'t Match": MessageLookupByLibrary.simpleMessage("違います"),
        "They Match": MessageLookupByLibrary.simpleMessage("一致しています"),
        "This room has been archived.":
            MessageLookupByLibrary.simpleMessage("この部屋はアーカイブされています。"),
        "Thursday": MessageLookupByLibrary.simpleMessage("木曜日"),
        "Try to send again": MessageLookupByLibrary.simpleMessage("送信し直してみる"),
        "Tuesday": MessageLookupByLibrary.simpleMessage("火曜日"),
        "Unblock Device": MessageLookupByLibrary.simpleMessage("デバイスをブロック解除する"),
        "Unknown device": MessageLookupByLibrary.simpleMessage("未知デバイス"),
        "Unknown encryption algorithm":
            MessageLookupByLibrary.simpleMessage("未知の暗号化アルゴリズム"),
        "Unmute chat": MessageLookupByLibrary.simpleMessage("チャットをミュート解除する"),
        "Unpin": MessageLookupByLibrary.simpleMessage("ピンを外す"),
        "Use Amoled compatible colors?":
            MessageLookupByLibrary.simpleMessage("有機EL(Amoled)対応の色にしますか？"),
        "Username": MessageLookupByLibrary.simpleMessage("ユーザー名"),
        "Verify": MessageLookupByLibrary.simpleMessage("確認"),
        "Verify User": MessageLookupByLibrary.simpleMessage("ユーザーの認証"),
        "Video call": MessageLookupByLibrary.simpleMessage("音声通話"),
        "Visibility of the chat history":
            MessageLookupByLibrary.simpleMessage("チャット履歴の表示"),
        "Visible for all participants":
            MessageLookupByLibrary.simpleMessage("すべての参加者が閲覧可能"),
        "Visible for everyone":
            MessageLookupByLibrary.simpleMessage("すべての人が閲覧可能"),
        "Voice message": MessageLookupByLibrary.simpleMessage("ボイスメッセージ"),
        "Wallpaper": MessageLookupByLibrary.simpleMessage("壁紙"),
        "Wednesday": MessageLookupByLibrary.simpleMessage("水曜日"),
        "Welcome to the cutest instant messenger in the matrix network.":
            MessageLookupByLibrary.simpleMessage(
                "matrixネットワークで一番かわいいチャットアプリへようこそ。"),
        "Who is allowed to join this group":
            MessageLookupByLibrary.simpleMessage("誰がこのチャットに入れますか"),
        "Write a message...":
            MessageLookupByLibrary.simpleMessage("メッセージを入力してください..."),
        "Yes": MessageLookupByLibrary.simpleMessage("はい"),
        "You": MessageLookupByLibrary.simpleMessage("あなた"),
        "You are invited to this chat":
            MessageLookupByLibrary.simpleMessage("チャットに招待されています"),
        "You are no longer participating in this chat":
            MessageLookupByLibrary.simpleMessage("あなたはもうこのチャットの参加者ではありません"),
        "You cannot invite yourself":
            MessageLookupByLibrary.simpleMessage("自分自身を招待することはできません"),
        "You have been banned from this chat":
            MessageLookupByLibrary.simpleMessage("チャットからBANされてしまいました"),
        "You won\'t be able to disable the encryption anymore. Are you sure?":
            MessageLookupByLibrary.simpleMessage(
                "一度暗号化を有効にするともとに戻せません。よろしいですか？"),
        "Your own username": MessageLookupByLibrary.simpleMessage("あなたのユーザー名"),
        "acceptedTheInvitation": m0,
        "activatedEndToEndEncryption": m1,
        "alias": MessageLookupByLibrary.simpleMessage("エイリアス"),
        "answeredTheCall": m2,
        "askSSSSCache": MessageLookupByLibrary.simpleMessage(
            "鍵をキャッシュするためにはパスフレーズやリカバリーキーを入力してください。"),
        "askSSSSSign": MessageLookupByLibrary.simpleMessage(
            "他の人を署名するためにはパスフレーズやリカバリーキーを入力してください。"),
        "askSSSSVerify": MessageLookupByLibrary.simpleMessage(
            "セッションを検証するためにはパスフレーズやリカバリーキーを入力してください。"),
        "askVerificationRequest": m3,
        "bannedUser": m4,
        "byDefaultYouWillBeConnectedTo": m5,
        "cachedKeys": MessageLookupByLibrary.simpleMessage("鍵のキャッシュに成功しました！"),
        "changedTheChatAvatar": m6,
        "changedTheChatDescriptionTo": m7,
        "changedTheChatNameTo": m8,
        "changedTheChatPermissions": m9,
        "changedTheDisplaynameTo": m10,
        "changedTheGuestAccessRules": m11,
        "changedTheGuestAccessRulesTo": m12,
        "changedTheHistoryVisibility": m13,
        "changedTheHistoryVisibilityTo": m14,
        "changedTheJoinRules": m15,
        "changedTheJoinRulesTo": m16,
        "changedTheProfileAvatar": m17,
        "changedTheRoomAliases": m18,
        "changedTheRoomInvitationLink": m19,
        "compareEmojiMatch": MessageLookupByLibrary.simpleMessage(
            "表示されている絵文字が他のデバイスで表示されているものと一致するか確認してください:"),
        "compareNumbersMatch": MessageLookupByLibrary.simpleMessage(
            "表示されている数字が他のデバイスで表示されているものと一致するか確認してください:"),
        "couldNotDecryptMessage": m20,
        "countParticipants": m21,
        "createdTheChat": m22,
        "crossSigningDisabled":
            MessageLookupByLibrary.simpleMessage("相互署名は使えません"),
        "crossSigningEnabled":
            MessageLookupByLibrary.simpleMessage("相互署名が使えます"),
        "dateAndTimeOfDay": m23,
        "dateWithYear": m24,
        "dateWithoutYear": m25,
        "emoteExists": MessageLookupByLibrary.simpleMessage("Emoteはすでに存在します！"),
        "emoteInvalid":
            MessageLookupByLibrary.simpleMessage("不正なEmoteショートコード！"),
        "emoteWarnNeedToPick":
            MessageLookupByLibrary.simpleMessage("Emoteショートコードと画像を選択してください！"),
        "endedTheCall": m26,
        "groupWith": m27,
        "hasWithdrawnTheInvitationFor": m28,
        "incorrectPassphraseOrKey":
            MessageLookupByLibrary.simpleMessage("パスフレーズかリカバリーキーが間違っています"),
        "inviteContactToGroup": m29,
        "inviteText": m30,
        "invitedUser": m31,
        "is typing...": MessageLookupByLibrary.simpleMessage("入力しています..."),
        "isDeviceKeyCorrect":
            MessageLookupByLibrary.simpleMessage("このデバイスキーは正しいですか？"),
        "joinedTheChat": m32,
        "keysCached": MessageLookupByLibrary.simpleMessage("鍵はキャッシュされたいます"),
        "keysMissing": MessageLookupByLibrary.simpleMessage("鍵がありません"),
        "kicked": m33,
        "kickedAndBanned": m34,
        "lastActiveAgo": m35,
        "loadCountMoreParticipants": m36,
        "logInTo": m37,
        "newVerificationRequest":
            MessageLookupByLibrary.simpleMessage("新しい認証リクエスト！"),
        "noCrossSignBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChatは現在相互署名機能をサポートしていません。Riotから有効化してください。"),
        "noMegolmBootstrap": MessageLookupByLibrary.simpleMessage(
            "FluffyChatは現在鍵のオンラインバックアップの有効化をサポートしていません。Riotから有効化してください。"),
        "numberSelected": m38,
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "onlineKeyBackupDisabled":
            MessageLookupByLibrary.simpleMessage("オンライン鍵バックアップは使用されていません"),
        "onlineKeyBackupEnabled":
            MessageLookupByLibrary.simpleMessage("オンライン鍵バックアップは使用されています"),
        "passphraseOrKey":
            MessageLookupByLibrary.simpleMessage("パスフレーズかリカバリーキー"),
        "play": m39,
        "redactedAnEvent": m40,
        "rejectedTheInvitation": m41,
        "removedBy": m42,
        "seenByUser": m43,
        "seenByUserAndCountOthers": m44,
        "seenByUserAndUser": m45,
        "sentAFile": m46,
        "sentAPicture": m47,
        "sentASticker": m48,
        "sentAVideo": m49,
        "sentAnAudio": m50,
        "sentCallInformations": m51,
        "sessionVerified": MessageLookupByLibrary.simpleMessage("セッションは確認済みです"),
        "sharedTheLocation": m52,
        "startedACall": m53,
        "timeOfDay": m54,
        "title": MessageLookupByLibrary.simpleMessage("FluffyChat"),
        "unbannedUser": m55,
        "unknownEvent": m56,
        "unknownSessionVerify":
            MessageLookupByLibrary.simpleMessage("未知のセッションです。確認してください。"),
        "unreadChats": m57,
        "unreadMessages": m58,
        "unreadMessagesInChats": m59,
        "userAndOthersAreTyping": m60,
        "userAndUserAreTyping": m61,
        "userIsTyping": m62,
        "userLeftTheChat": m63,
        "userSentUnknownEvent": m64,
        "verifiedSession":
            MessageLookupByLibrary.simpleMessage("セッションの確認ができました！"),
        "verifyManual": MessageLookupByLibrary.simpleMessage("手動で確認"),
        "verifyStart": MessageLookupByLibrary.simpleMessage("確認を始める"),
        "verifySuccess": MessageLookupByLibrary.simpleMessage("確認が完了しました！"),
        "verifyTitle": MessageLookupByLibrary.simpleMessage("他のアカウントを確認中"),
        "waitingPartnerAcceptRequest":
            MessageLookupByLibrary.simpleMessage("パートナーのリクエスト承諾待ちです..."),
        "waitingPartnerEmoji":
            MessageLookupByLibrary.simpleMessage("パートナーの絵文字承諾待ちです..."),
        "waitingPartnerNumbers":
            MessageLookupByLibrary.simpleMessage("パートナーの数字承諾待ちです...")
      };
}
