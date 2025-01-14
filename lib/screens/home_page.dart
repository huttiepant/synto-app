import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:reading_app/api/models/book.dart';
import 'package:reading_app/widgets/book_widget.dart';

import '../widgets/home_header.dart';

final List<Book> books = [
  Book.fromJson({
    "image": 'assets/book-image.png',
    "author": 'Marcus Aurelius',
    "title": 'Meditations',
    "description": 'Meditations is for anyone who wants to live with purpose and inner calm, even when life feels chaotic. It’s often read by people looking to build resilience and find practical wisdom they can apply every day. If you’re exploring questions about leading a meaningful life or dealing with challenges, this book offers timeless advice from one of history’s greatest thinkers.',
    "hashtags": '#virtue #self-discipline #mortality #duty #resilience'
  }),
  Book.fromJson({
    "image": 'assets/book-image.png',
    "author": 'Marcus Aurelius',
    "title": 'Meditations',
    "description": 'Meditations is for anyone who wants to live with purpose and inner calm, even when life feels chaotic. It’s often read by people looking to build resilience and find practical wisdom they can apply every day. If you’re exploring questions about leading a meaningful life or dealing with challenges, this book offers timeless advice from one of history’s greatest thinkers.',
    "hashtags": '#virtue #self-discipline #mortality #duty #resilience'
  }),
  Book.fromJson({
    "image": 'assets/book-image.png',
    "author": 'Marcus Aurelius',
    "title": 'Meditations',
    "description": 'Meditations is for anyone who wants to live with purpose and inner calm, even when life feels chaotic. It’s often read by people looking to build resilience and find practical wisdom they can apply every day. If you’re exploring questions about leading a meaningful life or dealing with challenges, this book offers timeless advice from one of history’s greatest thinkers.',
    "hashtags": '#virtue #self-discipline #mortality #duty #resilience'
  }),
];

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeader(),
            SizedBox(height: 16),
            ...books.map((book) => BookWidget(book: book)),
          ],
        ),
      ),
    );
  }
}
