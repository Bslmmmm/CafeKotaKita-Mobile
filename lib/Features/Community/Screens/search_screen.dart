import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> recentSearches = [
    {
      'username': '@arielrezka22',
      'id': 'dummyaccount21',
      'imageUrl': 'https://i.ibb.co/x8M4sx5/arielrezka22.jpg'
    },
    {
      'username': '@arielrezka22',
      'id': 'dummyaccount21',
      'imageUrl': 'https://i.ibb.co/x8M4sx5/arielrezka22.jpg'
    },
    {
      'username': '@arielrezka22',
      'id': 'dummyaccount21',
      'imageUrl': 'https://i.ibb.co/x8M4sx5/arielrezka22.jpg'
    },
    {
      'username': '@arielrezka22',
      'id': 'dummyaccount21',
      'imageUrl': 'https://i.ibb.co/x8M4sx5/arielrezka22.jpg'
    },
    {
      'username': '@arielrezka22',
      'id': 'dummyaccount21',
      'imageUrl': 'https://i.ibb.co/x8M4sx5/arielrezka22.jpg'
    },
    {
      'username': '@arielrezka22',
      'id': 'dummyaccount21',
      'imageUrl': 'https://i.ibb.co/x8M4sx5/arielrezka22.jpg'
    },
  ];

  void _removeSearch(int index) {
    setState(() {
      recentSearches.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan search bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16, right: 8),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Cari....',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Label "Terbaru"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Terbaru',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // List recent searches
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  final search = recentSearches[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        // Profile image
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(search['imageUrl'] ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // User info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                search['username'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                search['id'] ?? '',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Close button
                        GestureDetector(
                          onTap: () => _removeSearch(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
