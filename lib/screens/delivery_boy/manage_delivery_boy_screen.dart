import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/delivery_boy/get_delivery_boy/get_delivery_boy_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_boy.dart';
import 'package:food_hunt_admin_app/screens/delivery_boy/view_delivery_boy_screen.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:food_hunt_admin_app/widgets/image_error_widget.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';
import 'package:intl/intl.dart';

import '../responsive_layout.dart';
import 'edit_delivery_boy_screen.dart';

class ManageDeliveryBoyScreen extends StatefulWidget {
  static const routeName = '/manage-delivery-boy';

  @override
  _ManageDeliveryBoyScreenState createState() => _ManageDeliveryBoyScreenState();
}

class _ManageDeliveryBoyScreenState extends State<ManageDeliveryBoyScreen> {
  bool _isInit = true;

  final GetDeliveryBoyBloc _getDeliveryBoyBloc = GetDeliveryBoyBloc();
  List<DeliveryBoy> _restaurantList = [];
  List<DeliveryBoy> _searchDeliveryBoyList = [];
  final List<DeliveryBoy> _selectedDeliveryBoyList = [];
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
  bool _isByDeliveryBoySelected = false;

  bool _isFloatingActionButtonVisible = true;

  String LIMIT_PER_PAGE = '10';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _searchQueryEditingController = TextEditingController();
      _getDeliveryBoyBloc.add(GetDeliveryBoyDataEvent());
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
          ? _selectedDeliveryBoyList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetDeliveryBoyBloc, GetDeliveryBoyState>(
        bloc: _getDeliveryBoyBloc,
        listener: (context, state) {
          if (state is GetDeliveryBoySuccessState) {
            _restaurantList = state.deliveryBoyList;
          } else if (state is GetDeliveryBoyFailedState) {
            _showSnackMessage(state.message);
          } else if (state is GetDeliveryBoyExceptionState) {
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
    );
  }

  AppBar _defaultAppBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 70,
      elevation: 3,
      title: Text(
        'Manage DeliveryBoy',
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
        'Selected (${_selectedDeliveryBoyList.length})',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDeliveryBoyList.clear();
              _selectedDeliveryBoyList.addAll(_restaurantList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showDeliveryBoyDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedDeliveryBoyList.clear();
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
                hintText: 'Search DeliveryBoy...',
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
                      _isByDeliveryBoySelected = !_isByDeliveryBoySelected;
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
                        if (_isByDeliveryBoySelected)
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

  Widget _buildMobileView(GetDeliveryBoyState state) {
    return state is GetDeliveryBoyLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildDeliveryBoySearchList(state)
            : _buildDeliveryBoyList(state);
  }

  Widget _buildTabletView(GetDeliveryBoyState state) {
    return state is GetDeliveryBoyLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildDeliveryBoySearchList(state)
            : _buildDeliveryBoyList(state);
  }

  Widget _buildWebView(double screenHeight, double screenWidth, GetDeliveryBoyState state) {
    return Scaffold(
      appBar: _selectedDeliveryBoyList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetDeliveryBoyLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildDeliveryBoySearchList(state)
              : _buildDeliveryBoyList(state),
    );
  }

  void search() {
    _searchDeliveryBoyList = _restaurantList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
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
      _searchDeliveryBoyList.clear();
      _isSearching = false;
      _isByDeliveryBoySelected = false;
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

  Widget _buildDeliveryBoyList(GetDeliveryBoyState state) {
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
              onSelectAll: _onSelectAllDeliveryBoy,
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
                  label: Text('DeliveryBoy Name'),
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
                  label: Text('DeliveryBoy Type'),
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
                      _restaurantList.sort((user1, user2) => user1.emailId.compareTo(user2.emailId));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
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
                      _restaurantList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
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
                        _restaurantList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _restaurantList = _restaurantList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions'),
                ),
              ],
              source: DeliveryBoyDataTableSource(
                context: context,
                state: state,
                restaurantList: _restaurantList,
                selectedDeliveryBoyList: _selectedDeliveryBoyList,
                onSelectDeliveryBoyChanged: _onSelectDeliveryBoyChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
                showDeliveryBoyDeleteConfirmation: _showDeliveryBoyDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryBoySearchList(GetDeliveryBoyState state) {
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
              onSelectAll: _onSelectAllDeliveryBoy,
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
                  label: Text('DeliveryBoy Name'),
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
                  label: Text('DeliveryBoy Type'),
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
                      _restaurantList.sort((user1, user2) => user1.emailId.compareTo(user2.emailId));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
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
                      _restaurantList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _restaurantList = _restaurantList.reversed.toList();
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
                        _restaurantList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _restaurantList = _restaurantList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text('Actions'),
                ),
              ],
              source: DeliveryBoyDataTableSource(
                context: context,
                state: state,
                restaurantList: _searchDeliveryBoyList,
                selectedDeliveryBoyList: _selectedDeliveryBoyList,
                onSelectDeliveryBoyChanged: _onSelectDeliveryBoyChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
                showDeliveryBoyDeleteConfirmation: _showDeliveryBoyDeleteConfirmation,
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

  void _onSelectAllDeliveryBoy(value) {
    if (value) {
      setState(() {
        _selectedDeliveryBoyList.clear();
        _selectedDeliveryBoyList.addAll(_restaurantList);
      });
    } else {
      setState(() {
        _selectedDeliveryBoyList.clear();
      });
    }
  }

  void _onSelectDeliveryBoyChanged(bool value, DeliveryBoy restaurant) {
    if (value) {
      setState(() {
        _selectedDeliveryBoyList.add(restaurant);
      });
    } else {
      setState(() {
        _selectedDeliveryBoyList.removeWhere((restau) => restau.id == restaurant.id);
      });
    }
  }

  void _refreshHandler() {
    _getDeliveryBoyBloc.add(GetDeliveryBoyDataEvent());
  }

  void _showDeliveryBoyDeleteConfirmation(DeliveryBoy restaurant) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete DeliveryBoy'),
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
                _getDeliveryBoyBloc.add(
                  GetDeliveryBoyDeleteEvent(
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

  void _showDeliveryBoyDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All DeliveryBoy'),
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
                _getDeliveryBoyBloc.add(
                  GetDeliveryBoyDeleteAllEvent(
                    emailIdList: _selectedDeliveryBoyList.map((item) {
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

class DeliveryBoyDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetDeliveryBoyState state;
  final List<DeliveryBoy> restaurantList;
  final List<DeliveryBoy> selectedDeliveryBoyList;
  final Function onSelectDeliveryBoyChanged;
  final Function refreshHandler;
  final Function showImage;
  final Function showDeliveryBoyDeleteConfirmation;

  DeliveryBoyDataTableSource({
    required this.context,
    required this.state,
    required this.restaurantList,
    required this.selectedDeliveryBoyList,
    required this.onSelectDeliveryBoyChanged,
    required this.refreshHandler,
    required this.showImage,
    required this.showDeliveryBoyDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final restaurant = restaurantList[index];
    return DataRow(
      selected: selectedDeliveryBoyList.any((selectedDeliveryBoy) => selectedDeliveryBoy.id == restaurant.id),
      onSelectChanged: (value) => onSelectDeliveryBoyChanged(value, restaurant),
      cells: [
        DataCell(Text(restaurant.name)),
        DataCell(Text(restaurant.restaurantType)),
        DataCell(Text(restaurant.emailId)),
        DataCell(Text(restaurant.mobileNo)),
        // DataCell(TextButton(
        //   onPressed: state is! GetDeliveryBoyLoadingItemState
        //       ? () {
        //           showImage(restaurant.businessLogo);
        //         }
        //       : null,
        //   child: Text(
        //     'View Image',
        //     style: TextStyle(decoration: TextDecoration.underline),
        //   ),
        // )),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(restaurant.createdAt.toLocal()))),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(restaurant.updatedAt.toLocal()))),
        DataCell(
          Row(
            children: [
              TextButton.icon(
                onPressed: state is! GetDeliveryBoyLoadingItemState
                    ? () {
                        Navigator.of(context).pushNamed(ViewDeliveryBoyScreen.routeName, arguments: restaurant).then((value) {
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
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetDeliveryBoyLoadingItemState
                    ? () {
                        Navigator.of(context).pushNamed(EditDeliveryBoyScreen.routeName, arguments: restaurant).then((value) {
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
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetDeliveryBoyLoadingItemState
                    ? () {
                        showDeliveryBoyDeleteConfirmation(restaurant);
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
  int get rowCount => restaurantList.length;

  @override
  int get selectedRowCount => selectedDeliveryBoyList.length;
}
