import 'package:flutter/widgets.dart';
import 'package:project_management_app/core/preferences/AppPreferences.dart';

extension RoleExtensions on BuildContext {
  List<String> get userRoles => AppPreferences.roles ?? [];

  bool hasRole(String role) => userRoles.contains(role);
}