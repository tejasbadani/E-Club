import 'package:flutter/material.dart';
import './screen_1.dart';
import './screen_2.dart';
import './screen_3.dart';
import '../login.dart';

class Introduction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IntroductionState();
  }
}

class _IntroductionState extends State<Introduction> {
  final _pageController = PageController(
    initialPage: 0,
  );
  final array = [Screen1(), Screen2(), Screen3(), Login()];
  int _currentPage = 0;
  //double page = _pageController.

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, int index) {
        return Stack(
          children: <Widget>[
            //Dots view
            array[index],
            Baseline(
              baseline: MediaQuery.of(context).size.height / 1.1,
              baselineType: TextBaseline.alphabetic,
              //  bottom: 150.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          _currentPage == 0 ? Colors.white : Colors.grey,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          _currentPage == 1 ? Colors.white : Colors.grey,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          _currentPage == 2 ? Colors.white : Colors.grey,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor:
                          _currentPage == 3 ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      controller: _pageController,
      onPageChanged: (int index) {
        print(index);
        setState(() {
          _currentPage = index;
        });
      },
      itemCount: 4,
    );
  }
}
