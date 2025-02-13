import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/api/models/answer.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/api/models/pre_reading_question.dart';
import 'package:synto_app/popups/information_popup.dart';
import 'package:synto_app/popups/open_ended_result_notification_popup.dart';
import 'package:synto_app/popups/result_notification_popup.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_title_bar.dart';
import 'package:synto_app/widgets/book_tag.dart';

import '../../ui/brand_colors.dart';

class ReadingLevel {
  final String displayName;
  final ReadingStep value;

  ReadingLevel({required this.displayName, required this.value});
}

List<ReadingLevel> readingLevels = [
  ReadingLevel(displayName: 'Pre-Read', value: ReadingStep.preReading),
  ReadingLevel(displayName: 'Reading', value: ReadingStep.whileReading),
  ReadingLevel(displayName: 'Post Read', value: ReadingStep.postReading),
];

@RoutePage()
class ChoicePage extends StatefulWidget {
  const ChoicePage({super.key});

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  final BooksService _service = BooksService();

  final _answerFieldController = TextEditingController();
  final _answerFieldFocusNode = FocusNode();

  Book? _book;
  ReadingStep? _step;
  PreReadingQuestion? _currentQuestion;

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

  Future<void> _initialize() async {
    if (_service.selectedBookId == null) return;
    _book = _service.getBook(_service.selectedBookId!);
    _currentQuestion = _service.getCurrentQuestion();
    _step = _service.getCurrentBookStep(_service.selectedBookId!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null || _book == null) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()));
    }

    handleAnswer(Answer answer) async {
      final correctAnswer = _service.getCorrectAnswer();
      await _service.answerQuestion(
        _currentQuestion!.id,
        answer.id,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultNotificationPopup(answer: answer, correct: correctAnswer),
          fullscreenDialog: true,
        ),
      );
      await Future.delayed(Duration(milliseconds: 250));
      final nextQuestion = _service.getCurrentQuestion();
      if (nextQuestion == null) {
        // _showCompletionScreen();
      } else {
        setState(() => _currentQuestion = nextQuestion);
      }
    }

    handleOpenEndedAnswer({bool skip = false}) async {
      final answer = _answerFieldController.text;
      await _service.answerQuestion(
        _currentQuestion!.id,
        skip ? '' : answer,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OpenEndedResultNotificationPopup(
            dialog: _currentQuestion?.dialog ?? '',
          ),
          fullscreenDialog: true,
        ),
      );
      _answerFieldController.text = '';
      _answerFieldFocusNode.unfocus();
      await Future.delayed(Duration(milliseconds: 250));
      final nextQuestion = _service.getCurrentQuestion();
      if (nextQuestion == null) {
        // _showCompletionScreen();
      } else {
        setState(() => _currentQuestion = nextQuestion);
      }
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
                    context.router.back();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...readingLevels.map((level) => BookTag(
                          onTap: () {
                            setState(() {});
                          },
                          title: level.displayName,
                          selected: level.value == _step,
                        )),
                  ],
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
                              SizedBox(
                                  width: 40,
                                  child: FittedBox(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 24,
                                          )))),
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
                                          ))))
                            ],
                          ),
                        Container(
                          constraints: BoxConstraints(minHeight: 68),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              _currentQuestion!.question,
                              textAlign: TextAlign.left,
                              style: TextStyle(),
                            ),
                          ),
                        ),
                        Divider(
                          color: Color(0xffE8E8E8).withOpacity(0.7),
                        ),
                        SizedBox(
                          height: 13,
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
                                              color: brandLightBlue),
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
                              GestureDetector(
                                onTap: () {
                                  // ownIdea = !ownIdea;
                                  setState(() {});
                                },
                                child: Text(
                                  'Freely enter your own idea:',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins().copyWith(
                                    color: brandLightBlue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
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
