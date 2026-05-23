class HomePageController {
  int selectedIndex = 0;

  /// Updates the selected page index
  void updateSelectedIndex(int index) {
    selectedIndex = index;
  }

  /// Gets the current selected index
  int getSelectedIndex() {
    return selectedIndex;
  }

  /// Gets the total number of pages
  int getPageCount() {
    return 2;
  }
}
