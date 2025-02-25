import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/popups/information_popup.dart';
import 'package:synto_app/services/books_service.dart';

import '../ui/brand_button.dart';
import '../ui/brand_colors.dart';

class BookWidget extends StatelessWidget {
  BookWidget({super.key, required this.book});

  final BooksService _booksService = BooksService();
  final Book book;


  void showInformationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return InformationPopup(
          title: book.name,
          info: book.info,
          themes: book.themes,
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
                      image: AssetImage('assets/books/${book.id}.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if(_booksService.getBookReadStatus(book.id))
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
                Expanded(
                  child: Text(
                    book.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff171A1F)),
                  ),
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
              book.author,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff9095A1)),
            ),
            SizedBox(height: 13),
            Text(
              book.description,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff9095A1)),
            ),
            // SizedBox(height: 19),
            // Text(
            //   '',
            //   style: GoogleFonts.inter().copyWith(
            //       fontSize: 14,
            //       fontWeight: FontWeight.w400,
            //       color: Color(0xff9095A1)),
            // ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BrandButton(
                    onTap: () {
                      _booksService.selectBook(book.id);
                      final step = _booksService.getCurrentBookStep(book.id);
                      context.router.pushNamed('/$step');
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
