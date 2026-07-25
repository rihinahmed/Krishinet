class KnowledgePost {
  final String id;
  final String authorName;
  final String authorTitle;
  String content;
  String? imagePath;
  final String date;
  int likes;
  bool isLikedByMe;

  KnowledgePost({
    required this.id,
    required this.authorName,
    required this.authorTitle,
    required this.content,
    this.imagePath,
    required this.date,
    this.likes = 0,
    this.isLikedByMe = false,
  });
}

class PostService {
  // Global singleton list of posts
  static final List<KnowledgePost> posts = [
    KnowledgePost(
      id: "1",
      authorName: "Dr. Tariq Mahmood",
      authorTitle: "Director of Agricultural Expansion",
      content: "Maximizing Rabi Yields through Regenerative Practices:\n\nRecent analytics suggest that local nitrogen levels are dipping across North zones. Recommend adding clover cover crops to maintain soil health for the upcoming cycle.",
      imagePath: "https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=800&q=80",
      date: "2 hours ago",
      likes: 120,
    ),
    KnowledgePost(
      id: "2",
      authorName: "Prof. Abdus Sobhan",
      authorTitle: "Soil Science Policy Advisor",
      content: "Intercropping Mustard with Wheat:\n\nData from the regional analysis shows a 15% reduction in pest outbreaks when mustard intercropping is implemented in sandy loam soils.",
      imagePath: "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?auto=format&fit=crop&w=800&q=80",
      date: "5 hours ago",
      likes: 85,
    ),
  ];

  static void addPost(String content, String? imagePath) {
    posts.insert(
      0,
      KnowledgePost(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorName: "Dr. Tariq Mahmood",
        authorTitle: "Director of Agricultural Expansion",
        content: content,
        imagePath: imagePath,
        date: "Just now",
        likes: 0,
      ),
    );
  }

  static void editPost(String id, String content, String? imagePath) {
    final index = posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      posts[index].content = content;
      posts[index].imagePath = imagePath;
    }
  }

  static void deletePost(String id) {
    posts.removeWhere((p) => p.id == id);
  }
}
