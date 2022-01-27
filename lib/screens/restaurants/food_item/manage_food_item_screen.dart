import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_item/get_food_item/get_food_item_bloc.dart';
import 'package:food_hunt_admin_app/models/food_item.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/screens/restaurants/food_item/add_food_item_screen.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
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
  List<FoodItem> _selectedFoodItemList = [];
  bool _sortNameAsc = true;
  bool _sortCreatedAtAsc = true;
  bool _sortEditedAtAsc = true;
  bool _sortAsc = true;
  int? _sortColumnIndex;
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _searchVerticalScrollController = ScrollController();
  late TextEditingController _searchQueryEditingController;
  bool _isSearching = false;
  String searchQuery = "Search query";
  bool _isByFoodItemSelected = false;

  bool _isFloatingActionButtonVisible = true;

  String LIMIT_PER_PAGE = '10';

  Restaurant? restaurant;

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

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
              Navigator.of(context).pushNamed(AddFoodItemScreen.routeName, arguments: restaurant);

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
      title: Text(
        'Manage Food Category',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
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
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
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
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
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
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    setState(() {
                      _isByFoodItemSelected = !_isByFoodItemSelected;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        if (_isByFoodItemSelected)
                          Row(
                            children: [
                              Icon(
                                Icons.done,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        Text(
                          'By Name',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            : _buildFoodItemList(state);
  }

  Widget _buildTabletView(GetFoodItemState state) {
    return state is GetFoodItemLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildFoodItemSearchList(state)
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
              : _buildFoodItemList(state),
    );
  }

  void search() {
    _searchFoodItemList = _foodItemList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
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
      _searchFoodItemList.clear();
      _isSearching = false;
      _isByFoodItemSelected = false;
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
                  label: Text('Name'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodItemList.sort((user1, user2) => user1.name.compareTo(user2.name));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('In Stock'),
                ),
                DataColumn(
                  label: Text('Date created'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCreatedAtAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCreatedAtAsc;
                      }
                      _foodItemList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                    label: Text('Date modified'),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = _sortEditedAtAsc = ascending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = _sortEditedAtAsc;
                        }
                        _foodItemList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _foodItemList = _foodItemList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions'),
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
                  label: Text('Name'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodItemList.sort((user1, user2) => user1.name.compareTo(user2.name));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('In Stock'),
                ),
                DataColumn(
                  label: Text('Date created'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCreatedAtAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCreatedAtAsc;
                      }
                      _foodItemList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _foodItemList = _foodItemList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                    label: Text('Date modified'),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = _sortEditedAtAsc = ascending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = _sortEditedAtAsc;
                        }
                        _foodItemList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _foodItemList = _foodItemList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions'),
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

  void _editFoodItemCallback(FoodItem foodItem) {
    Navigator.of(context);
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
  final Function showFoodItemDeleteConfirmation;

  FoodItemDataTableSource({
    required this.context,
    required this.state,
    required this.foodItemList,
    required this.selectedFoodItemList,
    required this.onSelectFoodItemChanged,
    required this.refreshHandler,
    required this.editFoodItemCallback,
    required this.showFoodItemDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final foodItem = foodItemList[index];
    return DataRow(
      selected: selectedFoodItemList.any((selectedFoodItem) => selectedFoodItem.id == foodItem.id),
      onSelectChanged: (value) => onSelectFoodItemChanged(value, foodItem),
      cells: [
        DataCell(Text(foodItem.name)),
        DataCell(Text(foodItem.inStock)),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(foodItem.createdAt.toLocal()))),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(foodItem.updatedAt.toLocal()))),
        DataCell(
          Row(
            children: [
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
                  style: TextStyle(
                    color: Colors.blue,
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
                  style: TextStyle(
                    color: Colors.red,
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
