import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/popups/information_popup.dart';

import '../ui/brand_button.dart';
import '../ui/brand_colors.dart';

class BookWidget extends StatelessWidget {
  const BookWidget({super.key, required this.book});

  final Book book;

  void showInformationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return InformationPopup(
          book: book,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Divider(
        color: Color(0xffBDC1CA).withOpacity(0.4),
      ),
      Padding(
        padding: EdgeInsets.only(top: 16, left: 16, bottom: 26, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: 143,
                  height: 233,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(book.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: -14,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xff21FC80),
                      ),
                      child: Center(
                        child: Text('READ',
                            style: GoogleFonts.poppins().copyWith(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                      )),
                )
              ]),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meditations',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins().copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff171A1F)),
                ),
                GestureDetector(
                  onTap: () {
                    showInformationDialog(context);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/info.svg',
                    height: 24,
                    width: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Marcus Aurelius',
              textAlign: TextAlign.left,
              style: GoogleFonts.inter().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff9095A1)),
            ),
            SizedBox(height: 13),
            Text(
              'Meditations is for anyone who wants to live with purpose and inner calm, even when life feels chaotic. It’s often read by people looking to build resilience and find practical wisdom they can apply every day. If you’re exploring questions about leading a meaningful life or dealing with challenges, this book offers timeless advice from one of history’s greatest thinkers.',
              textAlign: TextAlign.left,
              style: GoogleFonts.inter().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff9095A1)),
            ),
            SizedBox(height: 19),
            Text(
              '#virtue #self-discipline #mortality #duty #resilience',
              style: GoogleFonts.inter().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff9095A1)),
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BrandButton(
                    onTap: () {
                      context.router.pushNamed('/choice');
                    },
                    text: 'Choose Book',
                    color: brandLightBlue,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18)),
              ],
            )
          ],
        ),
      ),
    ]);
  }
}
