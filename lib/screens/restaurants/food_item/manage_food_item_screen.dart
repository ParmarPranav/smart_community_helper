import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_item/get_food_item/get_food_item_bloc.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_item/add_food_item_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_item/edit_food_item_screen.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:food_hunt_admin_app/widgets/image_error_widget.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';
import 'package:intl/intl.dart';

import '../../responsive_layout.dart';

class ManageFoodItemScreen extends StatefulWidget {
  static const routeName = '/manage-food-item';

  @override
  _ManageFoodItemScreenState createState() => _ManageFoodItemScreenState();
}

class _ManageFoodItemScreenState extends State<ManageFoodItemScreen> {
  bool _isInit = true;

  final GetFoodItemBloc _getFoodItemBloc = GetFoodItemBloc();
  List<FoodItem> _foodItemList = [];
  List<FoodItem> _searchFoodItemList = [];
  List<FoodItem> _filteredFoodItemList = [];
  List<FoodItem> _selectedFoodItemList = [];
  bool _sortNameAsc = true;
  bool _sortCreatedAtAsc = true;
  bool _sortEditedAtAsc = true;
  bool _sortAsc = true;
  int? _sortColumnIndex;
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _filteredVerticalScrollController = ScrollController();
  final ScrollController _searchVerticalScrollController = ScrollController();
  late TextEditingController _searchQueryEditingController;
  bool _isSearching = false;
  bool _isFilters = false;
  String searchQuery = "Search query";
  bool _isByFoodNameSelected = true;
  bool _isByFoodCategorySelected = false;
  bool _isByFoodTypeSelected = false;
  bool _isByTypeSelected = false;

  bool _isFloatingActionButtonVisible = true;

  String LIMIT_PER_PAGE = '10';

