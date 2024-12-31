import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileView;
  final Widget tabletView;

  const ResponsiveLayout({
    Key? key,
    required this.mobileView,
    required this.tabletView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileView; // Display mobile layout for screens less than 600dp wide
        } else {
          return tabletView; // Display tablet layout for screens 600dp wide and above
        }
      },
    );
  }
}
