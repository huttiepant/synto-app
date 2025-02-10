import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class OpenEndedResultNotificationPopup extends StatelessWidget {
  const OpenEndedResultNotificationPopup({super.key, required this.dialog});

  final String dialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      style: GoogleFonts.poppins()
                          .copyWith(fontSize: 15, color: Color(0xff5A5A5A)),
                      textAlign: TextAlign.center,
                      dialog,
                    ),
                    SizedBox(height: 32),

                  ],
                ),
              ),
            ),
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
