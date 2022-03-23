import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/liquor_item/get_liquor_item/get_liquor_item_bloc.dart';
import 'package:food_hunt_admin_app/models/liquor_item.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/screens/restaurants/liquor_item/edit_liquor_item_screen.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:food_hunt_admin_app/widgets/image_error_widget.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';
import 'package:intl/intl.dart';

import '../../responsive_layout.dart';
import 'add_liquor_item_screen.dart';

class ManageLiquorItemScreen extends StatefulWidget {
  static const routeName = '/manage-liquor-item';

  @override
  _ManageLiquorItemScreenState createState() => _ManageLiquorItemScreenState();
}

class _ManageLiquorItemScreenState extends State<ManageLiquorItemScreen> {
  bool _isInit = true;

  final GetLiquorItemBloc _getLiquorItemBloc = GetLiquorItemBloc();
  List<LiquorItem> _liquorItemList = [];
  List<LiquorItem> _searchLiquorItemList = [];
  List<LiquorItem> _selectedLiquorItemList = [];
  List<LiquorItem> _filterLiquorItemList = [];
  bool _sortNameAsc = true;
  bool _sortCreatedAtAsc = true;
  bool _sortEditedAtAsc = true;
  bool _sortAsc = true;
  int? _sortColumnIndex;
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _searchVerticalScrollController = ScrollController();
  final ScrollController _filterVerticalScrollController = ScrollController();
  late TextEditingController _searchQueryEditingController;
  bool _isSearching = false;
  String searchQuery = "Search query";
  bool _isByLiquorNameSelected = true;
  bool _isByLiquorCategorySelected = true;
  bool _isFloatingActionButtonVisible = true;

  bool _isFilter = false;

  String LIMIT_PER_PAGE = '10';

