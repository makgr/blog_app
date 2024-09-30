import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/blog_post.dart';
import 'screens/blog_list_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BlogPostAdapter());
  await Hive.openBox<BlogPost>('blogPosts');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlogListScreen(),
    );
  }
}
