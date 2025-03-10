import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_dropdown.dart';

import '../ui/brand_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final BooksService booksService = BooksService();

    return Container(
      color: brandLightBlue,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 54,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/book.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Choose a book. \n We\'ll help you master it.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins().copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xfff7f7f7)),
              ),
              SizedBox(height: 4),
              Text(
                'We’ll take you beyond the pages with guided challenges, thought-provoking questions, and deep insights. \n \n We currently offer 15 books, but we’re always expanding. Want a book added? Let us know!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffD0D0D0)),
              ),
              SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 76),
                child: BrandDropdown<Book>(
                  title: 'Pick a Book',
                  onSelect: (book) {
                    // booksService.resetBookProgress(book.id);
                    // return;
                    booksService.selectBook(book.id);
                    final step = booksService.getCurrentBookStep(book.id);
                    context.router.pushNamed('/$step');
                  },
                  options: books
                      .map((Book book) =>
                          DropDownOption<Book>(title: book.name, value: book))
                      .toList(),
                ),
              ),
            ],
          )),
    );
  }
}
