import 'dart:async';

import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/components/widget/carousel/model/model_carousel.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatefulWidget {
  final List<CarouselItemData> items; 
  final double height;
  final BoxFit fit;
  final bool autoPlay;
  final Duration autoplayInterval;
  final Duration autoplayAnimation;
  final Curve autoplaycurve;
  final ValueChanged<int>? onPageChange;

  const CustomCarousel({
    super.key,
    this.height = 200.0,
    this.fit = BoxFit.cover,
    this.autoPlay = true,
    this.autoplayInterval = const Duration(seconds: 3),
    this.autoplayAnimation = const Duration(milliseconds: 900),
    this.autoplaycurve = Curves.easeOut,
    this.onPageChange,
    required this.items,
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  late PageController _pageController;
  int _currentpage = 0;
  Timer? _autoPlayTimer;
  bool _isUserInteracting = false; // Track user interaction

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentpage);

    if (widget.autoPlay && widget.items.isNotEmpty) { // Safety check
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    if (_isUserInteracting) return; // Don't start if user is interacting
    
    _autoPlayTimer?.cancel(); // Cancel existing timer
    _autoPlayTimer = Timer.periodic(widget.autoplayInterval, (timer) {
      if (!mounted || widget.items.isEmpty || _isUserInteracting) {
        timer.cancel();
        return;
      }
      
      int nextPage = (_currentpage + 1) % widget.items.length;
      _pageController.animateToPage(
        nextPage,
        duration: widget.autoplayAnimation,
        curve: widget.autoplaycurve,
      );
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  void _pauseAutoPlay() {
    _isUserInteracting = true;
    _stopAutoPlay();
  }

  void _resumeAutoPlay() {
    _isUserInteracting = false;
    if (widget.autoPlay) {
      // Resume after a delay to avoid immediate restart
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_isUserInteracting) {
          _startAutoPlay();
        }
      });
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safety check for empty items
    if (widget.items.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Center(
          child: Text('No items to display'),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: GestureDetector(
            onPanStart: (_) => _pauseAutoPlay(), // Stop autoplay when user starts dragging
            onPanEnd: (_) => _resumeAutoPlay(),  // Resume autoplay after user stops dragging
            onTapDown: (_) => _pauseAutoPlay(),  // Stop autoplay when user taps
            onTapUp: (_) => _resumeAutoPlay(),   // Resume autoplay after tap
            onTapCancel: () => _resumeAutoPlay(), // Resume if tap is cancelled
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentpage = index;
                });
                if (widget.onPageChange != null) {
                  widget.onPageChange!(index);
                }
                // Pause autoplay when page changes manually
                if (_isUserInteracting) {
                  _pauseAutoPlay();
                  _resumeAutoPlay();
                }
              },
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return GestureDetector(
                  onTap: () {
                    _pauseAutoPlay(); // Pause when carousel item is tapped
                    item.onTap?.call(); // Call the onTap function safely
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage(item.imgUrl),
                        fit: widget.fit,
                      ),
                    ),
                    // Optional: Tambahkan loading/error handling
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        // Optional: Tambahkan overlay gradient untuk readability
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        // Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              height: 8.0,
              width: _currentpage == index ? 24.0 : 8.0,
              decoration: BoxDecoration(
                color: _currentpage == index ? primaryc : clrfont3,
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        ),
      ],
    );
  }
}