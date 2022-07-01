import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/task_view.dart';
import 'screens/home.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true),
    // AutoRoute(page: TaskView, path: "taskview"),
  ],
)
class $AppRouter {}

class AppRouter extends _$$AppRouter {}
