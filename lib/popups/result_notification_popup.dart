import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class ResultNotificationPopup extends StatelessWidget {
  const ResultNotificationPopup({super.key, required this.answer, this.correct});

  final Answer answer;
  final Answer? correct;

  @override
  Widget build(BuildContext context) {
    final isCorrect = answer.id == correct?.id;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
            SizedBox(
              height: 60,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (isCorrect) Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/success.png',
                            ),
                            fit: BoxFit.contain,
                          )),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                Text(
                  style: GoogleFonts.poppins()
                      .copyWith(fontSize: 15, color: Color(0xff5A5A5A)),
                  textAlign: TextAlign.center,
                  answer.dialogue,
                ),
                SizedBox(height: 32),

              ],
            ),
            Spacer(),
            BrandButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
              border: Border.all(color: Colors.white, width: 1),
              text: 'Next Question',
              color: brandLightBlue,
              textColor: Colors.white,
            )
                    ],
                  ),
          )),
    );
  }
}
