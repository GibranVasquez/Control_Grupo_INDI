import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  const ResponsiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width > 900) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(
                  width: 480,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                    child: child,
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }

        if (width > 600) {
          return Center(
            child: SizedBox(
              width: 600,
              child: child,
            ),
          );
        }

        return child;
      },
    );
  }
}
