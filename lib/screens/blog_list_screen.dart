import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:blog_app/models/blog_post.dart';
import 'package:blog_app/screens/add_blog_screen.dart';
import 'package:blog_app/screens/edit_blog_screen.dart';
import 'package:blog_app/screens/view_blog_screen.dart';
import 'dart:io';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late Box<BlogPost> blogBox;

  @override
  void initState() {
    super.initState();
    blogBox = Hive.box<BlogPost>('blogPosts');
  }

  void _deletePost(int index) {
    BlogPost? deletedPost = blogBox.getAt(index);
    blogBox.deleteAt(index);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${deletedPost?.title ?? "Blog post"} deleted successfully'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (deletedPost != null) {
              blogBox.add(deletedPost);
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blog Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
      ),
      body: ValueListenableBuilder(
        valueListenable: blogBox.listenable(),
        builder: (context, Box<BlogPost> box, _) {
          if (box.isEmpty) {
            return const Center(
                child: Text('No Blog Posts', style: TextStyle(fontSize: 18)));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              BlogPost? post = box.getAt(index);
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewBlogScreen(blogPost: post!),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: post?.imagePath != null
                              ? Image.file(
                                  File(post!.imagePath),
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image, size: 80),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post?.title ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                post?.content ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBlogScreen(
                                        blogPost: post!, index: index),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deletePost(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBlogScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
