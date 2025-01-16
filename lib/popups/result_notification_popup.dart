import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_title_bar.dart';

import '../ui/brand_colors.dart';

class ResultNotificationPopup extends StatelessWidget {
  const ResultNotificationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: BrandTitleBar(title: ''),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
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
                Text(
                  'Correct',
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
                  "Lorum ipsum fhjhf hdfhdsjfhdsfjh sdfjh dsfjhdsjfhds jfhdsf",
                ),
                SizedBox(height: 32),
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
          )
        ],
      )),
    );
  }
}
