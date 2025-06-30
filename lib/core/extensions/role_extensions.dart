import 'package:flutter/widgets.dart';
import 'package:project_management_app/core/preferences/AppPreferences.dart';

import '../constants/app_roles.dart';

extension RoleExtensions on BuildContext {
  List<String> get userRoles => AppPreferences.roles ?? [];

  bool hasRole(String role) => userRoles.contains(role);

  // Admin rolü kontrolü
  bool get isAdmin => hasRole(Roles.admin);
}