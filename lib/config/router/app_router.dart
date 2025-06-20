import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/check-status',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/check-status',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final String productId = state.params['id'] ?? 'no-id';
          return ProductScreen(productId: productId);
        }
      ),
    ],
    
    redirect: (context, state) {
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if(isGoingTo == '/check-status' && authStatus == AuthStatus.checking) return null;

      if(authStatus == AuthStatus.notAuthenticated) {
        if(isGoingTo == '/login' || isGoingTo == '/register') return null;
        
        return '/login';
      }

      if(authStatus == AuthStatus.authenticated) {
        if(isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/check-status') return '/';
      }

      return null;
    },
  );
});