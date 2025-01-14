import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reading_app/api/models/book.dart';
import 'package:reading_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class InformationPopup extends StatelessWidget {
  const InformationPopup({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  book.title,
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
                  book.description,
                ),
                SizedBox(height: 32),
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
          )
        ],
      )),
    );
  }
}
