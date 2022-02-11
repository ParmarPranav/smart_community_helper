import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/liquor_category/add_liquor_category/add_liquor_category_bloc.dart';
import 'package:food_hunt_admin_app/bloc/liquor_category/edit_liquor_category/edit_liquor_category_bloc.dart';
import 'package:food_hunt_admin_app/bloc/liquor_category/get_liquor_category/get_liquor_category_bloc.dart';
import 'package:food_hunt_admin_app/models/liquor_category.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:intl/intl.dart';

import '../../responsive_layout.dart';

class ManageLiquorCategoryScreen extends StatefulWidget {
  static const routeName = '/manage-liquor-category';

  @override
  _ManageLiquorCategoryScreenState createState() => _ManageLiquorCategoryScreenState();
}

class _ManageLiquorCategoryScreenState extends State<ManageLiquorCategoryScreen> {
  bool _isInit = true;
  final _addFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final AddLiquorCategoryBloc _addLiquorCategoryBloc = AddLiquorCategoryBloc();
  final EditLiquorCategoryBloc _editLiquorCategoryBloc = EditLiquorCategoryBloc();
  final GetLiquorCategoryBloc _getLiquorCategoryBloc = GetLiquorCategoryBloc();
  List<LiquorCategory> _foodCategoryList = [];
  List<LiquorCategory> _searchLiquorCategoryList = [];
  final List<LiquorCategory> _selectedLiquorCategoryList = [];
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
  bool _isByLiquorCategorySelected = false;

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
      _getLiquorCategoryBloc.add(GetLiquorCategoryDataEvent(data: {
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
          ? _selectedLiquorCategoryList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetLiquorCategoryBloc, GetLiquorCategoryState>(
        bloc: _getLiquorCategoryBloc,
        listener: (context, state) {
          if (state is GetLiquorCategorySuccessState) {
            _foodCategoryList = state.liquorCategoryList;
          } else if (state is GetLiquorCategoryFailedState) {
            _showSnackMessage(state.message, Colors.red.shade700);
          } else if (state is GetLiquorCategoryExceptionState) {
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
              LiquorCategory? foodCategory = await showDialog<LiquorCategory?>(
                context: context,
                builder: (ctx) {
                  return BlocConsumer<AddLiquorCategoryBloc, AddLiquorCategoryState>(
                    bloc: _addLiquorCategoryBloc,
                    listener: (ct, state) {
                      if (state is AddLiquorCategorySuccessState) {
                        Navigator.of(ctx).pop(state.foodCategory);
                      } else if (state is AddLiquorCategoryFailureState) {
                        _showSnackMessage(state.message, Colors.red.shade700);
                        Navigator.of(ctx).pop(null);
                      } else if (state is AddLiquorCategoryExceptionState) {
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
                              'Add Liquor Category',
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
                                  _addLiquorCategoryBloc.add(AddLiquorCategoryAddEvent(
                                    addLiquorCategoryData: _addData,
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
        'Manage Liquor Category',
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
        'Selected (${_selectedLiquorCategoryList.length})',
        style: ProjectConstant.WorkSansFontBoldTextStyle(
          fontSize: 20,
          fontColor: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedLiquorCategoryList.clear();
              _selectedLiquorCategoryList.addAll(_foodCategoryList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showLiquorCategoryDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedLiquorCategoryList.clear();
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
                hintText: 'Search Liquor Category...',
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
                      _isByLiquorCategorySelected = !_isByLiquorCategorySelected;
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
                        if (_isByLiquorCategorySelected)
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

  Widget _buildMobileView(GetLiquorCategoryState state) {
    return state is GetLiquorCategoryLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildLiquorCategorySearchList(state)
            : _buildLiquorCategoryList(state);
  }

  Widget _buildTabletView(GetLiquorCategoryState state) {
    return state is GetLiquorCategoryLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildLiquorCategorySearchList(state)
            : _buildLiquorCategoryList(state);
  }

  Widget _buildWebView(double screenHeight, double screenWidth, GetLiquorCategoryState state) {
    return Scaffold(
      appBar: _selectedLiquorCategoryList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetLiquorCategoryLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildLiquorCategorySearchList(state)
              : _buildLiquorCategoryList(state),
    );
  }

  void search() {
    _searchLiquorCategoryList = _foodCategoryList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
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
      _searchLiquorCategoryList.clear();
      _isSearching = false;
      _isByLiquorCategorySelected = false;
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

  Widget _buildLiquorCategoryList(GetLiquorCategoryState state) {
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
              onSelectAll: _onSelectAllLiquorCategory,
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
              source: LiquorCategoryDataTableSource(
                context: context,
                state: state,
                foodCategoryList: _foodCategoryList,
                selectedLiquorCategoryList: _selectedLiquorCategoryList,
                onSelectLiquorCategoryChanged: _onSelectLiquorCategoryChanged,
                refreshHandler: _refreshHandler,
                editLiquorCategoryCallBack: _editLiquorCategoryCallBack,
                updateStatusLiquorCategoryFunc: _updateStatusLiquorCategoryFunc,
                showLiquorCategoryDeleteConfirmation: _showLiquorCategoryDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiquorCategorySearchList(GetLiquorCategoryState state) {
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
              onSelectAll: _onSelectAllLiquorCategory,
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
              source: LiquorCategoryDataTableSource(
                context: context,
                state: state,
                foodCategoryList: _searchLiquorCategoryList,
                selectedLiquorCategoryList: _selectedLiquorCategoryList,
                onSelectLiquorCategoryChanged: _onSelectLiquorCategoryChanged,
                refreshHandler: _refreshHandler,
                editLiquorCategoryCallBack: _editLiquorCategoryCallBack,
                updateStatusLiquorCategoryFunc: _updateStatusLiquorCategoryFunc,
                showLiquorCategoryDeleteConfirmation: _showLiquorCategoryDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editLiquorCategoryCallBack(LiquorCategory foodCategory) async {
    _nameController.text = foodCategory.name;
    LiquorCategory? tempLiquorCategory = await showDialog<LiquorCategory?>(
      context: context,
      builder: (ctx) {
        return BlocConsumer<EditLiquorCategoryBloc, EditLiquorCategoryState>(
          bloc: _editLiquorCategoryBloc,
          listener: (ct, state) {
            if (state is EditLiquorCategorySuccessState) {
              Navigator.of(ctx).pop(state.liquorCategory);
            } else if (state is EditLiquorCategoryFailureState) {
              _showSnackMessage(state.message, Colors.red.shade700);
              Navigator.of(ctx).pop(null);
            } else if (state is EditLiquorCategoryExceptionState) {
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
                    'Edit Liquor Category',
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
                        _editLiquorCategoryBloc.add(EditLiquorCategoryAddEvent(
                          editLiquorCategoryData: _editData,
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
    if (tempLiquorCategory != null) {
      setState(() {
        int index = _foodCategoryList.indexWhere((element) => element.id == foodCategory.id);
        _foodCategoryList.removeWhere((element) => element.id == foodCategory.id);
        _foodCategoryList.insert(index, tempLiquorCategory);
      });
    }
    validate = false;
  }

  void _onSelectAllLiquorCategory(value) {
    if (value) {
      setState(() {
        _selectedLiquorCategoryList.clear();
        _selectedLiquorCategoryList.addAll(_foodCategoryList);
      });
    } else {
      setState(() {
        _selectedLiquorCategoryList.clear();
      });
    }
  }

  void _onSelectLiquorCategoryChanged(bool value, LiquorCategory foodCategory) {
    if (value) {
      setState(() {
        _selectedLiquorCategoryList.add(foodCategory);
      });
    } else {
      setState(() {
        _selectedLiquorCategoryList.removeWhere((foodCat) => foodCat.id == foodCategory.id);
      });
    }
  }

  void _refreshHandler() {
    _getLiquorCategoryBloc.add(GetLiquorCategoryDataEvent(data: {
      'restaurant_id': restaurant!.emailId,
    }));
  }

  void _showLiquorCategoryDeleteConfirmation(LiquorCategory foodCategory) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete LiquorCategory'),
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
                _getLiquorCategoryBloc.add(
                  GetLiquorCategoryDeleteEvent(
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

  void _showLiquorCategoryDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All LiquorCategory'),
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
                _getLiquorCategoryBloc.add(
                  GetLiquorCategoryDeleteAllEvent(
                    idList: _selectedLiquorCategoryList.map((item) {
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

  void _updateStatusLiquorCategoryFunc(LiquorCategory foodCategory, String status) {
    _getLiquorCategoryBloc.add(
      GetLiquorCategoryUpdateStatusEvent(
        data: {
          'id': foodCategory.id,
          'status': status,
        },
      ),
    );
  }
}

class LiquorCategoryDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetLiquorCategoryState state;
  final List<LiquorCategory> foodCategoryList;
  final List<LiquorCategory> selectedLiquorCategoryList;
  final Function onSelectLiquorCategoryChanged;
  final Function refreshHandler;
  final Function editLiquorCategoryCallBack;
  final Function updateStatusLiquorCategoryFunc;
  final Function showLiquorCategoryDeleteConfirmation;

  LiquorCategoryDataTableSource({
    required this.context,
    required this.state,
    required this.foodCategoryList,
    required this.selectedLiquorCategoryList,
    required this.onSelectLiquorCategoryChanged,
    required this.refreshHandler,
    required this.editLiquorCategoryCallBack,
    required this.updateStatusLiquorCategoryFunc,
    required this.showLiquorCategoryDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final foodCategory = foodCategoryList[index];
    return DataRow(
      selected: selectedLiquorCategoryList.any((selectedLiquorCategory) => selectedLiquorCategory.id == foodCategory.id),
      onSelectChanged: (value) => onSelectLiquorCategoryChanged(value, foodCategory),
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
                onChanged: state is! GetLiquorCategoryLoadingItemState
                    ? (value) {
                        updateStatusLiquorCategoryFunc(foodCategory, value ? '1' : '0');
                      }
                    : null,
              ),
              Text(
                foodCategory.status == '1' ? 'Activated' : 'Deactivated',
              ),
            ],
          ),
        ),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(foodCategory.createdAt.toLocal()))),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(foodCategory.updatedAt.toLocal()))),
        DataCell(
          Row(
            children: [
              TextButton.icon(
                onPressed: state is! GetLiquorCategoryLoadingItemState
                    ? () {
                        editLiquorCategoryCallBack(foodCategory);
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
                onPressed: state is! GetLiquorCategoryLoadingItemState
                    ? () {
                        showLiquorCategoryDeleteConfirmation(foodCategory);
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
  int get rowCount => foodCategoryList.length;

  @override
  int get selectedRowCount => selectedLiquorCategoryList.length;
}
