import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mickeyadmin/pages/coverPhotos.dart';
import 'package:mickeyadmin/pages/holidayHomesListing.dart';
import 'package:mickeyadmin/pages/requestListing.dart';
import 'package:mickeyadmin/pages/safariesListing.dart';
import 'package:mickeyadmin/widgets/customAppBar.dart';
import 'package:mickeyadmin/widgets/footer.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:url_strategy/url_strategy.dart';

//Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCniUnoOpZ6j2FasjhRF_qoT-nn-TV4BOI',
      appId: '1:140657092147:web:61b4af9421656244aae546',
      messagingSenderId: '140657092147',
      projectId: 'project-5-97d71',
      authDomain: 'project-5-97d71.firebaseapp.com',
      databaseURL: 'https://project-5-97d71.firebaseio.com',
      storageBucket: 'project-5-97d71.appspot.com',
      measurementId: 'G-YSQF0YRZZ9',
    ),
  );

  setPathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin | Mickey Tours & Travel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, 50.0),
        child: const CustomAppBar(
          isShrink: true,
        ),
      ),
      body: RawScrollbar(
        controller: _controller,
        isAlwaysShown: false,
        radius: const Radius.circular(6.0),
        thumbColor: Colors.pink,
        thickness: 12.0,
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ResponsiveWrapper(
                  maxWidth: 800,
                  minWidth: 400,
                  defaultScale: true,
                  breakpoints: const [
                    ResponsiveBreakpoint.resize(480, name: MOBILE),
                    ResponsiveBreakpoint.autoScale(800, name: TABLET),
                    ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                    ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                  ],
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome to \nAdmin Panel",
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Mickey Tours & Travel ",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 12.0,
                                  ),
                                  Text(
                                    " Admin",
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          // =================================================================//
                          Text(
                            "Manage Cover Photos",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Card(
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CoverPhotos()));
                              },
                              leading: const Icon(
                                Icons.edit,
                                color: Colors.pink,
                              ),
                              title: const Text(
                                  "Arrange, Edit and Delete Cover Photos"),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Manage Safaries",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Card(
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SafariesListing()));
                              },
                              leading: const Icon(
                                Icons.edit,
                                color: Colors.pink,
                              ),
                              title: const Text("Edit and Upload new Safaries"),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Manage Holiday Homes",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Card(
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HolidayHomesListing()));
                              },
                              leading: const Icon(
                                Icons.edit,
                                color: Colors.pink,
                              ),
                              title: const Text(
                                  "Edit and Upload new Holiday Homes"),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Booking Requests",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Card(
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RequestListing()));
                              },
                              leading: const Icon(
                                Icons.edit,
                                color: Colors.pink,
                              ),
                              title: const Text("View Client Requests"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
