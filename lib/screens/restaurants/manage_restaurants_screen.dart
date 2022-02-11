import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/register_city/get_register_city/get_register_city_bloc.dart';
import 'package:food_hunt_admin_app/bloc/restaurant/get_restaurants/get_restaurants_bloc.dart';
import 'package:food_hunt_admin_app/models/register_city.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/screens/restaurants/add_restaurant_screen.dart';
import 'package:food_hunt_admin_app/screens/restaurants/view_restaurant_screen.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:food_hunt_admin_app/widgets/image_error_widget.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../responsive_layout.dart';
import 'edit_restaurant_screen.dart';

class ManageRestaurantScreen extends StatefulWidget {
  static const routeName = '/manage-restaurant';

  @override
  _ManageRestaurantScreenState createState() => _ManageRestaurantScreenState();
}

class _ManageRestaurantScreenState extends State<ManageRestaurantScreen> {
  bool _isInit = true;

  final GetRestaurantsBloc _getRestaurantsBloc = GetRestaurantsBloc();
  final GetRegisterCityBloc _getRegisterCityBloc = GetRegisterCityBloc();
  List<RegisterCity> _registerCityList = [];

  List<Restaurant> _restaurantList = [];
  List<Restaurant> _searchRestaurantList = [];
  List<Restaurant> _selectedRestaurantList = [];
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
  bool _isByRestaurantSelected = false;

  var horizontalMargin = 20.0;
  var containerRadius = 30.0;
  var spacingHeight = 16.0;

  bool _isFloatingActionButtonVisible = true;

  String LIMIT_PER_PAGE = '10';

