import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:synto_app/api/services/auth_service.dart';
import 'package:synto_app/screens/auth/auth_page.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_colors.dart';
import 'package:synto_app/widgets/book_widget.dart';

import '../widgets/home_header.dart';

// final List<Book> books = [
//   Book.fromJson({
//     "image": 'assets/book-image.png',
//     "author": 'Marcus Aurelius',
//     "title": 'Meditations',
//     "description":
//         'Meditations is for anyone who wants to live with purpose and inner calm, even when life feels chaotic. It’s often read by people looking to build resilience and find practical wisdom they can apply every day. If you’re exploring questions about leading a meaningful life or dealing with challenges, this book offers timeless advice from one of history’s greatest thinkers.',
//     "hashtags": '#virtue #self-discipline #mortality #duty #resilience'
//   }),
//   Book.fromJson({
//     "image": 'assets/book-image.png',
//     "author": 'Marcus Aurelius',
//     "title": 'Meditations',
//     "description":
//         'Meditations is for anyone who wants to live with purpose and inner calm, even when life feels chaotic. It’s often read by people looking to build resilience and find practical wisdom they can apply every day. If you’re exploring questions about leading a meaningful life or dealing with challenges, this book offers timeless advice from one of history’s greatest thinkers.',
//     "hashtags": '#virtue #self-discipline #mortality #duty #resilience'
//   }),
//   Book.fromJson({
//     "image": 'assets/book-image.png',
//     "author": 'Marcus Aurelius',
//     "title": 'Meditations',
//     "description":
//         'Meditations is for anyone who wants to live with purpose and inner calm, even when life feels chaotic. It’s often read by people looking to build resilience and find practical wisdom they can apply every day. If you’re exploring questions about leading a meaningful life or dealing with challenges, this book offers timeless advice from one of history’s greatest thinkers.',
//     "hashtags": '#virtue #self-discipline #mortality #duty #resilience'
//   }),
// ];

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BooksService _booksService = BooksService();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _booksService.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _booksService.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final books = _booksService.getBooks();
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeHeader(books: books),
                  SizedBox(height: 16),
                  ...books.map((book) => BookWidget(book: book)),
                  Container(
                    margin: EdgeInsets.all(40),
                    child: BrandButton(
                        onTap: () {
                          GetIt.instance<AuthService>().logout().then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthPage()),
                            );
                          });
                        },
                        text: 'Sign Out',
                        color: brandLightBlue,
                        textColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 18)),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
