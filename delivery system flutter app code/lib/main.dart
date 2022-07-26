// ignore_for_file: file_names

import 'package:delivery_system/controller/services/firebase/authentication/auth.dart';
import 'package:delivery_system/controller/services/firebase/real_time_database/user/UserEntity.dart';
import 'package:delivery_system/ui/screens/home/HomePage.dart';
import 'package:delivery_system/ui/screens/home/loading/LoadingPage.dart';
import 'package:delivery_system/ui/screens/home/map/MapPage.dart';
import 'package:delivery_system/ui/screens/main/Wrapper.dart';
import 'package:delivery_system/ui/shared/constants/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'ui/screens/home/orders/OrdersPage.dart';
import 'ui/screens/home/profile/ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////
    return StreamProvider<User?>.value(
      value: AuthServices.user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Delivery robot',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const Wrapper(),
        initialRoute: routePageWrapper,
        routes: {
          routePageWrapper: (context) => const Wrapper(),
          routePageHome: (context) => const HomePage(),
          routePageMap: (context) => const MapPage(),
          routePageLoading: (context) => const LoadingPage(),
          routePageOrders: (context) => const OrdersPage(),
          routePageProfile: (context) => const ProfilePage(),
        },
      ),
    );
  }
}