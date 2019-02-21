import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../util/url.dart';
import '../query_model.dart';

class PassTimesModel extends QueryModel {
  Map<String, String> _issLocation;
  LocationData _userLocation;

  @override
  Future loadData() async {
    // Get item by http call
    response = await http.get(Url.issLocation);

    // Clear old data
    clearItems();

    _issLocation = Map.from(json.decode(response.body)['iss_position']);

    // Ask user about location
    // Parse if permission are granted
    try {
      print(2.1);
      // Get user's location
      _userLocation = await Location().getLocation();
      print(2.2);
      // Get items by http call & parse them
      response = await http.get(
        '${Url.issPassTimes}?lat=${_userLocation.latitude}&lon=${_userLocation.longitude}&n=10',
      );
      snapshot = json.decode(response.body)['response'];
      print(2.3);
      items.addAll(
        snapshot.map((passTime) => PassTime.fromJson(passTime)).toList(),
      );
      print(2.4);
    } on PlatformException {
      _userLocation = null;
      print('error');
    }

    // Finished loading data
    setLoading(false);
  }

  Map<String, String> get issLocation => _issLocation;

  LocationData get userLocation => _userLocation;

  String get getUserLocation =>
      '${userLocation.latitude.toStringAsPrecision(5)},  ${userLocation.longitude.toStringAsPrecision(5)}';
}

class PassTime {
  final Duration duration;
  final DateTime date;

  PassTime({this.duration, this.date});

  factory PassTime.fromJson(Map<String, dynamic> json) {
    return PassTime(
      duration: Duration(seconds: json['duration']),
      date: DateTime.fromMillisecondsSinceEpoch(json['risetime'] * 1000)
          .toLocal(),
    );
  }

  String getDate(context) => FlutterI18n.translate(
        context,
        'spacex.other.date.time',
        {'date': DateFormat.yMMMMd().format(date), 'hour': getTime},
      );

  String get getTime => '${DateFormat.Hm().format(date)} ${date.timeZoneName}';

  String getDuration(context) => FlutterI18n.translate(
        context,
        'iss.times.tab.duration',
        {'time': NumberFormat.decimalPattern().format(duration.inSeconds)},
      );
}
