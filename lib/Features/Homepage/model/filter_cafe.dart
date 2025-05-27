// Features/Homepage/Models/filter_state.dart

class FilterState {
  final String searchQuery;
  final bool showOpenOnly;
  final bool showTopRated;
  final bool showNearest;

  const FilterState({
    this.searchQuery = '',
    this.showOpenOnly = false,
    this.showTopRated = false,
    this.showNearest = false,
  });

  // Create a copy of this FilterState with the given field updated
  FilterState copyWith({
    String? searchQuery,
    bool? showOpenOnly,
    bool? showTopRated,
    bool? showNearest,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      showOpenOnly: showOpenOnly ?? this.showOpenOnly,
      showTopRated: showTopRated ?? this.showTopRated,
      showNearest: showNearest ?? this.showNearest,
    );
  }

  // Reset all filter options except search query
  FilterState resetFilterOptions() {
    return FilterState(
      searchQuery: searchQuery,
      showOpenOnly: false,
      showTopRated: false,
      showNearest: false,
    );
  }

  // Reset all filters including search
  FilterState resetAll() {
    return const FilterState();
  }

  // Toggle a specific filter and reset others
  FilterState toggleFilterExclusive(FilterType type) {
    switch (type) {
      case FilterType.openOnly:
        return copyWith(
          showOpenOnly: !showOpenOnly,
          showTopRated: false,
          showNearest: false,
        );
      case FilterType.topRated:
        return copyWith(
          showTopRated: !showTopRated,
          showOpenOnly: false,
          showNearest: false,
        );
      case FilterType.nearest:
        return copyWith(
          showNearest: !showNearest,
          showOpenOnly: false,
          showTopRated: false,
        );
    }
  }
}

enum FilterType {
  openOnly,
  topRated,
  nearest,
}
