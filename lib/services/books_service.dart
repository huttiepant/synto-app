import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:synto_app/api/models/answer.dart';
import 'package:synto_app/api/models/book.dart';
import 'package:synto_app/api/models/pre_reading_question.dart';
import 'package:synto_app/api/models/question_progress.dart';
import 'package:synto_app/api/models/reading_progress.dart';
import 'package:synto_app/api/models/user_progress.dart';

enum ReadingStep {
  preReading,
  whileReading,
  postReading,
}

class BooksService {
  static final BooksService _instance = BooksService._internal();

  factory BooksService() => _instance;

  BooksService._internal();

  int? selectedBookId;

  List<Book> _books = [];
  UserProgress _progress = UserProgress(progress: {});

  Future<void> initialize() async {
    await _loadBooks();
    await _loadProgress();
  }

  void selectBook(int bookId) {
    selectedBookId = bookId;
    if (_progress.progress[bookId] == null) {
      _progress.progress[bookId] = QuestionProgress(
          preReading:
              ReadingProgress(currentQuestionIndices: 0, answeredQuestions: {}),
          whileReading:
              ReadingProgress(currentQuestionIndices: 0, answeredQuestions: {}),
          postReading:
              ReadingProgress(currentQuestionIndices: 0, answeredQuestions: {}),
          readingStep: ReadingStep.preReading);
    }
  }

  Future<void> _loadBooks() async {
    final jsonString = await rootBundle.loadString('assets/json/books.json');
    final jsonData = json.decode(jsonString) as List;
    _books = jsonData.map((book) => Book.fromJson(book)).toList();
  }

  Future<void> _loadProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final progressCollection = await userRef.get();
    final data = progressCollection.data();
    final progress = data?['progress'];
    if (progress != null) {
      _progress = UserProgress.fromJson(jsonDecode(progress));
    }
  }

  Future<void> _saveProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final progress = jsonEncode(_progress);
    final progressCollection = await userRef.get();
    final data = progressCollection.data();
    if (data != null) {
      userRef.update({'progress': progress});
    } else {
      userRef.set({'progress': progress});
    }
  }

  // Public methods
  List<Book> getBooks() => _books;

  Book? getBook(int bookId) => _books.firstWhere((book) => book.id == bookId);

  getCurrentBookStep(int bookId) =>
      _progress.progress[bookId]?.currentStep ?? ReadingStep.preReading;

  void goToPreviousQuestion() {
    _progress.progress[selectedBookId]
        ?.getCurrentReadingProgress()
        .currentQuestionIndices -= 1;
  }

  dynamic getCurrentQuestion() {
    if (selectedBookId == null) {
      return null;
    }
    final book = getBook(selectedBookId!);
    final currentBookProgress = _progress.progress[selectedBookId];
    final ReadingStep currentStep = currentBookProgress!.currentStep;
    if (book == null) return null;

    final currentIndex =
        currentBookProgress.getCurrentReadingProgress().currentQuestionIndices;
    final questions = book.getCurrentStepQuestions(currentStep);
    if (questions.length > currentIndex) {
      return book.getCurrentStepQuestions(currentStep)[currentIndex];
    }
    return null;
  }

  int getQuestionsCount() {
    if (selectedBookId == null) {
      return 0;
    }
    final book = getBook(selectedBookId!);
    if (book == null) return 0;
    final ReadingStep currentStep =
        _progress.progress[selectedBookId]?.currentStep ??
            ReadingStep.preReading;
    return book.getCurrentStepQuestions(currentStep).length;
  }

  int getCurrentQuestionIndex() {
    if (selectedBookId == null) {
      return 0;
    }
    final book = getBook(selectedBookId!);
    if (book == null) return 0;
    final currentBookProgress = _progress.progress[selectedBookId];

    final currentIndex = currentBookProgress
            ?.getCurrentReadingProgress()
            .currentQuestionIndices ??
        0;
    return currentIndex;
  }

  Answer? getCorrectAnswer() {
    final PreReadingQuestion? question = getCurrentQuestion();
    if (question == null || question.answers == null) {
      return null;
    }
    return question.answers
        ?.firstWhereOrNull((Answer answer) => answer.correct == true);
  }

  String? getAnswerFromProgressByQuestionId(int? questionId) {
    if (selectedBookId == null || questionId == null) return null;
    final answers = _progress.progress[selectedBookId]
        ?.getCurrentReadingProgress()
        .answeredQuestions;
    if (answers == null || answers[questionId] == null) return null;
    return answers[questionId];
  }

  Future<void> answerQuestion(int questionId, dynamic answer) async {
    if (selectedBookId == null) return;
    final questionProgress =
        _progress.progress[selectedBookId]!.getCurrentReadingProgress();
    questionProgress.answeredQuestions[questionId] = answer;
    questionProgress.currentQuestionIndices =
        questionProgress.currentQuestionIndices + 1;

    await _saveProgress();
  }

  Future<void> nextStep() async {
    final prevQuestionProgress =
        _progress.progress[selectedBookId]!.getCurrentReadingProgress();
    prevQuestionProgress.currentQuestionIndices = 0;
    _progress.progress[selectedBookId]!.setNextStep();
    final currentQuestionProgress =
        _progress.progress[selectedBookId]!.getCurrentReadingProgress();
    currentQuestionProgress.currentQuestionIndices = 0;
    await _saveProgress();
  }

  Future<void> resetBookProgress(int bookId) async {
    _progress.progress[bookId] = QuestionProgress(
        preReading:
            ReadingProgress(currentQuestionIndices: 0, answeredQuestions: {}),
        whileReading:
            ReadingProgress(currentQuestionIndices: 0, answeredQuestions: {}),
        postReading:
            ReadingProgress(currentQuestionIndices: 0, answeredQuestions: {}),
        readingStep: ReadingStep.preReading);
    await _saveProgress();
  }
}
