import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_input_field.dart';
import 'package:synto_app/ui/brand_title_bar.dart';
import 'package:synto_app/widgets/reading_step_widget.dart';
import 'package:synto_app/widgets/tag.dart';

import '../../ui/brand_colors.dart';

@RoutePage()
class IdeasTaggerPage extends StatefulWidget {
  const IdeasTaggerPage({super.key});

  @override
  State<IdeasTaggerPage> createState() => _IdeasTaggerPageState();
}

class _IdeasTaggerPageState extends State<IdeasTaggerPage> {
  bool ownIdea = false;
  final List<String> selectedTags = [];
  final List<String> tags = [
    'Aristocracy',
    'Science',
    'Politics',
    'Prudence',
    'Time',
  ];
  final BooksService _service = BooksService();
  final BooksService booksService = BooksService();
  final scrollController = ScrollController();
  Book? _book;
  ReadingStep? _step;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void onTagSelect(tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    setState(() {});
  }

  Future<void> _initialize() async {
    if (_service.selectedBookId == null) return;
    _book = _service.getBook(_service.selectedBookId!);
    _step = _service.getCurrentBookStep(_service.selectedBookId!);
    final savedTags = _service.getTags();
    if (savedTags != null) {
      tags.addAll(savedTags);
      selectedTags.addAll(savedTags);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            children: [
              Column(
                children: [
                  BrandTitleBar(
                    title: _book?.name ?? '',
                    onBack: () {
                      context.router.pushNamed('/');
                    },
                  ),
                  Text(
                    '(${_book?.author ?? ''})',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins().copyWith(
                      color: Color(0xff2A2A2A),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  ReadingStepWidget(
                    step: _step!,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 26, bottom: 10),
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        itemCount: tags.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 8,
                          mainAxisExtent: 36,
                          childAspectRatio: 36 / 161,
                        ),
                        itemBuilder: (context, index) {
                          final String tag = tags[index];
                          return Tag(
                            tag: tag,
                            onTap: onTagSelect,
                            selected: selectedTags.contains(tag),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              BrandInputField(
                name: 'tag',
                title: '',
                hint: 'Enter Your Own Tags Here',
                expands: true,
                inputType: TextInputType.text,
                selectAllOnFocus: true,
                onSubmit: (tag) async {
                  if (tag.isEmpty || tags.contains(tag)) return;
                  tags.add(tag);
                  selectedTags.add(tag);
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 150));
                  scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                },
              ),
              BrandButton(
                onTap: () async {
                  await _service.saveTags(selectedTags);
                  await _service.nextStep();
                  final step = booksService
                      .getCurrentBookStep(booksService.selectedBookId!);
                  context.router.pushNamed('/$step');
                },
                text: 'Start Reading',
                color: brandLightBlue,
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
