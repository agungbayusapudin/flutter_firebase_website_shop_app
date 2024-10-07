import 'package:flutter/widgets.dart';

class Responsive {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive(
      {required this.mobile, required this.tablet, required this.desktop});

  static bool Ismobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 768;

  static bool IsTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 768 &&
      MediaQuery.sizeOf(context).width < 1280;

  static bool IsLaptop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1280;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    if (size.width > 1280) {
      return desktop;
    } else if (size.width > 904) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
