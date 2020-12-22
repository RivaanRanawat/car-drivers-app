import 'package:car_driver_app/universal_variables.dart';
import "package:flutter/material.dart";
import "package:car_driver_app/tabs/home_tab.dart";
import "package:car_driver_app/tabs/earning_tab.dart";
import "package:car_driver_app/tabs/profile_tab.dart";
import "package:car_driver_app/tabs/ratings_tab.dart";

class HomeScreen extends StatefulWidget {
  static const String id = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [HomeTab(), EarningTab(), RatingsTab(), ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card), title: Text("Earning")),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), title: Text("Ratings")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Profile")),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: UniversalVariables.colorIcon,
        selectedItemColor: UniversalVariables.colorOrange,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: onItemClicked,
      ),
    );
  }
}