  int _registerCityId = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _searchQueryEditingController = TextEditingController();
      _getRegisterCityBloc.add(GetRegisterCityDataEvent());
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
          ? _selectedRestaurantList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetRegisterCityBloc, GetRegisterCityState>(
        bloc: _getRegisterCityBloc,
        listener: (context, state) {
          if (state is GetRegisterCitySuccessState) {
            _registerCityList = state.registerCityList;
            _getRestaurantsBloc.add(GetRestaurantsDataEvent(data: {
              'register_city_id': _registerCityList.first.id,
            }));
          } else if (state is GetRegisterCityFailedState) {
            _showSnackMessage(state.message, Colors.red.shade600);
          } else if (state is GetRegisterCityExceptionState) {
            _showSnackMessage(state.message, Colors.red.shade600);
          }
        },
        builder: (context, state) {
          return state is GetRegisterCityLoadingState || state is GetRestaurantsInitialState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : BlocConsumer<GetRestaurantsBloc, GetRestaurantsState>(
                  bloc: _getRestaurantsBloc,
                  listener: (context, state) {
                    if (state is GetRestaurantsSuccessState) {
                      _restaurantList = state.restaurantList;
                    } else if (state is GetRestaurantsFailedState) {
                      _showSnackMessage(state.message, Colors.red);
                    } else if (state is GetRestaurantsExceptionState) {
                      _showSnackMessage(state.message, Colors.red);
                    }
                  },
                  builder: (context, state) {
                    return ResponsiveLayout(
                      smallScreen: _buildMobileView(state),
                      mediumScreen: _buildTabletView(state),
                      largeScreen: _buildWebView(screenHeight, screenWidth, state),
                    );
                  },
                );
        },
      ),
      floatingActionButton: Visibility(
        visible: _isFloatingActionButtonVisible,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16, right: 16),
          child: FloatingActionButton(
            onPressed: () async {
              Restaurant? restaurant = await Navigator.of(context).pushNamed(AddRestaurantScreen.routeName) as Restaurant?;
              if (restaurant != null) {
                setState(() {
                  _restaurantList.add(restaurant);
                });
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
        'Manage Restaurants',
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
        'Selected (${_selectedRestaurantList.length})',
        style: ProjectConstant.WorkSansFontBoldTextStyle(
          fontSize: 20,
          fontColor: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedRestaurantList.clear();
              _selectedRestaurantList.addAll(_restaurantList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showRestaurantDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedRestaurantList.clear();
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
                hintText: 'Search Restaurant...',
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
                      _isByRestaurantSelected = !_isByRestaurantSelected;
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
                        if (_isByRestaurantSelected)
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
                          style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
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

  Widget _buildMobileView(GetRestaurantsState state) {
    return state is GetRestaurantsLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildRestaurantSearchList(state)
            : _buildRestaurantList(state);
  }

  Widget _buildTabletView(GetRestaurantsState state) {
    return state is GetRestaurantsLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildRestaurantSearchList(state)
            : _buildRestaurantList(state);
  }

  Widget _buildWebView(double screenHeight, double screenWidth, GetRestaurantsState state) {
    return Scaffold(
      appBar: _selectedRestaurantList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetRestaurantsLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildRestaurantSearchList(state)
              : _buildRestaurantList(state),
    );
  }

  void search() {
    _searchRestaurantList = _restaurantList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
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
      _searchRestaurantList.clear();
      _isSearching = false;
      _isByRestaurantSelected = false;
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

  Widget _buildRestaurantList(GetRestaurantsState state) {
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
              onSelectAll: _onSelectAllRestaurant,
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
              header: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 150,
                    child: _registerCityDropDownWidget(),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              columns: [
                DataColumn(
                  label: Text(
                    'Restaurant Name',
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
                      _restaurantList.sort((user1, user2) => user1.name.compareTo(user2.name));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Restaurant Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Email',
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
                      _restaurantList.sort((user1, user2) => user1.emailId.compareTo(user2.emailId));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Mobile No.',
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
                      _restaurantList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
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
                        _restaurantList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _restaurantList = _restaurantList.reversed.toList();
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
              source: RestaurantDataTableSource(
                context: context,
                state: state,
                restaurantList: _restaurantList,
                selectedRestaurantList: _selectedRestaurantList,
                onSelectRestaurantChanged: _onSelectRestaurantChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
                showRestaurantDeleteConfirmation: _showRestaurantDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantSearchList(GetRestaurantsState state) {
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
              onSelectAll: _onSelectAllRestaurant,
              showFirstLastButtons: true,
              onRowsPerPageChanged: (value) {
                setState(() {
                  LIMIT_PER_PAGE = value.toString();
                });
              },
              header: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 150,
                    child: _registerCityDropDownWidget(),
                  ),
                  SizedBox(width: 10),
                ],
              ),
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
                    'Restaurant Name',
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
                      _restaurantList.sort((user1, user2) => user1.name.compareTo(user2.name));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Restaurant Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Email',
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
                      _restaurantList.sort((user1, user2) => user1.emailId.compareTo(user2.emailId));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Mobile No.',
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
                      _restaurantList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
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
                        _restaurantList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _restaurantList = _restaurantList.reversed.toList();
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
              source: RestaurantDataTableSource(
                context: context,
                state: state,
                restaurantList: _searchRestaurantList,
                selectedRestaurantList: _selectedRestaurantList,
                onSelectRestaurantChanged: _onSelectRestaurantChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
                showRestaurantDeleteConfirmation: _showRestaurantDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showImage(String imageFile) {
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
                    imageUrl: '../$imageFile',
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

  void _onSelectAllRestaurant(value) {
    if (value) {
      setState(() {
        _selectedRestaurantList.clear();
        _selectedRestaurantList.addAll(_restaurantList);
      });
    } else {
      setState(() {
        _selectedRestaurantList.clear();
      });
    }
  }

  void _onSelectRestaurantChanged(bool value, Restaurant restaurant) {
    if (value) {
      setState(() {
        _selectedRestaurantList.add(restaurant);
      });
    } else {
      setState(() {
        _selectedRestaurantList.removeWhere((restau) => restau.id == restaurant.id);
      });
    }
  }

  void _refreshHandler() {
    _getRestaurantsBloc.add(GetRestaurantsDataEvent(data: {
      'register_city_id': _registerCityId,
    }));
  }

  void _showRestaurantDeleteConfirmation(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete Restaurant'),
          content: Text('Do you really want to delete this restaurant ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getRestaurantsBloc.add(
                  GetRestaurantsDeleteEvent(
                    emailId: {
                      'email_id': restaurant.emailId,
                      'old_business_logo_path': restaurant.businessLogo,
                      'old_cover_photo_path': restaurant.coverPhoto,
                      'old_photo_gallery': restaurant.photoGallery,
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

  void _showRestaurantDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All Restaurant'),
          content: Text('Do you really want to delete this restaurants ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getRestaurantsBloc.add(
                  GetRestaurantsDeleteAllEvent(
                    emailIdList: _selectedRestaurantList.map((item) {
                      return {
                        'email_id': item.emailId,
                        'old_business_logo_path': item.businessLogo,
                        'old_cover_photo_path': item.coverPhoto,
                        'old_photo_gallery': item.photoGallery,
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

  Widget _registerCityDropDownWidget() {
    return BlocBuilder<GetRegisterCityBloc, GetRegisterCityState>(
      bloc: _getRegisterCityBloc,
      builder: (context, state) {
        return state is GetRegisterCityLoadingState
            ? TextFormField(
                decoration: InputDecoration(
                  hintText: 'Select City',
                  hintStyle: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 12,
                    fontColor: Colors.black,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
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
              )
            : DropdownButtonFormField<RegisterCity>(
                value: _registerCityList.firstWhereOrNull((element) => element.id == _registerCityId),
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
                style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                  fontSize: 12,
                  fontColor: Colors.black,
                ),
                isExpanded: true,
                items: _registerCityList.map((registerCity) {
                  return DropdownMenuItem<RegisterCity>(
                    value: registerCity,
                    child: Text(
                      registerCity.city,
                      style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 12,
                        fontColor: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                iconEnabledColor: Colors.black,
                onChanged: (value) {
                  _registerCityId = value!.id;
                  _getRestaurantsBloc.add(GetRestaurantsDataEvent(data: {
                    'register_city_id': _registerCityId,
                  }));
                },
              );
      },
    );
  }
}

class RestaurantDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetRestaurantsState state;
  final List<Restaurant> restaurantList;
  final List<Restaurant> selectedRestaurantList;
  final Function onSelectRestaurantChanged;
  final Function refreshHandler;
  final Function showImage;
  final Function showRestaurantDeleteConfirmation;

  RestaurantDataTableSource({
    required this.context,
    required this.state,
    required this.restaurantList,
    required this.selectedRestaurantList,
    required this.onSelectRestaurantChanged,
    required this.refreshHandler,
    required this.showImage,
    required this.showRestaurantDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final restaurant = restaurantList[index];
    return DataRow(
      selected: selectedRestaurantList.any((selectedRestaurant) => selectedRestaurant.id == restaurant.id),
      onSelectChanged: (value) => onSelectRestaurantChanged(value, restaurant),
      cells: [
        DataCell(
          Text(
            restaurant.name,
            style: ProjectConstant.WorkSansFontRegularTextStyle(
              fontSize: 15,
              fontColor: Colors.black,
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(ViewRestaurantScreen.routeName, arguments: restaurant).then((value) {
              refreshHandler();
            });
          },
        ),
        DataCell(Text(
          restaurant.restaurantType,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          restaurant.emailId,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          restaurant.mobileNo,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        // DataCell(TextButton(
        //   onPressed: state is! GetRestaurantsLoadingItemState
        //       ? () {
        //           showImage(restaurant.businessLogo);
        //         }
        //       : null,
        //   child: Text(
        //     'View Image',
        //     style: TextStyle(decoration: TextDecoration.underline),
        //   ),
        // )),
        DataCell(Text(
          DateFormat('dd MMM yyyy hh:mm a').format(restaurant.createdAt.toLocal()),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          DateFormat('dd MMM yyyy hh:mm a').format(restaurant.updatedAt.toLocal()),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(
          Row(
            children: [
              TextButton.icon(
                onPressed: state is! GetRestaurantsLoadingItemState
                    ? () {
                        Navigator.of(context).pushNamed(ViewRestaurantScreen.routeName, arguments: restaurant).then((value) {
                          refreshHandler();
                        });
                      }
                    : null,
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
                label: Text(
                  'View',
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetRestaurantsLoadingItemState
                    ? () {
                        Navigator.of(context).pushNamed(EditRestaurantScreen.routeName, arguments: restaurant).then((value) {
                          refreshHandler();
                        });
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
                onPressed: state is! GetRestaurantsLoadingItemState
                    ? () {
                        showRestaurantDeleteConfirmation(restaurant);
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
  int get rowCount => restaurantList.length;

  @override
  int get selectedRowCount => selectedRestaurantList.length;
}
