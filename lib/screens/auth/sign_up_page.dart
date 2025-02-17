import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:toastification/toastification.dart';

import '../../api/services/auth_service.dart';
import '../../popups/popup_page.dart';
import '../../ui/brand_colors.dart';
import '../../ui/brand_input_field.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final authService = GetIt.instance<AuthService>();

  Future<void> _handleSignUp() async {
    final form = _formKey.currentState;
    if (form == null) return;
    form.save();
    if (!form.validate()) return;
    final values = _formKey.currentState?.value;
    final email = values?['email'];
    final name = values?['name'];
    final password = values?['password'];
    context.loaderOverlay.show();
    authService.signUpWithCredentials(email, password, name).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PopupPage(),
          fullscreenDialog: true,
        ),
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
      backgroundColor: Colors.white,
      body: SafeArea(
          child: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Column(
            children: [
              Text(
                'Sign up',
                style: GoogleFonts.inter().copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.64),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Create an account to continue!',
                style: GoogleFonts.inter().copyWith(
                    fontSize: 12,
                    color: Color(0xff6C7278),
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.12),
              ),
              SizedBox(
                height: 32,
              ),
              BrandInputField(
                name: 'name',
                title: 'Full Name',
                hint: 'Full Name',
                expands: false,
                validator: FormBuilderValidators.required(),
                inputType: TextInputType.text,
                selectAllOnFocus: false,
              ),
              SizedBox(
                height: 16,
              ),
              BrandInputField(
                name: 'email',
                title: 'Email',
                hint: 'Email address',
                expands: false,
                inputType: TextInputType.emailAddress,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email()
                ]),
                selectAllOnFocus: false,
              ),
              SizedBox(
                height: 16,
              ),
              BrandInputField(
                name: 'password',
                title: 'Set Password',
                hint: 'Password',
                expands: false,
                obscureText: true,
                validator: FormBuilderValidators.required(),
                inputType: TextInputType.text,
                selectAllOnFocus: false,
              ),
              SizedBox(
                height: 24,
              ),
              Wrap(
                runSpacing: 10,
                children: [
                  BrandButton(
                      onTap: () {
                        _handleSignUp();
                      },
                      border: Border.all(color: Colors.white, width: 1),
                      text: 'Register',
                      color: brandLightBlue,
                      textColor: Colors.white)
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                children: [
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.inter().copyWith(
                        color: Color(0xff6C7278),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.12),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.inter().copyWith(
                          color: Color(0xff4D81E7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.12),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      )),
    );
  }
}
