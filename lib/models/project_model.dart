class ProjectModel {
  final String id;
  final String title;
  final String subtitle;
  final String? label;
  final String image;
  final bool isAsset;
  final List<String> gradientColors;
  final String location;
  final String area;
  final String developerName;
  final String developerId;
  final String category;
  final String description;
  final double? watchProgress;
  final int? rank;
  final bool isFeatured;
  final bool isUpcoming;
  final bool isSaved;
  final List<String> tags;
  final DateTime? createdAt;
  // New fields for Project Details
  final String script;
  final String whatsappNumber;
  final String locationUrl;
  final String inventoryUrl;
  final String advertisementVideoUrl; // Video URL for advertisement in hero section

  ProjectModel({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.label,
    required this.image,
    this.isAsset = false,
    this.gradientColors = const ['0xFF1a4a4a', '0xFF0d2525'],
    this.location = '',
    this.area = '',
    this.developerName = '',
    this.developerId = '',
    this.category = 'Residential',
    this.description = '',
    this.watchProgress,
    this.rank,
    this.isFeatured = false,
    this.isUpcoming = false,
    this.isSaved = false,
    this.tags = const [],
    this.createdAt,
    this.script = '',
    this.whatsappNumber = '',
    this.locationUrl = '',
    this.inventoryUrl = '',
    this.advertisementVideoUrl = '',
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      label: json['label'],
      image: json['image'] ?? '',
      isAsset: json['isAsset'] ?? false,
      gradientColors: json['gradientColors'] != null
          ? List<String>.from(json['gradientColors'])
          : ['0xFF1a4a4a', '0xFF0d2525'],
      location: json['location'] ?? '',
      area: json['area'] ?? '',
      developerName: json['developerName'] ?? '',
      developerId: json['developerId'] ?? '',
      category: json['category'] ?? 'Residential',
      description: json['description'] ?? '',
      watchProgress: json['watchProgress']?.toDouble(),
      rank: json['rank'],
      isFeatured: json['isFeatured'] ?? false,
      isUpcoming: json['isUpcoming'] ?? false,
      isSaved: json['isSaved'] ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      script: json['script'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
      locationUrl: json['locationUrl'] ?? '',
      inventoryUrl: json['inventoryUrl'] ?? '',
      advertisementVideoUrl: json['advertisementVideoUrl'] ?? json['adVideoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'label': label,
      'image': image,
      'isAsset': isAsset,
      'gradientColors': gradientColors,
      'location': location,
      'area': area,
      'developerName': developerName,
      'developerId': developerId,
      'category': category,
      'description': description,
      'watchProgress': watchProgress,
      'rank': rank,
      'isFeatured': isFeatured,
      'isUpcoming': isUpcoming,
      'isSaved': isSaved,
      'tags': tags,
      'createdAt': createdAt?.toIso8601String(),
      'script': script,
      'whatsappNumber': whatsappNumber,
      'locationUrl': locationUrl,
      'inventoryUrl': inventoryUrl,
      'advertisementVideoUrl': advertisementVideoUrl,
    };
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? label,
    String? image,
    bool? isAsset,
    List<String>? gradientColors,
    String? location,
    String? area,
    String? developerName,
    String? developerId,
    String? category,
    String? description,
    double? watchProgress,
    int? rank,
    bool? isFeatured,
    bool? isUpcoming,
    bool? isSaved,
    List<String>? tags,
    DateTime? createdAt,
    String? script,
    String? whatsappNumber,
    String? locationUrl,
    String? inventoryUrl,
    String? advertisementVideoUrl,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      label: label ?? this.label,
      image: image ?? this.image,
      isAsset: isAsset ?? this.isAsset,
      gradientColors: gradientColors ?? this.gradientColors,
      location: location ?? this.location,
      area: area ?? this.area,
      developerName: developerName ?? this.developerName,
      developerId: developerId ?? this.developerId,
      category: category ?? this.category,
      description: description ?? this.description,
      watchProgress: watchProgress ?? this.watchProgress,
      rank: rank ?? this.rank,
      isFeatured: isFeatured ?? this.isFeatured,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      isSaved: isSaved ?? this.isSaved,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      script: script ?? this.script,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      locationUrl: locationUrl ?? this.locationUrl,
      inventoryUrl: inventoryUrl ?? this.inventoryUrl,
      advertisementVideoUrl: advertisementVideoUrl ?? this.advertisementVideoUrl,
    );
  }
}

