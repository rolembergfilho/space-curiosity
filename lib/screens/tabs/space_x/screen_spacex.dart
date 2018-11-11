import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../models/querry_model.dart';
import '../../../models/rockets/launch.dart';
import '../../../models/rockets/spacex_company.dart';
import '../../../models/rockets/spacex_home.dart';
import '../../../models/rockets/vehicle.dart';
import 'tab_company.dart';
import 'tab_home.dart';
import 'tab_launches.dart';
import 'tab_vehicles.dart';

class SpacexScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SpacexTabScreen();
}

class _SpacexTabScreen extends State<SpacexScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  static final List<QuerryModel> modelTab = [
    SpacexHomeModel(),
    VehiclesModel(),
    LaunchesModel(0),
    LaunchesModel(1),
    SpacexCompanyModel(),
  ];

  final List<ScopedModel> _tabs = [
    ScopedModel<SpacexHomeModel>(
      model: modelTab[0],
      child: SpacexHomeTab(),
    ),
    ScopedModel<VehiclesModel>(
      model: modelTab[1],
      child: VehiclesTab(),
    ),
    ScopedModel<LaunchesModel>(
      model: modelTab[2],
      child: LaunchesTab('Upcoming launches'),
    ),
    ScopedModel<LaunchesModel>(
      model: modelTab[3],
      child: LaunchesTab('Latest launches'),
    ),
    ScopedModel<SpacexCompanyModel>(
      model: modelTab[4],
      child: SpacexCompanyTab(),
    ),
  ];

  @override
  initState() {
    super.initState();
    modelTab.forEach((model) => model.loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: const Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: const Text('Vehicles'),
            icon: Icon(FontAwesomeIcons.rocket),
          ),
          BottomNavigationBarItem(
            title: const Text('Upcoming'),
            icon: Icon(Icons.timer),
          ),
          BottomNavigationBarItem(
            title: const Text('Latest'),
            icon: Icon(Icons.library_books),
          ),
          BottomNavigationBarItem(
            title: const Text('Company'),
            icon: Icon(Icons.location_city),
          ),
        ],
      ),
    );
  }
}