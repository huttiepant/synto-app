import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:synto_app/api/services/auth_service.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:synto_app/ui/brand_colors.dart';
import 'package:synto_app/widgets/book_widget.dart';

import '../widgets/home_header.dart';

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
                  if (FirebaseAuth.instance.currentUser != null)
                    Container(
                      margin: EdgeInsets.all(40),
                      child: BrandButton(
                          onTap: () {
                            _booksService.resetUserLocalProgress();
                            GetIt.instance<AuthService>().logout().then((_) {
                              context.router.replaceNamed('/auth');
                            });
                          },
                          text: 'Sign Out',
                          color: brandLightBlue,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 18)),
                    ),
                ],
              ),
            );
          }),
    );
  }
}
