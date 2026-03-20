import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ui/screen.dart';
import 'ui/shared/custompageroute.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const routeName = '/main';
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      primary: Colors.blue, // màu chính
      onPrimary: Colors.white, // chữ trên nền xanh
      secondary: Colors.blueAccent,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      brightness: Brightness.light,
      surfaceTint: Colors.blue[50],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersManager(),
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child) {
          return MaterialApp(
            title: 'T Shop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: colorScheme,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shadowColor: Colors.grey,
              ),
              textTheme: const TextTheme(
                displaySmall: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                displayMedium: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                displayLarge: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              checkboxTheme: CheckboxThemeData(
                side: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
            home: authManager.isAuth
                ? const SafeArea(child: OverViewScreen())
                : FutureBuilder(
                    future: authManager.tryAutoLogin(),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const SafeArea(child: SplashScreen())
                          : const SafeArea(child: AuthScreen());
                    },
                  ),
            routes: {
              '/over_view': (ctx) => const SafeArea(
                    child: OverViewScreen(),
                  ),
              '/product_favorite': (ctx) => const SafeArea(
                    child: ProductsFavoriteScreen(),
                  ),
              '/user_products': (ctx) => const SafeArea(
                    child: UserProductsScreen(),
                  ),
              '/auth_information': (ctx) => const SafeArea(
                    child: AuthInformationScreen(),
                  ),
              '/order_screen': (ctx) => const SafeArea(
                    child: OrdersScreen(),
                  ),
              '/revenue': (ctx) => const RevenueScreen(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/cart_screen':
                  return CustomPageRoute(builder: (context) => CartScreen());
                case '/edit_product':
                  final productId = settings.arguments as String?;
                  return CustomPageRoute(
                      builder: (context) => EditProductScreen(productId != null
                          ? ctx.read<ProductManager>().findById(productId)
                          : null));
                case '/edit_auth':
                  final user = settings.arguments as Map<String, dynamic>;
                  return CustomPageRoute(
                      builder: (context) => EditAuthScreen(
                          ctx.read<AuthManager>().getUserFromMap(user)));
                case '/payment':
                  final cartItem = settings.arguments as CartItem;
                  return CustomPageRoute(
                      builder: (context) => PaymentScreen(cartItem));
                case '/product_detail':
                  final productId = settings.arguments as String;
                  return CustomPageRoute(
                      builder: (context) => ProductDetailScreen(
                          ctx.read<ProductManager>().findById(productId)!));
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
