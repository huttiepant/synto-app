import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BookTag extends StatefulWidget {
  const BookTag({
    super.key,
    required this.title,
    required this.onTap,
    required this.selected,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<BookTag> createState() => _BookTagState();
}

class _BookTagState extends State<BookTag> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 18),
        decoration: BoxDecoration(
          color: widget.selected ? Color(0xff304FFE) : Color(0xffBDC1CA),
          border: Border.all(
              color: widget.selected ? Color(0xff304FFE) : Color(0xffBDC1CA),
              width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/svgs/book.svg',
              height: 16,
              width: 16,
            ),
            SizedBox(width: 4),
            Text(
              widget.title,
              style: GoogleFonts.poppins().copyWith(
                color: widget.selected ? Color(0xffFFFFFF) : Color(0xff2A2A2A),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
