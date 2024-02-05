

import 'package:flutter/material.dart';
import 'package:smr_driver/new_screens/booking_history_screen.dart';
import 'package:smr_driver/new_screens/home_screen.dart';
import 'package:smr_driver/new_screens/my_profile.dart';

import 'package:smr_driver/utils/colors.dart';


import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
class BottomBar extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BottomBar> {
  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();

  }
  List<Widget> screenList = [ HomeScreen(),
    BookingHistoryScreen(),
    ProfileScreen(),];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        backgroundColor: MyColorName.scaffoldColor,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          CurvedNavigationBarItem(
            child: Icon(
                 Icons.home,
              color: selectedIndex==0?MyColorName.secondColor:Colors.black,
             ),
            label: "Home",
            labelStyle: TextStyle(
              color: selectedIndex==0?MyColorName.secondColor:Colors.black,
            )
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.history,
              color: selectedIndex==1?MyColorName.secondColor:Colors.black,
            ),
            label: "My Booking",
              labelStyle: TextStyle(
                color: selectedIndex==1?MyColorName.secondColor:Colors.black,
              )
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.person,
              color: selectedIndex==2?MyColorName.secondColor:Colors.black,
            ),
            label: "Account",
              labelStyle: TextStyle(
                color: selectedIndex==2?MyColorName.secondColor:Colors.black,
              )
          ),

        ],
      ),
    );
  }
}