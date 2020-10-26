import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

class Application {
  static FluroRouter router;

  static navigateTo(
      {@required BuildContext context,
        @required String route,
        transition = TransitionType.inFromRight}) {
    router.navigateTo(context, route, transition: transition);
  }

  static navigateToClearStack(
      {@required BuildContext context,
        @required String route,
        clearStack = true,
        transition = TransitionType.inFromRight}) {
    router.navigateTo(context, route,
        clearStack: clearStack, transition: transition);
  }
}
