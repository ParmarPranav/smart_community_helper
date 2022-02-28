import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/models/restaurant.dart';
import 'package:food_hunt_admin_app/screens/order/view_order_screen.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:food_hunt_admin_app/widgets/image_error_widget.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';
import 'package:intl/intl.dart';

import '../../bloc/order/get_order/get_order_bloc.dart';
import '../../models/order.dart';
import '../responsive_layout.dart';

class ManageOrderScreen extends StatefulWidget {
  static const routeName = '/manage-order';

  @override
  _ManageOrderScreenState createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen> {
  bool _isInit = true;
  bool _isFilters = false;
  Restaurant? restaurant;
  final GetOrderBloc _getOrderBloc = GetOrderBloc();
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
  List<Order> _orderList = [];
  List<Order> _searchOrderList = [];
  List<Order> _filterOrderList = [];
  final List<Order> _selectedOrderList = [];
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
  bool _isByOrderSelected = false;

  bool _isFloatingActionButtonVisible = true;

  String LIMIT_PER_PAGE = '10';

  int _registerCityId = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
      _searchQueryEditingController = TextEditingController();
      _getOrderBloc.add(GetOrderDataEvent(data: {'restaurant_id': restaurant!.emailId}));

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
          ? _selectedOrderList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetOrderBloc, GetOrderState>(
        bloc: _getOrderBloc,
        listener: (context, state) {
          if (state is GetOrderSuccessState) {
            _orderList = state.orderList;
          } else if (state is GetOrderFailedState) {
            _showSnackMessage(state.message, Colors.red);
          } else if (state is GetOrderExceptionState) {
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
      ),
    );
  }

  AppBar _defaultAppBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 70,
      elevation: 3,
      title: Text(
        'Manage Order',
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
        'Selected (${_selectedOrderList.length})',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedOrderList.clear();
              _selectedOrderList.addAll(_orderList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showOrderDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedOrderList.clear();
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
                hintText: 'Search Order...',
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
                      _isByOrderSelected = !_isByOrderSelected;
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
                        if (_isByOrderSelected)
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

  Widget _buildMobileView(GetOrderState state) {
    return state is GetOrderLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildOrderSearchList(state)
            : _isFilters
        ? _buildOrderFilterList(state)
        : _buildOrderList(state);
  }

  Widget _buildTabletView(GetOrderState state) {
    return state is GetOrderLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildOrderSearchList(state)
            : _isFilters
        ? _buildOrderFilterList(state)
        : _buildOrderList(state);
  }

  Widget _buildWebView(double screenHeight, double screenWidth, GetOrderState state) {
    return Scaffold(
      appBar: _selectedOrderList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetOrderLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildOrderSearchList(state)
              : _isFilters
          ? _buildOrderFilterList(state)
          : _buildOrderList(state),
    );
  }

  void search() {
    _searchOrderList = _orderList.where((item) => item.orderNo.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
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
      _searchOrderList.clear();
      _isSearching = false;
      _isByOrderSelected = false;
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

  Widget _buildOrderList(GetOrderState state) {
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
              onSelectAll: _onSelectAllOrder,
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
                    'Order No',
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
                      _orderList.sort((user1, user2) => user1.orderNo.compareTo(user2.orderNo));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Order Status',
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
                      _orderList.sort((user1, user2) => user1.orderStatus.compareTo(user2.orderStatus));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Payment Status',
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
                      _orderList.sort((user1, user2) => user1.paymentStatus.compareTo(user2.paymentStatus));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Total Amount',
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
                      _orderList.sort((user1, user2) => user1.grandTotal.compareTo(user2.grandTotal));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
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
                      _orderList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
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
                        _orderList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _orderList = _orderList.reversed.toList();
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
              source: OrderDataTableSource(
                context: context,
                state: state,
                orderList: _orderList,
                selectedOrderList: _selectedOrderList,
                onSelectOrderChanged: _onSelectOrderChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
                showOrderDeleteConfirmation: _showOrderDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSearchList(GetOrderState state) {
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
              onSelectAll: _onSelectAllOrder,
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
                    'Order No',
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
                      _orderList.sort((user1, user2) => user1.orderNo.compareTo(user2.orderNo));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Order Status',
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
                      _orderList.sort((user1, user2) => user1.orderStatus.compareTo(user2.orderStatus));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Payment Status',
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
                      _orderList.sort((user1, user2) => user1.paymentStatus.compareTo(user2.paymentStatus));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Total Amount',
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
                      _orderList.sort((user1, user2) => user1.grandTotal.compareTo(user2.grandTotal));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
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
                      _orderList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
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
                        _orderList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _orderList = _orderList.reversed.toList();
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
              source: OrderDataTableSource(
                context: context,
                state: state,
                orderList: _searchOrderList,
                selectedOrderList: _selectedOrderList,
                onSelectOrderChanged: _onSelectOrderChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
                showOrderDeleteConfirmation: _showOrderDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderFilterList(GetOrderState state) {
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
              onSelectAll: _onSelectAllOrder,
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
                    'Order No',
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
                      _orderList.sort((user1, user2) => user1.orderNo.compareTo(user2.orderNo));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Order Status',
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
                      _orderList.sort((user1, user2) => user1.orderStatus.compareTo(user2.orderStatus));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Payment Status',
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
                      _orderList.sort((user1, user2) => user1.paymentStatus.compareTo(user2.paymentStatus));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Total Amount',
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
                      _orderList.sort((user1, user2) => user1.grandTotal.compareTo(user2.grandTotal));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
                      }
                    });
                  },
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
                      _orderList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _orderList = _orderList.reversed.toList();
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
                        _orderList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _orderList = _orderList.reversed.toList();
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
              source: OrderDataTableSource(
                context: context,
                state: state,
                orderList: _filterOrderList,
                selectedOrderList: _selectedOrderList,
                onSelectOrderChanged: _onSelectOrderChanged,
                refreshHandler: _refreshHandler,
                showImage: showImage,
                showOrderDeleteConfirmation: _showOrderDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _filtersFunc(String type) {
    if (type == 'all') {
      setState(() {
        _isFilters = false;
        _filterOrderList.clear();
      });
    } else if (type == 'today') {
      setState(() {
        _isFilters = true;

        _filterOrderList = _orderList.where((element) => element.updatedAt.toLocal().difference(DateTime.now()).inDays == 0).toList();
      });
    } else if (type == 'yesterday') {
      setState(() {
        _isFilters = true;
        _filterOrderList = _orderList.where((element) => element.updatedAt.toLocal().difference(DateTime.now()).inDays == -1).toList();
      });
    } else if (type == '7days') {
      setState(() {
        _isFilters = true;
        _filterOrderList = _orderList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 7))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '30days') {
      setState(() {
        _isFilters = true;
        _filterOrderList = _orderList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 30))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '90days') {
      setState(() {
        _isFilters = true;
        _filterOrderList = _orderList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 90))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '180days') {
      setState(() {
        _isFilters = true;
        _filterOrderList = _orderList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 180))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    } else if (type == '365days') {
      setState(() {
        _isFilters = true;
        _filterOrderList = _orderList
            .where((element) =>
                element.updatedAt.toLocal().compareTo(DateTime.now().subtract(Duration(days: 365))) > 0 &&
                (element.updatedAt.toLocal().compareTo(DateTime.now()) < 0 || element.updatedAt.toLocal().compareTo(DateTime.now()) == 0))
            .toList();
      });
    }
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

  void _onSelectAllOrder(value) {
    if (value) {
      setState(() {
        _selectedOrderList.clear();
        _selectedOrderList.addAll(_orderList);
      });
    } else {
      setState(() {
        _selectedOrderList.clear();
      });
    }
  }

  void _onSelectOrderChanged(bool value, Order restaurant) {
    if (value) {
      setState(() {
        _selectedOrderList.add(restaurant);
      });
    } else {
      setState(() {
        _selectedOrderList.removeWhere((restau) => restau.id == restaurant.id);
      });
    }
  }

  void _refreshHandler() {
    _getOrderBloc.add(GetOrderDataEvent(data: {'restaurant_id': restaurant!.emailId}));

  }

  void _showOrderDeleteConfirmation(Order order) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete Order'),
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
                _getOrderBloc.add(
                  GetOrderDeleteEvent(
                    emailId: {
                      'id': order.id,
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

  void _showOrderDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All Order'),
          content: Text('Do you really want to delete this delivery boy ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getOrderBloc.add(
                  GetOrderDeleteAllEvent(
                    emailIdList: _selectedOrderList.map((item) {
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
}

class OrderDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetOrderState state;
  final List<Order> orderList;
  final List<Order> selectedOrderList;
  final Function onSelectOrderChanged;
  final Function refreshHandler;
  final Function showImage;
  final Function showOrderDeleteConfirmation;

  OrderDataTableSource({
    required this.context,
    required this.state,
    required this.orderList,
    required this.selectedOrderList,
    required this.onSelectOrderChanged,
    required this.refreshHandler,
    required this.showImage,
    required this.showOrderDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final order = orderList[index];
    return DataRow(
      selected: selectedOrderList.any((selectedOrder) => selectedOrder.id == order.id),
      onSelectChanged: (value) => onSelectOrderChanged(value, order),
      cells: [
        DataCell(Text(
          order.orderNo,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          order.orderStatus,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          order.paymentStatus,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          order.grandTotal.toString(),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        // DataCell(TextButton(
        //   onPressed: state is! GetOrderLoadingItemState
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
          DateFormat('dd MMM yyyy hh:mm a').format(order.createdAt.toLocal()),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(
          Text(
            DateFormat('dd MMM yyyy hh:mm a').format(order.updatedAt.toLocal()),
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
                onPressed: state is! GetOrderLoadingItemState
                    ? () {
                        Navigator.of(context).pushNamed(ViewOrderScreen.routeName, arguments: order).then((value) {
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
                  style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.green)
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetOrderLoadingItemState ? () {} : null,
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                label: Text(
                  'Edit',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.blue)
    ,
                ),
              ),
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetOrderLoadingItemState
                    ? () {
                        showOrderDeleteConfirmation(order);
                      }
                    : null,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: Text(
                  'Delete',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(fontSize: 16, fontColor: Colors.red)

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
  int get rowCount => orderList.length;

  @override
  int get selectedRowCount => selectedOrderList.length;
}
