import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Home%20Page/home.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Home(),
    ),
  ],
);
GoRouter getRouter(){
  return _router;
}