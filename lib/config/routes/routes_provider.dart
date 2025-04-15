import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/config/routes/app_routes.dart';
import 'package:todo/config/routes/router_location.dart';
final routesProvider = Provider<GoRouter>((ref){
  return GoRouter(
      initialLocation: RouterLocation.home,
      navigatorKey: navigationKey,
      routes: appRoutes,
  );
});