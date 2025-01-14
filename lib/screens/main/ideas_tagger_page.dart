import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reading_app/ui/brand_button.dart';
import 'package:reading_app/ui/brand_input_field.dart';
import 'package:reading_app/ui/brand_title_bar.dart';
import 'package:reading_app/widgets/book_tag.dart';
import 'package:reading_app/widgets/tag.dart';

import '../../ui/brand_colors.dart';

const List<String> readingLevel = ['Pre-Read', 'Reading', 'Post Read'];

class IdeasTaggerPage extends StatefulWidget {
  const IdeasTaggerPage({super.key});

  @override
  State<IdeasTaggerPage> createState() => _IdeasTaggerPageState();
}

class _IdeasTaggerPageState extends State<IdeasTaggerPage> {
  String? selectedLevel = readingLevel[0];
  bool ownIdea = false;
  final List<String> selectedTags = [];

  void onTagSelect(tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    setState(() {});
  }

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
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Text(
                        'Big Ideas You’ll Find In This Book',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins().copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Books of such great importance have many Big Ideas in them. Being able to relate these across texts is a key attribute in an active reader. We help you identify some of the ideas and will show them later to you as you come across these ideas more and more. When you’re able to link your thoughts like this, you’ll become an unstoppable force.',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins().copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Tag(
                                  tag: 'Aristocracy',
                                  onTap: onTagSelect,
                                  selected:
                                      selectedTags.contains('Aristocracy'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Tag(
                                  tag: 'Science',
                                  onTap: onTagSelect,
                                  selected: selectedTags.contains('Science'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Tag(
                                  tag: 'Politics',
                                  onTap: onTagSelect,
                                  selected: selectedTags.contains('Politics'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Tag(
                                  tag: 'Prudence',
                                  onTap: onTagSelect,
                                  selected: selectedTags.contains('Prudence'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Tag(
                                  tag: 'Time',
                                  onTap: onTagSelect,
                                  selected: selectedTags.contains('Time'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Tag(
                                  tag: 'Immortality',
                                  onTap: onTagSelect,
                                  selected:
                                      selectedTags.contains('Immortality'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      BrandInputField(
                        name: 'tag',
                        title: '',
                        hint: 'Enter Your Own Tags Here',
                        expands: true,
                        inputType: TextInputType.text,
                        selectAllOnFocus: true,
                      ),
                      SizedBox(height: 10),
                      BrandButton(
                        onTap: () {},
                        text: 'Start Reading',
                        color: brandLightBlue,
                        textColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
