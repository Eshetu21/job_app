import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CompanyApplications extends StatefulWidget {
  const CompanyApplications({super.key});

  @override
  State<CompanyApplications> createState() => _CompanyApplicationsState();
}

class _CompanyApplicationsState extends State<CompanyApplications> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Application page"));
  }
}
