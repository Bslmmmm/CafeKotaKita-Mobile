import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/Features/Homepage/managers/cafe_filter_manager.dart';
import 'package:KafeKotaKita/Features/Homepage/managers/cafe_list_manager.dart';
import 'package:KafeKotaKita/Features/Homepage/model/filter_cafe.dart';
import 'package:KafeKotaKita/Features/Homepage/model/model_homepage.dart';
import 'package:KafeKotaKita/components/widget/custom_card_cafe.dart';
import 'package:KafeKotaKita/components/widget/custom_searchbar.dart';
import 'package:KafeKotaKita/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key}); // Mengubah menjadi const constructor

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController searchController = TextEditingController();
  List<CafeData> _cafe = [];
  late CafeListManager _cafeListManager;
  late CafeFilterManager _filterManager;

  @override
  void initState() {
    super.initState();

    // 1. Daftarkan CafeFilterManager dengan GetX jika belum ada
    // Ini memastikan hanya ada satu instance yang digunakan di seluruh aplikasi
    if (!Get.isRegistered<CafeFilterManager>()) {
      Get.put(CafeFilterManager());
    }
    // 2. Ambil instance CafeFilterManager dari GetX
    _filterManager = Get.find<CafeFilterManager>();

    // 3. Tambahkan listener ke _filterManager.
    // Ketika filter berubah (notifyListeners terpanggil), _applyFilters akan dijalankan.
    _filterManager.addListener(_applyFilters);

    // Inisialisasi CafeListManager
    _cafeListManager = CafeListManager(
      onStateChanged: (state) {
        // Ketika status CafeListManager berubah, perbarui UI
        if (state.status == CafeListStatus.success) {
          _applyFilters(); // Terapkan filter setelah data berhasil dimuat
        } else {
          setState(() {}); // Perbarui UI untuk loading/error state
        }
      },
    );
    _cafeListManager.loadCafes(); // Muat kafe saat initState
  }

  // Fungsi ini dipanggil setiap kali _filterManager.notifyListeners() dipanggil
  // atau ketika _cafeListManager.state.status menjadi success.
  void _applyFilters() {
    // Perbarui daftar _cafe berdasarkan filter yang aktif dan data kafe dari manager
    _cafe = _filterManager.applyFilters(_cafeListManager.state.cafes);
    // Panggil setState untuk memicu pembangunan ulang UI
    setState(() {});
  }

  void onSearch(String value) {
    _filterManager.setSearchQuery(value);
  }

  // Fungsi toggle filter ini akan dipanggil dari dalam popup
  void _toggleFilter(FilterType type) {
    _filterManager.toggleFilter(type);
  }

  @override
  void dispose() {
    searchController.dispose();
    // Penting: Hapus listener saat widget di-dispose untuk mencegah memory leaks
    _filterManager.removeListener(_applyFilters);
    // Jika CafeFilterManager hanya digunakan di sini dan Anda ingin menghapusnya dari memori GetX
    // saat SearchView ditutup, Anda bisa menambahkan:
    // Get.delete<CafeFilterManager>();
    super.dispose();
  }

  // --- Fungsi untuk menampilkan Filter Popup (Bottom Sheet) ---
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Memungkinkan sheet menyesuaikan tinggi keyboard
      backgroundColor: Colors.transparent, // Untuk efek rounded corner
      builder: (context) {
        // GetBuilder akan mendengarkan perubahan pada CafeFilterManager
        // dan membangun ulang bagian ini secara otomatis.
        return GetBuilder<CafeFilterManager>(
          // Tidak perlu 'init' karena CafeFilterManager sudah di-Get.put()
          builder: (manager) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Filter Kafe',
                        style: AppTextStyles.poppinsBody(
                          fontSize: 22,
                          weight: AppTextStyles.semiBold,
                          color: primaryc,
                        ),
                      ),
                    ),
                    const Divider(),
                    _buildFilterCheckbox(
                      label: 'Kafe Terdekat',
                      value: manager.filterState.showNearest,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          manager.toggleFilter(FilterType.nearest);
                        }
                      },
                    ),
                    _buildFilterCheckbox(
                      label: 'Rating Tertinggi',
                      value: manager.filterState.showTopRated,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          manager.toggleFilter(FilterType.topRated);
                        }
                      },
                    ),
                    _buildFilterCheckbox(
                      label: 'Sedang Buka',
                      value: manager.filterState.showOpenOnly,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          manager.toggleFilter(FilterType.openOnly);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                manager
                                    .resetFilters(); // Reset filter melalui manager
                                searchController
                                    .clear(); // Bersihkan search bar
                                // Gunakan Future.microtask untuk menunda Get.back()
                                Future.microtask(() => Get.back());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryc,
                                foregroundColor: white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Reset Filter',
                                style: AppTextStyles.poppinsBody(
                                  fontSize: 16,
                                  weight: AppTextStyles.medium,
                                  color: white
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Filter sudah otomatis diterapkan karena manager notify listeners
                                // Gunakan Future.microtask untuk menunda Get.back()
                                Future.microtask(() => Get.back());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryc,
                                foregroundColor: white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Terapkan',
                                style: AppTextStyles.poppinsBody(
                                    fontSize: 16,
                                    weight: AppTextStyles.medium,
                                    color: white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget pembantu untuk CheckboxListTile
  Widget _buildFilterCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(
        label,
        style: AppTextStyles.poppinsBody(
          fontSize: 16,
          color: black,
          weight: AppTextStyles.regular,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: primaryc,
      checkColor: white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _cafeListManager.refreshCafes();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Menggunakan const
            slivers: [
              // SliverAppBar untuk Search Bar dan Tombol Filter
              SliverAppBar(
                expandedHeight: 120.0,
                floating: true,
                snap: true,
                pinned: true,
                elevation: 0,
                backgroundColor: primaryc,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  background: Container(
                    color: primaryc,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomSearchbar(
                                  controller: searchController,
                                  onChanged: onSearch,
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.filter_list_rounded,
                                    color: white, size: 30),
                                onPressed: _showFilterBottomSheet,
                                tooltip: 'Filter Kafe',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // SliverPersistentHeader untuk teks "Semua Kafe di kotamu"
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 80.0,
                  maxHeight: 80.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Semua Kafe di kotamu',
                        style: AppTextStyles.poppinsBody(
                          fontSize: 20,
                          weight: AppTextStyles.semiBold,
                          color: primaryc,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // SliverList untuk daftar kafe
              _buildSliverCafeList(),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi ini mengembalikan SliverList atau state kosong/loading/error
  Widget _buildSliverCafeList() {
    if (_cafeListManager.state.status == CafeListStatus.loading) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_cafeListManager.state.status == CafeListStatus.error) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'Error loading cafes: ${_cafeListManager.state.errorMessage}',
            style: AppTextStyles.poppinsBody(color: Colors.red),
          ),
        ),
      );
    } else if (_cafe.isEmpty) {
      // Menampilkan pesan 'No cafes found' jika daftar kafe kosong
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  'No cafes found',
                  style: AppTextStyles.poppinsBody(
                    fontSize: 16,
                    color: Colors.grey,
                    weight: AppTextStyles.medium,
                  ),
                ),
                // Tombol "Clear Filters" hanya muncul jika ada filter aktif
                if (_filterManager.filterState.searchQuery.isNotEmpty ||
                    _filterManager.filterState.showOpenOnly ||
                    _filterManager.filterState.showTopRated ||
                    _filterManager
                        .filterState.showNearest) // Tambahkan showNearest
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _filterManager.resetFilters();
                        searchController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryc,
                        foregroundColor: white,
                      ),
                      child: const Text('Clear Filters'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // Jika ada kafe, tampilkan daftar menggunakan SliverList
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final data = _cafe[index];
          return Container(
            color: white,
            child: CustomCardCafe(
              cafeimgurl: data.imageUrl,
              Id: data.id,
              namacafe: data.cafename,
              lokasi: data.alamat,
              jambuka: data.jambuka,
              jamtutup: data.jamtutup,
              rating: data.rating,
              isOpen: data.isOpen,
              onTap: () {
                Get.toNamed(AppRoutes.detailcafe,
                    arguments: data.id);
              },
            ),
          );
        },
        childCount: _cafe.length,
      ),
    );
  }
}

// Delegate kustom untuk SliverPersistentHeader
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
