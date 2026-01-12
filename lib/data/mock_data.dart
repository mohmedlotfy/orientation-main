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
      image: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200',
      isAsset: false,
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
      // Video from internet for testing
      advertisementVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      hasVideo: true,
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
      // Video from internet for testing
      advertisementVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      hasVideo: true,
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
      // Video from internet for testing
      advertisementVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      hasVideo: true,
    ),
  ];

  // Latest Projects
  static List<ProjectModel> latestProjects = [
    ProjectModel(
      id: 'lat-1',
      title: 'Seashore',
      subtitle: 'North Coast',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      // Video from internet for testing
      advertisementVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      hasVideo: true,
    ),
    ProjectModel(
      id: 'lat-2',
      title: 'THE ICON',
      subtitle: 'New Cairo',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
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
      // Video from internet for testing
      advertisementVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      hasVideo: true,
    ),
    ProjectModel(
      id: 'lat-3',
      title: 'Palm Hills',
      subtitle: 'October',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
      gradientColors: ['0xFF2d5a4a', '0xFF1d4a3a'],
      location: 'October',
      developerName: 'Palm Hills',
      category: 'Residential',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
      // Video from internet for testing
      advertisementVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      hasVideo: true,
    ),
  ];

  // Continue Watching
  static List<ProjectModel> continueWatching = [
    ProjectModel(
      id: 'cw-1',
      title: 'Tawny',
      subtitle: 'Hyde Park',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
      gradientColors: ['0xFFd4c4b0', '0xFFc4b4a0'],
      watchProgress: 0.4,
      developerName: 'Hyde Park',
    ),
    ProjectModel(
      id: 'cw-2',
      title: 'Tawny',
      subtitle: 'Hyde Park',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
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
      // Video from internet for testing
      advertisementVideoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      hasVideo: true,
    ),
    ProjectModel(
      id: 'top-3',
      title: 'Seashore',
      subtitle: 'North Coast',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
    ProjectModel(
      id: 'top-4',
      title: 'LVERSAN',
      subtitle: 'North Coast',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
      gradientColors: ['0xFF1a4a4a', '0xFF0d2525'],
      rank: 4,
      location: 'North Coast',
      area: 'Sidi Abdelrahman',
      developerName: 'Mountain View',
      developerId: 'dev-1',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'top-5',
      title: 'Aljar British District',
      subtitle: 'New Cairo',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
      gradientColors: ['0xFF6B8E23', '0xFF556B2F'],
      rank: 5,
      location: 'New Cairo',
      area: 'New Cairo',
      developerName: 'Concord Al-Salam',
      developerId: 'dev-5',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'top-6',
      title: 'Hyde Park',
      subtitle: 'New Cairo',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
      gradientColors: ['0xFF8B4513', '0xFF654321'],
      rank: 6,
      location: 'New Cairo',
      area: 'New Cairo',
      developerName: 'Hyde Park',
      developerId: 'dev-6',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'top-7',
      title: 'Marassi',
      subtitle: 'North Coast',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
      gradientColors: ['0xFF4682B4', '0xFF2F4F4F'],
      rank: 7,
      location: 'North Coast',
      area: 'Sidi Abdelrahman',
      developerName: 'Emaar Misr',
      developerId: 'dev-4',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'top-8',
      title: 'Westown',
      subtitle: '6th October',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
      gradientColors: ['0xFF9370DB', '0xFF663399'],
      rank: 8,
      location: '6th October',
      area: '6th October',
      developerName: 'SODIC',
      developerId: 'dev-3',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'top-9',
      title: 'Cairo Festival City',
      subtitle: 'New Cairo',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
      gradientColors: ['0xFFCD853F', '0xFF8B4513'],
      rank: 9,
      location: 'New Cairo',
      area: 'New Cairo',
      developerName: 'Al-Futtaim',
      developerId: 'dev-7',
      script: sampleScript,
      whatsappNumber: '+201205403733',
      locationUrl: 'https://maps.app.goo.gl/c4QrejpXGrCswfDU9',
      inventoryUrl: 'https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit',
    ),
    ProjectModel(
      id: 'top-10',
      title: 'Madinaty',
      subtitle: 'New Cairo',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
      gradientColors: ['0xFF20B2AA', '0xFF008B8B'],
      rank: 10,
      location: 'New Cairo',
      area: 'New Cairo',
      developerName: 'Talaat Moustafa Group',
      developerId: 'dev-8',
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      location: 'Dubai',
      area: 'Dubai',
    ),
    ProjectModel(
      id: 'db-2',
      title: 'Downtown',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
      gradientColors: ['0xFF3d3d3d', '0xFF2a2a2a'],
      location: 'Dubai',
      area: 'Dubai',
    ),
  ];

  static List<ProjectModel> omanProjects = [
    ProjectModel(
      id: 'om-1',
      title: 'Muscat Hills',
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      location: 'Oman',
      area: 'Muscat',
    ),
    ProjectModel(
      id: 'om-2',
      title: 'Salalah Beach',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
      gradientColors: ['0xFF5a8a9a', '0xFF3a6a7a'],
      isUpcoming: true,
    ),
    ProjectModel(
      id: 'up-2',
      title: 'Sky Tower',
      subtitle: 'Coming Soon',
      image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=1200',
      isAsset: false,
      gradientColors: ['0xFF3d3d3d', '0xFF2a2a2a'],
      isUpcoming: true,
    ),
  ];

  // Developers
  static List<DeveloperModel> developers = [
    DeveloperModel(
      id: 'dev-1',
      name: 'Mountain View',
      logo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      isAsset: false,
      projectsCount: 15,
      areas: ['North Coast', 'New Cairo', 'October'],
    ),
    DeveloperModel(
      id: 'dev-2',
      name: 'Tatweer Misr',
      logo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      isAsset: false,
      projectsCount: 12,
      areas: ['North Coast', 'Ain Sokhna'],
    ),
    DeveloperModel(
      id: 'dev-3',
      name: 'SODIC',
      logo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      isAsset: false,
      projectsCount: 20,
      areas: ['North Coast', 'Sheikh Zayed', 'New Cairo'],
    ),
    DeveloperModel(
      id: 'dev-4',
      name: 'Emaar',
      logo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      isAsset: false,
      projectsCount: 25,
      areas: ['New Cairo', 'Dubai'],
    ),
    DeveloperModel(
      id: 'dev-5',
      name: 'Palm Hills',
      logo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      isAsset: false,
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
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/video1.mp4',
      duration: '15:30',
      description: 'An overview of the LVERSAN project',
    ),
    EpisodeModel(
      id: 'ep-2',
      projectId: 'feat-1',
      title: 'Unit Types',
      episodeNumber: 2,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/video2.mp4',
      duration: '22:45',
      description: 'Explore different unit types',
    ),
    EpisodeModel(
      id: 'ep-3',
      projectId: 'feat-1',
      title: 'Amenities & Facilities',
      episodeNumber: 3,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/video3.mp4',
      duration: '18:20',
      description: 'Discover all amenities',
    ),
    EpisodeModel(
      id: 'ep-4',
      projectId: 'feat-2',
      title: 'Masaya Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/video4.mp4',
      duration: '20:00',
      description: 'Overview of Masaya project',
    ),
    EpisodeModel(
      id: 'ep-5',
      projectId: 'feat-3',
      title: 'Seashore Introduction',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
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
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '20:00',
      description: 'Overview of Seashore project',
    ),
    EpisodeModel(
      id: 'ep-7',
      projectId: 'lat-2',
      title: 'THE ICON Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '18:30',
      description: 'Overview of THE ICON project',
    ),
    EpisodeModel(
      id: 'ep-8',
      projectId: 'lat-3',
      title: 'Palm Hills Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      duration: '22:00',
      description: 'Overview of Palm Hills project',
    ),
    // Top 10 Projects Episodes
    EpisodeModel(
      id: 'ep-9',
      projectId: 'top-1',
      title: 'Masaya Project Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '20:00',
      description: 'Complete overview of Masaya project',
    ),
    EpisodeModel(
      id: 'ep-10',
      projectId: 'top-1',
      title: 'Masaya Unit Types',
      episodeNumber: 2,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '18:30',
      description: 'Explore different unit types in Masaya',
    ),
    EpisodeModel(
      id: 'ep-11',
      projectId: 'top-2',
      title: 'THE ICON Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      duration: '22:00',
      description: 'Complete overview of THE ICON project',
    ),
    EpisodeModel(
      id: 'ep-12',
      projectId: 'top-2',
      title: 'THE ICON Amenities',
      episodeNumber: 2,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      duration: '19:45',
      description: 'Discover all amenities and facilities',
    ),
    EpisodeModel(
      id: 'ep-13',
      projectId: 'top-3',
      title: 'Seashore Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '21:15',
      description: 'Complete overview of Seashore project',
    ),
    EpisodeModel(
      id: 'ep-14',
      projectId: 'top-4',
      title: 'LVERSAN Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '20:30',
      description: 'Complete overview of LVERSAN project',
    ),
    EpisodeModel(
      id: 'ep-15',
      projectId: 'top-5',
      title: 'Aljar British District Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      duration: '19:00',
      description: 'Complete overview of Aljar British District',
    ),
    EpisodeModel(
      id: 'ep-16',
      projectId: 'top-6',
      title: 'Hyde Park Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      duration: '18:45',
      description: 'Complete overview of Hyde Park project',
    ),
    EpisodeModel(
      id: 'ep-17',
      projectId: 'top-7',
      title: 'Marassi Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '20:20',
      description: 'Complete overview of Marassi project',
    ),
    EpisodeModel(
      id: 'ep-18',
      projectId: 'top-8',
      title: 'Westown Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '19:30',
      description: 'Complete overview of Westown project',
    ),
    EpisodeModel(
      id: 'ep-19',
      projectId: 'top-9',
      title: 'Cairo Festival City Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      duration: '21:00',
      description: 'Complete overview of Cairo Festival City',
    ),
    EpisodeModel(
      id: 'ep-20',
      projectId: 'top-10',
      title: 'Madinaty Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      duration: '20:15',
      description: 'Complete overview of Madinaty project',
    ),
    // North Coast Projects Episodes
    EpisodeModel(
      id: 'ep-21',
      projectId: 'nc-1',
      title: 'Seashore North Coast Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '21:00',
      description: 'Complete overview of Seashore project in North Coast',
    ),
    EpisodeModel(
      id: 'ep-22',
      projectId: 'nc-2',
      title: 'LVERSAN North Coast Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '19:30',
      description: 'Complete overview of LVERSAN project in North Coast',
    ),
    // Dubai Projects Episodes
    EpisodeModel(
      id: 'ep-23',
      projectId: 'db-1',
      title: 'Palm Jumeirah Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      duration: '22:30',
      description: 'Complete overview of Palm Jumeirah project',
    ),
    EpisodeModel(
      id: 'ep-24',
      projectId: 'db-2',
      title: 'Downtown Dubai Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      duration: '20:45',
      description: 'Complete overview of Downtown Dubai project',
    ),
    // Oman Projects Episodes
    EpisodeModel(
      id: 'ep-25',
      projectId: 'om-1',
      title: 'Muscat Hills Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '19:15',
      description: 'Complete overview of Muscat Hills project',
    ),
    EpisodeModel(
      id: 'ep-26',
      projectId: 'om-2',
      title: 'Salalah Beach Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '18:00',
      description: 'Complete overview of Salalah Beach project',
    ),
    // Upcoming Projects Episodes
    EpisodeModel(
      id: 'ep-27',
      projectId: 'up-1',
      title: 'New Vista Preview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      duration: '15:30',
      description: 'Preview of upcoming New Vista project',
    ),
    EpisodeModel(
      id: 'ep-28',
      projectId: 'up-2',
      title: 'Sky Tower Preview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      duration: '16:45',
      description: 'Preview of upcoming Sky Tower project',
    ),
    // Continue Watching Projects Episodes
    EpisodeModel(
      id: 'ep-29',
      projectId: 'cw-1',
      title: 'Tawny Overview',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '20:30',
      description: 'Complete overview of Tawny project',
    ),
    EpisodeModel(
      id: 'ep-30',
      projectId: 'cw-2',
      title: 'Tawny Unit Types',
      episodeNumber: 1,
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '19:15',
      description: 'Explore different unit types in Tawny',
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
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip1.mp4',
      developerName: 'Mountain View',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 245,
    ),
    ClipModel(
      id: 'clip-2',
      projectId: 'feat-1',
      title: 'LVERSAN Beach View',
      description: 'Beautiful beach views from LVERSAN units',
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip2.mp4',
      developerName: 'Mountain View',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 189,
    ),
    // Masaya clips
    ClipModel(
      id: 'clip-3',
      projectId: 'feat-2',
      title: 'Masaya Overview',
      description: 'Discover the beauty of Masaya in Sidi Abdelrahman',
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip3.mp4',
      developerName: 'Tatweer Misr',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 320,
    ),
    ClipModel(
      id: 'clip-4',
      projectId: 'feat-2',
      title: 'Masaya Lifestyle',
      description: 'Experience the lifestyle at Masaya',
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip4.mp4',
      developerName: 'Tatweer Misr',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 156,
    ),
    // Seashore clips
    ClipModel(
      id: 'clip-5',
      projectId: 'feat-3',
      title: 'Seashore Intro',
      description: 'Welcome to Seashore - Ras El Hekma',
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip5.mp4',
      developerName: 'SODIC',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 412,
    ),
    // Additional clips for other projects (lat-1, lat-2, etc.)
    ClipModel(
      id: 'clip-6',
      projectId: 'lat-1',
      title: 'Seashore Tour',
      description: 'Explore Seashore project in North Coast',
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip6.mp4',
      developerName: 'SODIC',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 280,
    ),
    ClipModel(
      id: 'clip-7',
      projectId: 'lat-2',
      title: 'THE ICON Overview',
      description: 'Discover THE ICON in New Cairo',
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip7.mp4',
      developerName: 'Emaar',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 195,
    ),
    ClipModel(
      id: 'clip-8',
      projectId: 'top-1',
      title: 'Masaya Lifestyle',
      description: 'Experience life at Masaya',
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip8.mp4',
      developerName: 'Tatweer Misr',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 350,
    ),
    ClipModel(
      id: 'clip-9',
      projectId: 'top-2',
      title: 'THE ICON Tour',
      description: 'Take a tour of THE ICON project',
      thumbnail: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip9.mp4',
      developerName: 'Emaar',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
      likes: 220,
    ),
    ClipModel(
      id: 'clip-10',
      projectId: 'top-3',
      title: 'Seashore Beach View',
      description: 'Beautiful beach views from Seashore',
      thumbnail: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=800',
      isAsset: false,
      videoUrl: 'https://example.com/clip10.mp4',
      developerName: 'SODIC',
      developerLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200',
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
      id: 'pdf-7-lat-2',
      projectId: 'lat-2',
      title: 'THE ICON Brochure',
      fileName: 'the-icon-latest-brochure.pdf',
      fileUrl: 'https://example.com/files/the-icon-latest-brochure.pdf',
      description: 'Complete project information and features',
      fileSize: 2200000, // 2.2 MB
      createdAt: DateTime(2024, 1, 28),
    ),
    PdfFileModel(
      id: 'pdf-8-lat-2',
      projectId: 'lat-2',
      title: 'THE ICON Floor Plans',
      fileName: 'the-icon-latest-floor-plans.pdf',
      fileUrl: 'https://example.com/files/the-icon-latest-floor-plans.pdf',
      description: 'Detailed floor plans for all unit types',
      fileSize: 3100000, // 3.1 MB
      createdAt: DateTime(2024, 2, 2),
    ),
    PdfFileModel(
      id: 'pdf-9-lat-3',
      projectId: 'lat-3',
      title: 'Palm Hills Brochure',
      fileName: 'palm-hills-brochure.pdf',
      fileUrl: 'https://example.com/files/palm-hills-brochure.pdf',
      description: 'Complete project information',
      fileSize: 1950000, // 1.95 MB
      createdAt: DateTime(2024, 2, 5),
    ),
    PdfFileModel(
      id: 'pdf-10-lat-3',
      projectId: 'lat-3',
      title: 'Palm Hills Price List',
      fileName: 'palm-hills-price-list.pdf',
      fileUrl: 'https://example.com/files/palm-hills-price-list.pdf',
      description: 'Updated price list for all units',
      fileSize: 900000, // 900 KB
      createdAt: DateTime(2024, 2, 8),
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
    PdfFileModel(
      id: 'pdf-8',
      projectId: 'top-1',
      title: 'Masaya Brochure',
      fileName: 'masaya-brochure.pdf',
      fileUrl: 'https://example.com/files/masaya-brochure.pdf',
      description: 'Complete project brochure with all details',
      fileSize: 1800000, // 1.8 MB
      createdAt: DateTime(2024, 2, 15),
    ),
    PdfFileModel(
      id: 'pdf-9',
      projectId: 'top-2',
      title: 'THE ICON Brochure',
      fileName: 'the-icon-brochure.pdf',
      fileUrl: 'https://example.com/files/the-icon-brochure.pdf',
      description: 'Complete project information and features',
      fileSize: 2200000, // 2.2 MB
      createdAt: DateTime(2024, 2, 12),
    ),
    PdfFileModel(
      id: 'pdf-10',
      projectId: 'top-2',
      title: 'THE ICON Floor Plans',
      fileName: 'the-icon-floor-plans.pdf',
      fileUrl: 'https://example.com/files/the-icon-floor-plans.pdf',
      description: 'Detailed floor plans for all unit types',
      fileSize: 3100000, // 3.1 MB
      createdAt: DateTime(2024, 2, 18),
    ),
    PdfFileModel(
      id: 'pdf-11',
      projectId: 'top-3',
      title: 'Seashore Brochure',
      fileName: 'seashore-brochure-top10.pdf',
      fileUrl: 'https://example.com/files/seashore-brochure-top10.pdf',
      description: 'Complete project information and amenities',
      fileSize: 1900000, // 1.9 MB
      createdAt: DateTime(2024, 2, 8),
    ),
    PdfFileModel(
      id: 'pdf-12',
      projectId: 'top-4',
      title: 'LVERSAN Investment Guide',
      fileName: 'lversan-investment-guide.pdf',
      fileUrl: 'https://example.com/files/lversan-investment-guide.pdf',
      description: 'Investment opportunities and analysis',
      fileSize: 2400000, // 2.4 MB
      createdAt: DateTime(2024, 2, 20),
    ),
    PdfFileModel(
      id: 'pdf-13',
      projectId: 'top-5',
      title: 'Aljar British District Brochure',
      fileName: 'aljar-brochure.pdf',
      fileUrl: 'https://example.com/files/aljar-brochure.pdf',
      description: 'Complete project information',
      fileSize: 2000000, // 2.0 MB
      createdAt: DateTime(2024, 2, 22),
    ),
    PdfFileModel(
      id: 'pdf-14',
      projectId: 'top-6',
      title: 'Hyde Park Brochure',
      fileName: 'hyde-park-brochure.pdf',
      fileUrl: 'https://example.com/files/hyde-park-brochure.pdf',
      description: 'Complete project information',
      fileSize: 1750000, // 1.75 MB
      createdAt: DateTime(2024, 2, 25),
    ),
    PdfFileModel(
      id: 'pdf-15',
      projectId: 'top-7',
      title: 'Marassi Brochure',
      fileName: 'marassi-brochure.pdf',
      fileUrl: 'https://example.com/files/marassi-brochure.pdf',
      description: 'Complete project information',
      fileSize: 2100000, // 2.1 MB
      createdAt: DateTime(2024, 2, 28),
    ),
    PdfFileModel(
      id: 'pdf-16',
      projectId: 'top-8',
      title: 'Westown Brochure',
      fileName: 'westown-brochure.pdf',
      fileUrl: 'https://example.com/files/westown-brochure.pdf',
      description: 'Complete project information',
      fileSize: 1950000, // 1.95 MB
      createdAt: DateTime(2024, 3, 1),
    ),
    PdfFileModel(
      id: 'pdf-17',
      projectId: 'top-9',
      title: 'Cairo Festival City Brochure',
      fileName: 'cairo-festival-brochure.pdf',
      fileUrl: 'https://example.com/files/cairo-festival-brochure.pdf',
      description: 'Complete project information',
      fileSize: 2300000, // 2.3 MB
      createdAt: DateTime(2024, 3, 3),
    ),
    PdfFileModel(
      id: 'pdf-18',
      projectId: 'top-10',
      title: 'Madinaty Brochure',
      fileName: 'madinaty-brochure.pdf',
      fileUrl: 'https://example.com/files/madinaty-brochure.pdf',
      description: 'Complete project information',
      fileSize: 2050000, // 2.05 MB
      createdAt: DateTime(2024, 3, 5),
    ),
    // North Coast Projects PDFs
    PdfFileModel(
      id: 'pdf-19',
      projectId: 'nc-1',
      title: 'Seashore North Coast Brochure',
      fileName: 'seashore-nc-brochure.pdf',
      fileUrl: 'https://example.com/files/seashore-nc-brochure.pdf',
      description: 'Complete project information',
      fileSize: 1950000, // 1.95 MB
      createdAt: DateTime(2024, 3, 7),
    ),
    PdfFileModel(
      id: 'pdf-20',
      projectId: 'nc-2',
      title: 'LVERSAN North Coast Brochure',
      fileName: 'lversan-nc-brochure.pdf',
      fileUrl: 'https://example.com/files/lversan-nc-brochure.pdf',
      description: 'Complete project information',
      fileSize: 2100000, // 2.1 MB
      createdAt: DateTime(2024, 3, 9),
    ),
    // Dubai Projects PDFs
    PdfFileModel(
      id: 'pdf-21',
      projectId: 'db-1',
      title: 'Palm Jumeirah Brochure',
      fileName: 'palm-jumeirah-brochure.pdf',
      fileUrl: 'https://example.com/files/palm-jumeirah-brochure.pdf',
      description: 'Complete project information',
      fileSize: 2250000, // 2.25 MB
      createdAt: DateTime(2024, 3, 11),
    ),
    PdfFileModel(
      id: 'pdf-22',
      projectId: 'db-2',
      title: 'Downtown Dubai Brochure',
      fileName: 'downtown-dubai-brochure.pdf',
      fileUrl: 'https://example.com/files/downtown-dubai-brochure.pdf',
      description: 'Complete project information',
      fileSize: 2000000, // 2.0 MB
      createdAt: DateTime(2024, 3, 13),
    ),
    // Oman Projects PDFs
    PdfFileModel(
      id: 'pdf-23',
      projectId: 'om-1',
      title: 'Muscat Hills Brochure',
      fileName: 'muscat-hills-brochure.pdf',
      fileUrl: 'https://example.com/files/muscat-hills-brochure.pdf',
      description: 'Complete project information',
      fileSize: 1850000, // 1.85 MB
      createdAt: DateTime(2024, 3, 15),
    ),
    PdfFileModel(
      id: 'pdf-24',
      projectId: 'om-2',
      title: 'Salalah Beach Brochure',
      fileName: 'salalah-beach-brochure.pdf',
      fileUrl: 'https://example.com/files/salalah-beach-brochure.pdf',
      description: 'Complete project information',
      fileSize: 1900000, // 1.9 MB
      createdAt: DateTime(2024, 3, 17),
    ),
    // Upcoming Projects PDFs
    PdfFileModel(
      id: 'pdf-25',
      projectId: 'up-1',
      title: 'New Vista Preview',
      fileName: 'new-vista-preview.pdf',
      fileUrl: 'https://example.com/files/new-vista-preview.pdf',
      description: 'Preview information for upcoming project',
      fileSize: 1500000, // 1.5 MB
      createdAt: DateTime(2024, 3, 19),
    ),
    PdfFileModel(
      id: 'pdf-26',
      projectId: 'up-2',
      title: 'Sky Tower Preview',
      fileName: 'sky-tower-preview.pdf',
      fileUrl: 'https://example.com/files/sky-tower-preview.pdf',
      description: 'Preview information for upcoming project',
      fileSize: 1600000, // 1.6 MB
      createdAt: DateTime(2024, 3, 21),
    ),
    // Continue Watching Projects PDFs
    PdfFileModel(
      id: 'pdf-27',
      projectId: 'cw-1',
      title: 'Tawny Brochure',
      fileName: 'tawny-brochure.pdf',
      fileUrl: 'https://example.com/files/tawny-brochure.pdf',
      description: 'Complete project information',
      fileSize: 1950000, // 1.95 MB
      createdAt: DateTime(2024, 3, 23),
    ),
    PdfFileModel(
      id: 'pdf-28',
      projectId: 'cw-2',
      title: 'Tawny Floor Plans',
      fileName: 'tawny-floor-plans.pdf',
      fileUrl: 'https://example.com/files/tawny-floor-plans.pdf',
      description: 'Detailed floor plans for all unit types',
      fileSize: 2800000, // 2.8 MB
      createdAt: DateTime(2024, 3, 25),
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
      final project = allProjects.firstWhere((p) => p.id == id);
      print('✅ MockData.getProjectById($id): Found project "${project.title}"');
      print('   - advertisementVideoUrl: ${project.advertisementVideoUrl}');
      print('   - hasVideo: ${project.hasVideo}');
      return project;
    } catch (e) {
      print('❌ MockData.getProjectById($id): Project not found');
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

  // Add a new clip/reel (adds to the beginning so newest appears first)
  static void addClip(ClipModel clip) {
    clips.insert(0, clip);
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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
      image: 'https://images.unsplash.com/photo-1520942702018-0862200e6873?w=1200',
      isAsset: false,
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

