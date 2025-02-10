import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class InformationPopup extends StatelessWidget {
  const InformationPopup({super.key, required this.title, required this.info});

  final String title;
  final String info;

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
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins().copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff2A2A2A)),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          style: GoogleFonts.poppins()
                              .copyWith(fontSize: 15, color: Color(0xff5A5A5A)),
                          textAlign: TextAlign.center,
                          info,
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
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
              text: 'Ok',
              color: brandLightBlue,
              textColor: Colors.white,
            )
          ],
        ),
      )),
    );
  }
}
