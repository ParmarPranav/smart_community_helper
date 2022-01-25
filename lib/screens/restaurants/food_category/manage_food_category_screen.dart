import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/food_category/get_food_category/get_food_category_bloc.dart';
import 'package:food_hunt_admin_app/models/food_category.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:food_hunt_admin_app/widgets/image_error_widget.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';
import 'package:intl/intl.dart';
import '../../responsive_layout.dart';

class ManageFoodCategoryScreen extends StatefulWidget {
  static const routeName = '/manage-food-category';

  @override
  _ManageFoodCategoryScreenState createState() => _ManageFoodCategoryScreenState();
}

class _ManageFoodCategoryScreenState extends State<ManageFoodCategoryScreen> {
  bool _isInit = true;

  final GetFoodCategoryBloc _getFoodCategorysBloc = GetFoodCategoryBloc();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _searchQueryEditingController = TextEditingController();
      _getFoodCategorysBloc.add(GetFoodCategoryDataEvent());
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
        bloc: _getFoodCategorysBloc,
        listener: (context, state) {
          if (state is GetFoodCategorySuccessState) {
            _foodCategoryList = state.foodCategoryList;
          } else if (state is GetFoodCategoryFailedState) {
            _showSnackMessage(state.message);
          } else if (state is GetFoodCategoryExceptionState) {
            _showSnackMessage(state.message);
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
              FoodCategory? foodCategory = await Navigator.of(context).pushNamed(AddFoodCategoryScreen.routeName) as FoodCategory?;
              if (foodCategory != null) {
                setState(() {
                  _foodCategoryList.add(foodCategory);
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
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back),
      ),
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

  void _showSnackMessage(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
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
                  label: Text('FoodCategory Name'),
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
                  label: Text('FoodCategory Type'),
                ),
                DataColumn(
                  label: Text('Email'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodCategoryList.sort((user1, user2) => user1.emailId.compareTo(user2.emailId));
                      if (!ascending) {
                        _foodCategoryList = _foodCategoryList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Mobile No.'),
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
                      _foodCategoryList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _foodCategoryList = _foodCategoryList.reversed.toList();
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
                        _foodCategoryList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _foodCategoryList = _foodCategoryList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions'),
                ),
              ],
              source: FoodCategoryDataTableSource(
                context: context,
                state: state,
                foodCategoryList: _foodCategoryList,
                selectedFoodCategoryList: _selectedFoodCategoryList,
                onSelectFoodCategoryChanged: _onSelectFoodCategoryChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
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
                  label: Text('FoodCategory Name'),
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
                  label: Text('FoodCategory Type'),
                ),
                DataColumn(
                  label: Text('Email'),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortNameAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortNameAsc;
                      }
                      _foodCategoryList.sort((user1, user2) => user1.emailId.compareTo(user2.emailId));
                      if (!ascending) {
                        _foodCategoryList = _foodCategoryList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Mobile No.'),
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
                      _foodCategoryList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _foodCategoryList = _foodCategoryList.reversed.toList();
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
                        _foodCategoryList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _foodCategoryList = _foodCategoryList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions'),
                ),
              ],
              source: FoodCategoryDataTableSource(
                context: context,
                state: state,
                foodCategoryList: _searchFoodCategoryList,
                selectedFoodCategoryList: _selectedFoodCategoryList,
                onSelectFoodCategoryChanged: _onSelectFoodCategoryChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
                showFoodCategoryDeleteConfirmation: _showFoodCategoryDeleteConfirmation,
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
        _selectedFoodCategoryList.removeWhere((restau) => restau.id == foodCategory.id);
      });
    }
  }

  void _refreshHandler() {
    _getFoodCategorysBloc.add(GetFoodCategoryDataEvent());
  }

  void _showFoodCategoryDeleteConfirmation(FoodCategory foodCategory) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete FoodCategory'),
          content: Text('Do you really want to delete this foodCategory ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getFoodCategorysBloc.add(
                  GetFoodCategoryDeleteEvent(
                    emailId: {
                      'email_id': foodCategory.emailId,
                      'old_business_logo_path': foodCategory.businessLogo,
                      'old_cover_photo_path': foodCategory.coverPhoto,
                      'old_photo_gallery': foodCategory.photoGallery,
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
          content: Text('Do you really want to delete this foodCategorys ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getFoodCategorysBloc.add(
                  GetFoodCategoryDeleteAllEvent(
                    emailIdList: _selectedFoodCategoryList.map((item) {
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
}

class FoodCategoryDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetFoodCategoryState state;
  final List<FoodCategory> foodCategoryList;
  final List<FoodCategory> selectedFoodCategoryList;
  final Function onSelectFoodCategoryChanged;
  final Function refreshHandler;
  final Function showImage;
  final Function showFoodCategoryDeleteConfirmation;

  FoodCategoryDataTableSource({
    required this.context,
    required this.state,
    required this.foodCategoryList,
    required this.selectedFoodCategoryList,
    required this.onSelectFoodCategoryChanged,
    required this.refreshHandler,
    required this.showImage,
    required this.showFoodCategoryDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final foodCategory = foodCategoryList[index];
    return DataRow(
      selected: selectedFoodCategoryList.any((selectedFoodCategory) => selectedFoodCategory.id == foodCategory.id),
      onSelectChanged: (value) => onSelectFoodCategoryChanged(value, foodCategory),
      cells: [
        DataCell(Text(foodCategory.name)),
        DataCell(Text(foodCategory.foodCategoryType)),
        DataCell(Text(foodCategory.emailId)),
        DataCell(Text(foodCategory.mobileNo)),
        // DataCell(TextButton(
        //   onPressed: state is! GetFoodCategorysLoadingItemState
        //       ? () {
        //           showImage(foodCategory.businessLogo);
        //         }
        //       : null,
        //   child: Text(
        //     'View Image',
        //     style: TextStyle(decoration: TextDecoration.underline),
        //   ),
        // )),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(foodCategory.createdAt.toLocal()))),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(foodCategory.updatedAt.toLocal()))),
        DataCell(
          Row(
            children: [
              TextButton.icon(
                onPressed: state is! GetFoodCategoryLoadingItemState
                    ? () {
                        // Navigator.of(context).pushNamed(ViewFoodCategoryScreen.routeName, arguments: foodCategory).then((value) {
                        //   refreshHandler();
                        // });
                      }
                    : null,
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.green,
                ),
                label: Text(
                  'View',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetFoodCategoryLoadingItemState
                    ? () {
                        // Navigator.of(context).pushNamed(EditFoodCategoryScreen.routeName, arguments: foodCategory).then((value) {
                        //   refreshHandler();
                        // });
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
  int get selectedRowCount => selectedFoodCategoryList.length;
}
