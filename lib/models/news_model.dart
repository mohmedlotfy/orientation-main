class NewsModel {
  final String id;
  final String projectId;
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final bool isAsset;
  final List<String> gradientColors;
  final DateTime date;
  final String projectName;
  final String projectSubtitle;
  final bool isReminded;

  NewsModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.subtitle = '',
    this.description = '',
    required this.image,
    this.isAsset = false,
    this.gradientColors = const ['0xFF5a8a9a', '0xFF3a6a7a'],
    required this.date,
    required this.projectName,
    this.projectSubtitle = '',
    this.isReminded = false,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['_id'] ?? json['id'] ?? '',
      projectId: json['projectId'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      isAsset: json['isAsset'] ?? false,
      gradientColors: json['gradientColors'] != null
          ? List<String>.from(json['gradientColors'])
          : ['0xFF5a8a9a', '0xFF3a6a7a'],
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      projectName: json['projectName'] ?? '',
      projectSubtitle: json['projectSubtitle'] ?? '',
      isReminded: json['isReminded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'image': image,
      'isAsset': isAsset,
      'gradientColors': gradientColors,
      'date': date.toIso8601String(),
      'projectName': projectName,
      'projectSubtitle': projectSubtitle,
      'isReminded': isReminded,
    };
  }

  NewsModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? subtitle,
    String? description,
    String? image,
    bool? isAsset,
    List<String>? gradientColors,
    DateTime? date,
    String? projectName,
    String? projectSubtitle,
    bool? isReminded,
  }) {
    return NewsModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      image: image ?? this.image,
      isAsset: isAsset ?? this.isAsset,
      gradientColors: gradientColors ?? this.gradientColors,
      date: date ?? this.date,
      projectName: projectName ?? this.projectName,
      projectSubtitle: projectSubtitle ?? this.projectSubtitle,
      isReminded: isReminded ?? this.isReminded,
    );
  }
}

