import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_category/add_food_category/add_food_category_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_category/edit_food_category/edit_food_category_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_category/get_food_category/get_food_category_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:intl/intl.dart';

import '../../responsive_layout.dart';

class ManageFoodCategoryScreen extends StatefulWidget {
  static const routeName = '/manage-food-category';

  @override
  _ManageFoodCategoryScreenState createState() => _ManageFoodCategoryScreenState();
}

class _ManageFoodCategoryScreenState extends State<ManageFoodCategoryScreen> {
  bool _isInit = true;
  final _addFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final AddFoodCategoryBloc _addFoodCategoryBloc = AddFoodCategoryBloc();
  final EditFoodCategoryBloc _editFoodCategoryBloc = EditFoodCategoryBloc();
  final GetFoodCategoryBloc _getFoodCategoryBloc = GetFoodCategoryBloc();
  List<FoodCategory> _foodCategoryList = [];
  List<FoodCategory> _searchFoodCategoryList = [];
  final List<FoodCategory> _selectedFoodCategoryList = [];
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
  bool _isByFoodCategorySelected = false;

  bool _isFloatingActionButtonVisible = true;

  String LIMIT_PER_PAGE = '10';

  Restaurant? restaurant;
  bool validate = false;
  var _nameController = TextEditingController();

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  Map<String, dynamic> _addData = {
    'name': '',
    'restaurant_id': 0,
  };

