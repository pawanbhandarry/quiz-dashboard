import 'package:dashboard/common/widgets/layouts/templates/site_layout.dart';
import 'package:dashboard/features/reports/responsive/reports_desktop.dart';
import 'package:flutter/material.dart';

class RepostsScreen extends StatelessWidget {
  const RepostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: ReportsDesktopScreen(),
    );
  }
}
