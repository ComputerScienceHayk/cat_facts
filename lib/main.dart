import 'package:cat_facts/routes/app_routes.dart';
import 'package:cat_facts/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Size get size => MediaQuery.of(navigatorKey.currentContext!).size;

void main() async {
  initializeDateFormatting();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: RouteName.facts,
      routes: appRoutes,
    ),
  );
}
