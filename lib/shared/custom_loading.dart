import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomLoadingState();
  }
}

class _CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _transitionTween;
  Animation animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(
          seconds: 1,
          milliseconds: 30,
        ),
        vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _transitionTween = Tween<double>(
      begin: 20.0,
      end: 60.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _controller.forward();
  }


  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Center(
      child: Opacity(
        opacity: 0.85,
        child: AnimatedBuilder(
          builder: (context, child) {
            return Container(
              alignment: Alignment(0, 0),
              height: _transitionTween.value,
              width: _transitionTween.value,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).buttonColor),
            );
          },
          animation: _controller,
        ),
      ),
    );
  }
}
