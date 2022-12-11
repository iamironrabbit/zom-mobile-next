import 'package:fluffychat/pages/connect/connect_page.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'sso_button.dart';

class ConnectPageView extends StatelessWidget {
  final ConnectPageController controller;
  const ConnectPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final identityProviders = controller.identityProviders;
    return LoginScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          if (Matrix.of(context).loginRegistrationSupported ?? false) ...[
            Image.asset('assets/login_wallpaper.png', width: double.infinity),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: 'loginButton',
                child: TextButton(
                  onPressed: controller.loading ? () {} : controller.signUpUser,
                  child: controller.loading
                      ? const LinearProgressIndicator()
                      : Text(
                          L10n.of(context)!.createAccountNow,
                          style: const TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ),
          ],
          if (controller.supportsSso)
            identityProviders == null
                ? const SizedBox(
                    height: 74,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  )
                : Center(
                    child: identityProviders.length == 1
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              icon: identityProviders.single.icon == null
                                  ? const Icon(
                                      Icons.web_outlined,
                                      size: 16,
                                    )
                                  : Image.network(
                                      Uri.parse(identityProviders.single.icon!)
                                          .getDownloadLink(Matrix.of(context)
                                              .getLoginClient())
                                          .toString(),
                                      width: 32,
                                      height: 32,
                                    ),
                              onPressed: () => controller
                                  .ssoLoginAction(identityProviders.single.id!),
                              label: Text(identityProviders.single.name ??
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
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: controller.loading ? () {} : controller.login,
                  child: Text(L10n.of(context)!.signInMessage,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
