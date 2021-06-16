import 'package:flutter/material.dart';
import 'package:question/utils/const.dart';
import 'package:question/view/home/dodo_view.dart';
import 'package:question/view/home/qcm_view.dart';

import 'package:question/widget/app_header.dart';
import 'package:question/widget/submit_round.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _children;
  int _currentIndex;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _children = [
      QCMView(),
      DodoView(),
    ];
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(needHome: false),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.all(8),
                width: 140,
                child: SubmitRound(
                  title: "+ Nouveau",
                  callback: () {
                    Navigator.of(context).pushNamed(ROUTE.CREATE,
                        arguments: (_currentIndex == 0));
                  },
                ),
              ),
            ),
            Expanded(child: _children[_currentIndex])
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: COLOR.BLUE,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "images/list-check.png",
            ),
            activeIcon: Image.asset(
              "images/list-check.png",
              color: COLOR.BLUE,
            ),
            label: "QCM",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "images/soundwave.png",
            ),
            activeIcon: Image.asset(
              "images/soundwave.png",
              color: COLOR.BLUE,
            ),
            label: "Dodo studieux",
          ),
        ],
      ),
    );
  }
}
