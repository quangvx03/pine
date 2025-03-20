import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pine_admin_panel/routes/routes.dart';

import '../common/widgets/layouts/sidebars/sidebar_controller.dart';

 class RouteObservers extends GetObserver {
   /// Called when a route is popped from the navigation stack
   @override
   void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
     final sidebarController = Get.put(SidebarController());

     if (previousRoute != null) {
       // Check the route name and update the active item in the sidebar accordingly
       for (var routeName in PRoutes.sidebarMenuItems) {
         if (previousRoute.settings.name == routeName) {
           sidebarController.activeItem.value = routeName;
         }
       }
     }
   }

   @override
   void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
     final sidebarController = Get.put(SidebarController());

     if (previousRoute != null) {
       // Check the route name and update the active item in the sidebar accordingly
       for (var routeName in PRoutes.sidebarMenuItems) {
         if (route?.settings.name == routeName) {
           sidebarController.activeItem.value = routeName;
         }
       }
     }
   }
 }