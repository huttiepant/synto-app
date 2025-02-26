import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/api/models/post_reading_question.dart';
import 'package:synto_app/popups/information_popup.dart';
import 'package:synto_app/popups/open_ended_result_notification_popup.dart';
import 'package:synto_app/screens/home_page.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_title_bar.dart';
import 'package:synto_app/widgets/reading_step_widget.dart';

import '../../ui/brand_colors.dart';

@RoutePage()
class PostReadingPage extends StatefulWidget {
  const PostReadingPage({super.key});

  @override
  State<PostReadingPage> createState() => _PostReadingPageState();
}

class _PostReadingPageState extends State<PostReadingPage> {
  final BooksService _service = BooksService();

  final _answerFieldController = TextEditingController();
  final _answerFieldFocusNode = FocusNode();

  Book? _book;
  ReadingStep? _step;
  PostReadingQuestion? _currentQuestion;

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
    if (answer == null) return;

    if (_currentQuestion?.type == 'openEnded') {
      _answerFieldController.text = answer;
    }
  }

  Future<void> _initialize() async {
    if (_service.selectedBookId == null) return;
    _book = _service.getBook(_service.selectedBookId!);
    _currentQuestion = _service.getCurrentQuestion();
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

    handleOpenEndedAnswer({bool skip = false}) async {
      final answer = _answerFieldController.text;
      await _service.answerQuestion(
        _currentQuestion!.id,
        skip ? '' : answer,
      );
      _answerFieldController.text = '';
      _answerFieldFocusNode.unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OpenEndedResultNotificationPopup(
            dialog: _currentQuestion?.dialog ?? '',
            onTap: () async {
              final nextQuestion = _service.getCurrentQuestion();
              if (nextQuestion == null) {
                _service.nextStep();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              } else {
                Navigator.of(context).pop();
                _currentQuestion = nextQuestion;
                fetchAndSetSelectedAnswer();
                setState(() => {});
              }
            },
          ),
          fullscreenDialog: true,
        ),
      );
    }

    final questionsCount = _service.getQuestionsCount();
    final currentQuestionIndex = _service.getCurrentQuestionIndex();

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Column(
                      children: [
                        if (_currentQuestion?.type == 'openEnded')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (_currentQuestion?.info != null)
                                SizedBox(
                                    width: 40,
                                    child: FittedBox(
                                        child: IconButton(
                                            onPressed: () {
                                              showInformationDialog(context, '',
                                                  _currentQuestion?.info ?? '');
                                            },
                                            icon: Icon(
                                              Icons.info_outline,
                                              size: 24,
                                            )))),
                              if (_currentQuestion?.tips != null)
                                SizedBox(
                                    width: 40,
                                    child: FittedBox(
                                        child: IconButton(
                                            onPressed: () {
                                              showInformationDialog(context, '',
                                                  _currentQuestion?.tips ?? '');
                                            },
                                            icon: Icon(
                                              Icons.question_mark,
                                              size: 24,
                                            )))),
                            ],
                          ),
                        Container(
                          constraints: BoxConstraints(minHeight: 68),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Html(
                              data: _currentQuestion!.question ?? '',
                              style: {
                                "*": Style(
                                  color: Color(0xff5A5A5A),
                                ),
                                "span": Style(
                                  fontSize: FontSize(15),
                                ),
                              },
                            ),
                          ),
                        ),
                        Divider(
                          color: Color(0xffE8E8E8).withOpacity(0.7),
                        ),
                        SizedBox(height: 8),
                        if (_currentQuestion?.type == 'openEnded')
                          Column(
                            children: [
                              TextField(
                                controller: _answerFieldController,
                                focusNode: _answerFieldFocusNode,
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
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 142,
                                    child: BrandButton(
                                      onTap: () async {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //         const IdeasTaggerPage(),
                                        //         fullscreenDialog: true));
                                        await handleOpenEndedAnswer(skip: true);
                                      },
                                      text: 'Skip',
                                      color: Color(0xffB8B8B8),
                                      textColor: Colors.black,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 142,
                                    child: BrandButton(
                                      onTap: () async {
                                        await handleOpenEndedAnswer();
                                      },
                                      text: 'Submit',
                                      color: brandLightBlue,
                                      textColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ProgressWidget(
                count: questionsCount,
                currentIndex: currentQuestionIndex,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProgressWidget extends StatelessWidget {
  const ProgressWidget(
      {super.key, required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: [
        ...List.generate(
            count,
            (index) => AnimatedContainer(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: index == currentIndex
                        ? Colors.black
                        : Color(0xffB8B8B8),
                    shape: BoxShape.circle,
                  ),
                  duration: Duration(milliseconds: 250),
                ))
      ],
    );
  }
}
