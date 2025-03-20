import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:synto_app/api/models/answer.dart';
import 'package:synto_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class ResultNotificationPopup extends StatelessWidget {
  const ResultNotificationPopup(
      {super.key, required this.answer});

  final Answer answer;

  @override
  Widget build(BuildContext context) {
    final isCorrect = answer.correct == true;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              isCorrect
                                  ? 'assets/correct.jpg'
                                  : 'assets/wrong.jpg',
                            ),
                            fit: BoxFit.contain,
                          )),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                    Html(
                      data: answer.dialogue,
                      style: {
                        "*": Style(
                          textAlign: TextAlign.center,
                          color: Color(0xff5A5A5A),
                        ),
                        "span": Style(
                          fontSize: FontSize(15),
                        ),
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: BrandButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                border: Border.all(color: Colors.white, width: 1),
                text: 'Next Question',
                color: brandLightBlue,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      )),
    );
  }
}
