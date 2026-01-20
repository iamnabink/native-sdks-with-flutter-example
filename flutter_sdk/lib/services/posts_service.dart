import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../models/post.dart';

class PostsService {
  final Dio _dio;

  PostsService(this._dio);

  Future<Either<String, List<Post>>> getPosts() async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final posts = data.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
        return Right(posts);
      } else {
        return Left('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error loading posts: ${e.toString()}');
    }
  }
}
