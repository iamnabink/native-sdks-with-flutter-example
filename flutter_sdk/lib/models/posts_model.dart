import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../models/post.dart';
import '../services/posts_service.dart';
import '../services/service_locator.dart';

class PostsModel extends ChangeNotifier {
  PostsModel() {
    _service = PostsService(GetIt.instance<Dio>());
    _loadPosts();
  }

  late final PostsService _service;
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Fake 3 second delay
    await Future.delayed(const Duration(seconds: 3));

    final result = await _service.getPosts();
    
    result.fold(
      (error) {
        _error = error;
        _isLoading = false;
      },
      (posts) {
        _posts = posts;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadPosts();
  }
}
