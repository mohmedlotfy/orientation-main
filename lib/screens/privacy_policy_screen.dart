import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Policy icon
                    _buildPolicyIcon(),
                    const SizedBox(height: 24),
                    // Content paragraphs
                    ..._buildContentParagraphs(),
                  ],
                ),
              ),
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
                'Privacy Policy',
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

  Widget _buildPolicyIcon() {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFD4A84B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Clipboard top
          Positioned(
            top: -8,
            left: 25,
            right: 25,
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFB8860B),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Content area
          Positioned(
            top: 16,
            left: 8,
            right: 8,
            bottom: 8,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5DC),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Policies',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCheckbox(true),
                      const SizedBox(width: 8),
                      _buildCheckbox(true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCheckbox(false),
                      const SizedBox(width: 8),
                      _buildCheckbox(false),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(bool checked) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: checked ? Colors.green : Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(2),
      ),
      child: checked
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 12,
            )
          : null,
    );
  }

  List<Widget> _buildContentParagraphs() {
    const loremIpsum = '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum''';

    const shortParagraph = '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.''';

    return [
      _buildParagraph(loremIpsum),
      const SizedBox(height: 16),
      _buildParagraph(shortParagraph),
      const SizedBox(height: 16),
      _buildParagraph(loremIpsum),
      const SizedBox(height: 16),
      _buildParagraph(shortParagraph),
    ];
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 13,
        height: 1.6,
      ),
    );
  }
}

