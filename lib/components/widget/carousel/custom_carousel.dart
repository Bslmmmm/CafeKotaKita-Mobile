import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/components/widget/carousel/model/model_carousel.dart';
import 'package:flutter/material.dart';


class CustomCarousel extends StatefulWidget {
  // final List<String> imgUrl;
  final List<CarouselItemData> items; 
  final double height;
  final BoxFit fit;
  final bool autoPlay;
  final Duration autoplayInterval;
  final Duration autoplayAnimation;
  final Curve autoplaycurve; //<====== ini buat kecepatan animasi =======>
  final ValueChanged<int>? onPageChange;


  const CustomCarousel(
      {super.key,
      this.height = 200.0,
      this.fit = BoxFit.cover,
      this.autoPlay = false,
      this.autoplayInterval = const Duration(seconds: 2),
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
  


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentpage);

    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoplayInterval, () {
      if (!mounted) return;
      int nextPage = (_currentpage + 1) % widget.items.length;
      _pageController
          .animateToPage(
        nextPage,
        duration: widget.autoplayAnimation,
        curve: widget.autoplaycurve,
      )
          .then((_) {
        if (mounted && widget.autoPlay) {
          _startAutoPlay();
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          height: widget.height,
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
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return GestureDetector(
                onTap: item.onTap,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: AssetImage(item.imgUrl),
                          fit: widget.fit
                          )),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10.0),
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
