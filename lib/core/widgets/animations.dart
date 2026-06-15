import 'package:flutter/material.dart';

class SlideFadeRoute extends PageRouteBuilder {
  final Widget page;

  SlideFadeRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
}

class StaggeredEntrance extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration delay;

  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
    this.delay = const Duration(milliseconds: 80),
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay * widget.index, _controller.forward);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: widget.child,
      ),
    );
  }
}

class RevealSection extends StatefulWidget {
  final Widget child;
  final int delayMs;

  const RevealSection({super.key, required this.child, this.delayMs = 0});

  @override
  State<RevealSection> createState() => _RevealSectionState();
}

class _RevealSectionState extends State<RevealSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.delayMs), _controller.forward);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: widget.child,
      ),
    );
  }
}

class AnimatedNavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final int? badgeCount;

  const AnimatedNavIcon({
    super.key,
    required this.icon,
    required this.isActive,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: child,
          ),
          child: Icon(
            icon,
            key: ValueKey(isActive),
            size: 22,
            color: isActive
                ? const Color(0xFFbd003b)
                : const Color(0xFF5f5e5e),
          ),
        ),
        if (badgeCount != null && badgeCount! > 0)
          Positioned(
            right: -8,
            top: -4,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFbd003b),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AnimatedTabBar extends StatelessWidget {
  final List<AnimatedTabData> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AnimatedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFfff8f7),
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final tab = tabs[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                height: 60,
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedNavIcon(
                      icon: tab.icon,
                      isActive: i == selectedIndex,
                      badgeCount: tab.badgeCount,
                    ),
                    const SizedBox(height: 2),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: i == selectedIndex
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: i == selectedIndex
                            ? const Color(0xFFbd003b)
                            : const Color(0xFF5f5e5e),
                      ),
                      child: Text(tab.label),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AnimatedTabData {
  final IconData icon;
  final String label;
  final int? badgeCount;

  const AnimatedTabData({
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}
