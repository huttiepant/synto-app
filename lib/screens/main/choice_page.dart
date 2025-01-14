import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reading_app/screens/main/ideas_tagger_page.dart';
import 'package:reading_app/ui/brand_button.dart';
import 'package:reading_app/ui/brand_title_bar.dart';
import 'package:reading_app/widgets/book_tag.dart';

import '../../popups/result_notification_popup.dart';
import '../../ui/brand_colors.dart';

const List<String> readingLevel = ['Pre-Read', 'Reading', 'Post Read'];
const List<String> answers = [
  'Reading it quickly for an overview of its key ideas',
  'Taking notes and reflecting deeply on each section',
  'Reading it multiple times to uncover new layers of meaning',
  'Integrating its ideas into daily life as you go'
];

@RoutePage()
class ChoicePage extends StatefulWidget {
  const ChoicePage({super.key});

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  String? selectedLevel = readingLevel[0];
  bool ownIdea = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              BrandTitleBar(title: 'Meditations'),
              Text(
                '(Marcus Aurelius)',
                style: GoogleFonts.poppins().copyWith(
                  color: Color(0xff2A2A2A),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...readingLevel.map((level) => BookTag(
                        onTap: () {
                          selectedLevel = level;
                          setState(() {});
                        },
                        title: level,
                        selected: selectedLevel == level,
                      )),
                ],
              ),
              SizedBox(height: 26),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'How do you plan to approach the book?',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: GoogleFonts.poppins().copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 3,
                      ),
                      Divider(
                        color: Color(0xffE8E8E8).withOpacity(0.7),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      ...answers.map((answer) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ResultNotificationPopup(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 13),
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: brandLightBlue),
                              child: Text(
                                answer,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins().copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )),
                      SizedBox(height: 19),
                      GestureDetector(
                        onTap: () {
                          ownIdea = !ownIdea;
                          setState(() {});
                        },
                        child: Text(
                          'Freely enter your own idea:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins().copyWith(
                            color: ownIdea ? Colors.black : brandLightBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      if (ownIdea)
                        Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: GoogleFonts.poppins().copyWith(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 5,
                            ),
                            SizedBox(height: 20,),
                            BrandButton(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) => const IdeasTaggerPage(),
                                fullscreenDialog: true));
                              },
                              text: 'Submit',
                              color: brandLightBlue,
                              textColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            ),
                          ],
                        ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
