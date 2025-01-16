import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandTitleBar extends StatelessWidget {
  const BrandTitleBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SvgPicture.asset(
              'assets/svgs/arrow-left.svg',
              height: 24,
              width: 24,
            ),
          ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins().copyWith(
                color: Color(0xff2A2A2A),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}