  Map<String, dynamic> _editData = {
    'id': 0,
    'name': '',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant?;
      _searchQueryEditingController = TextEditingController();
      _getFoodCategoryBloc.add(GetFoodCategoryDataEvent(data: {
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
          ? _selectedFoodCategoryList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetFoodCategoryBloc, GetFoodCategoryState>(
        bloc: _getFoodCategoryBloc,
        listener: (context, state) {
          if (state is GetFoodCategorySuccessState) {
            _foodCategoryList = state.foodCategoryList;
          } else if (state is GetFoodCategoryFailedState) {
            _showSnackMessage(state.message, Colors.red.shade700);
          } else if (state is GetFoodCategoryExceptionState) {
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
              FoodCategory? foodCategory = await showDialog<FoodCategory?>(
                context: context,
                builder: (ctx) {
                  return BlocConsumer<AddFoodCategoryBloc, AddFoodCategoryState>(
                    bloc: _addFoodCategoryBloc,
                    listener: (ct, state) {
                      if (state is AddFoodCategorySuccessState) {
                        Navigator.of(ctx).pop(state.foodCategory);
                      } else if (state is AddFoodCategoryFailureState) {
                        _showSnackMessage(state.message, Colors.red.shade700);
                        Navigator.of(ctx).pop(null);
                      } else if (state is AddFoodCategoryExceptionState) {
                        _showSnackMessage(state.message, Colors.red.shade700);
                        Navigator.of(ctx).pop(null);
                      }
                    },
                    builder: (context, state) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            actionsPadding: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              'Add Food Category',
                              style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                fontSize: 16,
                                fontColor: Colors.black,
                              ),
                            ),
                            content: Form(
                              key: _addFormKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Container(
                                    decoration: DottedDecoration(
                                      shape: Shape.box,
                                      color: _nameController.text == '' && validate ? Colors.red : Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(containerRadius),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(containerRadius),
                                        color: Colors.grey.shade100,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          hintText: 'Name',
                                          hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                                            fontSize: 15,
                                            fontColor: Colors.grey,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: ProjectConstant.WorkSansFontRegularTextStyle(
                                          fontSize: 15,
                                          fontColor: Colors.black,
                                        ),
                                        onSaved: (newValue) {
                                          _addData['name'] = newValue!.trim();
                                        },
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ),
                                  if (_nameController.text == '' && validate)
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          Text(
                                            'Required Field !!',
                                            style: ProjectConstant.WorkSansFontRegularTextStyle(
                                              fontSize: 12,
                                              fontColor: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(null);
                                },
                                child: Text(
                                  'Cancel',
                                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                    fontSize: 15,
                                    fontColor: Colors.red,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    validate = true;
                                  });
                                  if (_nameController.text.trim() == '') {
                                    return;
                                  }
                                  _addFormKey.currentState!.save();
                                  _addData['restaurant_id'] = restaurant!.emailId;
                                  _addFoodCategoryBloc.add(AddFoodCategoryAddEvent(
                                    addFoodCategoryData: _addData,
                                  ));
                                },
                                child: Text(
                                  'Okay',
                                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                                    fontSize: 15,
                                    fontColor: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
              if (foodCategory != null) {
                setState(() {
                  _foodCategoryList.add(foodCategory);
                });
              }
              _nameController.text = '';
              validate = false;
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
        'Selected (${_selectedFoodCategoryList.length})',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedFoodCategoryList.clear();
              _selectedFoodCategoryList.addAll(_foodCategoryList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showFoodCategoryDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedFoodCategoryList.clear();
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
                hintText: 'Search Food Category...',
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
                      _isByFoodCategorySelected = !_isByFoodCategorySelected;
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
                        if (_isByFoodCategorySelected)
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

  Widget _buildMobileView(GetFoodCategoryState state) {
    return state is GetFoodCategoryLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildFoodCategorySearchList(state)
            : _buildFoodCategoryList(state);
  }

  Widget _buildTabletView(GetFoodCategoryState state) {
    return state is GetFoodCategoryLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildFoodCategorySearchList(state)
            : _buildFoodCategoryList(state);
  }

  Widget _buildWebView(double screenHeight, double screenWidth, GetFoodCategoryState state) {
    return Scaffold(
      appBar: _selectedFoodCategoryList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetFoodCategoryLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildFoodCategorySearchList(state)
              : _buildFoodCategoryList(state),
    );
  }

  void search() {
    _searchFoodCategoryList = _foodCategoryList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
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
      _searchFoodCategoryList.clear();
      _isSearching = false;
      _isByFoodCategorySelected = false;
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

  Widget _buildFoodCategoryList(GetFoodCategoryState state) {
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
              onSelectAll: _onSelectAllFoodCategory,
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
                  label: Text('Name',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodCategoryList.sort((user1, user2) => user1.name.compareTo(user2.name));
                      if (!ascending) {
                        _foodCategoryList = _foodCategoryList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Status',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                ),
                DataColumn(
                  label: Text('Date created',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCreatedAtAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCreatedAtAsc;
                      }
                      _foodCategoryList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _foodCategoryList = _foodCategoryList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                    label: Text('Date modified',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = _sortEditedAtAsc = ascending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = _sortEditedAtAsc;
                        }
                        _foodCategoryList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _foodCategoryList = _foodCategoryList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                ),
              ],
              source: FoodCategoryDataTableSource(
                context: context,
                state: state,
                foodCategoryList: _foodCategoryList,
                selectedFoodCategoryList: _selectedFoodCategoryList,
                onSelectFoodCategoryChanged: _onSelectFoodCategoryChanged,
                refreshHandler: _refreshHandler,
                editFoodCategoryCallBack: _editFoodCategoryCallBack,
                updateStatusFoodCategoryFunc: _updateStatusFoodCategoryFunc,
                showFoodCategoryDeleteConfirmation: _showFoodCategoryDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCategorySearchList(GetFoodCategoryState state) {
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
              onSelectAll: _onSelectAllFoodCategory,
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
                  label: Text('Name',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodCategoryList.sort((user1, user2) => user1.name.compareTo(user2.name));
                      if (!ascending) {
                        _foodCategoryList = _foodCategoryList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Status',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                ),
                DataColumn(
                  label: Text('Date created',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCreatedAtAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCreatedAtAsc;
                      }
                      _foodCategoryList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _foodCategoryList = _foodCategoryList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                    label: Text('Date modified',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        if (columnIndex == _sortColumnIndex) {
                          _sortAsc = _sortEditedAtAsc = ascending;
                        } else {
                          _sortColumnIndex = columnIndex;
                          _sortAsc = _sortEditedAtAsc;
                        }
                        _foodCategoryList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _foodCategoryList = _foodCategoryList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                ),
              ],
              source: FoodCategoryDataTableSource(
                context: context,
                state: state,
                foodCategoryList: _searchFoodCategoryList,
                selectedFoodCategoryList: _selectedFoodCategoryList,
                onSelectFoodCategoryChanged: _onSelectFoodCategoryChanged,
                refreshHandler: _refreshHandler,
                editFoodCategoryCallBack: _editFoodCategoryCallBack,
                updateStatusFoodCategoryFunc: _updateStatusFoodCategoryFunc,
                showFoodCategoryDeleteConfirmation: _showFoodCategoryDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editFoodCategoryCallBack(FoodCategory foodCategory) async {
    _nameController.text = foodCategory.name;
    FoodCategory? tempFoodCategory = await showDialog<FoodCategory?>(
      context: context,
      builder: (ctx) {
        return BlocConsumer<EditFoodCategoryBloc, EditFoodCategoryState>(
          bloc: _editFoodCategoryBloc,
          listener: (ct, state) {
            if (state is EditFoodCategorySuccessState) {
              Navigator.of(ctx).pop(state.foodCategory);
            } else if (state is EditFoodCategoryFailureState) {
              _showSnackMessage(state.message, Colors.red.shade700);
              Navigator.of(ctx).pop(null);
            } else if (state is EditFoodCategoryExceptionState) {
              _showSnackMessage(state.message, Colors.red.shade700);
              Navigator.of(ctx).pop(null);
            }
          },
          builder: (context, state) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  actionsPadding: EdgeInsets.all(8.0),
                  title: Text(
                    'Edit Food Category',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  content: Form(
                    key: _editFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
                          decoration: DottedDecoration(
                            shape: Shape.box,
                            color: _nameController.text == '' && validate ? Colors.red : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(containerRadius),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(containerRadius),
                              color: Colors.grey.shade100,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle: ProjectConstant.WorkSansFontRegularTextStyle(
                                  fontSize: 15,
                                  fontColor: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                              style: ProjectConstant.WorkSansFontRegularTextStyle(
                                fontSize: 15,
                                fontColor: Colors.black,
                              ),
                              onSaved: (newValue) {
                                _editData['name'] = newValue!.trim();
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                        if (_nameController.text == '' && validate)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'Required Field !!',
                                  style: ProjectConstant.WorkSansFontRegularTextStyle(
                                    fontSize: 12,
                                    fontColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(null);
                      },
                      child: Text(
                        'Cancel',
                        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 15,
                          fontColor: Colors.red,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          validate = true;
                        });
                        if (_nameController.text.trim() == '') {
                          return;
                        }
                        _editFormKey.currentState!.save();
                        _editData['id'] = foodCategory.id;
                        _editFoodCategoryBloc.add(EditFoodCategoryAddEvent(
                          editFoodCategoryData: _editData,
                        ));
                      },
                      child: Text(
                        'Okay',
                        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 15,
                          fontColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
    if (tempFoodCategory != null) {
      setState(() {
        int index = _foodCategoryList.indexWhere((element) => element.id == foodCategory.id);
        _foodCategoryList.removeWhere((element) => element.id == foodCategory.id);
        _foodCategoryList.insert(index, tempFoodCategory);
      });
    }
    validate = false;
  }

  void _onSelectAllFoodCategory(value) {
    if (value) {
      setState(() {
        _selectedFoodCategoryList.clear();
        _selectedFoodCategoryList.addAll(_foodCategoryList);
      });
    } else {
      setState(() {
        _selectedFoodCategoryList.clear();
      });
    }
  }

  void _onSelectFoodCategoryChanged(bool value, FoodCategory foodCategory) {
    if (value) {
      setState(() {
        _selectedFoodCategoryList.add(foodCategory);
      });
    } else {
      setState(() {
        _selectedFoodCategoryList.removeWhere((foodCat) => foodCat.id == foodCategory.id);
      });
    }
  }

  void _refreshHandler() {
    _getFoodCategoryBloc.add(GetFoodCategoryDataEvent(data: {
      'restaurant_id': restaurant!.emailId,
    }));
  }

  void _showFoodCategoryDeleteConfirmation(FoodCategory foodCategory) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete FoodCategory'),
          content: Text('Do you really want to delete this food category ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getFoodCategoryBloc.add(
                  GetFoodCategoryDeleteEvent(
                    data: {
                      'id': foodCategory.id,
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

  void _showFoodCategoryDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All FoodCategory'),
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
                _getFoodCategoryBloc.add(
                  GetFoodCategoryDeleteAllEvent(
                    idList: _selectedFoodCategoryList.map((item) {
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

  void _updateStatusFoodCategoryFunc(FoodCategory foodCategory, String status) {
    _getFoodCategoryBloc.add(
      GetFoodCategoryUpdateStatusEvent(
        data: {
          'id': foodCategory.id,
          'status': status,
        },
      ),
    );
  }
}

class FoodCategoryDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetFoodCategoryState state;
  final List<FoodCategory> foodCategoryList;
  final List<FoodCategory> selectedFoodCategoryList;
  final Function onSelectFoodCategoryChanged;
  final Function refreshHandler;
  final Function editFoodCategoryCallBack;
  final Function updateStatusFoodCategoryFunc;
  final Function showFoodCategoryDeleteConfirmation;

  FoodCategoryDataTableSource({
    required this.context,
    required this.state,
    required this.foodCategoryList,
    required this.selectedFoodCategoryList,
    required this.onSelectFoodCategoryChanged,
    required this.refreshHandler,
    required this.editFoodCategoryCallBack,
    required this.updateStatusFoodCategoryFunc,
    required this.showFoodCategoryDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final foodCategory = foodCategoryList[index];
    return DataRow(
      selected: selectedFoodCategoryList.any((selectedFoodCategory) => selectedFoodCategory.id == foodCategory.id),
      onSelectChanged: (value) => onSelectFoodCategoryChanged(value, foodCategory),
      cells: [
        DataCell(Text(foodCategory.name,style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                value: foodCategory.status == '1',
                onChanged: state is! GetFoodCategoryLoadingItemState
                    ? (value) {
                        updateStatusFoodCategoryFunc(foodCategory, value ? '1' : '0');
                      }
                    : null,
              ),
              Text(
                foodCategory.status == '1' ? 'Activated' : 'Deactivated',
              ),
            ],
          ),
        ),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(foodCategory.createdAt.toLocal()),style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(foodCategory.updatedAt.toLocal()),style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(
          Row(
            children: [
              TextButton.icon(
                onPressed: state is! GetFoodCategoryLoadingItemState
                    ? () {
                        editFoodCategoryCallBack(foodCategory);
                      }
                    : null,
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                label: Text(
                  'Edit',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetFoodCategoryLoadingItemState
                    ? () {
                        showFoodCategoryDeleteConfirmation(foodCategory);
                      }
                    : null,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: Text(
                  'Delete',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
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
  int get rowCount => foodCategoryList.length;

  @override
  int get selectedRowCount => selectedFoodCategoryList.length;
}
