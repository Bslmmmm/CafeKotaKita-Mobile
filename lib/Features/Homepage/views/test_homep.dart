import 'package:KafeKotaKita/Features/Homepage/managers/carousel_manager.dart';
import 'package:KafeKotaKita/components/widget/carousel/custom_carousel.dart';
import 'package:flutter/material.dart';
import 'package:KafeKotaKita/Constant/colors.dart';
import 'package:KafeKotaKita/Constant/textstyle.dart';
import 'package:KafeKotaKita/Features/Homepage/model/model_homepage.dart';
import 'package:KafeKotaKita/Features/Homepage/model/filter_cafe.dart';
import 'package:KafeKotaKita/components/widget/custom_button.dart';
import 'package:KafeKotaKita/components/widget/custom_card_cafe.dart';
import 'package:KafeKotaKita/components/widget/custom_searchbar.dart';
import 'package:KafeKotaKita/Features/Homepage/managers/cafe_list_manager.dart';
import 'package:KafeKotaKita/Features/Homepage/managers/cafe_filter_manager.dart';
import 'package:flutter/rendering.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  final TextEditingController searchController = TextEditingController();
  late CafeListManager _cafeListManager;
  late CafeFilterManager _filterManager;
  List<CafeData> _displayedCafes = [];

  @override
  void initState() {
    super.initState();
    _filterManager = CafeFilterManager();
    _filterManager.addListener(_applyFilters);
    _cafeListManager = CafeListManager(
      onStateChanged: (state) {
        if (state.status == CafeListStatus.success) {
          _applyFilters();
        } else {
          setState(() {});
        }
      },
    );
    _cafeListManager.loadCafes();
  }

  @override
  void dispose() {
    searchController.dispose();
    _filterManager.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _displayedCafes =
          _filterManager.applyFilters(_cafeListManager.state.cafes);
    });
  }

  void onSearch(String value) {
    _filterManager.setSearchQuery(value);
  }

  void _toggleNearestCafe() {
    _filterManager.toggleFilter(FilterType.nearest);
  }

  void _toggleTopCafe() {
    _filterManager.toggleFilter(FilterType.topRated);
  }

  void _toggleOpenCafe() {
    _filterManager.toggleFilter(FilterType.openOnly);
  }

  @override
  Widget build(BuildContext context) {
    final filterState = _filterManager.filterState;

    return Scaffold(
      backgroundColor: primaryc,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _cafeListManager.refreshCafes();
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 180.0,
                floating: false,
                snap: false,
                pinned: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    width: double.infinity,
                    height: 160,
                    color: primaryc,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomSearchbar(
                            controller: searchController,
                            onChanged: onSearch,
                          ),
                        ),
                        SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: LayoutBuilder(builder: (context, constraints) {
                            final totalAvailableWidth = constraints.maxWidth;
                            final spacing = 8.0;
                            final numberOfButtons = 3;
                            final totalSpacingWidth =
                                spacing * (numberOfButtons - 1);

                            final remainingWidthForButtons =
                                totalAvailableWidth - totalSpacingWidth;
                            final propNearest = 1.2; // Sedikit lebih besar
                            final propTop = 1.0;
                            final propOpen = 1.2; // Sedikit lebih besar
                            final totalProportions =
                                propNearest + propTop + propOpen;

                            final buttonWidthNearest =
                                (remainingWidthForButtons / totalProportions) *
                                    propNearest;
                            final buttonWidthTop =
                                (remainingWidthForButtons / totalProportions) *
                                    propTop;
                            final buttonWidthOpen =
                                (remainingWidthForButtons / totalProportions) *
                                    propOpen;
                            final buttonHeight = 50.0;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: buttonWidthNearest,
                                  height: buttonHeight,
                                  child: CustomHomeButton(
                                    label: 'Nearest',
                                    icon: Icons.location_on,
                                    onPressed: _toggleNearestCafe,
                                    backgroundColor: filterState.showNearest
                                        ? white
                                        : clrbtn,
                                    iconColor: filterState.showNearest
                                        ? primaryc
                                        : clrbg,
                                    textColor: filterState.showNearest
                                        ? primaryc
                                        : clrbg,
                                  ),
                                ),
                                SizedBox(width: spacing),
                                SizedBox(
                                  width: buttonWidthTop,
                                  height: buttonHeight,
                                  child: CustomHomeButton(
                                    label: 'Top',
                                    icon: Icons.star_rounded,
                                    onPressed: _toggleTopCafe,
                                    backgroundColor: filterState.showTopRated
                                        ? white
                                        : clrbtn,
                                    iconColor: filterState.showTopRated
                                        ? primaryc
                                        : clrbg,
                                    textColor: filterState.showTopRated
                                        ? primaryc
                                        : clrbg,
                                  ),
                                ),
                                SizedBox(width: spacing),
                                SizedBox(
                                  width: buttonWidthOpen,
                                  height: buttonHeight,
                                  child: CustomHomeButton(
                                    label: 'Open',
                                    icon: Icons.watch_later_rounded,
                                    onPressed: _toggleOpenCafe,
                                    backgroundColor: filterState.showOpenOnly
                                        ? white
                                        : clrbtn,
                                    iconColor: filterState.showOpenOnly
                                        ? primaryc
                                        : clrbg,
                                    textColor: filterState.showOpenOnly
                                        ? primaryc
                                        : clrbg,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 16)
                      ],
                    ),
                  ),
                ),
              ),
              //<====== cara edit slivernya =======>
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, -1),
                          child: Text(
                            'Pick a cafe in your city',
                            textAlign: TextAlign.left,
                            style: AppTextStyles.poppinsBody(
                                fontSize: 20,
                                weight: AppTextStyles.semiBold,
                                color: black),
                          ),
                        ),
                        SizedBox(height: 10),
                        _buildCafeListContent(),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1, -1),
                                child: Text(
                                  'Cari Kafe sesuai mood mu',
                                  style: AppTextStyles.poppinsBody(
                                      weight: AppTextStyles.semiBold,
                                      color: black,
                                      fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomCarousel(items: kCarouselitems),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCafeListContent() {
    switch (_cafeListManager.state.status) {
      case CafeListStatus.loading:
        return _buildLoadingState();
      case CafeListStatus.error:
        return _buildErrorState();
      case CafeListStatus.success:
        return _buildSuccessState();
      case CafeListStatus.initial:
        return _buildLoadingState();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircularProgressIndicator(color: primaryc),
            SizedBox(height: 16),
            Text(
              'Loading cafes...',
              style: AppTextStyles.poppinsBody(
                fontSize: 16,
                color: primaryc,
                weight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 12),
            Text(
              'Failed to load cafes',
              style: AppTextStyles.poppinsBody(
                fontSize: 16,
                color: Colors.red,
                weight: AppTextStyles.medium,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _cafeListManager.state.errorMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsBody(
                fontSize: 14,
                color: clreror,
                weight: AppTextStyles.regular,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _cafeListManager.loadCafes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryc,
                foregroundColor: white,
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    if (_displayedCafes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'No cafes found',
                style: AppTextStyles.poppinsBody(
                  fontSize: 16,
                  color: Colors.grey,
                  weight: AppTextStyles.medium,
                ),
              ),
              if (_filterManager.filterState.searchQuery.isNotEmpty ||
                  _filterManager.filterState.showOpenOnly ||
                  _filterManager.filterState.showTopRated)
                ElevatedButton(
                  onPressed: () {
                    searchController.clear();
                    _filterManager.resetFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryc,
                    foregroundColor: white,
                  ),
                  child: Text('Clear Filters'),
                ),
            ],
          ),
        ),
      );
    }
    final limitcafe = _displayedCafes.take(3).toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: limitcafe.length,
      itemBuilder: (context, index) {
        final cafe = limitcafe[index];
        return CustomCardCafe(
          cafeimgurl: cafe.imageUrl,
          namacafe: cafe.cafename,
          lokasi: cafe.alamat,
          jambuka: cafe.jambuka,
          jamtutup: cafe.jamtutup,
          rating: cafe.rating,
          isOpen: cafe.isOpen,
          onTap: () {
            //<====== future cafe detail =======>
            
          },
        );
      },
    );
  }
}
