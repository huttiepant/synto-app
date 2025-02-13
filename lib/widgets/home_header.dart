import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/ui/brand_dropdown.dart';

import '../ui/brand_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.books});

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
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
                'Choose the book you\'re about to read',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins().copyWith(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Color(0xfff7f7f7)),
              ),
              SizedBox(height: 4),
              Text(
                'We currently have a small list of books that you can choose'
                'to read. That’s because each of the activities, questions and'
                'challenges are designed by Philosophy professionals to'
                'ensure the biggest boost to your reading skills. If you want a'
                'new book added, scroll to the bottom and send a request.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
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
                    context.router.pushNamed('/choice');
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
