import '../models/project_model.dart';
import '../models/developer_model.dart';
import '../models/area_model.dart';
import '../models/episode_model.dart';
import '../models/clip_model.dart';
import '../models/pdf_file_model.dart';
import '../models/news_model.dart';

class MockData {
  // Sample marketing script
  static const String sampleScript = '''Aljar British District

Direct On Suez Road
مباشر علي طريق السويس امام مدينتي4
و مدخل الشروق 3

Serviced Apartments By
Concord Al-Salam Hotel

5% Down payment
10% After 3 months
7 years installments

1 bed: 66m to 72m - 4.4M to 5.9M
2 bed: 121m to 130m - 8M to 11.2M
3 bed: 151m to 188m - 9.5M to 14.7M

Maintenance: 5k per meter
10% Launch Discount

Fully finished with Ac's, kitchen Units and Under Ground Parking

Facilities:
• Clubhouse
• Gym
• Swimming pools
• Commercial District
• Medical Center
• British University''';

  // Featured Projects
  static List<ProjectModel> featuredProjects = [
    ProjectModel(
      id: 'feat-1',
      title: 'LVERSAN',
      subtitle: 'NORTH COAST',
      label: 'PRESENTS',
      image: 'assets/images/lversan.png',
      isAsset: true,
      gradientColors: ['0xFF1a4a4a', '0xFF0d2525'],
      location: 'North Coast',
      area: 'Sidi Abdelrahman',
      developerName: 'Mountain View',
      developerId: 'dev-1',
      category: 'Residential',
      isFeatured: true,
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'feat-2',
      title: 'masaya',
      subtitle: 'SIDI ABDELRAHMAN',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      gradientColors: ['0xFF4ECDC4', '0xFF44A08D'],
      location: 'North Coast',
      area: 'Sidi Abdelrahman',
      developerName: 'Tatweer Misr',
      developerId: 'dev-2',
      category: 'Residential',
      isFeatured: true,
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'feat-3',
      title: 'SEASHORE',
      subtitle: 'RAS ELHEKMA',
      image: 'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=1200',
      gradientColors: ['0xFF2d5a7b', '0xFF1a3a52'],
      location: 'North Coast',
      area: 'Ras El Hekma',
      developerName: 'SODIC',
      developerId: 'dev-3',
      category: 'Residential',
      isFeatured: true,
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
  ];

  // Latest Projects
  static List<ProjectModel> latestProjects = [
    ProjectModel(
      id: 'lat-1',
      title: 'Seashore',
      subtitle: 'North Coast',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      location: 'North Coast',
      area: 'Ras El Hekma',
      developerName: 'SODIC',
      developerId: 'dev-3',
      category: 'Residential',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'lat-2',
      title: 'THE ICON',
      subtitle: 'New Cairo',
      image: 'assets/top10/the_icon.png',
      isAsset: true,
      gradientColors: ['0xFF3d3d3d', '0xFF2a2a2a'],
      location: 'New Cairo',
      area: 'New Cairo',
      developerName: 'Emaar',
      developerId: 'dev-4',
      category: 'Commercial',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'lat-3',
      title: 'Palm Hills',
      subtitle: 'October',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF2d5a4a', '0xFF1d4a3a'],
      location: 'October',
      developerName: 'Palm Hills',
      category: 'Residential',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
  ];

  // Continue Watching
  static List<ProjectModel> continueWatching = [
    ProjectModel(
      id: 'cw-1',
      title: 'Tawny',
      subtitle: 'Hyde Park',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFFd4c4b0', '0xFFc4b4a0'],
      watchProgress: 0.4,
      developerName: 'Hyde Park',
    ),
    ProjectModel(
      id: 'cw-2',
      title: 'Tawny',
      subtitle: 'Hyde Park',
      image: 'assets/top10/the_icon.png',
      isAsset: true,
      gradientColors: ['0xFFd4c4b0', '0xFFc4b4a0'],
      watchProgress: 0.6,
      developerName: 'Hyde Park',
    ),
  ];

  // Top 10 Projects
  static List<ProjectModel> top10Projects = [
    ProjectModel(
      id: 'top-1',
      title: 'masaya',
      subtitle: 'North Coast',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF8B7355', '0xFF5D4E37'],
      rank: 1,
      location: 'North Coast',
      area: 'Sidi Abdelrahman',
      developerName: 'Tatweer Misr',
      developerId: 'dev-2',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'top-2',
      title: 'THE ICON',
      subtitle: 'New Cairo',
      image: 'assets/top10/the_icon.png',
      isAsset: true,
      gradientColors: ['0xFF3d3d3d', '0xFF2a2a2a'],
      rank: 2,
      location: 'New Cairo',
      area: 'New Cairo',
      developerName: 'Emaar',
      developerId: 'dev-4',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'top-3',
      title: 'Seashore',
      subtitle: 'North Coast',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      rank: 3,
      location: 'North Coast',
      area: 'Ras El Hekma',
      developerName: 'SODIC',
      developerId: 'dev-3',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
  ];

  // Projects by Area
  static List<ProjectModel> northCoastProjects = [
    ProjectModel(
      id: 'nc-1',
      title: 'Seashore',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      location: 'North Coast',
      area: 'Ras El Hekma',
      developerName: 'SODIC',
      developerId: 'dev-3',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'nc-2',
      title: 'LVERSAN',
      image: 'assets/images/lversan.png',
      isAsset: true,
      gradientColors: ['0xFF1a4a4a', '0xFF0d2525'],
      location: 'North Coast',
      area: 'Sidi Abdelrahman',
      developerName: 'Mountain View',
      developerId: 'dev-1',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
  ];

  static List<ProjectModel> dubaiProjects = [
    ProjectModel(
      id: 'db-1',
      title: 'Palm Jumeirah',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      location: 'Dubai',
      area: 'Dubai',
    ),
    ProjectModel(
      id: 'db-2',
      title: 'Downtown',
      image: 'assets/top10/the_icon.png',
      isAsset: true,
      gradientColors: ['0xFF3d3d3d', '0xFF2a2a2a'],
      location: 'Dubai',
      area: 'Dubai',
    ),
  ];

  static List<ProjectModel> omanProjects = [
    ProjectModel(
      id: 'om-1',
      title: 'Muscat Hills',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      location: 'Oman',
      area: 'Muscat',
    ),
    ProjectModel(
      id: 'om-2',
      title: 'Salalah Beach',
      image: 'assets/top10/the_icon.png',
      isAsset: true,
      gradientColors: ['0xFF3d3d3d', '0xFF2a2a2a'],
      location: 'Oman',
      area: 'Salalah',
    ),
  ];

  // Upcoming Projects
  static List<ProjectModel> upcomingProjects = [
    ProjectModel(
      id: 'up-1',
      title: 'New Vista',
      subtitle: 'Coming Soon',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      isUpcoming: true,
    ),
    ProjectModel(
      id: 'up-2',
      title: 'Sky Tower',
      subtitle: 'Coming Soon',
      image: 'assets/top10/the_icon.png',
      isAsset: true,
      gradientColors: ['0xFF3d3d3d', '0xFF2a2a2a'],
      isUpcoming: true,
    ),
  ];

  // Developers
  static List<DeveloperModel> developers = [
    DeveloperModel(
      id: 'dev-1',
      name: 'Mountain View',
      logo: 'assets/developers/mountain_view.png',
      isAsset: true,
      projectsCount: 15,
      areas: ['North Coast', 'New Cairo', 'October'],
    ),
    DeveloperModel(
      id: 'dev-2',
      name: 'Tatweer Misr',
      logo: 'assets/developers/tatweer.png',
      isAsset: true,
      projectsCount: 12,
      areas: ['North Coast', 'Ain Sokhna'],
    ),
    DeveloperModel(
      id: 'dev-3',
      name: 'SODIC',
      logo: 'assets/developers/sodic.png',
      isAsset: true,
      projectsCount: 20,
      areas: ['North Coast', 'Sheikh Zayed', 'New Cairo'],
    ),
    DeveloperModel(
      id: 'dev-4',
      name: 'Emaar',
      logo: 'assets/developers/emaar.png',
      isAsset: true,
      projectsCount: 25,
      areas: ['New Cairo', 'Dubai'],
    ),
    DeveloperModel(
      id: 'dev-5',
      name: 'Palm Hills',
      logo: 'assets/developers/palm_hills.png',
      isAsset: true,
      projectsCount: 18,
      areas: ['October', 'New Cairo', 'Alexandria'],
    ),
  ];

  // Areas
  static List<AreaModel> areas = [
    AreaModel(
      id: 'area-1',
      name: 'North Coast',
      projectsCount: 45,
      country: 'Egypt',
    ),
    AreaModel(
      id: 'area-2',
      name: 'New Cairo',
      projectsCount: 80,
      country: 'Egypt',
    ),
    AreaModel(
      id: 'area-3',
      name: 'Sheikh Zayed',
      projectsCount: 35,
      country: 'Egypt',
    ),
    AreaModel(
      id: 'area-4',
      name: 'October',
      projectsCount: 40,
      country: 'Egypt',
    ),
    AreaModel(
      id: 'area-5',
      name: 'Ain Sokhna',
      projectsCount: 25,
      country: 'Egypt',
    ),
    AreaModel(
      id: 'area-6',
      name: 'Dubai',
      projectsCount: 120,
      country: 'UAE',
    ),
    AreaModel(
      id: 'area-7',
      name: 'Oman',
      projectsCount: 30,
      country: 'Oman',
    ),
  ];

  // Episodes
  static List<EpisodeModel> episodes = [
    EpisodeModel(
      id: 'ep-1',
      projectId: 'feat-1',
      title: 'Project Overview',
      episodeNumber: 1,
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/video1.mp4',
      duration: '15:30',
      description: 'An overview of the LVERSAN project',
    ),
    EpisodeModel(
      id: 'ep-2',
      projectId: 'feat-1',
      title: 'Unit Types',
      episodeNumber: 2,
      thumbnail: 'assets/top10/the_icon.png',
      isAsset: true,
      videoUrl: 'https://example.com/video2.mp4',
      duration: '22:45',
      description: 'Explore different unit types',
    ),
    EpisodeModel(
      id: 'ep-3',
      projectId: 'feat-1',
      title: 'Amenities & Facilities',
      episodeNumber: 3,
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/video3.mp4',
      duration: '18:20',
      description: 'Discover all amenities',
    ),
    EpisodeModel(
      id: 'ep-4',
      projectId: 'feat-2',
      title: 'Masaya Overview',
      episodeNumber: 1,
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/video4.mp4',
      duration: '20:00',
      description: 'Overview of Masaya project',
    ),
    EpisodeModel(
      id: 'ep-5',
      projectId: 'feat-3',
      title: 'Seashore Introduction',
      episodeNumber: 1,
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '25:15',
      description: 'Introduction to Seashore',
    ),
    // Episodes for latest projects
    EpisodeModel(
      id: 'ep-6',
      projectId: 'lat-1',
      title: 'Seashore Overview',
      episodeNumber: 1,
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '20:00',
      description: 'Overview of Seashore project',
    ),
    EpisodeModel(
      id: 'ep-7',
      projectId: 'lat-2',
      title: 'THE ICON Overview',
      episodeNumber: 1,
      thumbnail: 'assets/top10/the_icon.png',
      isAsset: true,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '18:30',
      description: 'Overview of THE ICON project',
    ),
    EpisodeModel(
      id: 'ep-8',
      projectId: 'lat-3',
      title: 'Palm Hills Overview',
      episodeNumber: 1,
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      duration: '22:00',
      description: 'Overview of Palm Hills project',
    ),
  ];

  // Clips/Reels
  static List<ClipModel> clips = [
    // LVERSAN clips
    ClipModel(
      id: 'clip-1',
      projectId: 'feat-1',
      title: 'LVERSAN Tour',
      description: 'Take a tour of the stunning LVERSAN project in North Coast',
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip1.mp4',
      developerName: 'Mountain View',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 245,
    ),
    ClipModel(
      id: 'clip-2',
      projectId: 'feat-1',
      title: 'LVERSAN Beach View',
      description: 'Beautiful beach views from LVERSAN units',
      thumbnail: 'assets/top10/the_icon.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip2.mp4',
      developerName: 'Mountain View',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 189,
    ),
    // Masaya clips
    ClipModel(
      id: 'clip-3',
      projectId: 'feat-2',
      title: 'Masaya Overview',
      description: 'Discover the beauty of Masaya in Sidi Abdelrahman',
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip3.mp4',
      developerName: 'Tatweer Misr',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 320,
    ),
    ClipModel(
      id: 'clip-4',
      projectId: 'feat-2',
      title: 'Masaya Lifestyle',
      description: 'Experience the lifestyle at Masaya',
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip4.mp4',
      developerName: 'Tatweer Misr',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 156,
    ),
    // Seashore clips
    ClipModel(
      id: 'clip-5',
      projectId: 'feat-3',
      title: 'Seashore Intro',
      description: 'Welcome to Seashore - Ras El Hekma',
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip5.mp4',
      developerName: 'SODIC',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 412,
    ),
    // Additional clips for other projects (lat-1, lat-2, etc.)
    ClipModel(
      id: 'clip-6',
      projectId: 'lat-1',
      title: 'Seashore Tour',
      description: 'Explore Seashore project in North Coast',
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip6.mp4',
      developerName: 'SODIC',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 280,
    ),
    ClipModel(
      id: 'clip-7',
      projectId: 'lat-2',
      title: 'THE ICON Overview',
      description: 'Discover THE ICON in New Cairo',
      thumbnail: 'assets/top10/the_icon.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip7.mp4',
      developerName: 'Emaar',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 195,
    ),
    ClipModel(
      id: 'clip-8',
      projectId: 'top-1',
      title: 'Masaya Lifestyle',
      description: 'Experience life at Masaya',
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip8.mp4',
      developerName: 'Tatweer Misr',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 350,
    ),
    ClipModel(
      id: 'clip-9',
      projectId: 'top-2',
      title: 'THE ICON Tour',
      description: 'Take a tour of THE ICON project',
      thumbnail: 'assets/top10/the_icon.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip9.mp4',
      developerName: 'Emaar',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 220,
    ),
    ClipModel(
      id: 'clip-10',
      projectId: 'top-3',
      title: 'Seashore Beach View',
      description: 'Beautiful beach views from Seashore',
      thumbnail: 'assets/top10/masaya.png',
      isAsset: true,
      videoUrl: 'https://example.com/clip10.mp4',
      developerName: 'SODIC',
      developerLogo: 'assets/developers/Rectangle.png',
      likes: 310,
    ),
  ];

  // PDF Files
  static List<PdfFileModel> pdfFiles = [
    // LVERSAN PDFs
    PdfFileModel(
      id: 'pdf-1',
      projectId: 'feat-1',
      title: 'LVERSAN Brochure',
      fileName: 'lversan-brochure.pdf',
      fileUrl: 'https://example.com/files/lversan-brochure.pdf',
      description: 'Complete project brochure with all details',
      fileSize: 2500000, // 2.5 MB
      createdAt: DateTime(2024, 1, 15),
    ),
    PdfFileModel(
      id: 'pdf-2',
      projectId: 'feat-1',
      title: 'LVERSAN Price List',
      fileName: 'lversan-prices.pdf',
      fileUrl: 'https://example.com/files/lversan-prices.pdf',
      description: 'Updated price list for all units',
      fileSize: 850000, // 850 KB
      createdAt: DateTime(2024, 2, 1),
    ),
    // Masaya PDFs
    PdfFileModel(
      id: 'pdf-3',
      projectId: 'feat-2',
      title: 'Masaya Floor Plans',
      fileName: 'masaya-floor-plans.pdf',
      fileUrl: 'https://example.com/files/masaya-floor-plans.pdf',
      description: 'Detailed floor plans for all unit types',
      fileSize: 3200000, // 3.2 MB
      createdAt: DateTime(2024, 1, 20),
    ),
    // Seashore PDFs
    PdfFileModel(
      id: 'pdf-4',
      projectId: 'feat-3',
      title: 'Seashore Brochure',
      fileName: 'seashore-brochure.pdf',
      fileUrl: 'https://example.com/files/seashore-brochure.pdf',
      description: 'Complete project information and amenities',
      fileSize: 1800000, // 1.8 MB
      createdAt: DateTime(2024, 1, 10),
    ),
    PdfFileModel(
      id: 'pdf-5',
      projectId: 'feat-3',
      title: 'Seashore Payment Plan',
      fileName: 'seashore-payment-plan.pdf',
      fileUrl: 'https://example.com/files/seashore-payment-plan.pdf',
      description: 'Flexible payment plans and installments',
      fileSize: 650000, // 650 KB
      createdAt: DateTime(2024, 2, 5),
    ),
    // Additional PDFs for other projects
    PdfFileModel(
      id: 'pdf-6',
      projectId: 'lat-1',
      title: 'Seashore Overview',
      fileName: 'seashore-overview.pdf',
      fileUrl: 'https://example.com/files/seashore-overview.pdf',
      description: 'Project overview and key features',
      fileSize: 1200000, // 1.2 MB
      createdAt: DateTime(2024, 1, 25),
    ),
    PdfFileModel(
      id: 'pdf-7',
      projectId: 'top-1',
      title: 'Masaya Investment Guide',
      fileName: 'masaya-investment-guide.pdf',
      fileUrl: 'https://example.com/files/masaya-investment-guide.pdf',
      description: 'Investment opportunities and ROI analysis',
      fileSize: 2100000, // 2.1 MB
      createdAt: DateTime(2024, 2, 10),
    ),
  ];

  // Liked clips
  static List<String> likedClipIds = [];

  // Saved Projects (user's favorites)
  static List<String> savedProjectIds = [];

  // Filter projects by category
  static List<ProjectModel> getProjectsByCategory(String category) {
    final allProjects = [...latestProjects, ...top10Projects, ...northCoastProjects];
    if (category == 'All') return allProjects;
    return allProjects.where((p) => p.category == category).toList();
  }

  // Get projects by area
  static List<ProjectModel> getProjectsByArea(String areaName) {
    switch (areaName.toLowerCase()) {
      case 'north coast':
      case 'northcoast':
        return northCoastProjects;
      case 'dubai':
        return dubaiProjects;
      case 'oman':
        return omanProjects;
      default:
        return [];
    }
  }

  // Get project by ID
  static ProjectModel? getProjectById(String id) {
    final allProjects = [
      ...featuredProjects,
      ...latestProjects,
      ...continueWatching,
      ...top10Projects,
      ...northCoastProjects,
      ...dubaiProjects,
      ...omanProjects,
      ...upcomingProjects,
    ];
    try {
      return allProjects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get episodes by project ID
  static List<EpisodeModel> getEpisodesByProjectId(String projectId) {
    return episodes.where((e) => e.projectId == projectId).toList();
  }

  // Get clips by project ID
  static List<ClipModel> getClipsByProjectId(String projectId) {
    return clips.where((c) => c.projectId == projectId).toList();
  }

  // Get PDF files by project ID
  static List<PdfFileModel> getPdfFilesByProjectId(String projectId) {
    return pdfFiles.where((p) => p.projectId == projectId).toList();
  }

  // Get all clips
  static List<ClipModel> getAllClips() {
    return clips;
  }

  // Check if clip is liked
  static bool isClipLiked(String clipId) {
    return likedClipIds.contains(clipId);
  }

  // Like clip
  static void likeClip(String clipId) {
    if (!likedClipIds.contains(clipId)) {
      likedClipIds.add(clipId);
    }
  }

  // Unlike clip
  static void unlikeClip(String clipId) {
    likedClipIds.remove(clipId);
  }

  // Check if project is saved
  static bool isProjectSaved(String projectId) {
    return savedProjectIds.contains(projectId);
  }

  // Save project
  static void saveProject(String projectId) {
    if (!savedProjectIds.contains(projectId)) {
      savedProjectIds.add(projectId);
    }
  }

  // Unsave project
  static void unsaveProject(String projectId) {
    savedProjectIds.remove(projectId);
  }

  // Get saved projects
  static List<ProjectModel> getSavedProjects() {
    return savedProjectIds
        .map((id) => getProjectById(id))
        .where((p) => p != null)
        .cast<ProjectModel>()
        .toList();
  }

  // Get projects by developer ID
  static List<ProjectModel> getProjectsByDeveloperId(String developerId) {
    final allProjects = [
      ...featuredProjects,
      ...latestProjects,
      ...continueWatching,
      ...top10Projects,
      ...northCoastProjects,
      ...dubaiProjects,
      ...omanProjects,
      ...upcomingProjects,
    ];
    return allProjects.where((p) => p.developerId == developerId).toList();
  }

  // Add a new clip/reel
  static void addClip(ClipModel clip) {
    clips.add(clip);
  }

  // Update project inventory URL
  static void updateProjectInventory(String projectId, String inventoryUrl) {
    final allProjects = [
      ...featuredProjects,
      ...latestProjects,
      ...continueWatching,
      ...top10Projects,
      ...northCoastProjects,
      ...dubaiProjects,
      ...omanProjects,
      ...upcomingProjects,
    ];
    final projectIndex = allProjects.indexWhere((p) => p.id == projectId);
    if (projectIndex != -1) {
      // Note: This is a simplified approach. In a real scenario, you'd need to update the specific list
      // For now, we'll store it in SharedPreferences in ProjectApi
    }
  }

  // News
  static List<NewsModel> news = [
    NewsModel(
      id: 'news-1',
      projectId: 'feat-3',
      title: 'Seashore',
      subtitle: 'RAS EL HEKMA',
      description: 'FULLY FINISHED UNITS',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      date: DateTime.now().subtract(const Duration(days: 2)),
      projectName: 'SeaShore',
      projectSubtitle: 'The Icon',
    ),
    NewsModel(
      id: 'news-2',
      projectId: 'feat-1',
      title: 'LVERSAN',
      subtitle: 'NORTH COAST',
      description: 'PRESENTS',
      image: 'assets/images/lversan.png',
      isAsset: true,
      gradientColors: ['0xFF1a4a4a', '0xFF0d2525'],
      date: DateTime.now().subtract(const Duration(days: 5)),
      projectName: 'LVERSAN',
      projectSubtitle: 'Mountain View',
    ),
    NewsModel(
      id: 'news-3',
      projectId: 'feat-2',
      title: 'masaya',
      subtitle: 'SIDI ABDELRAHMAN',
      description: 'NEW LAUNCH',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF4ECDC4', '0xFF44A08D'],
      date: DateTime.now().subtract(const Duration(days: 7)),
      projectName: 'masaya',
      projectSubtitle: 'Tatweer Misr',
    ),
    NewsModel(
      id: 'news-4',
      projectId: 'feat-3',
      title: 'Seashore',
      subtitle: 'RAS EL HEKMA',
      description: 'FULLY FINISHED UNITS',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      date: DateTime.now().subtract(const Duration(days: 10)),
      projectName: 'SeaShore',
      projectSubtitle: 'The Icon',
    ),
    NewsModel(
      id: 'news-5',
      projectId: 'feat-1',
      title: 'LVERSAN',
      subtitle: 'NORTH COAST',
      description: 'PRESENTS',
      image: 'assets/images/lversan.png',
      isAsset: true,
      gradientColors: ['0xFF1a4a4a', '0xFF0d2525'],
      date: DateTime.now().subtract(const Duration(days: 12)),
      projectName: 'LVERSAN',
      projectSubtitle: 'Mountain View',
    ),
    NewsModel(
      id: 'news-6',
      projectId: 'feat-2',
      title: 'masaya',
      subtitle: 'SIDI ABDELRAHMAN',
      description: 'NEW LAUNCH',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF4ECDC4', '0xFF44A08D'],
      date: DateTime.now().subtract(const Duration(days: 15)),
      projectName: 'masaya',
      projectSubtitle: 'Tatweer Misr',
    ),
    NewsModel(
      id: 'news-7',
      projectId: 'feat-3',
      title: 'Seashore',
      subtitle: 'RAS EL HEKMA',
      description: 'FULLY FINISHED UNITS',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      date: DateTime.now().subtract(const Duration(days: 18)),
      projectName: 'SeaShore',
      projectSubtitle: 'The Icon',
    ),
    NewsModel(
      id: 'news-8',
      projectId: 'feat-1',
      title: 'LVERSAN',
      subtitle: 'NORTH COAST',
      description: 'PRESENTS',
      image: 'assets/images/lversan.png',
      isAsset: true,
      gradientColors: ['0xFF1a4a4a', '0xFF0d2525'],
      date: DateTime.now().subtract(const Duration(days: 20)),
      projectName: 'LVERSAN',
      projectSubtitle: 'Mountain View',
    ),
    NewsModel(
      id: 'news-9',
      projectId: 'feat-2',
      title: 'masaya',
      subtitle: 'SIDI ABDELRAHMAN',
      description: 'NEW LAUNCH',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF4ECDC4', '0xFF44A08D'],
      date: DateTime.now().subtract(const Duration(days: 22)),
      projectName: 'masaya',
      projectSubtitle: 'Tatweer Misr',
    ),
    NewsModel(
      id: 'news-10',
      projectId: 'feat-3',
      title: 'Seashore',
      subtitle: 'RAS EL HEKMA',
      description: 'FULLY FINISHED UNITS',
      image: 'assets/top10/masaya.png',
      isAsset: true,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      date: DateTime.now().subtract(const Duration(days: 25)),
      projectName: 'SeaShore',
      projectSubtitle: 'The Icon',
    ),
  ];

  // Get all news
  static List<NewsModel> getAllNews() {
    return news;
  }
}

