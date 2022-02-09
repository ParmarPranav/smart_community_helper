import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/coupon/get_coupon/get_coupon_bloc.dart';
import '../../models/coupon.dart';
import '../../utils/project_constant.dart';
import '../../widgets/drawer/main_drawer.dart';
import '../responsive_layout.dart';
import 'add_coupon_screen.dart';

class ManageCouponsScreen extends StatefulWidget {
  static const routeName = '/manage-coupons';

  @override
  _ManageCouponsScreenState createState() => _ManageCouponsScreenState();
}

class _ManageCouponsScreenState extends State<ManageCouponsScreen> {
  bool _isInit = true;
  final GetCouponsBloc _getCouponsBloc = GetCouponsBloc();
  List<Coupon> _couponList = [];
  List<Coupon> _searchCouponList = [];
  List<Coupon> _selectedCouponList = [];
  bool _sortCouponAsc = true;
  bool _sortCreatedAtAsc = true;
  bool _sortEditedAtAsc = true;
  bool _sortAsc = true;
  int? _sortColumnIndex;
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _searchVerticalScrollController = ScrollController();
  late TextEditingController _searchQueryEditingController;
  bool _isSearching = false;
  String searchQuery = "Search query";
  bool _isByCouponCodeSelected = true;

  bool _isFloatingActionButtonVisible = true;

