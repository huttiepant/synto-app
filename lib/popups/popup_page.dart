import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class PopupPage extends StatelessWidget {
  const PopupPage({super.key, this.step});

  final ReadingStep? step;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 213,
              height: 248,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/popover-person.png',
                      ),
                      fit: BoxFit.contain)),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Great call! This is your first step to becoming an expert reader.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins().copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2A2A2A)),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 32),
              child: Text(
                  style: GoogleFonts.poppins()
                      .copyWith(fontSize: 15, color: Color(0xff5A5A5A)),
                  textAlign: TextAlign.center,
                  "Expert readers: \n\n1. Remember more of what they read\n2. Apply more of what they read in everyday life.\n3. Know how to think independently and critically.\n\nAnd these benefits don’t just go for when they’re reading!"),
            ),
            BrandButton(
                onTap: () {
                  if (step != null) {
                    context.router.replaceNamed('/$step');
                  } else {
                    context.router.replaceNamed('/');
                  }
                },
                border: Border.all(color: Colors.white, width: 1),
                text: 'Sounds Good',
                color: brandLightBlue,
                textColor: Colors.white)
          ],
        ),
      )),
    );
  }
}
