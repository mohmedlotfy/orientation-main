import 'package:flutter/material.dart';

class Top10Screen extends StatelessWidget {
  const Top10Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // Alternating between masaya and the_icon
    final items = List.generate(10, (index) {
      return index.isEven 
          ? 'assets/top10/masaya.png' 
          : 'assets/top10/the_icon.png';
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Top 10',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return Top10Card(
              rank: index + 1,
              imagePath: items[index],
            );
          },
        ),
      ),
    );
  }
}

class Top10Card extends StatelessWidget {
  final int rank;
  final String imagePath;

  const Top10Card({
    super.key,
    required this.rank,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Outline number (behind - shifted down/right as shadow)
        Positioned(
          left: 0,
          bottom: -15,
          child: Image.asset(
            'assets/top10/${rank}_outline.png',
            height: 85,
            fit: BoxFit.contain,
          ),
        ),
        // Card image
        Positioned(
          top: 0,
          right: 0,
          left: 35,
          bottom: 35,
          child: Container(
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
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Filled number (in front)
        Positioned(
          left: -8,
          bottom: -5,
          child: Image.asset(
            'assets/top10/$rank.png',
            height: 85,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