  String LIMIT_PER_PAGE = '10';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _searchQueryEditingController = TextEditingController();
      _getCouponsBloc.add(GetCouponsDataEvent());
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
    return Scaffold(
      drawer: ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)
          ? MainDrawer(
              navigatorKey: Navigator.of(context).widget.key as GlobalKey<NavigatorState>,
            )
          : null,
      appBar: ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)
          ? _selectedCouponList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetCouponsBloc, GetCouponsState>(
        bloc: _getCouponsBloc,
        listener: (context, state) {
          if (state is GetCouponsSuccessState) {
            _couponList = state.couponList;
          } else if (state is GetCouponsFailedState) {
            _showSnackMessage(state.message, Colors.red.shade700);
          } else if (state is GetCouponsExceptionState) {
            _showSnackMessage(state.message, Colors.red.shade700);
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            smallScreen: _buildMobileView(state),
            mediumScreen: _buildTabletView(state),
            largeScreen: _buildWebView(state),
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: _isFloatingActionButtonVisible,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16, right: 16),
          child: FloatingActionButton(
            onPressed: () async {
              Coupon? coupon = await Navigator.of(context).pushNamed(AddCouponScreen.routeName) as Coupon?;
              if (coupon != null) {
                setState(() {
                  _couponList.add(coupon);
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
        'Manage Coupons',
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
        'Selected (${_selectedCouponList.length})',
        style: ProjectConstant.WorkSansFontBoldTextStyle(
          fontSize: 20,
          fontColor: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedCouponList.clear();
              _selectedCouponList.addAll(_couponList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showCouponDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedCouponList.clear();
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
                hintText: 'Search Coupons...',
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
                      name: 'By Coupon Code',
                      isSelected: _isByCouponCodeSelected,
                      onTap: () {
                        setState(() {
                          _isByCouponCodeSelected = !_isByCouponCodeSelected;
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

  Widget _buildMobileView(GetCouponsState state) {
    return state is GetCouponsLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildCouponSearchList(state)
            : _buildCouponList(state);
  }

  Widget _buildTabletView(GetCouponsState state) {
    return state is GetCouponsLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildCouponSearchList(state)
            : _buildCouponList(state);
  }

  Widget _buildWebView(GetCouponsState state) {
    return Scaffold(
      appBar: _selectedCouponList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetCouponsLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildCouponSearchList(state)
              : _buildCouponList(state),
    );
  }

  Widget _buildCouponList(GetCouponsState state) {
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
              onSelectAll: _onSelectAllCoupon,
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
                    'Coupon Title',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCouponAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCouponAsc;
                      }
                      _couponList.sort((coupon, user2) => coupon.couponCode.compareTo(user2.couponCode));
                      if (!ascending) {
                        _couponList = _couponList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Coupon Subtitle',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCouponAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCouponAsc;
                      }
                      _couponList.sort((coupon, user2) => coupon.couponCode.compareTo(user2.couponCode));
                      if (!ascending) {
                        _couponList = _couponList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Coupon Code',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Minimum Order Price',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Maximum Discount Price',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Usable Count',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Discount Calculation Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Discount',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'For User',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Validity Ends',
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
                      _couponList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _couponList = _couponList.reversed.toList();
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
                        _couponList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _couponList = _couponList.reversed.toList();
                        }
                      });
                    }),
                DataColumn(
                  label: Text(
                    'Status',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
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
              source: CouponDataTableSource(
                context: context,
                state: state,
                couponList: _couponList,
                selectedCouponList: _selectedCouponList,
                onSelectCouponChanged: _onSelectCouponChanged,
                refreshHandler: _refreshHandler,
                editCallBack: _editCouponCallback,
                statusChangeCallBack: _statusChangeCouponCallback,
                showCouponDeleteConfirmation: _showCouponDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponSearchList(GetCouponsState state) {
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
              onSelectAll: _onSelectAllCoupon,
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
                    'Coupon Title',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCouponAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCouponAsc;
                      }
                      _couponList.sort((coupon, user2) => coupon.couponCode.compareTo(user2.couponCode));
                      if (!ascending) {
                        _couponList = _couponList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Coupon Subtitle',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      if (columnIndex == _sortColumnIndex) {
                        _sortAsc = _sortCouponAsc = ascending;
                      } else {
                        _sortColumnIndex = columnIndex;
                        _sortAsc = _sortCouponAsc;
                      }
                      _couponList.sort((coupon, user2) => coupon.couponCode.compareTo(user2.couponCode));
                      if (!ascending) {
                        _couponList = _couponList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Coupon Code',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Minimum Order Price',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Maximum Discount Price',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Usable Count',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Discount Calculation Type',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Discount',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'For User',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Validity Ends',
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
                      _couponList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _couponList = _couponList.reversed.toList();
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
                      _couponList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                      if (!ascending) {
                        _couponList = _couponList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                      fontSize: 16,
                      fontColor: Colors.black,
                    ),
                  ),
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
              source: CouponDataTableSource(
                context: context,
                state: state,
                couponList: _searchCouponList,
                selectedCouponList: _selectedCouponList,
                onSelectCouponChanged: _onSelectCouponChanged,
                refreshHandler: _refreshHandler,
                editCallBack: _editCouponCallback,
                statusChangeCallBack: _statusChangeCouponCallback,
                showCouponDeleteConfirmation: _showCouponDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void search() {
    _searchCouponList = _couponList.where((item) => item.couponCode.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
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
      _searchCouponList.clear();
      _isSearching = false;
      _isByCouponCodeSelected = true;
    });
  }

  void _showSnackMessage(String message, Color color, [int seconds = 3]) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  void _onSelectAllCoupon(value) {
    if (value) {
      setState(() {
        _selectedCouponList.clear();
        _selectedCouponList.addAll(_couponList);
      });
    } else {
      setState(() {
        _selectedCouponList.clear();
      });
    }
  }

  void _onSelectCouponChanged(bool value, Coupon coupon) {
    if (value) {
      setState(() {
        _selectedCouponList.add(coupon);
      });
    } else {
      setState(() {
        _selectedCouponList.removeWhere((restau) => restau.id == coupon.id);
      });
    }
  }

  void _refreshHandler() {
    _getCouponsBloc.add(GetCouponsDataEvent());
  }

  void _editCouponCallback(Coupon coupon) async {
    // Coupon? tempCoupon = await Navigator.of(context).pushNamed(EditCouponScreen.routeName, arguments: coupon) as Coupon?;
    // setState(() {
    //   if (tempCoupon != null) {
    //     int index = _couponList.indexWhere((element) => element.id == tempCoupon.id);
    //     _couponList.removeAt(index);
    //     _couponList.insert(index, tempCoupon);
    //     if (_isSearching) {
    //       int index = _searchCouponList.indexWhere((element) => element.id == tempCoupon.id);
    //       _searchCouponList.removeAt(index);
    //       _searchCouponList.insert(index, tempCoupon);
    //     }
    //   }
    // });
  }

  void _statusChangeCouponCallback(Coupon coupon, bool value) async {
    _getCouponsBloc.add(GetCouponsUpdateStatusEvent(
      data: {
        'id': coupon.id,
        'status': value ? '1' : '0',
      },
    ));
  }

  void _showCouponDeleteConfirmation(Coupon coupon) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete Coupon'),
          content: Text('Do you really want to delete this coupon ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getCouponsBloc.add(
                  GetCouponsDeleteEvent(
                    id: {
                      'id': coupon.id,
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

  void _showCouponDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All Coupon'),
          content: Text('Do you really want to delete this coupons ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getCouponsBloc.add(
                  GetCouponsDeleteAllEvent(
                    idList: _selectedCouponList.map((item) {
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

class CouponDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetCouponsState state;
  final List<Coupon> couponList;
  final List<Coupon> selectedCouponList;
  final Function onSelectCouponChanged;
  final Function refreshHandler;
  final Function editCallBack;
  final Function statusChangeCallBack;
  final Function showCouponDeleteConfirmation;

  CouponDataTableSource({
    required this.context,
    required this.state,
    required this.couponList,
    required this.selectedCouponList,
    required this.onSelectCouponChanged,
    required this.refreshHandler,
    required this.editCallBack,
    required this.statusChangeCallBack,
    required this.showCouponDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final coupon = couponList[index];
    return DataRow(
      selected: selectedCouponList.any((selectedCoupon) => selectedCoupon.id == coupon.id),
      onSelectChanged: (value) => onSelectCouponChanged(value, coupon),
      cells: [
        DataCell(Text(
          coupon.couponTitle,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          coupon.couponSubtitle,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          coupon.couponCode,
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          '\$${coupon.minimumOrderPrice.toStringAsFixed(2)}',
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          '\$${coupon.maximumDiscountPrice.toStringAsFixed(2)}',
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          '${coupon.noOfTimeUse}',
        )),
        DataCell(Text(
          '${coupon.discountCalculationType == 'flat' ? 'Flat' : 'Upto'}',
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          '${coupon.discountType == 'percentage' ? '${coupon.discountValue}%' : '\$${coupon.discountValue}'}',
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          '${coupon.userType == 'all' ? 'All' : 'Specific'}',
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          DateFormat('dd MMM yyyy hh:mm a').format(coupon.validityEnd.toLocal()),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          DateFormat('dd MMM yyyy hh:mm a').format(coupon.createdAt.toLocal()),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(Text(
          DateFormat('dd MMM yyyy hh:mm a').format(coupon.updatedAt.toLocal()),
          style: ProjectConstant.WorkSansFontRegularTextStyle(
            fontSize: 15,
            fontColor: Colors.black,
          ),
        )),
        DataCell(
          Switch(
            value: coupon.status == '1',
            onChanged: (value) {
              statusChangeCallBack(coupon, value);
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              TextButton.icon(
                onPressed: state is! GetCouponsLoadingItemState ? () {} : null,
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
                onPressed: state is! GetCouponsLoadingItemState
                    ? () {
                        editCallBack(coupon);
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
                onPressed: state is! GetCouponsLoadingItemState
                    ? () {
                        showCouponDeleteConfirmation(coupon);
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
  int get rowCount => couponList.length;

  @override
  int get selectedRowCount => selectedCouponList.length;
}
