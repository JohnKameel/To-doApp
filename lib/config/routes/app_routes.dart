import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/config/routes/router_location.dart';
import 'package:todo/screens/create_task_screen.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/screens.dart';

final navigationKey = GlobalKey<NavigatorState>();
final appRoutes = [
  GoRoute(
      path: RouterLocation.home,
    parentNavigatorKey: navigationKey,
    builder: HomeScreen.builder,
  ),
  GoRoute(
    path: RouterLocation.createTask,
    parentNavigatorKey: navigationKey,
    builder: CreateTaskScreen.builder,
  ),
];