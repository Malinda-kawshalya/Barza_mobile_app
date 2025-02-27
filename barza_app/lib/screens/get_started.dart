import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';

void main() {
  runApp(const BaterApp());
}

class BaterApp extends StatelessWidget {
  const BaterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barza App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0C969C),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0C969C),
          primary: const Color(0xFF0C969C),
        ),
        fontFamily: 'Poppins',
      ),
      home: const GetStartedPage(),
    );
  }
}

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentTextIndex = 0;
  final List<String> _animatedTexts = [
    'Exchange',
    'Trade',
    'Barter',
    'Connect'
  ];
  Timer? _textAnimationTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    // Setup timer to change text animation
    _textAnimationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentTextIndex = (_currentTextIndex + 1) % _animatedTexts.length;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEEE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Barza ',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Icon(
                      Icons.menu,
                      size: 28,
                    ),
                  ],
                ),
              ),

              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Animated Fade-in text
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Get Started',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'Ready to ',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.black54,
                                    fontFamily:'poppins',
                                    
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.0, 0.5),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    _animatedTexts[_currentTextIndex],
                                    key: ValueKey<String>(
                                        _animatedTexts[_currentTextIndex]),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Animated Features
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C969C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/illustration.png',
                              height: 160,
                              fit: BoxFit.contain,
                              // Note: Replace with your actual image or use a placeholder
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0C969C)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.sync_alt,
                                    size: 60,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Getting Started Steps
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'How It Works',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily:'poppins',
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildStepItem(
                              context,
                              icon: Icons.person_add_outlined,
                              title: 'Create Your Account',
                              description:
                                  'Sign up and build your profile with items you want to trade',
                              stepNumber: '1',
                            ),
                            _buildStepItem(
                              context,
                              icon: Icons.search_outlined,
                              title: 'Discover Trades',
                              description:
                                  'Browse items or services available for barter',
                              stepNumber: '2',
                            ),
                            _buildStepItem(
                              context,
                              icon: Icons.handshake_outlined,
                              title: 'Make an Offer',
                              description:
                                  'Propose your trade and negotiate terms',
                              stepNumber: '3',
                            ),
                            _buildStepItem(
                              context,
                              icon: Icons.check_circle_outline,
                              title: 'Complete Trade',
                              description:
                                  'Meet up, exchange items, and leave feedback',
                              stepNumber: '4',
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Get Started Button
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Get Started Now'),
                                        
                          
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String stepNumber,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(left: 0, top: 10, bottom: 20),
                  width: 2,
                  height: 30,
                  color: Colors.grey.withOpacity(0.3),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