  Restaurant? restaurant;

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  List<Map<String, String>> _filtersList = [
    {
      'title': 'All',
      'value': 'all',
    },
    {
      'title': 'Today',
      'value': 'today',
    },
    {
      'title': 'Yesterday',
      'value': 'yesterday',
    },
    {
      'title': '7 days',
      'value': '7days',
    },
    {
      'title': '30 days',
      'value': '30days',
    },
    {
      'title': '90 days',
      'value': '90days',
    },
    {
      'title': '180 days',
      'value': '180days',
    },
    {
      'title': '365 days',
      'value': '365days',
    }
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant?;
      _searchQueryEditingController = TextEditingController();
      _getFoodItemBloc.add(GetFoodItemDataEvent(data: {
        'restaurant_id': restaurant!.emailId,
      }));
      _verticalScrollController.addListener(() {
        if (_verticalScrollController.position.userScrollDirection == ScrollDirection.reverse) {
          if (_isFloatingActionButtonVisible == true) {
            /* only set when the previous state is false
             * Less widget rebuilds
             */
            print("**** ${_isFloatingActionButtonVisible} up"); //Move IO away from setState
            setState(() {
              _isFloatingActionButtonVisible = false;
            });
          }
        } else {
          if (_verticalScrollController.position.userScrollDirection == ScrollDirection.forward) {
            if (_isFloatingActionButtonVisible == false) {
              /* only set when the previous state is false
               * Less widget rebuilds
               */
              print("**** ${_isFloatingActionButtonVisible} down"); //Move IO away from setState
              setState(() {
                _isFloatingActionButtonVisible = true;
              });
            }
          }
        }
      });
      _searchVerticalScrollController.addListener(() {
        if (_searchVerticalScrollController.position.userScrollDirection == ScrollDirection.reverse) {
          if (_isFloatingActionButtonVisible == true) {
            /* only set when the previous state is false
             * Less widget rebuilds
             */
            print("**** ${_isFloatingActionButtonVisible} up"); //Move IO away from setState
            setState(() {
              _isFloatingActionButtonVisible = false;
            });
          }
        } else {
          if (_searchVerticalScrollController.position.userScrollDirection == ScrollDirection.forward) {
            if (_isFloatingActionButtonVisible == false) {
              /* only set when the previous state is false
               * Less widget rebuilds
               */
              print("**** ${_isFloatingActionButtonVisible} down"); //Move IO away from setState
              setState(() {
                _isFloatingActionButtonVisible = true;
              });
            }
          }
        }
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      drawer: ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)
          ? MainDrawer(
              navigatorKey: Navigator.of(context).widget.key as GlobalKey<NavigatorState>,
            )
          : null,
      appBar: ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)
          ? _selectedFoodItemList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetFoodItemBloc, GetFoodItemState>(
        bloc: _getFoodItemBloc,
        listener: (context, state) {
          if (state is GetFoodItemSuccessState) {
            _foodItemList = state.foodItemList;
          } else if (state is GetFoodItemFailedState) {
            _showSnackMessage(state.message, Colors.red.shade700);
          } else if (state is GetFoodItemExceptionState) {
            _showSnackMessage(state.message, Colors.red.shade700);
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            smallScreen: _buildMobileView(state),
            mediumScreen: _buildTabletView(state),
            largeScreen: _buildWebView(screenHeight, screenWidth, state),
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: _isFloatingActionButtonVisible,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16, right: 16),
          child: FloatingActionButton(
            onPressed: () async {
              FoodItem? foodItem = await Navigator.of(context).pushNamed(AddFoodItemScreen.routeName, arguments: restaurant) as FoodItem?;
              if (foodItem != null) {
                _foodItemList.add(foodItem);
              }
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  AppBar _defaultAppBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 70,
      elevation: 3,
      title: Text(
        'Manage Food Items',
        style: ProjectConstant.WorkSansFontBoldTextStyle(
          fontSize: 20,
          fontColor: Colors.black,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _startSearch();
            },
            icon: Icon(
              Icons.search,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _refreshHandler();
            },
            icon: Icon(
              Icons.refresh,
            ),
          ),
        ),
      ],
    );
  }

  AppBar _selectionAppBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 70,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      elevation: 3,
      title: Text(
        'Selected (${_selectedFoodItemList.length})',
        style: ProjectConstant.WorkSansFontBoldTextStyle(
          fontSize: 20,
          fontColor: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedFoodItemList.clear();
              _selectedFoodItemList.addAll(_foodItemList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showFoodItemDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedFoodItemList.clear();
              setState(() {});
            },
            icon: Icon(
              Icons.close,
            ),
          ),
        ),
      ],
    );
  }

  AppBar _searchWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: null,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      toolbarHeight: 120,
      flexibleSpace: Column(
        children: [
          AppBar(
            elevation: 0,
            toolbarHeight: 60,
            leading: InkWell(
              onTap: () {
                if (_searchQueryEditingController.text.isEmpty) {
                  setState(() {
                    _isSearching = false;
                  });
                  return;
                }
                _clearSearchQuery();
              },
              child: Icon(
                Icons.arrow_back,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            title: TextField(
              controller: _searchQueryEditingController,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Search Food Item...',
                border: InputBorder.none,
                hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                  fontSize: 16,
                  fontColor: Colors.grey,
                ),
              ),
              style: ProjectConstant.WorkSansFontRegularTextStyle(
                fontSize: 16,
                fontColor: Colors.black,
              ),
              onChanged: _updateSearchQuery,
            ),
            backgroundColor: Colors.white,
            actions: [
              Container(
                margin: EdgeInsets.only(right: 20),
                child: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    if (_searchQueryEditingController.text.isEmpty) {
                      setState(() {
                        _isSearching = false;
                      });
                      return;
                    }
                    _clearSearchQuery();
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _searchBarItemWidget(
                      name: 'By Food Name',
                      isSelected: _isByFoodNameSelected,
                      onTap: () {
                        setState(() {
                          _isByFoodNameSelected = !_isByFoodNameSelected;
                          _isByFoodCategorySelected = false;
                          _isByFoodTypeSelected = false;
                          _isByTypeSelected = false;
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    _searchBarItemWidget(
                      name: 'By Food Category',
                      isSelected: _isByFoodCategorySelected,
                      onTap: () {
                        setState(() {
                          _isByFoodNameSelected = false;
                          _isByFoodCategorySelected = !_isByFoodCategorySelected;
                          _isByFoodTypeSelected = false;
                          _isByTypeSelected = false;
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    _searchBarItemWidget(
                      name: 'By Food Type',
                      isSelected: _isByFoodTypeSelected,
                      onTap: () {
                        setState(() {
                          _isByFoodNameSelected = false;
                          _isByFoodCategorySelected = false;
                          _isByFoodTypeSelected = !_isByFoodTypeSelected;
                          _isByTypeSelected = false;
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    _searchBarItemWidget(
                      name: 'By Type',
                      isSelected: _isByTypeSelected,
                      onTap: () {
                        setState(() {
                          _isByFoodNameSelected = false;
                          _isByFoodCategorySelected = false;
                          _isByFoodTypeSelected = false;
                          _isByTypeSelected = !_isByTypeSelected;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell _searchBarItemWidget({
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey,
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            if (isSelected)
              Row(
                children: [
                  Icon(
                    Icons.done,
                    color: Colors.red,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            Text(
              name,
              style: isSelected
                  ? ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 15,
                      fontColor: Colors.red,
                    )
                  : ProjectConstant.WorkSansFontRegularTextStyle(
                      fontSize: 15,
                      fontColor: Colors.black,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileView(GetFoodItemState state) {
    return state is GetFoodItemLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildFoodItemSearchList(state)
            : _isFilters
                ? _buildFilteredFoodItemList(state)
                : _buildFoodItemList(state);
  }

  Widget _buildTabletView(GetFoodItemState state) {
    return state is GetFoodItemLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildFoodItemSearchList(state)
            : _isFilters
                ? _buildFilteredFoodItemList(state)
                : _buildFoodItemList(state);
  }

  Widget _buildWebView(double screenHeight, double screenWidth, GetFoodItemState state) {
    return Scaffold(
      appBar: _selectedFoodItemList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetFoodItemLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildFoodItemSearchList(state)
              : _isFilters
                  ? _buildFilteredFoodItemList(state)
                  : _buildFoodItemList(state),
    );
  }

  void search() {
    if (_isByFoodNameSelected) {
      _searchFoodItemList = _foodItemList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
    } else if (_isByFoodCategorySelected) {
      _searchFoodItemList = _foodItemList.where((item) => item.foodCategoryName.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
    } else if (_isByFoodTypeSelected) {
      _searchFoodItemList = _foodItemList.where((item) => (item.foodType == 'veg' ? 'Vegetarian' : 'Non-Vegetarian').toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
    } else if (_isByTypeSelected) {
      _searchFoodItemList = _foodItemList.where((item) => (item.type == 'normal' ? 'Normal' : 'Custom').toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
    }
  }

  void _startSearch() {
    print("open search box");
    search();
    setState(() {
      _isSearching = true;
    });
  }

  void _filtersFunc(String type) {
    if (type == 'all') {
      setState(() {
        _isFilters = false;
        _filteredFoodItemList.clear();
      });
    } else if (type == 'today') {
      setState(() {
        _isFilters = true;

        _filteredFoodItemList = _foodItemList.where((element) => element.updatedAt.toLocal().difference(DateTime.now()).inDays == 0).toList();
      });
    } else if (type == 'yesterday') {
      setState(() {
        _isFilters = true;
        _filteredFoodItemList = _foodItemList.where((element) => element.updatedAt.toLocal().difference(DateTime.now()).inDays == -1).toList();
      });
    } else if (type == '7days') {
      setState(() {
        _isFilters = true;
        _filteredFoodItemList = _foodItemList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 7))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '30days') {
      setState(() {
        _isFilters = true;
        _filteredFoodItemList = _foodItemList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 30))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '90days') {
      setState(() {
        _isFilters = true;
        _filteredFoodItemList = _foodItemList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 90))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '180days') {
      setState(() {
        _isFilters = true;
        _filteredFoodItemList = _foodItemList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 180))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '365days') {
      setState(() {
        _isFilters = true;
        _filteredFoodItemList = _foodItemList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 365))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    }
  }

  void _updateSearchQuery(String newQuery) {
    print("search query " + newQuery);
    setState(() {
      search();
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQueryEditingController.clear();
      _searchFoodItemList.clear();
      _isSearching = false;
      _isByFoodNameSelected = false;
    });
  }

  void _showSnackMessage(String message, Color color, [int seconds = 3]) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: seconds),
      ),
    );
  }

  Widget _buildFoodItemList(GetFoodItemState state) {
    return Align(
      alignment: Alignment.topLeft,
      child: RefreshIndicator(
        onRefresh: () async {
          _refreshHandler();
        },
        child: Scrollbar(
          controller: _verticalScrollController,
          isAlwaysShown: true,
          showTrackOnHover: true,
          child: SingleChildScrollView(
            controller: _verticalScrollController,
            child: PaginatedDataTable(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 120,
                    child: DropdownButtonFormField<Map<String, String>>(
                      value: _filtersList.first,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0.0),
                      ),
                      isExpanded: true,
                      items: _filtersList.map((filter) {
                        return DropdownMenuItem<Map<String, String>>(
                          value: filter,
                          child: Text(
                            filter['title'] ?? '',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 12,
                              fontColor: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      iconEnabledColor: Colors.black,
                      onChanged: (value) {
                        _filtersFunc(value!['value'] ?? '');
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              showCheckboxColumn: true,
              sortAscending: _sortAsc,
              sortColumnIndex: _sortColumnIndex,
              onSelectAll: _onSelectAllFoodItem,
              showFirstLastButtons: true,
              onRowsPerPageChanged: (value) {
                setState(() {
                  LIMIT_PER_PAGE = value.toString();
                });
              },
              rowsPerPage: num.parse(LIMIT_PER_PAGE).toInt(),
              onPageChanged: (value) {
                setState(() {
                  _verticalScrollController.animateTo(
                    0.0,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.ease,
                  );
                });
              },
              columns: [
                DataColumn(
                  label: Text(
                    'Name',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodItemList.sort((foodItem1, foodItem2) => foodItem1.name.compareTo(foodItem2.name));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    'Price',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodItemList.sort((foodItem1, foodItem2) => foodItem1.price.compareTo(foodItem2.price));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Food Category',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodItemList.sort((foodItem1, foodItem2) => foodItem1.foodCategoryName.compareTo(foodItem2.foodCategoryName));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Food Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'In Stock',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Image',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date created',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCreatedAtAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCreatedAtAsc;
                      }
                      _foodItemList.sort((foodItem1, foodItem2) => foodItem1.createdAt.compareTo(foodItem2.createdAt));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                    label: Text(
                      'Date modified',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      ),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = _sortEditedAtAsc = ascending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = _sortEditedAtAsc;
                        }
                        _foodItemList.sort((foodItem1, foodItem2) => foodItem1.updatedAt.compareTo(foodItem2.updatedAt));
                        if (!ascending) {
                          _foodItemList = _foodItemList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
              ],
              source: FoodItemDataTableSource(
                context: context,
                state: state,
                foodItemList: _foodItemList,
                selectedFoodItemList: _selectedFoodItemList,
                onSelectFoodItemChanged: _onSelectFoodItemChanged,
                refreshHandler: _refreshHandler,
                editFoodItemCallback: _editFoodItemCallback,
                showImageCallback: _showImage,
                showFoodItemDeleteConfirmation: _showFoodItemDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredFoodItemList(GetFoodItemState state) {
    return Align(
      alignment: Alignment.topLeft,
      child: RefreshIndicator(
        onRefresh: () async {
          _refreshHandler();
        },
        child: Scrollbar(
          controller: _filteredVerticalScrollController,
          isAlwaysShown: true,
          showTrackOnHover: true,
          child: SingleChildScrollView(
            controller: _filteredVerticalScrollController,
            child: PaginatedDataTable(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 120,
                    child: DropdownButtonFormField<Map<String, String>>(
                      value: _filtersList.first,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0.0),
                      ),
                      isExpanded: true,
                      items: _filtersList.map((filter) {
                        return DropdownMenuItem<Map<String, String>>(
                          value: filter,
                          child: Text(
                            filter['title'] ?? '',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 12,
                              fontColor: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      iconEnabledColor: Colors.black,
                      onChanged: (value) {
                        _filtersFunc(value!['value'] ?? '');
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              showCheckboxColumn: true,
              sortAscending: _sortAsc,
              sortColumnIndex: _sortColumnIndex,
              onSelectAll: _onSelectAllFoodItem,
              showFirstLastButtons: true,
              onRowsPerPageChanged: (value) {
                setState(() {
                  LIMIT_PER_PAGE = value.toString();
                });
              },
              rowsPerPage: num.parse(LIMIT_PER_PAGE).toInt(),
              onPageChanged: (value) {
                setState(() {
                  _filteredVerticalScrollController.animateTo(
                    0.0,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.ease,
                  );
                });
              },
              columns: [
                DataColumn(
                  label: Text(
                    'Name',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _filteredFoodItemList.sort((foodItem1, foodItem2) => foodItem1.name.compareTo(foodItem2.name));
                      if (!ascending) {
                        _filteredFoodItemList = _filteredFoodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    'Price',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _filteredFoodItemList.sort((foodItem1, foodItem2) => foodItem1.price.compareTo(foodItem2.price));
                      if (!ascending) {
                        _filteredFoodItemList = _filteredFoodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Food Category',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _filteredFoodItemList.sort((foodItem1, foodItem2) => foodItem1.foodCategoryName.compareTo(foodItem2.foodCategoryName));
                      if (!ascending) {
                        _filteredFoodItemList = _filteredFoodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Food Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'In Stock',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Image',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date created',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCreatedAtAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCreatedAtAsc;
                      }
                      _filteredFoodItemList.sort((foodItem1, foodItem2) => foodItem1.createdAt.compareTo(foodItem2.createdAt));
                      if (!ascending) {
                        _filteredFoodItemList = _filteredFoodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                    label: Text(
                      'Date modified',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      ),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = _sortEditedAtAsc = ascending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = _sortEditedAtAsc;
                        }
                        _filteredFoodItemList.sort((foodItem1, foodItem2) => foodItem1.updatedAt.compareTo(foodItem2.updatedAt));
                        if (!ascending) {
                          _filteredFoodItemList = _filteredFoodItemList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
              ],
              source: FoodItemDataTableSource(
                context: context,
                state: state,
                foodItemList: _filteredFoodItemList,
                selectedFoodItemList: _selectedFoodItemList,
                onSelectFoodItemChanged: _onSelectFoodItemChanged,
                refreshHandler: _refreshHandler,
                editFoodItemCallback: _editFoodItemCallback,
                showImageCallback: _showImage,
                showFoodItemDeleteConfirmation: _showFoodItemDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodItemSearchList(GetFoodItemState state) {
    return Align(
      alignment: Alignment.topLeft,
      child: RefreshIndicator(
        onRefresh: () async {
          _refreshHandler();
        },
        child: Scrollbar(
          controller: _searchVerticalScrollController,
          isAlwaysShown: true,
          showTrackOnHover: true,
          child: SingleChildScrollView(
            controller: _searchVerticalScrollController,
            child: PaginatedDataTable(
              showCheckboxColumn: true,
              sortAscending: _sortAsc,
              sortColumnIndex: _sortColumnIndex,
              onSelectAll: _onSelectAllFoodItem,
              showFirstLastButtons: true,
              onRowsPerPageChanged: (value) {
                setState(() {
                  LIMIT_PER_PAGE = value.toString();
                });
              },
              rowsPerPage: num.parse(LIMIT_PER_PAGE).toInt(),
              onPageChanged: (value) {
                setState(() {
                  _searchVerticalScrollController.animateTo(
                    0.0,
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.ease,
                  );
                });
              },
              columns: [
                DataColumn(
                  label: Text(
                    'Name',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodItemList.sort((foodItem1, foodItem2) => foodItem1.name.compareTo(foodItem2.name));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  numeric: true,
                  label: Text(
                    'Price',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodItemList.sort((foodItem1, foodItem2) => foodItem1.price.compareTo(foodItem2.price));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Food Category',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodItemList.sort((foodItem1, foodItem2) => foodItem1.foodCategoryName.compareTo(foodItem2.foodCategoryName));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Food Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'In Stock',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Image',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date created',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCreatedAtAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCreatedAtAsc;
                      }
                      _foodItemList.sort((foodItem1, foodItem2) => foodItem1.createdAt.compareTo(foodItem2.createdAt));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                    label: Text(
                      'Date modified',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      ),
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = _sortEditedAtAsc = ascending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = _sortEditedAtAsc;
                        }
                        _foodItemList.sort((foodItem1, foodItem2) => foodItem1.updatedAt.compareTo(foodItem2.updatedAt));
                        if (!ascending) {
                          _foodItemList = _foodItemList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
              ],
              source: FoodItemDataTableSource(
                context: context,
                state: state,
                foodItemList: _searchFoodItemList,
                selectedFoodItemList: _selectedFoodItemList,
                onSelectFoodItemChanged: _onSelectFoodItemChanged,
                refreshHandler: _refreshHandler,
                editFoodItemCallback: _editFoodItemCallback,
                showImageCallback: _showImage,
                showFoodItemDeleteConfirmation: _showFoodItemDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSelectAllFoodItem(value) {
    if (value) {
      setState(() {
        _selectedFoodItemList.clear();
        _selectedFoodItemList.addAll(_foodItemList);
      });
    } else {
      setState(() {
        _selectedFoodItemList.clear();
      });
    }
  }

  void _onSelectFoodItemChanged(bool value, FoodItem foodItem) {
    if (value) {
      setState(() {
        _selectedFoodItemList.add(foodItem);
      });
    } else {
      setState(() {
        _selectedFoodItemList.removeWhere((foodCat) => foodCat.id == foodItem.id);
      });
    }
  }

  void _refreshHandler() {
    _getFoodItemBloc.add(GetFoodItemDataEvent(data: {
      'restaurant_id': restaurant!.emailId,
    }));
  }

  void _showFoodItemDeleteConfirmation(FoodItem foodItem) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete FoodItem'),
          content: Text('Do you really want to delete this food item ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getFoodItemBloc.add(
                  GetFoodItemDeleteEvent(
                    data: {
                      'id': foodItem.id,
                      'food_image_path': foodItem.image,
                    },
                  ),
                );
                Navigator.of(ctx).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showFoodItemDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All FoodItem'),
          content: Text('Do you really want to delete this food categories ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getFoodItemBloc.add(
                  GetFoodItemDeleteAllEvent(
                    idList: _selectedFoodItemList.map((item) {
                      return {
                        'id': item.id,
                        'old_food_image_path': item.image,
                      };
                    }).toList(),
                  ),
                );
                Navigator.of(ctx).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _editFoodItemCallback(FoodItem foodItem) async {
    FoodItem? tempFoodItem = await Navigator.of(context).pushNamed(EditFoodItemScreen.routeName, arguments: foodItem) as FoodItem?;
    setState(() {
      if (tempFoodItem != null) {
        int index = _foodItemList.indexWhere((element) => element.id == tempFoodItem.id);
        _foodItemList.removeAt(index);
        _foodItemList.insert(index, tempFoodItem);
        if (_isSearching) {
          int index = _searchFoodItemList.indexWhere((element) => element.id == tempFoodItem.id);
          _searchFoodItemList.removeAt(index);
          _searchFoodItemList.insert(index, tempFoodItem);
        }
      }
    });
  }

  void _showImage(String imageFile) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            height: screenHeight,
            width: screenWidth,
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: CachedNetworkImage(
                    imageUrl: ProjectConstant.food_images_path+imageFile,
                    placeholder: (context, url) => SkeletonView(),
                    errorWidget: (context, url, error) => ImageErrorWidget(),
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: -5,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

class FoodItemDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetFoodItemState state;
  final List<FoodItem> foodItemList;
  final List<FoodItem> selectedFoodItemList;
  final Function onSelectFoodItemChanged;
  final Function refreshHandler;
  final Function editFoodItemCallback;
  final Function showImageCallback;
  final Function showFoodItemDeleteConfirmation;

  FoodItemDataTableSource({
    required this.context,
    required this.state,
    required this.foodItemList,
    required this.selectedFoodItemList,
    required this.onSelectFoodItemChanged,
    required this.refreshHandler,
    required this.editFoodItemCallback,
    required this.showImageCallback,
    required this.showFoodItemDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final foodItem = foodItemList[index];
    return DataRow(
      selected: selectedFoodItemList.any((selectedFoodItem) => selectedFoodItem.id == foodItem.id),
      onSelectChanged: (value) => onSelectFoodItemChanged(value, foodItem),
      cells: [
        DataCell(Text(
          foodItem.name,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          foodItem.price.toStringAsFixed(2),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          foodItem.foodCategoryName,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          foodItem.foodType == 'veg' ? 'Vegetarian' : 'Non-Vegetarian',
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          foodItem.type == 'normal' ? 'Normal' : 'Custom',
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          foodItem.inStock == '1' ? 'yes' : 'no',
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(
          InkWell(
            onTap: () {
              showImageCallback(foodItem.image);
            },
            child: Text(
              'View Image',
              style: ProjectConstant.WorkSansFontRegularTextStyle(
                fontSize: 15,
                fontColor: Colors.red,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        DataCell(Text(
          DateFormat('dd MMM yyyy hh:mm a').format(foodItem.createdAt.toLocal()),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          DateFormat('dd MMM yyyy hh:mm a').format(foodItem.updatedAt.toLocal()),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(
          Row(
            children: [
              TextButton.icon(
                onPressed: state is! GetFoodItemLoadingItemState ? () {} : null,
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
                label: Text(
                  'View',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 15,
                    fontColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetFoodItemLoadingItemState
                    ? () {
                        editFoodItemCallback(foodItem);
                      }
                    : null,
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                label: Text(
                  'Edit',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 15,
                    fontColor: Colors.blue,
                  ),
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetFoodItemLoadingItemState
                    ? () {
                        showFoodItemDeleteConfirmation(foodItem);
                      }
                    : null,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: Text(
                  'Delete',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 15,
                    fontColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => foodItemList.length;

  @override
  int get selectedRowCount => selectedFoodItemList.length;
}
