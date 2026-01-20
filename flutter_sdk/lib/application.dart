
import 'package:flutter/material.dart';
import 'views/posts_view.dart';
import 'views/home_page.dart';
import 'views/contents_view.dart';
import 'views/details_page.dart';

/// The "app" displayed by this module.
///
/// It offers routes for different views:
/// - '/' : Posts view (default)
/// - '/counter' : Home page with counter
/// - '/mini' : Mini contents view
/// - '/details' : Details page with data
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Module Title',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/counter',
      routes: {
        '/': (context) => const PostsView(),
        '/counter': (context) => const HomePage(),
        '/mini': (context) => const Contents(),
        '/details': (context) => const DetailsPage(),
      },
    );
  }
}
