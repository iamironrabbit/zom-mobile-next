import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pages/connect/connect_page.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'sso_button.dart';

class ConnectPageView extends StatelessWidget {
  final ConnectPageController controller;
  const ConnectPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatar = Matrix.of(context).loginAvatar;
    final identityProviders = controller.identityProviders;
    return LoginScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !controller.loading,
        centerTitle: true,
        title: Text(
          Matrix.of(context).getLoginClient().homeserver?.host ?? '',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          if (Matrix.of(context).loginRegistrationSupported ?? false) ...[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Stack(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(64),
                      elevation: 10,
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white.withAlpha(200),
                        child: avatar == null
                            ? const Icon(
                                Icons.person_outlined,
                                color: Colors.black,
                                size: 64,
                              )
                            : FutureBuilder<Uint8List>(
                                future: avatar.readAsBytes(),
                                builder: (context, snapshot) {
                                  final bytes = snapshot.data;
                                  if (bytes == null) {
                                    return const CircularProgressIndicator
                                        .adaptive();
                                  }
                                  return Image.memory(
                                    bytes,
                                    fit: BoxFit.cover,
                                    width: 128,
                                    height: 128,
                                  );
                                },
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: controller.pickAvatar,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller.usernameController,
                onSubmitted: (_) => controller.signUp(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box_outlined),
                  hintText: L10n.of(context)!.chooseAUsername,
                  errorText: controller.signupError,
                  errorStyle: const TextStyle(color: Colors.orange),
                  fillColor: Theme.of(context)
                      .colorScheme
                      .background
                      .withOpacity(0.75),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: 'loginButton',
                child: ElevatedButton(
                  onPressed: controller.loading ? () {} : controller.signUp,
                  child: controller.loading
                      ? const LinearProgressIndicator()
                      : Text(L10n.of(context)!.signUp),
                ),
              ),
            ),
            Row(
              children: [
                const Expanded(
                    child: Divider(
                  color: Colors.white,
                  thickness: 1,
                )),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    L10n.of(context)!.or,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Expanded(
                    child: Divider(
                  color: Colors.white,
                  thickness: 1,
                )),
              ],
            ),
          ],
          if (controller.supportsSso)
            identityProviders == null
                ? const SizedBox(
                    height: 74,
                    child: Center(
                        child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    )),
                  )
                : Center(
                    child: identityProviders.length == 1
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ElevatedButton(
                              onPressed: () => controller
                                  .ssoLoginAction(identityProviders.single.id!),
                              child: Text(identityProviders.single.name ??
                                  identityProviders.single.brand ??
                                  L10n.of(context)!.loginWithOneClick),
                            ),
                          )
                        : Wrap(
                            children: [
                              for (final identityProvider in identityProviders)
                                SsoButton(
                                  onPressed: () => controller
                                      .ssoLoginAction(identityProvider.id!),
                                  identityProvider: identityProvider,
                                ),
                            ].toList(),
                          ),
                  ),
          if (controller.supportsLogin)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: 'signinButton',
                child: ElevatedButton(
                  onPressed: controller.loading ? () {} : controller.login,
                  child: Text(L10n.of(context)!.login),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
