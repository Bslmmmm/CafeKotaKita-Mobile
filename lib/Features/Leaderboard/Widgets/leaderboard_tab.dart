import 'package:flutter/material.dart';

class LeaderboardTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData? icon;

  const LeaderboardTab({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.black87 : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive ? Colors.black87 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isActive ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardTabBar extends StatelessWidget {
  final List<String> tabs;
  final int activeIndex;
  final Function(int) onTabChanged;
  final List<IconData>? icons;

  const LeaderboardTabBar({
    Key? key,
    required this.tabs,
    required this.activeIndex,
    required this.onTabChanged,
    this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            return LeaderboardTab(
              label: tabs[index],
              isActive: activeIndex == index,
              onTap: () => onTabChanged(index),
              icon:
                  icons != null && icons!.length > index ? icons![index] : null,
            );
          }),
        ),
      ),
    );
  }
}

// Custom Tab Indicator untuk styling yang lebih custom
class CustomTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final double height;

  const CustomTabIndicator({
    this.color = Colors.black87,
    this.radius = 12.0,
    this.height = 4.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(
      color: color,
      radius: radius,
      height: height,
    );
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final Color color;
  final double radius;
  final double height;

  _CustomTabIndicatorPainter({
    required this.color,
    required this.radius,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double width = configuration.size!.width;
    final Rect rect = Rect.fromLTWH(
      offset.dx + (width - width * 0.6) / 2,
      offset.dy + configuration.size!.height - height,
      width * 0.6,
      height,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }
}

// Animated Tab Switcher
class AnimatedLeaderboardTabs extends StatefulWidget {
  final List<String> tabs;
  final int initialIndex;
  final Function(int) onTabChanged;
  final List<IconData>? icons;

  const AnimatedLeaderboardTabs({
    Key? key,
    required this.tabs,
    this.initialIndex = 0,
    required this.onTabChanged,
    this.icons,
  }) : super(key: key);

  @override
  State<AnimatedLeaderboardTabs> createState() =>
      _AnimatedLeaderboardTabsState();
}

class _AnimatedLeaderboardTabsState extends State<AnimatedLeaderboardTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(30),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: List.generate(widget.tabs.length, (index) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icons != null && widget.icons!.length > index) ...[
                  Icon(
                    widget.icons![index],
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(widget.tabs[index]),
              ],
            ),
          );
        }),
      ),
    );
  }
}
