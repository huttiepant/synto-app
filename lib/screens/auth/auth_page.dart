import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reading_app/screens/auth/login_page.dart';
import 'package:reading_app/screens/auth/sign_up_page.dart';
import 'package:reading_app/ui/brand_button.dart';
import 'package:reading_app/ui/brand_colors.dart';
import 'package:reading_app/widgets/brand_icon.dart';
import 'package:svg_clip/svg_clip.dart';
import 'package:video_player/video_player.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/splash.mp4');
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      backgroundColor: brandBgDark,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Stack(
              fit: StackFit.loose,
              children: [
                SvgClip(
                  asset: ClipAsset.local(path: 'assets/video_crop.svg'),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 1.018,
                    child: AspectRatio(
                      aspectRatio: 715 / 399,
                      child: Transform.translate(
                        offset: Offset(-(MediaQuery.of(context).size.width / 2.18), 0),
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 1,
                  child: SvgPicture.asset(
                    width: MediaQuery.of(context).size.width,
                    'assets/video_crop.svg',
                  ),
                )
              ],
            ),
          ),
          SafeArea(
              child: Container(
            padding: EdgeInsets.all(60),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    BrandIcon(),
                    SizedBox(
                      height: 20,
                    ),
                    AspectRatio(
                      aspectRatio: 2.16,
                      child: Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/logo-white.png',
                                ),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Wrap(
                  runSpacing: 10,
                  children: [
                    BrandButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      text: 'Sign Up',
                      color: brandOrange,
                      textColor: Colors.white,
                    ),
                    BrandButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        border: Border.all(color: Colors.white, width: 1),
                        text: 'Log In',
                        color: Colors.white.withOpacity(0.1),
                        textColor: Colors.white)
                  ],
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
