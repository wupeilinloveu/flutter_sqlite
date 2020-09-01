import 'package:flutter_sqlite/commons/application.dart';
import 'package:flutter/material.dart';

void navigateToPage(BuildContext context, String route) {
  Application.navigateTo(context: context, route: route);
}

void navigateToClearStackPage(BuildContext context, String route) {
  Application.navigateToClearStack(context: context, route: route);
}
