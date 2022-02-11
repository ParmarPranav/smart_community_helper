import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:intl/intl.dart';

import '../../bloc/staff/show_staff/show_staff_bloc.dart';
import '../../models/admin_details.dart';
import '../../widgets/drawer/main_drawer.dart';
import '../responsive_layout.dart';
import 'add_staff_screen.dart';
import 'edit_staff_screen.dart';

class ManageStaffScreen extends StatefulWidget {
  static const routeName = '/manage-staff';

  @override
  _ManageStaffScreenState createState() => _ManageStaffScreenState();
}

class _ManageStaffScreenState extends State<ManageStaffScreen> {
  bool _isInit = true;

  final ShowStaffBloc _showStaffBloc = ShowStaffBloc();

  List<AdminDetails> _staffList = [];
  List<AdminDetails> _selectedStaffList = [];
  List<AdminDetails> _searchStaffList = [];
  bool _sortNameAsc = true;
  bool _sortCreatedAtAsc = true;
  bool _sortEditedAtAsc = true;
  bool _sortAsc = true;
  int? _sortColumnIndex;

  TextEditingController _searchQueryEditingController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _searchHorizontalScrollController = ScrollController();
  final ScrollController _searchVerticalScrollController = ScrollController();
  bool _isByNameSelected = true;
  bool _isByMobileNoSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _showStaffBloc.add(ShowStaffDataEvent());
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return Scaffold(
      drawer: ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)
          ? MainDrawer(
              navigatorKey: Navigator.of(context).widget.key as GlobalKey<NavigatorState>,
            )
          : null,
      appBar: ResponsiveLayout.isSmallScreen(context) || ResponsiveLayout.isMediumScreen(context)
          ? _selectedStaffList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget()
          : null,
      body: ResponsiveLayout(
        smallScreen: _buildMobileView(),
        mediumScreen: _buildTabletView(),
        largeScreen: _buildWebView(screenHeight, screenWidth),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton(
          onPressed: () async {
            AdminDetails? staff = await Navigator.of(context).pushNamed(AddStaffScreen.routeName) as AdminDetails?;
            if (staff != null) {
              setState(() {
                _staffList.add(staff);
              });
            }
          },
          child: Icon(Icons.add),
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
        'Manage Staff',
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
        'Selected (${_selectedStaffList.length})',
        style: ProjectConstant.WorkSansFontBoldTextStyle(
          fontSize: 20,
          fontColor: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedStaffList.clear();
              _selectedStaffList.addAll(_staffList);
            });
          },
          icon: Icon(
            Icons.select_all,
          ),
        ),
        IconButton(
          onPressed: () {
            _showStaffDeleteAllConfirmation();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {
              _selectedStaffList.clear();
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
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: null,
      iconTheme: IconThemeData(color: Colors.black),
      toolbarHeight: 120,
      flexibleSpace: Column(
        children: [
          AppBar(
            elevation: 0,
            toolbarHeight: 60,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
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
            title: TextField(
              controller: _searchQueryEditingController,
              autofocus: true,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Search Staff...',
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
                      _isByMobileNoSelected = false;
                      _isByNameSelected = !_isByNameSelected;
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
                        if (_isByNameSelected)
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
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    setState(() {
                      _isByNameSelected = false;
                      _isByMobileNoSelected = !_isByMobileNoSelected;
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
                        if (_isByMobileNoSelected)
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
                          'By Phone No.',
                          style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                            fontSize: 16,
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

  Widget _buildMobileView() {
    return BlocConsumer<ShowStaffBloc, ShowStaffState>(
      bloc: _showStaffBloc,
      listener: (context, state) {
        if (state is ShowStaffSuccessState) {
          _selectedStaffList.clear();
          _staffList = state.staffList;
        } else if (state is ShowStaffFailedState) {
          _staffList = state.staffList;
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is ShowStaffExceptionState) {
          _staffList = state.staffList;
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return state is ShowStaffLoadingState
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _isSearching
                ? _searchStaffListWidget()
                : _staffListWidget();
      },
    );
  }

  Widget _buildTabletView() {
    return BlocConsumer<ShowStaffBloc, ShowStaffState>(
      bloc: _showStaffBloc,
      listener: (context, state) {
        if (state is ShowStaffSuccessState) {
          _selectedStaffList.clear();
          _staffList = state.staffList;
        } else if (state is ShowStaffFailedState) {
          _staffList = state.staffList;
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is ShowStaffExceptionState) {
          _staffList = state.staffList;
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return state is ShowStaffLoadingState
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _isSearching
                ? _searchStaffListWidget()
                : _staffListWidget();
      },
    );
  }

  Widget _buildWebView(double screenHeight, double screenWidth) {
    return BlocConsumer<ShowStaffBloc, ShowStaffState>(
      bloc: _showStaffBloc,
      listener: (context, state) {
        if (state is ShowStaffSuccessState) {
          _selectedStaffList.clear();
          _staffList = state.staffList;
        } else if (state is ShowStaffFailedState) {
          _staffList = state.staffList;
          _showSnackMessage(state.message, Colors.red.shade700);
        } else if (state is ShowStaffExceptionState) {
          _staffList = state.staffList;
          _showSnackMessage(state.message, Colors.red.shade700);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _selectedStaffList.isNotEmpty
              ? _selectionAppBarWidget()
              : _isSearching
                  ? _searchWidget()
                  : _defaultAppBarWidget(),
          body: state is ShowStaffLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _isSearching
                  ? _searchStaffListWidget()
                  : _staffListWidget(),
        );
      },
    );
  }

  Widget _staffListWidget() {
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
            child: Scrollbar(
              controller: _horizontalScrollController,
              isAlwaysShown: true,
              showTrackOnHover: true,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DataTable(
                    showCheckboxColumn: true,
                    sortAscending: _sortAsc,
                    sortColumnIndex: _sortColumnIndex,
                    onSelectAll: _onSelectAllStaff,
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
                            _staffList.sort((user1, user2) => user1.name.compareTo(user2.name));
                            if (!ascending) {
                              _staffList = _staffList.reversed.toList();
                            }
                          });
                        },
                      ),
                      DataColumn(
                        label: Text('Email',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                          fontSize: 16,
                          fontColor: Colors.black,
                        ),),
                      ),
                      DataColumn(
                        label: Text('Account Type',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
                            _staffList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                            if (!ascending) {
                              _staffList = _staffList.reversed.toList();
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
                              _staffList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                              if (!ascending) {
                                _staffList = _staffList.reversed.toList();
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
                    rows: _staffList.map((staff) {
                      return DataRow(
                        key: ValueKey(staff.emailId),
                        selected: _selectedStaffList.any((selectedUser) => selectedUser.emailId == staff.emailId),
                        onSelectChanged: (value) => _onSelectStaffChanged(value, staff),
                        cells: [
                          DataCell(Text(staff.name, style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),)),
                          DataCell(Text(staff.emailId, style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),)),
                          DataCell(Text(staff.accountType, style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),)),
                          DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(staff.createdAt.toLocal()), style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),)),
                          DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(staff.updatedAt.toLocal()), style: ProjectConstant.WorkSansFontRegularTextStyle(
                            fontSize: 15,
                            fontColor: Colors.black,
                          ),)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    AdminDetails? editedStaff = await Navigator.of(context).pushNamed(EditStaffScreen.routeName, arguments: staff) as AdminDetails?;
                                    if (editedStaff != null) {
                                      _refreshHandler();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showStaffDeleteConfirmation(staff);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchStaffListWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Scrollbar(
        controller: _searchVerticalScrollController,
        isAlwaysShown: true,
        showTrackOnHover: true,
        child: SingleChildScrollView(
          controller: _searchVerticalScrollController,
          child: Scrollbar(
            controller: _searchHorizontalScrollController,
            isAlwaysShown: true,
            showTrackOnHover: true,
            child: SingleChildScrollView(
              controller: _searchHorizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  showCheckboxColumn: true,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAsc,
                  onSelectAll: _onSelectAllStaff,
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
                          _staffList.sort((user1, user2) => user1.name.compareTo(user2.name));
                          if (!ascending) {
                            _staffList = _staffList.reversed.toList();
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: Text('Email',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
                        fontSize: 16,
                        fontColor: Colors.black,
                      ),),
                    ),
                    DataColumn(
                      label: Text('Account Type',style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
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
                          _staffList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                          if (!ascending) {
                            _staffList = _staffList.reversed.toList();
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
                            _staffList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                            if (!ascending) {
                              _staffList = _staffList.reversed.toList();
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
                  rows: _searchStaffList.map((staff) {
                    return DataRow(
                      key: ValueKey(staff.emailId),
                      selected: _selectedStaffList.any((selectedUser) => selectedUser.emailId == staff.emailId),
                      onSelectChanged: (value) => _onSelectStaffChanged(value, staff),
                      cells: [
                        DataCell(Text(staff.name, style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 15,
                          fontColor: Colors.black,
                        ),)),
                        DataCell(Text(staff.emailId, style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 15,
                          fontColor: Colors.black,
                        ),)),
                        DataCell(Text(staff.accountType, style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 15,
                          fontColor: Colors.black,
                        ),)),
                        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(staff.createdAt.toLocal()), style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 15,
                          fontColor: Colors.black,
                        ),)),
                        DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(staff.updatedAt.toLocal()), style: ProjectConstant.WorkSansFontRegularTextStyle(
                          fontSize: 15,
                          fontColor: Colors.black,
                        ),)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  AdminDetails? editedStaff = await Navigator.of(context).pushNamed(EditStaffScreen.routeName, arguments: staff) as AdminDetails?;
                                  if (editedStaff != null) {
                                    _refreshHandler();
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showStaffDeleteConfirmation(staff);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSelectAllStaff(value) {
    if (value) {
      setState(() {
        _selectedStaffList.clear();
        _selectedStaffList.addAll(_staffList);
      });
    } else {
      setState(() {
        _selectedStaffList.clear();
      });
    }
  }

  void _onSelectStaffChanged(bool? value, AdminDetails users) {
    if (value!) {
      setState(() {
        _selectedStaffList.add(users);
      });
    } else {
      setState(() {
        _selectedStaffList.removeWhere((selectedUser) => selectedUser.emailId == users.emailId);
      });
    }
  }

  void search() {
    if (_isByNameSelected) {
      _searchStaffList = _staffList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
    } else {
      _searchStaffList = _staffList.where((item) => item.name.toLowerCase().contains(_searchQueryEditingController.text.toLowerCase())).toList();
    }
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
      _searchStaffList.clear();
      _isSearching = false;
    });
  }

  void _showSnackMessage(String message, Color color) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }

  void _refreshHandler() {
    _showStaffBloc.add(ShowStaffDataEvent());
  }

  void _showStaffDeleteConfirmation(AdminDetails staff) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete Staff'),
          content: Text('Do you really want to delete this staff ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _showStaffBloc.add(ShowStaffDeleteEvent(
                  emailId: staff.emailId,
                ));
                Navigator.of(ctx).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showStaffDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All Staff'),
          content: Text('Do you really want to delete all this staff ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _showStaffBloc.add(
                  ShowStaffDeleteAllEvent(
                    emailIdList: _selectedStaffList.map((item) {
                      return {
                        'email_id': item.emailId,
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
