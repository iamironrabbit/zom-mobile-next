import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      appBar: AppBar(
        leading: controller.loading ? null : const BackButton(),
        automaticallyImplyLeading: !controller.loading,
        centerTitle: true,
        title: Text(L10n.of(context)!.signIn),
      ),
      body: Builder(builder: (context) {
        return AutofillGroup(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  readOnly: controller.loading,
                  autocorrect: false,
                  autofocus: true,
                  onChanged: controller.checkWellKnownWithCoolDown,
                  controller: controller.usernameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  autofillHints:
                      controller.loading ? null : [AutofillHints.username],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.account_box_outlined),
                    errorText: controller.usernameError,
                    errorStyle: const TextStyle(color: Colors.orange),
                    hintText: L10n.of(context)!.username,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  readOnly: controller.loading,
                  autocorrect: false,
                  autofillHints:
                      controller.loading ? null : [AutofillHints.password],
                  controller: controller.passwordController,
                  textInputAction: TextInputAction.go,
                  obscureText: !controller.showPassword,
                  onSubmitted: controller.login,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outlined),
                    errorText: controller.passwordError,
                    errorStyle: const TextStyle(color: Colors.orange),
                    suffixIcon: IconButton(
                      onPressed: controller.toggleShowPassword,
                      icon: Icon(
                        controller.showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black,
                      ),
                    ),
                    hintText: L10n.of(context)!.password,
                  ),
                ),
              ),
              Hero(
                tag: 'signinButton',
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: controller.loading
                        ? null
                        : () => controller.login(context),
                    child: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context)!.login),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
