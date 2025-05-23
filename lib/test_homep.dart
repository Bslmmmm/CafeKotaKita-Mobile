import 'package:flutter/material.dart';
import 'package:tugas_flutter/Constant/colors.dart';
import 'package:tugas_flutter/Constant/textstyle.dart';
import 'package:tugas_flutter/Features/Homepage/model/cafe_data.dart';
import 'package:tugas_flutter/Features/Homepage/model/filter_cafe.dart';
import 'package:tugas_flutter/components/widget/custom_button.dart';
import 'package:tugas_flutter/components/widget/custom_card_cafe.dart';
import 'package:tugas_flutter/components/widget/custom_searchbar.dart';
import 'package:tugas_flutter/Features/Homepage/managers/cafe_list_manager.dart';
import 'package:tugas_flutter/Features/Homepage/managers/cafe_filter_manager.dart';


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
    //inisiasi filter
    _filterManager = CafeFilterManager();
    _filterManager.addListener(_applyFilters);
    
    // inisiasi cafelist manager
    _cafeListManager = CafeListManager(
      onStateChanged: (state) {
        if (state.status == CafeListStatus.success) {
          _applyFilters();
        } else {
          setState(() {
            
          });
        }
      },
    );
    
    // Load initial data
    _cafeListManager.loadMockCafes();
  }
  
  @override
  void dispose() {
    searchController.dispose();
    _cafeListManager.dispose();
    _filterManager.dispose();
    super.dispose();
  }
  
  // apply cafedata filter
  void _applyFilters() {
    setState(() {
      _displayedCafes = _filterManager.applyFilters(_cafeListManager.state.cafes);
    });
  }

  //logika search
  void onSearch(String value) {
    _filterManager.setSearchQuery(value);
  }

  //filter berdasarkan button 
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _cafeListManager.refreshCafes();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  color: primaryc,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomSearchbar(
                        controller: searchController,
                        onChanged: onSearch,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        
                        children: [
                          CustomHomeButton(
                            label: 'Nearest\nCafe',
                            icon: Icons.location_on,
                            onPressed: _toggleNearestCafe,
                            backgroundColor: filterState.showNearest ? white : clrbtn,
                            iconColor: filterState.showNearest ? primaryc : clrbg,
                            textColor: filterState.showNearest ? primaryc : clrbg,
                          ),
                          SizedBox(width: 10),
                          CustomHomeButton(
                            label: 'Top\nCafe',
                            icon: Icons.star_rounded,
                            onPressed: _toggleTopCafe,
                            backgroundColor: filterState.showTopRated ? white : clrbtn,
                            iconColor: filterState.showTopRated ? primaryc : clrbg,
                            textColor: filterState.showTopRated ? primaryc : clrbg,
                          ),
                          SizedBox(width: 10),
                          CustomHomeButton(
                            label: 'Open',
                            icon: Icons.watch_later_rounded,
                            onPressed: _toggleOpenCafe,
                            backgroundColor: filterState.showOpenOnly ? white : clrbtn,
                            iconColor: filterState.showOpenOnly ? primaryc : clrbg,
                            textColor: filterState.showOpenOnly ? primaryc : clrbg,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1, -1),
                        child: Text(
                          'Pick a cafe in your city',
                          textAlign: TextAlign.left,
                          style: AppTextStyles.poppinsBody(
                            fontSize: 20,
                            weight: AppTextStyles.semiBold,
                            color: black
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Status Handler
                      _buildCafeListContent(),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1, -1),
                            child: Text(
                              'Cari Kafe Yang Kamu Mau',
                              style: AppTextStyles.poppinsBody(
                                weight: AppTextStyles.semiBold,
                                color: black,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    ],
                  ),
                ),
              ],
            ),
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
      default:
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
                _cafeListManager.loadMockCafes();
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

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _displayedCafes.length,
      itemBuilder: (context, index) {
        final cafe = _displayedCafes[index];
        return CustomCardCafe(
          cafeimgurl: cafe.imageUrl,
          namacafe: cafe.cafeName,
          lokasi: cafe.location,
          operationalhour: cafe.operationalHours,
          rating: cafe.rating,
          isOpen: cafe.isOpen,
          onTap: () {
            // Navigasi ke halaman detail cafe
            print('Selected cafe: ${cafe.cafeName}');
            // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailCafeView(cafeId: cafe.id)));
          },
        );
      },
    );
  }
  }