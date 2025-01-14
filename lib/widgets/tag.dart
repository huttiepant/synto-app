import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Tag extends StatefulWidget {
  const Tag({
    super.key,
    required this.tag,
    required this.onTap,
    required this.selected,
  });

  final String tag;
  final bool selected;
  final void Function(String tag) onTap;

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onTap(widget.tag);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 6.5,
            horizontal: 19,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.selected ? Colors.black : Color(0xffEAEBFF)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.tag,
                textAlign: widget.selected ? TextAlign.left : TextAlign.center,
                style: GoogleFonts.inter().copyWith(
                  color: widget.selected ? Colors.white : Color(0xff414141),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.selected)
                GestureDetector(
                  onTap: () {
                    widget.onTap(widget.tag);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/close.svg',
                    width: 13,
                    height: 14,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
