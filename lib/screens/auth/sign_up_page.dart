import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:reading_app/api/services/auth_service.dart';
import 'package:reading_app/screens/auth/create_account_page.dart';
import 'package:reading_app/ui/brand_button.dart';
import 'package:reading_app/ui/brand_colors.dart';
import 'package:reading_app/ui/brand_auth_title_bar.dart';
import 'package:toastification/toastification.dart';

import '../../ui/brand_input_field.dart';
import '../../widgets/brand_icon.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final authService = GetIt.instance<AuthService>();

  Future<void> _handleNextTap() async {
    final form = _formKey.currentState;
    if (form == null) return;
    form.save();
    if (!form.validate()) return;
    final values = _formKey.currentState?.value;
    final email = values?['email'];
    final password = values?['password'];
    context.loaderOverlay.show();
    authService.signUpWithCredentials(email, password).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateAccountPage()),
      );
    }).onError((String message, _) {
      toastification.show(
        context: context,
        description: Text(message),
        style: ToastificationStyle.flat,
        showProgressBar: false,
        closeOnClick: true,
        closeButtonShowType: CloseButtonShowType.none,
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }).whenComplete(() {
      context.loaderOverlay.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandBgDark,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: FormBuilder(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  BrandIcon(),
                  SizedBox(
                    height: 30,
                  ),
                  BrandAuthTitleBar(title: 'Sign up for Realize Music Sing'),
                  SizedBox(
                    height: 30,
                  ),
                  BrandInputField(
                    name: 'email',
                    title: 'email',
                    hint: 'Enter email',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                    expands: false,
                    inputType: TextInputType.emailAddress,
                    selectAllOnFocus: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BrandInputField(
                    name: 'password',
                    title: 'password',
                    hint: 'Enter password',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.password(),
                    ]),
                    expands: false,
                    obscureText: true,
                    inputType: TextInputType.text,
                    selectAllOnFocus: false,
                  ),
                ],
              ),
              Spacer(),
              BrandButton(
                onTap: () => _handleNextTap(),
                text: 'Next',
                color: brandOrange,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
