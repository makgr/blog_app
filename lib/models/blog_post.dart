import 'package:hive/hive.dart';

part 'blog_post.g.dart';

@HiveType(typeId: 0)
class BlogPost {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final String imagePath; // Store the image file path

  BlogPost(
      {required this.title, required this.content, required this.imagePath});
}
