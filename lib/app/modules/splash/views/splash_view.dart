import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _logoMoveController;
  late AnimationController _imageController;
  late AnimationController _taglineController;
  late AnimationController _buttonsController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoMoveAnimation;
  late Animation<double> _imageOpacityAnimation;
  late Animation<double> _taglineOpacityAnimation;
  late Animation<double> _buttonsOpacityAnimation;

  bool _showNextScreen = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoMoveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _imageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutQuart,
    ));

    _logoMoveAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _logoMoveController,
        curve: Curves.easeInOut,
      ),
    );

    _imageOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageController,
        curve: Curves.easeIn,
      ),
    );

    _taglineOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _taglineController,
        curve: Curves.easeIn,
      ),
    );

    _buttonsOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonsController,
        curve: Curves.easeIn,
      ),
    );

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _logoMoveController.forward();
      }
    });

    _logoMoveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _imageController.forward();
        _taglineController.forward();
      }
    });

    _taglineController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _buttonsController.forward();
            setState(() {
              _showNextScreen = true;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _logoMoveController.dispose();
    _imageController.dispose();
    _taglineController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
Get.toNamed('/login', transition: Transition.rightToLeft, duration: const Duration(milliseconds: 500));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _logoController,
            _logoMoveController,
            _imageController,
            _taglineController,
            _buttonsController
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_imageOpacityAnimation.value > 0)
                        Opacity(
                          opacity: _imageOpacityAnimation.value,
                          child: Container(
                            height: 250,
                            width: 250,
                            margin: const EdgeInsets.only(bottom: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(125),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(125),
                              child: Image.asset(
                                'images/splash.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(0, _logoMoveAnimation.value * 0.5),
                        child: Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hupe',
                                style: GoogleFonts.inter(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF6C9056),
                                ),
                              ),
                              Text(
                                'st',
                                style: GoogleFonts.inter(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      if (_taglineOpacityAnimation.value > 0)
                        Opacity(
                          opacity: _taglineOpacityAnimation.value,
                          child: Text(
                            'Informasi Nilai Akademik Siswa',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_showNextScreen)
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: _buttonsOpacityAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: _navigateToLogin,
                              child: Text(
                                'Skip',
                                style: GoogleFonts.inter(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _navigateToLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C9056),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Next',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_showNextScreen)
                  Positioned(
                    bottom: 70,
                    left: 0,
                    right: 0,
                    child: Opacity(
                      opacity: _buttonsOpacityAnimation.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 18,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C9056),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
