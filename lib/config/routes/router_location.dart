import 'package:flutter/material.dart';

@immutable
class RouterLocation {
  const RouterLocation._();

  static String get home => '/home';
  static String get createTask => '/createTask';
}