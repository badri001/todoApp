import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'screens/home.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true),
  ],
)
class $AppRouter {}

class AppRouter extends _$$AppRouter {}
