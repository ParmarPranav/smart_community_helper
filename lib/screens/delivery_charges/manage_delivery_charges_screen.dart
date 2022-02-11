import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/delivery_charges/get_delivery_charges/get_delivery_charges_bloc.dart';
import 'package:food_hunt_admin_app/models/delivery_charges.dart';
import 'package:food_hunt_admin_app/screens/delivery_charges/add_delivery_charges_screen.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:food_hunt_admin_app/widgets/image_error_widget.dart';
import 'package:food_hunt_admin_app/widgets/skeleton_view.dart';
import 'package:intl/intl.dart';

import '../responsive_layout.dart';
import 'edit_delivery_charges_screen.dart';

class ManageDeliveryChargesScreen extends StatefulWidget {
  static const routeName = '/manage-delivery-charges';

  @override
  _ManageDeliveryChargesScreenState createState() => _ManageDeliveryChargesScreenState();
}

class _ManageDeliveryChargesScreenState extends State<ManageDeliveryChargesScreen> {
  bool _isInit = true;

  final GetDeliveryChargesBloc _getDeliveryChargesBloc = GetDeliveryChargesBloc();
  List<DeliveryCharges> _deliveryChargesList = [];
  List<DeliveryCharges> _searchDeliveryChargesList = [];
  final List<DeliveryCharges> _selectedDeliveryChargesList = [];
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
  bool _isByDeliveryChargesSelected = false;

  bool _isFloatingActionButtonVisible = true;

