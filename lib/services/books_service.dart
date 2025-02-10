import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Book {
  final String name;
  final String author;
  final String description;
  final String info;
  final int id;
  final List<Question> questions;

  Book({
    required this.name,
    required this.author,
    required this.description,
    required this.info,
    required this.id,
    required this.questions,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['name'],
      author: json['author'],
      description: json['description'],
      info: json['info'],
      id: json['id'],
      questions: List<Question>.from(
        json['questions'].map((x) => Question.fromJson(x)),
      ),
    );
  }
}

class Question {
  final int id;
  final String type;
  final String question;
  final List<Answer>? answers;
  final String? info;
  final String? tips;
  final String? dialog;

  Question({
    required this.id,
    required this.type,
    required this.question,
    required this.answers,
    this.info,
    this.tips,
    this.dialog,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      type: json['type'],
      question: json['question'],
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      info: json['info'],
      tips: json['tips'],
      dialog: json['dialog'],
    );
  }
}

class Answer {
  final int id;
  final String answer;
  final String dialogue;
  final bool correct;

  Answer(
      {required this.id,
      required this.answer,
      required this.dialogue,
      required this.correct});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answer: json['answer'],
      dialogue: json['dialogue'],
      correct: json['correct'] ?? false,
    );
  }
}

class UserProgress {
  final Map<int, int> currentQuestionIndices; // BookID -> current index
  final Map<int, Map<int, dynamic>>
      answeredQuestions; // BookID -> QuestionID -> Answer

  UserProgress({
    required this.currentQuestionIndices,
    required this.answeredQuestions,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      currentQuestionIndices: (json['indices'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(int.parse(k), v as dynamic),
      ),
      answeredQuestions: (json['answers'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(
          int.parse(k),
          (v as Map<String, dynamic>).map(
            (ki, vi) => MapEntry(int.parse(ki), vi as dynamic),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'indices':
          currentQuestionIndices.map((k, v) => MapEntry(k.toString(), v)),
      'answers': answeredQuestions.map((k, v) => MapEntry(
            k.toString(),
            v.map((ki, vi) => MapEntry(ki.toString(), vi)),
          )),
    };
  }
}

class BooksService {
  static final BooksService _instance = BooksService._internal();

  factory BooksService() => _instance;

  BooksService._internal();

  int? selectedBookId;

  List<Book> _books = [];
  UserProgress _progress = UserProgress(
    currentQuestionIndices: {},
    answeredQuestions: {},
  );
  final String _progressKey = 'user_progress';

  Future<void> initialize() async {
    await _loadBooks();
    await _loadProgress();
  }

  selectBook(int bookId) {
    selectedBookId = bookId;
  }

  Future<void> _loadBooks() async {
    final jsonString = await rootBundle.loadString('assets/json/books.json');
    final jsonData = json.decode(jsonString) as List;
    _books = jsonData.map((book) => Book.fromJson(book)).toList();
  }

  Future<void> _loadProgress() async {
    return null;
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_progressKey);
    if (progressJson != null) {
      _progress = UserProgress.fromJson(json.decode(progressJson));
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    print(json.encode(_progress.toJson()));
    await prefs.setString(_progressKey, json.encode(_progress.toJson()));
  }

  // Public methods
  List<Book> getBooks() => _books;

  Book? getBook(int bookId) => _books.firstWhere((book) => book.id == bookId);

  Question? getCurrentQuestion() {
    if (selectedBookId == null) {
      return null;
    }
    final book = getBook(selectedBookId!);
    if (book == null) return null;

    final currentIndex = _progress.currentQuestionIndices[selectedBookId] ?? 0;
    if (currentIndex >= book.questions.length) return null;

    return book.questions[currentIndex];
  }

  int getQuestionsCount() {
    if (selectedBookId == null) {
      return 0;
    }
    final book = getBook(selectedBookId!);
    if (book == null) return 0;

    return book.questions.length;
  }

  int getCurrentQuestionIndex() {
    if (selectedBookId == null) {
      return 0;
    }
    final book = getBook(selectedBookId!);
    if (book == null) return 0;

    final currentIndex = _progress.currentQuestionIndices[selectedBookId] ?? 0;
    return currentIndex;
  }

  Answer? getCorrectAnswer() {
    final Question? question = getCurrentQuestion();
    if (question == null) {
      return null;
    }
    print('question.id');
    print(question.id);
    return question.answers
        ?.firstWhereOrNull((Answer answer) => answer.correct);
  }

  Future<void> answerQuestion(int questionId, dynamic answer) async {
    _progress.answeredQuestions[selectedBookId!] ??= {};
    _progress.answeredQuestions[selectedBookId]![questionId] = answer;

    // Move to next question
    final currentIndex = _progress.currentQuestionIndices[selectedBookId] ?? 0;
    _progress.currentQuestionIndices[selectedBookId!] = currentIndex + 1;

    await _saveProgress();
  }

  Future<void> resetBookProgress(int bookId) async {
    _progress.answeredQuestions.remove(bookId);
    _progress.currentQuestionIndices.remove(bookId);
    await _saveProgress();
  }
}
