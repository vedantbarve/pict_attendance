import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/room.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAfZfWSiBmDyeGrbRF21RrDmnfk3YOwm9Q",
      appId: "1:584562469392:web:81e09cc81d2f219f4ff895",
      messagingSenderId: "584562469392",
      projectId: "attendance-recordingmonitoring",
    ),
  );
  setPathUrlStrategy();
  runApp(RootWidget());
}

class RootWidget extends StatelessWidget {
  RootWidget({Key? key}) : super(key: key);

  final routeDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) {
          return const BeamPage(
            title: 'Home',
            child: HomeView(),
          );
        },
        '/room/:roomId': (context, state, data) {
          final roomId = state.pathParameters["roomId"];
          return BeamPage(
            title: 'room',
            popToNamed: '/',
            child: RoomWidget(roomId: roomId!),
          );
        },
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: const ScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: BeamerParser(),
      routerDelegate: routeDelegate,
    );
  }
}
