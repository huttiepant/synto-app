import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/api/models/while_reading_question.dart';
import 'package:synto_app/popups/information_popup.dart';
import 'package:synto_app/popups/open_ended_result_notification_popup.dart';
import 'package:synto_app/screens/main/post_reading_page.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_title_bar.dart';
import 'package:synto_app/widgets/reading_step_widget.dart';

import '../../ui/brand_colors.dart';

@RoutePage()
class WhileReadingPage extends StatefulWidget {
  const WhileReadingPage({super.key});

  @override
  State<WhileReadingPage> createState() => _WhileReadingPageState();
}

class _WhileReadingPageState extends State<WhileReadingPage> {
  final BooksService _service = BooksService();

  final _answerFieldController = TextEditingController();
  final _answerFieldFocusNode = FocusNode();
  final scrollController = ScrollController();

  Book? _book;
  ReadingStep? _step;
  WhileReadingQuestion? _currentQuestion;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void showInformationDialog(BuildContext context, String name, String info) {
    showDialog<void>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return InformationPopup(
          title: name,
          info: info,
        );
      },
    );
  }

  void fetchAndSetSelectedAnswer() {
    final String? answer =
        _service.getAnswerFromProgressByQuestionId(_currentQuestion?.id);
    if (answer != null) {
      _answerFieldController.text = answer;
    }
  }

  Future<void> _initialize() async {
    if (_service.selectedBookId == null) return;
    _book = _service.getBook(_service.selectedBookId!);
    _currentQuestion = _service.getCurrentQuestion();
    if (_currentQuestion == null) {
      await _service.nextStep();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PostReadingPage()),
      );
      return;
    }
    _step = _service.getCurrentBookStep(_service.selectedBookId!);
    fetchAndSetSelectedAnswer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null || _book == null) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()));
    }

    goToNextQuestion({bool skip = false}) async {
      final answer = _answerFieldController.text;
      await _service.answerQuestion(
        _currentQuestion!.id,
        skip ? '' : answer,
      );
      _answerFieldController.text = '';
      _answerFieldFocusNode.unfocus();

      final nextQuestion = _service.getCurrentQuestion();
      if (nextQuestion == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OpenEndedResultNotificationPopup(
              dialog:
                  'Congratulations! \n\n You’ve finished one of the most important books that has been written for humankind.\n We now have a set of challenges that have been designed to help you deepen your understanding of the book and apply the lessons in the book to life as it is today.',
              onTap: () async {
                await _service.nextStep();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PostReadingPage()),
                );
              },
            ),
            fullscreenDialog: true,
          ),
        );
      } else {
        _currentQuestion = nextQuestion;
        fetchAndSetSelectedAnswer();
        setState(() {});
      }
    }

    void goToPreviousQuestion() {
      _service.goToPreviousQuestion();
      final prevQuestion = _service.getCurrentQuestion();
      _currentQuestion = prevQuestion;
      fetchAndSetSelectedAnswer();
      setState(() => {});
    }

    final questionsCount = _service.getQuestionsCount();
    final currentQuestionIndex = _service.getCurrentQuestionIndex();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                BrandTitleBar(
                  title: _book!.name,
                  onBack: () {
                    context.router.pushNamed('/');
                  },
                ),
                Text(
                  '(${_book!.author})',
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
                SizedBox(height: 26),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Column(
                      children: [
                        Text(
                          'Amount of Book Completed:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins().copyWith(
                            color: Color(0xff5A5A5A),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '(${((currentQuestionIndex / questionsCount) * 100).toInt()}%)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins().copyWith(
                            color: Color(0xff5A5A5A),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                goToPreviousQuestion();
                              },
                              child: Container(
                                width: 42,
                                height: 42,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: brandLightBlue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: SvgPicture.asset(
                                  'assets/svgs/arrow-left-white.svg',
                                  height: 10,
                                  width: 10,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(19),
                                backgroundColor: Color(0xffE8E8E8),
                                color: brandLightBlue,
                                value: currentQuestionIndex / questionsCount,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                goToNextQuestion();
                              },
                              child: Container(
                                width: 42,
                                height: 42,
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: brandLightBlue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: SvgPicture.asset(
                                  'assets/svgs/arrow-right-white.svg',
                                  height: 10,
                                  width: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 4),
                              child: GestureDetector(
                                onTap: () {
                                  showInformationDialog(context, '',
                                      _currentQuestion?.info ?? '');
                                },
                                child: SvgPicture.asset(
                                  'assets/svgs/info-icon.svg',
                                  height: 24,
                                  width: 24,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showInformationDialog(
                                    context, '', _currentQuestion?.tips ?? '');
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/tip-icon.svg',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Use this space to capture your thoughts, reflections, or questions inspired by what you’ve just read.',
                          style: GoogleFonts.poppins().copyWith(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _answerFieldController,
                          focusNode: _answerFieldFocusNode,
                          onTap: () async {
                            await Future.delayed(
                                Duration(milliseconds: 500));
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.ease);
                          },
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
                          maxLines: 15,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Visit our community to discuss with others!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins().copyWith(
                            color: brandLightBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