  String LIMIT_PER_PAGE = '10';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _searchQueryEditingController = TextEditingController();
      _getDeliveryChargesBloc.add(GetDeliveryChargesDataEvent());
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
          ? _selectedDeliveryChargesList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: BlocConsumer<GetDeliveryChargesBloc, GetDeliveryChargesState>(
        bloc: _getDeliveryChargesBloc,
        listener: (context, state) {
          if (state is GetDeliveryChargesSuccessState) {
            _deliveryChargesList = state.deliveryChargesList;
          } else if (state is GetDeliveryChargesFailedState) {
            _showSnackMessage(state.message);
          } else if (state is GetDeliveryChargesExceptionState) {
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
              DeliveryCharges? deliveryCharges = await Navigator.of(context).pushNamed(AddDeliveryChargesScreen.routeName) as DeliveryCharges?;
              if (deliveryCharges != null) {
                setState(() {
                  _deliveryChargesList.add(deliveryCharges);
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
        'Manage Delivery Charges',
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
        'Selected (${_selectedDeliveryChargesList.length})',
        style: ProjectConstant.WorkSansFontBoldTextStyle(
          fontSize: 20,
          fontColor: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDeliveryChargesList.clear();
              _selectedDeliveryChargesList.addAll(_deliveryChargesList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showDeliveryChargesDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedDeliveryChargesList.clear();
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
                hintText: 'Search DeliveryCharges...',
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              style:  TextStyle(
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
                      _isByDeliveryChargesSelected = !_isByDeliveryChargesSelected;
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
                        if (_isByDeliveryChargesSelected)
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

  Widget _buildMobileView(GetDeliveryChargesState state) {
    return state is GetDeliveryChargesLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildDeliveryChargesSearchList(state)
            : _buildDeliveryChargesList(state);
  }

  Widget _buildTabletView(GetDeliveryChargesState state) {
    return state is GetDeliveryChargesLoadingState
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _isSearching
            ? _buildDeliveryChargesSearchList(state)
            : _buildDeliveryChargesList(state);
  }

  Widget _buildWebView(double screenHeight, double screenWidth, GetDeliveryChargesState state) {
    return Scaffold(
      appBar: _selectedDeliveryChargesList.isNotEmpty
          ? _selectionAppBarWidget()
          : _isSearching
              ? _searchWidget()
              : _defaultAppBarWidget(),
      body: state is GetDeliveryChargesLoadingState
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isSearching
              ? _buildDeliveryChargesSearchList(state)
              : _buildDeliveryChargesList(state),
    );
  }

  void search() {
    _searchDeliveryChargesList = _deliveryChargesList.where((item) => item.charge.toString().toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
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
      _searchDeliveryChargesList.clear();
      _isSearching = false;
      _isByDeliveryChargesSelected = false;
    });
  }

  void _statusChangeCallBack(DeliveryCharges deliveryCharges, bool value) async {
    _getDeliveryChargesBloc.add(UpdateDeliveryChargesEvent(data: {'id': deliveryCharges.id, 'status': value ? '1' : '0'}));
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

  Widget _buildDeliveryChargesList(GetDeliveryChargesState state) {
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
              onSelectAll: _onSelectAllDeliveryCharges,
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
                  label: Text('City',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                ),
                DataColumn(
                  label: Text('From Amount',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
                      _deliveryChargesList.sort((user1, user2) => user1.from.compareTo(user2.from));
                      if (!ascending) {
                        _deliveryChargesList = _deliveryChargesList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('To Amount',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
                      _deliveryChargesList.sort((user1, user2) => user1.to.compareTo(user2.to));
                      if (!ascending) {
                        _deliveryChargesList = _deliveryChargesList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Charges',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
                      _deliveryChargesList.sort((user1, user2) => user1.charge.compareTo(user2.charge));
                      if (!ascending) {
                        _deliveryChargesList = _deliveryChargesList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(label: Text('Status',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                  fontSize: 16,
                  fontColor: Colors.black,
                ),)),
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
                      _deliveryChargesList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _deliveryChargesList = _deliveryChargesList.reversed.toList();
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
                        _deliveryChargesList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _deliveryChargesList = _deliveryChargesList.reversed.toList();
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
              source: DeliveryChargesDataTableSource(
                context: context,
                state: state,
                deliveryChargesList: _deliveryChargesList,
                selectedDeliveryChargesList: _selectedDeliveryChargesList,
                onSelectDeliveryChargesChanged: _onSelectDeliveryChargesChanged,
                refreshHandler: _refreshHandler,
                statusChangeCallBack: _statusChangeCallBack,
                showDeliveryChargesDeleteConfirmation: _showDeliveryChargesDeleteConfirmation,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryChargesSearchList(GetDeliveryChargesState state) {
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
              onSelectAll: _onSelectAllDeliveryCharges,
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
                  label: Text('City',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                    fontSize: 16,
                    fontColor: Colors.black,
                  ),),
                ),
                DataColumn(
                  label: Text('From Amount',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
                      _deliveryChargesList.sort((user1, user2) => user1.from.compareTo(user2.from));
                      if (!ascending) {
                        _deliveryChargesList = _deliveryChargesList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('To Amount',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
                      _deliveryChargesList.sort((user1, user2) => user1.to.compareTo(user2.to));
                      if (!ascending) {
                        _deliveryChargesList = _deliveryChargesList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(
                  label: Text('Charges',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
                      _deliveryChargesList.sort((user1, user2) => user1.charge.compareTo(user2.charge));
                      if (!ascending) {
                        _deliveryChargesList = _deliveryChargesList.reversed.toList();
                      }
                    });
                  },
                ),
                DataColumn(label: Text('Status',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                  fontSize: 16,
                  fontColor: Colors.black,
                ),)),
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
                      _deliveryChargesList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                      if (!ascending) {
                        _deliveryChargesList = _deliveryChargesList.reversed.toList();
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
                        _deliveryChargesList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                        if (!ascending) {
                          _deliveryChargesList = _deliveryChargesList.reversed.toList();
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
              source: DeliveryChargesDataTableSource(
                context: context,
                state: state,
                deliveryChargesList: _searchDeliveryChargesList,
                selectedDeliveryChargesList: _selectedDeliveryChargesList,
                onSelectDeliveryChargesChanged: _onSelectDeliveryChargesChanged,
                refreshHandler: _refreshHandler,
                statusChangeCallBack: _statusChangeCallBack,
                showDeliveryChargesDeleteConfirmation: _showDeliveryChargesDeleteConfirmation,
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

  void _onSelectAllDeliveryCharges(value) {
    if (value) {
      setState(() {
        _selectedDeliveryChargesList.clear();
        _selectedDeliveryChargesList.addAll(_deliveryChargesList);
      });
    } else {
      setState(() {
        _selectedDeliveryChargesList.clear();
      });
    }
  }

  void _onSelectDeliveryChargesChanged(bool value, DeliveryCharges deliveryCharges) {
    if (value) {
      setState(() {
        _selectedDeliveryChargesList.add(deliveryCharges);
      });
    } else {
      setState(() {
        _selectedDeliveryChargesList.removeWhere((restau) => restau.id == deliveryCharges.id);
      });
    }
  }

  void _refreshHandler() {
    _getDeliveryChargesBloc.add(GetDeliveryChargesDataEvent());
  }

  void _showDeliveryChargesDeleteConfirmation(DeliveryCharges deliveryCharges) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete DeliveryCharges'),
          content: Text('Do you really want to delete this deliveryCharges ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getDeliveryChargesBloc.add(
                  GetDeliveryChargesDeleteEvent(
                    deiberyCharges: {
                      'id': deliveryCharges.id,
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

  void _showDeliveryChargesDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All Delivery Charges'),
          content: Text('Do you really want to delete this delivery chargess ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getDeliveryChargesBloc.add(
                  GetDeliveryChargesDeleteAllEvent(
                    deliveryChargesList: _selectedDeliveryChargesList.map((item) {
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

class DeliveryChargesDataTableSource extends DataTableSource {
  final BuildContext context;
  final GetDeliveryChargesState state;
  final List<DeliveryCharges> deliveryChargesList;
  final List<DeliveryCharges> selectedDeliveryChargesList;
  final Function onSelectDeliveryChargesChanged;
  final Function refreshHandler;
  final Function statusChangeCallBack;
  final Function showDeliveryChargesDeleteConfirmation;

  DeliveryChargesDataTableSource({
    required this.context,
    required this.state,
    required this.deliveryChargesList,
    required this.selectedDeliveryChargesList,
    required this.onSelectDeliveryChargesChanged,
    required this.refreshHandler,
    required this.statusChangeCallBack,
    required this.showDeliveryChargesDeleteConfirmation,
  });

  @override
  DataRow getRow(int index) {
    final deliveryCharges = deliveryChargesList[index];
    return DataRow(
      selected: selectedDeliveryChargesList.any((selectedDeliveryCharges) => selectedDeliveryCharges.id == deliveryCharges.id),
      onSelectChanged: (value) => onSelectDeliveryChargesChanged(value, deliveryCharges),
      cells: [
        DataCell(Text(deliveryCharges.city, style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(Text(deliveryCharges.from.toString(), style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(Text(deliveryCharges.to.toString(), style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(Text(deliveryCharges.charge.toString(), style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(Switch(
          onChanged: state is! GetDeliveryChargesLoadingItemState
              ? (value) {
                  statusChangeCallBack(deliveryCharges, value);
                }
              : null,
          value: deliveryCharges.status == '1',
        )),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(deliveryCharges.createdAt.toLocal()), style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(deliveryCharges.updatedAt.toLocal()), style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 15,
          fontColor: Colors.black,
        ),)),
        DataCell(
          Row(
            children: [
              SizedBox(width: 10),
              TextButton.icon(
                onPressed: state is! GetDeliveryChargesLoadingItemState
                    ? () {
                        Navigator.of(context).pushNamed(EditDeliveryChargesScreen.routeName, arguments: deliveryCharges).then((value) {
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
                onPressed: state is! GetDeliveryChargesLoadingItemState
                    ? () {
                        showDeliveryChargesDeleteConfirmation(deliveryCharges);
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
  int get rowCount => deliveryChargesList.length;

  @override
  int get selectedRowCount => selectedDeliveryChargesList.length;
}
