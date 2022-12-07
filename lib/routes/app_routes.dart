import 'package:cat_facts/cats/cats_history/history_page.dart';
import 'package:cat_facts/cats/cats_page.dart';
import 'package:cat_facts/routes/route_name.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  RouteName.facts: (context) => const CatsPage(),
  RouteName.history: (context) => const CatsHistory(),
};