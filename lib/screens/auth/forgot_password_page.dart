import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:synto_app/popups/information_popup.dart';
import 'package:synto_app/screens/auth/auth_page.dart';
import 'package:synto_app/screens/auth/sign_up_page.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_input_field.dart';
import 'package:toastification/toastification.dart';
import '../../api/services/auth_service.dart';
import '../../ui/brand_colors.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  void showInformationDialog(
      BuildContext context, String name, String info, VoidCallback onTap) {
    showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return InformationPopup(title: name, info: info, onTap: onTap);
      },
    );
  }

  Future<void> _handleForgotPasswordTap() async {
    final form = _formKey.currentState;

    if (form == null) return;
    form.save();
    if (!form.validate()) return;
    final values = _formKey.currentState?.value;
    final email = values?['email'];
    context.loaderOverlay.show();
    GetIt.instance<AuthService>().sendPasswordResetEmail(email).then((_) {
      showInformationDialog(
          context,
          'Reset Email Sent',
          'We\'ve sent you an email with instructions to reset your password. Please check your inbox and follow the link to create a new password.',
          () => context.router.pushNamed('/auth'));
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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Retrieve password',
                style: GoogleFonts.inter().copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.64),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Enter email to retrieve password',
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
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email()
                ]),
                selectAllOnFocus: false,
              ),
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.inter().copyWith(
                          color: Color(0xff6C7278),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.12),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthPage()),
                        );
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
              ),
              SizedBox(
                height: 24,
              ),
              Wrap(
                runSpacing: 10,
                children: [
                  BrandButton(
                      onTap: () {
                        _handleForgotPasswordTap();
                      },
                      border: Border.all(color: Colors.white, width: 1),
                      text: 'Retrieve Password',
                      color: brandLightBlue,
                      textColor: Colors.white)
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?',
                    style: GoogleFonts.inter().copyWith(
                        color: Color(0xff6C7278),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.12),
                  ),
                  SizedBox(
                    width: 6,
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