  Restaurant? restaurant;

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  List<Map<String, String>> _filterList = [
    {'title': 'All', 'value': 'all'},
    {'title': 'Today', 'value': 'today'},
    {'title': 'Yesterday', 'value': 'yesterday'},
    {'title': '7 days', 'value': '7days'},
    {'title': '30 days', 'value': '30days'},
    {'title': '90 days', 'value': '90days'},
    {'title': '180 days', 'value': '180days'},
    {'title': '365 days', 'value': '365days'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant?;
      _searchQueryEditingController = TextEditingController();
      _getLiquorItemBloc.add(GetLiquorItemDataEvent(data: {
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
          ? _selectedLiquorItemList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetLiquorItemBloc, GetLiquorItemState>(
        bloc: _getLiquorItemBloc,
        listener: (context, state) {
          if (state is GetLiquorItemSuccessState) {
            _liquorItemList = state.liquorItemList;
          } else if (state is GetLiquorItemFailedState) {
            _showSnackMessage(state.message, Colors.red.shade700);
          } else if (state is GetLiquorItemExceptionState) {
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
              Navigator.of(context).pushNamed(AddLiquorItemScreen.routeName, arguments: restaurant);
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
      // leading: IconButton(
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      //   icon: Icon(Icons.arrow_back),
      // ),
      title: Text('Manage Liquor Item',
          style: ProjectConstant.WorkSansFontBoldTextStyle(
            fontSize: 20,
            fontColor: Colors.black,
          )),
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
      title: Text('Selected (${_selectedLiquorItemList.length})',
          style: ProjectConstant.WorkSansFontBoldTextStyle(
            fontSize: 20,
            fontColor: Colors.black,
          )),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedLiquorItemList.clear();
              _selectedLiquorItemList.addAll(_liquorItemList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showLiquorItemDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedLiquorItemList.clear();
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
                hintText: 'Search Liquor Item...',
                border: InputBorder.none,
                hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                  fontSize: 16,
                  fontColor: Colors.black,
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
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
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _searchBarItemWidget(
                  onTap: () {
                    setState(() {
                      _isByLiquorNameSelected = !_isByLiquorNameSelected;
                      _isByLiquorCategorySelected = false;
                    });
                  },
                  name: 'By Liquor Name',
                  isSelected: _isByLiquorNameSelected,
                ),
                _searchBarItemWidget(
                  name: 'By Liquor Category',
                  isSelected: _isByLiquorCategorySelected,
                  onTap: () {
                    setState(() {
                      _isByLiquorCategorySelected = !_isByLiquorCategorySelected;
                      _isByLiquorNameSelected = false;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileView(GetLiquorItemState state) {
    return state is GetLiquorItemLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildLiquorItemSearchList(state)
            : _isFilter
                ? _buildFilterLiquorItemList(state)
                : _buildLiquorItemList(state);
  }

  Widget _buildTabletView(GetLiquorItemState state) {
    return state is GetLiquorItemLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildLiquorItemSearchList(state)
            : _isFilter
                ? _buildFilterLiquorItemList(state)
                : _buildLiquorItemList(state);
  }

  Widget _buildWebView(double screenHeight, double screenWidth, GetLiquorItemState state) {
    return Scaffold(
      appBar: _selectedLiquorItemList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetLiquorItemLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildLiquorItemSearchList(state)
              : _isFilter
                  ? _buildFilterLiquorItemList(state)
                  : _buildLiquorItemList(state),
    );
  }

  void search() {
    if (_isByLiquorNameSelected)
      _searchLiquorItemList = _liquorItemList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
    else if (_isByLiquorCategorySelected) _searchLiquorItemList = _liquorItemList.where((item) => item.liquorCategoryName.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
  }

  void _startSearch() {
    print("open search box");
    search();
    setState(() {
      _isSearching = true;
    });
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
      _searchLiquorItemList.clear();
      _isSearching = false;
      _isByLiquorNameSelected = false;
    });
  }

  void filterFunction(String type) {
    if (type == 'all') {
      setState(() {
        _isFilter = false;
        _filterLiquorItemList.clear();
      });
    } else if (type == 'today') {
      setState(() {
        _isFilter = true;
        _filterLiquorItemList = _liquorItemList.where((element) => element.updatedAt.toLocal().difference(DateTime.now()).inDays == 0).toList();
      });
    } else if (type == 'yesterday') {
      setState(() {
        _isFilter = true;
        _filterLiquorItemList = _liquorItemList.where((element) => element.updatedAt.toLocal().difference(DateTime.now()).inDays == -1).toList();
      });
    } else if (type == '7days') {
      setState(() {
        _isFilter = true;
        _filterLiquorItemList = _liquorItemList
            .where((element) => element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 7))) == 0 && (element.updatedAt.toLocal().compareTo(DateTime.now()) > 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '30days') {
      setState(() {
        _isFilter = true;
        _filterLiquorItemList = _liquorItemList
            .where((element) => element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 30))) == 0 && (element.updatedAt.toLocal().compareTo(DateTime.now()) > 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '90days') {
      setState(() {
        _isFilter = true;
        _filterLiquorItemList = _liquorItemList
            .where((element) => element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 90))) == 0 && (element.updatedAt.toLocal().compareTo(DateTime.now()) > 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '180days') {
      setState(() {
        _isFilter = true;
        _filterLiquorItemList = _liquorItemList
            .where((element) => element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 90 * 2))) == 0 && (element.updatedAt.toLocal().compareTo(DateTime.now()) > 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '365days') {
      setState(() {
        _isFilter = true;
        _filterLiquorItemList = _liquorItemList
            .where((element) => element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 365))) == 0 && (element.updatedAt.toLocal().compareTo(DateTime.now()) > 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    }
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

  Widget _buildLiquorItemList(GetLiquorItemState state) {
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
                      value: _filterList.first,
                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red, width: 1))),
                      isExpanded: true,
                      items: _filterList.map((filter) {
                        return DropdownMenuItem<Map<String, String>>(
                          value: filter,
                          child: Text(
                            filter['title'] ?? '',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 14,
                              fontColor: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        filterFunction(value!['value'] ?? '');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              showCheckboxColumn: true,
              sortAscending: _sortAsc,
              sortColumnIndex: _sortColumnIndex,
              onSelectAll: _onSelectAllLiquorItem,
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
                  label: Text('Name',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _liquorItemList.sort((foodItem1, foodItem2) => foodItem1.name.compareTo(foodItem2.name));
                      if (!ascending) {
                        _liquorItemList = _liquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Price',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _liquorItemList.sort((foodItem1, foodItem2) => foodItem1.price.compareTo(foodItem2.price));
                      if (!ascending) {
                        _liquorItemList = _liquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Original Price',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _liquorItemList.sort((foodItem1, foodItem2) => foodItem1.orginalPrice.compareTo(foodItem2.orginalPrice));
                      if (!ascending) {
                        _liquorItemList = _liquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Category',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _liquorItemList.sort((foodItem1, foodItem2) => foodItem1.liquorCategoryName.compareTo(foodItem2.liquorCategoryName));
                      if (!ascending) {
                        _liquorItemList = _liquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('In Stock',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                ),
                DataColumn(
                  label: Text('Image',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                ),
                DataColumn(
                  label: Text('Date created',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCreatedAtAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCreatedAtAsc;
                      }
                      _liquorItemList.sort((foodItem1, foodItem2) => foodItem1.createdAt.compareTo(foodItem2.createdAt));
                      if (!ascending) {
                        _liquorItemList = _liquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                    label: Text('Date modified',
                        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 16,
                          fontColor: Colors.black,
                        )),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = _sortEditedAtAsc = ascending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = _sortEditedAtAsc;
                        }
                        _liquorItemList.sort((foodItem1, foodItem2) => foodItem1.updatedAt.compareTo(foodItem2.updatedAt));
                        if (!ascending) {
                          _liquorItemList = _liquorItemList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                ),
              ],
              source: LiquorItemDataTableSource(
                context: context,
                state: state,
                liquorItemList: _liquorItemList,
                selectedLiquorItemList: _selectedLiquorItemList,
                onSelectLiquorItemChanged: _onSelectLiquorItemChanged,
                refreshHandler: _refreshHandler,
                editLiquorItemCallback: _editLiquorItemCallback,
                showImageCallback: _showImage,
                showLiquorItemDeleteConfirmation: _showLiquorItemDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiquorItemSearchList(GetLiquorItemState state) {
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
              onSelectAll: _onSelectAllLiquorItem,
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
                      _searchLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.name.compareTo(foodItem2.name));
                      if (!ascending) {
                        _searchLiquorItemList = _searchLiquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
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
                      _searchLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.price.compareTo(foodItem2.price));
                      if (!ascending) {
                        _searchLiquorItemList = _searchLiquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Original Price',
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
                      _searchLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.orginalPrice.compareTo(foodItem2.orginalPrice));
                      if (!ascending) {
                        _searchLiquorItemList = _searchLiquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Category',
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
                      _searchLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.liquorCategoryName.compareTo(foodItem2.liquorCategoryName));
                      if (!ascending) {
                        _searchLiquorItemList = _searchLiquorItemList.reversed.toList();
                      }
                    });
                  },
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
                      _searchLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.createdAt.compareTo(foodItem2.createdAt));
                      if (!ascending) {
                        _searchLiquorItemList = _searchLiquorItemList.reversed.toList();
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
                      _searchLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.updatedAt.compareTo(foodItem2.updatedAt));
                      if (!ascending) {
                        _searchLiquorItemList = _searchLiquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
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
              source: LiquorItemDataTableSource(
                context: context,
                state: state,
                liquorItemList: _searchLiquorItemList,
                selectedLiquorItemList: _selectedLiquorItemList,
                onSelectLiquorItemChanged: _onSelectLiquorItemChanged,
                refreshHandler: _refreshHandler,
                editLiquorItemCallback: _editLiquorItemCallback,
                showImageCallback: _showImage,
                showLiquorItemDeleteConfirmation: _showLiquorItemDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterLiquorItemList(GetLiquorItemState state) {
    return Align(
      alignment: Alignment.topLeft,
      child: RefreshIndicator(
        onRefresh: () async {
          _refreshHandler();
        },
        child: Scrollbar(
          controller: _filterVerticalScrollController,
          isAlwaysShown: true,
          showTrackOnHover: true,
          child: SingleChildScrollView(
            controller: _filterVerticalScrollController,
            child: PaginatedDataTable(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 120,
                    child: DropdownButtonFormField<Map<String, String>>(
                      value: _filterList.first,
                      decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red, width: 1))),
                      isExpanded: true,
                      items: _filterList.map((filter) {
                        return DropdownMenuItem<Map<String, String>>(
                          value: filter,
                          child: Text(
                            filter['title'] ?? '',
                            style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                              fontSize: 14,
                              fontColor: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        filterFunction(value!['value'] ?? '');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              showCheckboxColumn: true,
              sortAscending: _sortAsc,
              sortColumnIndex: _sortColumnIndex,
              onSelectAll: _onSelectAllLiquorItem,
              showFirstLastButtons: true,
              onRowsPerPageChanged: (value) {
                setState(() {
                  LIMIT_PER_PAGE = value.toString();
                });
              },
              rowsPerPage: num.parse(LIMIT_PER_PAGE).toInt(),
              onPageChanged: (value) {
                setState(() {
                  _filterVerticalScrollController.animateTo(
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
                      _filterLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.name.compareTo(foodItem2.name));
                      if (!ascending) {
                        _filterLiquorItemList = _filterLiquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
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
                      _filterLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.price.compareTo(foodItem2.price));
                      if (!ascending) {
                        _filterLiquorItemList = _filterLiquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Original Price',
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      )),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _filterLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.orginalPrice.compareTo(foodItem2.orginalPrice));
                      if (!ascending) {
                        _filterLiquorItemList = _filterLiquorItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Category',
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
                      _filterLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.liquorCategoryName.compareTo(foodItem2.liquorCategoryName));
                      if (!ascending) {
                        _filterLiquorItemList = _filterLiquorItemList.reversed.toList();
                      }
                    });
                  },
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
                      _filterLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.createdAt.compareTo(foodItem2.createdAt));
                      if (!ascending) {
                        _filterLiquorItemList = _filterLiquorItemList.reversed.toList();
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
                        _filterLiquorItemList.sort((foodItem1, foodItem2) => foodItem1.updatedAt.compareTo(foodItem2.updatedAt));
                        if (!ascending) {
                          _filterLiquorItemList = _filterLiquorItemList.reversed.toList();
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
              source: LiquorItemDataTableSource(
                context: context,
                state: state,
                liquorItemList: _filterLiquorItemList,
                selectedLiquorItemList: _selectedLiquorItemList,
                onSelectLiquorItemChanged: _onSelectLiquorItemChanged,
                refreshHandler: _refreshHandler,
                editLiquorItemCallback: _editLiquorItemCallback,
                showImageCallback: _showImage,
                showLiquorItemDeleteConfirmation: _showLiquorItemDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
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
                    imageUrl: ProjectConstant.liquor_images_path + imageFile,
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

  void _onSelectAllLiquorItem(value) {
    if (value) {
      setState(() {
        _selectedLiquorItemList.clear();
        _selectedLiquorItemList.addAll(_liquorItemList);
      });
    } else {
      setState(() {
        _selectedLiquorItemList.clear();
      });
    }
  }

  void _onSelectLiquorItemChanged(bool value, LiquorItem liquorItem) {
    if (value) {
      setState(() {
        _selectedLiquorItemList.add(liquorItem);
      });
    } else {
      setState(() {
        _selectedLiquorItemList.removeWhere((liquorCat) => liquorCat.id == liquorItem.id);
      });
    }
  }

  void _refreshHandler() {
    _getLiquorItemBloc.add(GetLiquorItemDataEvent(data: {
      'restaurant_id': restaurant!.emailId,
    }));
  }

  void _showLiquorItemDeleteConfirmation(LiquorItem liquorItem) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete LiquorItem'),
          content: Text('Do you really want to delete this liquor item ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getLiquorItemBloc.add(
                  GetLiquorItemDeleteEvent(
                    data: {'id': liquorItem.id, 'liquor_image_path': liquorItem.image},
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

  void _showLiquorItemDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All LiquorItem'),
          content: Text('Do you really want to delete this liquor categories ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getLiquorItemBloc.add(
                  GetLiquorItemDeleteAllEvent(
                    idList: _selectedLiquorItemList.map((item) {
                      return {'id': item.id, 'old_liquor_image_path': item.image};
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

  void _editLiquorItemCallback(LiquorItem liquorItem) {
    LiquorItem? tempLiquorItem = Navigator.of(context).pushNamed(EditLiquorItemScreen.routeName, arguments: liquorItem) as LiquorItem?;
    if (tempLiquorItem != null) {
      setState(() {
        int index = _liquorItemList.indexWhere((element) => element.id == tempLiquorItem.id);
        _liquorItemList.removeAt(index);
        _liquorItemList.insert(
          index,
          tempLiquorItem,
        );
        if (_isSearching) {
          int index = _searchLiquorItemList.indexWhere((element) => element.id == tempLiquorItem.id);
          _searchLiquorItemList.removeAt(index);
          _searchLiquorItemList.insert(
            index,
            tempLiquorItem,
          );
        }
      });
    }
  }
}

class LiquorItemDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetLiquorItemState state;
  final List<LiquorItem> liquorItemList;
  final List<LiquorItem> selectedLiquorItemList;
  final Function onSelectLiquorItemChanged;
  final Function refreshHandler;
  final Function editLiquorItemCallback;
  final Function showImageCallback;
  final Function showLiquorItemDeleteConfirmation;

  LiquorItemDataTableSource({
    required this.context,
    required this.state,
    required this.liquorItemList,
    required this.selectedLiquorItemList,
    required this.onSelectLiquorItemChanged,
    required this.refreshHandler,
    required this.editLiquorItemCallback,
    required this.showImageCallback,
    required this.showLiquorItemDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final liquorItem = liquorItemList[index];
    return DataRow(
      selected: selectedLiquorItemList.any((selectedLiquorItem) => selectedLiquorItem.id == liquorItem.id),
      onSelectChanged: (value) => onSelectLiquorItemChanged(value, liquorItem),
      cells: [
        DataCell(
          Text(
            liquorItem.name,
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.black,
            ),
          ),
        ),
        DataCell(
          Text(
            '${ProjectConstant.currencySymbol}${NumberFormat.decimalPattern().format(liquorItem.price)}',
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.black,
            ),
          ),
        ),
        DataCell(
          Text(
            '${ProjectConstant.currencySymbol}${NumberFormat.decimalPattern().format(liquorItem.orginalPrice)}',
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.black,
            ),
          ),
        ),
        DataCell(
          Text(
            liquorItem.liquorCategoryName,
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.black,
            ),
          ),
        ),
        DataCell(
          Text(
            liquorItem.inStock == '1' ? 'Yes' : 'No',
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.black,
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () {
              print(liquorItem.image);
              showImageCallback(liquorItem.image);
            },
            child: Text(
              'View Image',
              style: ProjectConstant.WorkSansFontRegularTextStyle(
                fontSize: 16,
                fontColor: Colors.red.shade700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd MMM yyyy hh:mm a').format(liquorItem.createdAt.toLocal()),
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.black,
            ),
          ),
        ),
        DataCell(
          Text(
            DateFormat('dd MMM yyyy hh:mm a').format(liquorItem.updatedAt.toLocal()),
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.black,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              TextButton.icon(
                onPressed: state is! GetLiquorItemLoadingItemState ? () {} : null,
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
              SizedBox(
                width: 10,
              ),
              TextButton.icon(
                onPressed: state is! GetLiquorItemLoadingItemState
                    ? () {
                        editLiquorItemCallback(liquorItem);
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
                onPressed: state is! GetLiquorItemLoadingItemState
                    ? () {
                        showLiquorItemDeleteConfirmation(liquorItem);
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
                    fontColor: Colors.black,
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
  int get rowCount => liquorItemList.length;

  @override
  int get selectedRowCount => selectedLiquorItemList.length;
}
