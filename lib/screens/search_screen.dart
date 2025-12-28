import 'package:flutter/material.dart';
import '../widgets/project_card.dart';
import 'project_details_screen.dart';
import 'latest_for_us_screen.dart';
import 'projects_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Color brandRed = Color(0xFFE50914);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Projects', 'Developers', 'Areas'];

  // Mock data for search
  final List<Map<String, dynamic>> _allProjects = [
    {
      'id': '1',
      'title': 'Seashore',
      'subtitle': 'FULLY FINISHED UNITS',
      'location': 'North Coast',
      'developer': 'Mountain View',
      'image': 'assets/top10/masaya.png',
      'colors': [Color(0xFF5a8a9a), Color(0xFF3a6a7a)],
    },
    {
      'id': '2',
      'title': 'THE ICON',
      'subtitle': 'Gardens',
      'location': 'New Cairo',
      'developer': 'SODIC',
      'image': 'assets/top10/the_icon.png',
      'colors': [Color(0xFF3d3d3d), Color(0xFF2a2a2a)],
    },
    {
      'id': '3',
      'title': 'Tawny',
      'subtitle': 'Hyde Park',
      'location': 'New Cairo',
      'developer': 'Hyde Park',
      'image': 'assets/top10/masaya.png',
      'colors': [Color(0xFFd4c4b0), Color(0xFFc4b4a0)],
    },
    {
      'id': '4',
      'title': 'Palm Hills',
      'subtitle': 'Luxury Living',
      'location': 'Dubai',
      'developer': 'Emaar',
      'image': 'assets/top10/the_icon.png',
      'colors': [Color(0xFF2d5a4a), Color(0xFF1d4a3a)],
    },
  ];

  final List<Map<String, dynamic>> _allDevelopers = [
    {'id': '1', 'name': 'Mountain View', 'projects': 15, 'image': 'assets/developers/mv.png'},
    {'id': '2', 'name': 'SODIC', 'projects': 22, 'image': 'assets/developers/sodic.png'},
    {'id': '3', 'name': 'Emaar', 'projects': 30, 'image': 'assets/developers/emaar.png'},
    {'id': '4', 'name': 'Hyde Park', 'projects': 12, 'image': 'assets/developers/hp.png'},
    {'id': '5', 'name': 'Palm Hills', 'projects': 18, 'image': 'assets/developers/ph.png'},
  ];

  final List<Map<String, dynamic>> _allAreas = [
    {'id': '1', 'name': 'North Coast', 'projects': 45, 'image': 'assets/areas/nc.png'},
    {'id': '2', 'name': 'New Cairo', 'projects': 80, 'image': 'assets/areas/cairo.png'},
    {'id': '3', 'name': 'Dubai', 'projects': 120, 'image': 'assets/areas/dubai.png'},
    {'id': '4', 'name': 'Oman', 'projects': 25, 'image': 'assets/areas/oman.png'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProjects {
    if (_searchQuery.isEmpty) return _allProjects;
    return _allProjects.where((p) =>
      p['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p['location'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
      p['developer'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  List<Map<String, dynamic>> get _filteredDevelopers {
    if (_searchQuery.isEmpty) return _allDevelopers;
    return _allDevelopers.where((d) =>
      d['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  List<Map<String, dynamic>> get _filteredAreas {
    if (_searchQuery.isEmpty) return _allAreas;
    return _allAreas.where((a) =>
      a['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(context),
            // Search bar
            _buildSearchBar(),
            // Filter tabs
            _buildFilterTabs(),
            // Results
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildInitialContent(context)
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 28,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.5),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search for a project....',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 36,
      margin: const EdgeInsets.only(top: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? brandRed : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? brandRed : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Show based on filter
          if (_selectedFilter == 'All' || _selectedFilter == 'Projects') ...[
            // The latest for us section
            _buildSection(
              context,
              'The latest for us',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LatestForUsScreen(),
                  ),
                );
              },
              child: _buildLatestList(context),
            ),
            // Continue watching section
            _buildSection(
              context,
              'Continue watching',
              onViewAll: () {},
              child: _buildContinueWatchingList(),
            ),
            // Projects in Dubai section
            _buildSection(
              context,
              'Projects in Dubai',
              onViewAll: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectsListScreen(
                      title: 'Projects in Dubai',
                    ),
                  ),
                );
              },
              child: _buildDubaiList(context),
            ),
          ],
          
          if (_selectedFilter == 'Developers') ...[
            _buildSection(
              context,
              'Top Developers',
              onViewAll: () {},
              child: _buildDevelopersList(),
            ),
          ],
          
          if (_selectedFilter == 'Areas') ...[
            _buildSection(
              context,
              'Popular Areas',
              onViewAll: () {},
              child: _buildAreasList(),
            ),
          ],
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // Check if there are results based on selected filter
    bool hasResults = false;
    
    if (_selectedFilter == 'All') {
      hasResults = _filteredProjects.isNotEmpty || 
                   _filteredDevelopers.isNotEmpty || 
                   _filteredAreas.isNotEmpty;
    } else if (_selectedFilter == 'Projects') {
      hasResults = _filteredProjects.isNotEmpty;
    } else if (_selectedFilter == 'Developers') {
      hasResults = _filteredDevelopers.isNotEmpty;
    } else if (_selectedFilter == 'Areas') {
      hasResults = _filteredAreas.isNotEmpty;
    }

    if (!hasResults) {
      return _buildNoResults();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Projects results
          if ((_selectedFilter == 'All' || _selectedFilter == 'Projects') && 
              _filteredProjects.isNotEmpty) ...[
            _buildSection(
              context,
              'Projects (${_filteredProjects.length})',
              onViewAll: () {},
              child: _buildProjectResults(),
            ),
          ],
          
          // Developers results
          if ((_selectedFilter == 'All' || _selectedFilter == 'Developers') && 
              _filteredDevelopers.isNotEmpty) ...[
            _buildSection(
              context,
              'Developers (${_filteredDevelopers.length})',
              onViewAll: () {},
              child: _buildDeveloperResults(),
            ),
          ],
          
          // Areas results
          if ((_selectedFilter == 'All' || _selectedFilter == 'Areas') && 
              _filteredAreas.isNotEmpty) ...[
            _buildSection(
              context,
              'Areas (${_filteredAreas.length})',
              onViewAll: () {},
              child: _buildAreaResults(),
            ),
          ],
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 50,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No results found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '"$_searchQuery"',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectResults() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredProjects.length,
        itemBuilder: (context, index) {
          final project = _filteredProjects[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _SearchProjectCard(
              title: project['title'],
              subtitle: project['subtitle'],
              imageAsset: project['image'],
              gradientColors: project['colors'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectDetailsScreen(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeveloperResults() {
    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredDevelopers.length,
        itemBuilder: (context, index) {
          final developer = _filteredDevelopers[index];
          return _DeveloperCard(
            name: developer['name'],
            projectCount: developer['projects'],
          );
        },
      ),
    );
  }

  Widget _buildAreaResults() {
    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredAreas.length,
        itemBuilder: (context, index) {
          final area = _filteredAreas[index];
          return _AreaCard(
            name: area['name'],
            projectCount: area['projects'],
          );
        },
      ),
    );
  }

  Widget _buildDevelopersList() {
    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _allDevelopers.length,
        itemBuilder: (context, index) {
          final developer = _allDevelopers[index];
          return _DeveloperCard(
            name: developer['name'],
            projectCount: developer['projects'],
          );
        },
      ),
    );
  }

  Widget _buildAreasList() {
    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _allAreas.length,
        itemBuilder: (context, index) {
          final area = _allAreas[index];
          return _AreaCard(
            name: area['name'],
            projectCount: area['projects'],
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title, {
    required VoidCallback onViewAll,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: brandRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildLatestList(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _SearchProjectCard(
            title: 'Seashore',
            subtitle: 'FULLY FINISHED UNITS',
            imageAsset: 'assets/top10/masaya.png',
            hasPromo: true,
            gradientColors: const [Color(0xFF5a8a9a), Color(0xFF3a6a7a)],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectDetailsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          _SearchProjectCard(
            title: 'THE ICON',
            subtitle: 'Gardens',
            imageAsset: 'assets/top10/the_icon.png',
            gradientColors: const [Color(0xFF3d3d3d), Color(0xFF2a2a2a)],
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContinueWatchingList() {
    return SizedBox(
      height: 145,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _ContinueWatchingCard(
            title: 'Tawny',
            progress: 0.4,
            imageAsset: 'assets/top10/masaya.png',
          ),
          const SizedBox(width: 12),
          _ContinueWatchingCard(
            title: 'Tawny',
            progress: 0.6,
            imageAsset: 'assets/top10/the_icon.png',
          ),
        ],
      ),
    );
  }

  Widget _buildDubaiList(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ProjectCard(
            title: 'Seashore',
            imageUrl: null,
            gradientColors: const [Color(0xFF5a8a9a), Color(0xFF3a6a7a)],
            width: 150,
            height: 150,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectDetailsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          ProjectCard(
            title: 'THE ICON',
            imageUrl: null,
            gradientColors: const [Color(0xFF3d3d3d), Color(0xFF2a2a2a)],
            width: 150,
            height: 150,
            onTap: () {},
          ),
        ],
      ),
    );
  }

}

class _SearchProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageAsset;
  final List<Color> gradientColors;
  final bool hasPromo;
  final VoidCallback? onTap;

  const _SearchProjectCard({
    required this.title,
    required this.subtitle,
    this.imageAsset,
    required this.gradientColors,
    this.hasPromo = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              if (imageAsset != null)
                Image.asset(
                  imageAsset!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: gradientColors,
                        ),
                      ),
                    );
                  },
                )
              else
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors,
                    ),
                  ),
                ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              // Title at top
              Positioned(
                top: 16,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // Promo badges at bottom
              if (hasPromo)
                Positioned(
                  bottom: 14,
                  left: 12,
                  child: Row(
                    children: [
                      _PromoBadge(text: '5%'),
                      const SizedBox(width: 8),
                      _PromoBadge(text: '8'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoBadge extends StatelessWidget {
  final String text;

  const _PromoBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ContinueWatchingCard extends StatelessWidget {
  final String title;
  final double progress;
  final String? imageAsset;

  const _ContinueWatchingCard({
    required this.title,
    required this.progress,
    this.imageAsset,
  });

  static const Color brandRed = Color(0xFFE50914);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                if (imageAsset != null)
                  Image.asset(
                    imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFd4c4b0), Color(0xFFc4b4a0)],
                          ),
                        ),
                      );
                    },
                  )
                else
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFd4c4b0), Color(0xFFc4b4a0)],
                      ),
                    ),
                  ),
                // Title overlay
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'TAWNY',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
                // Progress bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.black.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(brandRed),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 40),
            Text(
              '01:45 H',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final String name;
  final int projectCount;

  const _DeveloperCard({
    required this.name,
    required this.projectCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.business,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$projectCount projects',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final String name;
  final int projectCount;

  const _AreaCard({
    required this.name,
    required this.projectCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE50914).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.location_on,
              color: Color(0xFFE50914),
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$projectCount projects',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
