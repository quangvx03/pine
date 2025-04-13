import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/data/repositories/authentication_repository.dart';
import 'package:pine_admin_panel/routes/routes.dart';

class PRouteMiddleware extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated ? null : const RouteSettings(name: PRoutes.login);
  }
}