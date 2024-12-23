import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandButton extends StatelessWidget {
  const BrandButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.textColor,
    this.border,
  });

  final VoidCallback? onTap;
  final BoxBorder? border;
  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(50),
        color: color,
        child: InkWell(
            onTap: onTap,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: border,
                ),
                child: Center(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(text,
                            style: GoogleFonts.notoSans().copyWith(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                      )
                    ])))));
  }
}
