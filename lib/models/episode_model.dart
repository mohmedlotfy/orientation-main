class EpisodeModel {
  final String id;
  final String projectId;
  final String title;
  final int episodeNumber;
  final String thumbnail;
  final bool isAsset;
  final String videoUrl;
  final String duration;
  final String description;
  final DateTime? createdAt;

  EpisodeModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.episodeNumber,
    this.thumbnail = '',
    this.isAsset = false,
    this.videoUrl = '',
    this.duration = '',
    this.description = '',
    this.createdAt,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['_id'] ?? json['id'] ?? '',
      projectId: json['projectId'] ?? '',
      title: json['title'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 1,
      thumbnail: json['thumbnail'] ?? '',
      isAsset: json['isAsset'] ?? false,
      videoUrl: json['videoUrl'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'episodeNumber': episodeNumber,
      'thumbnail': thumbnail,
      'isAsset': isAsset,
      'videoUrl': videoUrl,
      'duration': duration,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

