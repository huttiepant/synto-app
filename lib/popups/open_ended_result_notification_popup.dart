import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:synto_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class OpenEndedResultNotificationPopup extends StatelessWidget {
  const OpenEndedResultNotificationPopup({
    super.key,
    required this.dialog,
    required this.onTap,
    this.actionText,
  });

  final String dialog;
  final String? actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Html(
                      data: dialog,
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
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: BrandButton(
                onTap: onTap,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                border: Border.all(color: Colors.white, width: 1),
                text: actionText ?? 'Next Question',
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
