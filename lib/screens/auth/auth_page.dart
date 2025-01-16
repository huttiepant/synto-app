import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:synto_app/screens/auth/sign_up_page.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_input_field.dart';
import 'package:toastification/toastification.dart';
import '../../api/services/auth_service.dart';
import '../../ui/brand_colors.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _handleLoginTap() async {
    final form = _formKey.currentState;
    if (form == null) return;
    form.save();
    if (!form.validate()) return;
    final values = _formKey.currentState?.value;
    final email = values?['email'];
    final password = values?['password'];
    context.loaderOverlay.show();
    GetIt.instance<AuthService>()
        .loginWithCredentials(email, password)
        .then((_) {
      context.router.replaceNamed('/choice');
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: FormBuilder(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign in to your Account',
                style: GoogleFonts.inter().copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.64),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Enter your email and password to log in',
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
                name: 'email',
                title: 'Email',
                hint: 'Email address',
                expands: false,
                inputType: TextInputType.emailAddress,
                selectAllOnFocus: false,
              ),
              SizedBox(
                height: 16,
              ),
              BrandInputField(
                name: 'password',
                title: 'Password',
                hint: 'Password',
                expands: false,
                obscureText: true,
                inputType: TextInputType.text,
                selectAllOnFocus: false,
              ),
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot Password ?',
                    style: GoogleFonts.inter().copyWith(
                        color: Color(0xff4D81E7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.12),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Wrap(
                runSpacing: 10,
                children: [
                  BrandButton(
                      onTap: () {
                        _handleLoginTap();
                      },
                      border: Border.all(color: Colors.white, width: 1),
                      text: 'Log In',
                      color: brandLightBlue,
                      textColor: Colors.white)
                ],
              ),
              Spacer(),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                children: [
                  Text(
                    'Don’t have an account?',
                    style: GoogleFonts.inter().copyWith(
                        color: Color(0xff6C7278),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.12),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
