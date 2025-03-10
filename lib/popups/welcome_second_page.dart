import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class WelcomeSecondPage extends StatelessWidget {
  const WelcomeSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 213,
                height: 248,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/sophia.jpg',
                        ),
                        fit: BoxFit.contain)),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Meet Sophia—Your \n Reading Guide',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins().copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2A2A2A)),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 32),
                child: Html(
                  data: '''
            <p>In Ancient Greece, Sophia means ‘wisdom’ so it was rather convenient that she accepted our invite to guide you through the app.</p>
            <p>Sophia will break down key ideas, share insights you might miss, and help you when you get stuck. Think of her as your personal reading mentor.</p>
            
                <div>Before you start reading, we’ll challenge you with carefully designed questions to:</div>
                <div>🧠 Get inside the author’s mind – Understand their motivations for writing.</div>
                <div>🤔 Get inside your own mind – Clarify what you want from the book.</div>
            
            <p>This is where deeper understanding begins. Let’s get started.</p>
          ''',
                  style: {
                    "*": Style(
                      textAlign: TextAlign.center,
                      color: Color(0xff5A5A5A),
                    ),
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: BrandButton(
                    onTap: () {
                      context.router.pushNamed('/');
                    },
                    border: Border.all(color: Colors.white, width: 1),
                    text: 'Begin',
                    color: brandLightBlue,
                    textColor: Colors.white),
              )
            ],
          ),
        ),
      )),
    );
  }
}
