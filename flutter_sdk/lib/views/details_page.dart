import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../models/posts_model.dart';
import '../models/post.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostsModel(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Details Page',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<PostsModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/lottie/be_bold.json',
                  width: 200,
                  height: 200,
                  repeat: true,
                ),
              );
            }

            if (model.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      model.error!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => model.refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                // Lottie background
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.2,
                    child: Lottie.asset(
                      'assets/lottie/be_bold.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                ),
                // Content
                RefreshIndicator(
                  onRefresh: () => model.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: model.posts.length,
                    itemBuilder: (context, index) {
                      final post = model.posts[index];
                      return _DetailCard(post: post);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final Post post;

  const _DetailCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.amber,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
      Colors.indigo,
    ];
    final icons = [
      Icons.info_outline,
      Icons.star_outline,
      Icons.analytics_outlined,
      Icons.settings_outlined,
      Icons.notifications_outlined,
      Icons.help_outline,
      Icons.favorite_outline,
      Icons.share_outlined,
      Icons.bookmark_outline,
      Icons.download_outlined,
    ];

    final colorIndex = post.id % colors.length;
    final iconIndex = post.id % icons.length;

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors[colorIndex].withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icons[iconIndex],
                color: colors[colorIndex],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors[colorIndex],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Post #${post.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.body,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
