class PdfFileModel {
  final String id;
  final String projectId;
  final String title;
  final String fileName;
  final String fileUrl; // Cloud Storage URL
  final String? description;
  final int fileSize; // Size in bytes
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PdfFileModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.fileName,
    required this.fileUrl,
    this.description,
    this.fileSize = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory PdfFileModel.fromJson(Map<String, dynamic> json) {
    return PdfFileModel(
      id: json['_id'] ?? json['id'] ?? '',
      projectId: json['projectId'] ?? '',
      title: json['title'] ?? '',
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      description: json['description'],
      fileSize: json['fileSize'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'description': description,
      'fileSize': fileSize,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Format file size for display
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}

