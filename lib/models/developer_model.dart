class DeveloperModel {
  final String id;
  final String name;
  final String logo;
  final bool isAsset;
  final int projectsCount;
  final String description;
  final List<String> areas;
  final DateTime? createdAt;

  DeveloperModel({
    required this.id,
    required this.name,
    this.logo = '',
    this.isAsset = false,
    this.projectsCount = 0,
    this.description = '',
    this.areas = const [],
    this.createdAt,
  });

  factory DeveloperModel.fromJson(Map<String, dynamic> json) {
    return DeveloperModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      isAsset: json['isAsset'] ?? false,
      projectsCount: json['projectsCount'] ?? 0,
      description: json['description'] ?? '',
      areas: json['areas'] != null ? List<String>.from(json['areas']) : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'isAsset': isAsset,
      'projectsCount': projectsCount,
      'description': description,
      'areas': areas,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

