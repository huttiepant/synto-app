import 'package:auto_route/auto_route.dart';
import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/answer.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/api/models/pre_reading_question.dart';
import 'package:synto_app/mixins/ios_keyboard_inset_util.dart';
import 'package:synto_app/popups/information_popup.dart';
import 'package:synto_app/popups/open_ended_result_notification_popup.dart';
import 'package:synto_app/popups/result_notification_popup.dart';
import 'package:synto_app/screens/main/ideas_tagger_page.dart';
import 'package:synto_app/screens/main/while_reading_page.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_title_bar.dart';
import 'package:synto_app/widgets/progress_widget.dart';
import 'package:synto_app/widgets/reading_step_widget.dart';

import '../../ui/brand_colors.dart';

@RoutePage()
class PreReadingPage extends StatefulWidget {
  const PreReadingPage({super.key});

  @override
  State<PreReadingPage> createState() => _PreReadingPageState();
}

class _PreReadingPageState extends State<PreReadingPage>
    with WidgetsBindingObserver, iOSKeyboardInsetUtil {
  final BooksService _service = BooksService();

  final _answerFieldController = TextEditingController();
  final _answerFieldFocusNode = FocusNode();
  final scrollController = ScrollController();

  Book? _book;
  ReadingStep? _step;
  PreReadingQuestion? _currentQuestion;
  String? selectedAnswerId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  bool get isIOSWeb {
    return kIsWeb && TargetPlatform.iOS == defaultTargetPlatform;
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
    } else {
      selectedAnswerId = answer;
    }
  }

  Future<void> _initialize() async {
    if (_service.selectedBookId == null) return;
    _book = _service.getBook(_service.selectedBookId!);
    _currentQuestion = _service.getCurrentQuestion();
    if (_currentQuestion == null) {
      context.router.replaceNamed('/ideas');
    }
    _step = _service.getCurrentBookStep(_service.selectedBookId!);
    fetchAndSetSelectedAnswer();
    setState(() {});
  }

  bool get isAndroidWeb {
    return (kIsWeb && defaultTargetPlatform == TargetPlatform.android);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null || _book == null) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()));
    }


    final questionsCount = _service.getQuestionsCount();
    final currentQuestionIndex = _service.getCurrentQuestionIndex();

    handleAnswer(Answer answer) async {
      await _service.answerQuestion(
        _currentQuestion!.id,
        answer.id,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultNotificationPopup(answer: answer),
          fullscreenDialog: true,
        ),
      );
      await Future.delayed(Duration(milliseconds: 250));
      final nextQuestion = _service.getCurrentQuestion();
      if (nextQuestion == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WhileReadingPage()),
        );
      } else {
        _currentQuestion = nextQuestion;
        fetchAndSetSelectedAnswer();
        setState(() => {});
      }
    }

    void goToQuestionByIndex(int index) {
      _service.goToQuestionByIndex(index);
      final selectedQuestion = _service.getCurrentQuestion();
      _currentQuestion = selectedQuestion;
      fetchAndSetSelectedAnswer();
      setState(() => {});
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
            actionText: (currentQuestionIndex == questionsCount - 1) ? 'Finish' : null,
            onTap: () {
              final nextQuestion = _service.getCurrentQuestion();
              if (nextQuestion == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IdeasTaggerPage(),
                      fullscreenDialog: true),
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

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: !isAndroidWeb,
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
                        if (_currentQuestion?.type == 'openEnded')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_currentQuestion?.heading != null)
                                Expanded(
                                  child: Html(
                                    data: _currentQuestion!.heading,
                                    style: {
                                      "*": Style(
                                        color: Colors.black,
                                        // lineHeight: LineHeight(0.2)
                                      ),
                                    },
                                  ),
                                ),
                              Row(
                                children: [
                                  if (_currentQuestion?.info != null)
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
                                  if (_currentQuestion?.tips != null)
                                    GestureDetector(
                                      onTap: () {
                                        showInformationDialog(context, '',
                                            _currentQuestion?.tips ?? '');
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svgs/tip-icon.svg',
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        Container(
                          constraints: BoxConstraints(minHeight: 68),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Html(
                              data: _currentQuestion?.question ?? '',
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
                        if (_currentQuestion?.type != 'openEnded')
                          Container(
                            margin: EdgeInsets.only(bottom: 13),
                            child: Divider(
                              color: Color(0xffE8E8E8).withOpacity(0.7),
                            ),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _currentQuestion?.answers
                                  ?.map((answer) => GestureDetector(
                                        onTap: () => handleAnswer(answer),
                                        child: Container(
                                          constraints:
                                              BoxConstraints(minHeight: 60),
                                          margin: EdgeInsets.only(bottom: 13),
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: answer.id.toString() ==
                                                      selectedAnswerId
                                                  ? brandDarkBlue
                                                  : brandLightBlue),
                                          child: Center(
                                            child: Text(
                                              answer.answer,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins()
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList() ??
                              [],
                        ),
                        SizedBox(height: 19),
                        if (_currentQuestion?.type == 'openEnded')
                          Column(
                            children: [
                              isIOSWeb
                                  ? TextField(
                                      controller: _answerFieldController,
                                      focusNode: _answerFieldFocusNode,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      style: GoogleFonts.poppins().copyWith(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 5,
                                    )
                                  : EnsureVisibleWhenFocused(
                                      focusNode: _answerFieldFocusNode,
                                      child: TextField(
                                        controller: _answerFieldController,
                                        focusNode: _answerFieldFocusNode,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        style: GoogleFonts.poppins().copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 5,
                                      ),
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
                  onTap: (int index) {
                    goToQuestionByIndex(index);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
