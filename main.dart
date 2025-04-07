import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hpd3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: SplashScreen(
        onThemeChanged: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  SplashScreen({required this.onThemeChanged, required this.isDarkMode});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
            onThemeChanged: widget.onThemeChanged,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: DiagonalClipper1(),
            child: Container(color: Color(0xFF221D1D)),
          ),
          ClipPath(
            clipper: DiagonalClipper2(),
            child: Container(color: Color(0xFF3A3333)),
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ElectroLex.",
                    style: TextStyle(fontSize: 36, fontFamily: 'ArialBlack')),
                SizedBox(height: 20),
                SpinnerLoadingAnimation(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.55, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DiagonalClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.4);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SpinnerLoadingAnimation extends StatefulWidget {
  @override
  _SpinnerLoadingAnimationState createState() => _SpinnerLoadingAnimationState();
}

class _SpinnerLoadingAnimationState extends State<SpinnerLoadingAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> controllers;
  late List<Animation<double>> animations;

  @override
  void initState() {
    super.initState();
    List<int> durations = [6, 3, 2, 1500, 1];
    controllers = List.generate(
      5,
          (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durations[i] * 1000),
      ),
    );
    animations = List.generate(
      5,
          (i) => Tween<double>(begin: -pi, end: pi).animate(controllers[i])
        ..addListener(() => setState(() {}))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            controllers[i].repeat();
          } else if (status == AnimationStatus.dismissed) {
            controllers[i].forward();
          }
        }),
    );
    controllers.forEach((c) => c.forward());
  }

  @override
  void dispose() {
    controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: CustomPaint(
        painter: SpinnerPainter(animations.map((a) => a.value).toList()),
      ),
    );
  }
}

class SpinnerPainter extends CustomPainter {
  final List<double> angles;
  SpinnerPainter(this.angles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff00A2FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < angles.length; i++) {
      double padding = i * size.width * 0.1;
      canvas.drawArc(
        Rect.fromLTRB(
          padding,
          padding,
          size.width - padding,
          size.height - padding,
        ),
        angles[i],
        2,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Home Page with Onboarding
class HomePage extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  HomePage({required this.onThemeChanged, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OnboardingScreen(
        onThemeChanged: onThemeChanged,
        isDarkMode: isDarkMode,
      ),
    );
  }
}

// Onboarding
class OnboardingScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  OnboardingScreen({required this.onThemeChanged, required this.isDarkMode});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "title": "Learn About Electronics",
      "description":
      "Discover electronic components\nand their functions in one place.",
      "image": "lib/assets/1.jpg"
    },
    {
      "title": "Understand How They Work",
      "description": "Get detailed descriptions\nand uses of each component.",
      "image": "lib/assets/2.jpg"
    },
    {
      "title": "Start Exploring",
      "description":
      "Dive into the world of electronics\nand expand your knowledge!",
      "image": "lib/assets/3.jpg"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) => OnboardingContent(
              title: onboardingData[index]["title"]!,
              description: onboardingData[index]["description"]!,
              image: onboardingData[index]["image"]!,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            onboardingData.length,
                (index) => buildDot(index: index),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _currentPage == onboardingData.length - 1
              ? ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => hpd3(
                    onThemeChanged: widget.onThemeChanged,
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF31E4FA),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              minimumSize: Size(double.infinity, 60),
            ),
            child: Text("Get Started",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => hpd3(
                        onThemeChanged: widget.onThemeChanged,
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                  );
                },
                child: Text("Skip",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF31E4FA),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text("Next", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Color(0xFF31E4FA) : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title, description, image;

  OnboardingContent(
      {required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 300),
        SizedBox(height: 20),
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
