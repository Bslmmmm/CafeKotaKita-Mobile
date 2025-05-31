import 'package:KafeKotaKita/Features/Leaderboard/Controllers/leaderboard_controller.dart';
import 'package:KafeKotaKita/Features/Leaderboard/Models/cafe_model.dart';
import 'package:KafeKotaKita/Features/Leaderboard/Widgets/cafe_card.dart';
import 'package:KafeKotaKita/Features/Leaderboard/Widgets/leaderboard_tab.dart';
import 'package:flutter/material.dart';
import '../controllers/leaderboard_controller.dart';
import '../models/cafe_model.dart';
import '../widgets/cafe_card.dart';
import '../widgets/leaderboard_tab.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardController _controller = LeaderboardController();
  int _selectedTabIndex = 0;
  bool _isRefreshing = false;

  final List<String> _tabs = ['Refresh Weekly'];
  final List<IconData> _tabIcons = [Icons.refresh];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    await _controller.fetchWeeklyLeaderboard();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _refreshLeaderboard() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    await _controller.refreshLeaderboard();

    setState(() {
      _isRefreshing = false;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leaderboard berhasil diperbarui!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with black background
          Container(
            color: Colors.black87,
            child: Column(
              children: [
                // Tab Bar
                LeaderboardTabBar(
                  tabs: _tabs,
                  icons: _tabIcons,
                  activeIndex: _selectedTabIndex,
                  onTabChanged: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isRefreshing ? null : _refreshLeaderboard,
        backgroundColor: Colors.black87,
        child: _isRefreshing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildContent() {
    if (_controller.isLoading && _controller.weeklyLeaderboard.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.black87,
            ),
            SizedBox(height: 16),
            Text(
              'Memuat leaderboard...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_controller.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _controller.error ?? 'Terjadi kesalahan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadLeaderboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_controller.weeklyLeaderboard.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data leaderboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Leaderboard akan diperbarui setiap minggu',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadLeaderboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Muat Ulang'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshLeaderboard,
      color: Colors.black87,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _controller.weeklyLeaderboard.length,
        itemBuilder: (context, index) {
          final cafe = _controller.weeklyLeaderboard[index];
          return CafeCard(
            cafe: cafe,
            onTap: () => _onCafeTap(cafe),
          );
        },
      ),
    );
  }

  void _onCafeTap(CafeModel cafe) {
    // Navigate to cafe detail screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => CafeDetailScreen(cafe: cafe),
    //   ),
    // );

    // For now, show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cafe.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ranking: #${cafe.weeklyRank}'),
            const SizedBox(height: 8),
            Text('Rating: ${cafe.rating.toStringAsFixed(1)}'),
            const SizedBox(height: 8),
            Text('Reviews: ${cafe.reviewCount}'),
            const SizedBox(height: 8),
            Text('Alamat: ${cafe.address}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Leaderboard'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leaderboard Mingguan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Diperbarui setiap minggu secara otomatis\n'
              '• Ranking berdasarkan rating dan jumlah review\n'
              '• Cafe dengan performa terbaik akan berada di posisi teratas\n'
              '• Data dapat direfresh secara manual',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}
