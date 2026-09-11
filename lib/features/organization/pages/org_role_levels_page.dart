import 'package:flutter/material.dart';
import 'org_roles_page.dart';

export 'org_roles_page.dart';

/// Backward-compatible wrapper for OrgRoleLevelsPage delegating to OrgRolesPage.
class OrgRoleLevelsPage extends StatelessWidget {
  const OrgRoleLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrgRolesPage();
  }
}
