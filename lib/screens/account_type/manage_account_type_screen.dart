import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/account_type/get_account_type/get_account_type_bloc.dart';
import 'package:food_hunt_admin_app/models/account_type.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';
import 'package:intl/intl.dart';

import '../responsive_layout.dart';
import 'add_account_type_screen.dart';
import 'edit_account_type_screen.dart';

class ManageAccountTypeScreen extends StatefulWidget {
  static const routeName = '/manage-account-type';

  @override
  _ManageAccountTypeScreenState createState() => _ManageAccountTypeScreenState();
}

class _ManageAccountTypeScreenState extends State<ManageAccountTypeScreen> {
  bool _isInit = true;

  final GetAccountTypeBloc _getAccountTypeBloc = GetAccountTypeBloc();

  List<AccountType> _accountTypeList = [];
  final List<AccountType> _selectedAccountTypeList = [];
  bool _sortNameAsc = true;
  bool _sortCreatedAtAsc = true;
  bool _sortEditedAtAsc = true;
  bool _sortAsc = true;
  int? _sortColumnIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getAccountTypeBloc.add(GetAccountTypeDataEvent());
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
      body: BlocConsumer<GetAccountTypeBloc, GetAccountTypeState>(
        bloc: _getAccountTypeBloc,
        listener: (context, state) {
          if (state is GetAccountTypeSuccessState) {
            _accountTypeList = state.accountTypeList;
          } else if (state is GetAccountTypeFailedState) {
            _accountTypeList = state.accountTypeList;
            _showSnackMessage(state.message, Colors.red.shade700);
          } else if (state is GetAccountTypeExceptionState) {
            _accountTypeList = state.accountTypeList;
            _showSnackMessage(state.message, Colors.red.shade700);
          }
        },
        builder: (context, state) {
          return state is GetAccountTypeLoadingState
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ResponsiveLayout(
                  smallScreen: _buildMobileView(state),
                  mediumScreen: _buildTabletView(state),
                  largeScreen: _buildWebView(state, screenWidth, screenHeight),
                );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 16),
        child: FloatingActionButton(
          onPressed: () async {
            AccountType? accountType = await Navigator.of(context).pushNamed(AddAccountTypeScreen.routeName) as AccountType?;
            if (accountType != null) {
              setState(() {
                _accountTypeList.add(accountType);
              });
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMobileView(GetAccountTypeState state) {
    return Column(
      children: [
        _selectedAccountTypeList.isNotEmpty
            ? AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 70,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                elevation: 3,
                title: Text(
                  'Selected Account Type(${_selectedAccountTypeList.length})',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedAccountTypeList.clear();
                        _selectedAccountTypeList.addAll(_accountTypeList);
                      });
                    },
                    icon: Icon(
                      Icons.select_all,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showAccountTypeDeleteConfirmation();
                    },
                    icon: Icon(
                      Icons.delete,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () {
                        _selectedAccountTypeList.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                ],
              )
            : AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 70,
                elevation: 3,
                title: Text(
                  'Manage Account Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: _accountTypeListWidget(state),
        ),
      ],
    );
  }

  Widget _buildTabletView(GetAccountTypeState state) {
    return Column(
      children: [
        _selectedAccountTypeList.isNotEmpty
            ? AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 70,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                elevation: 3,
                title: Text(
                  'Selected Account Type (${_selectedAccountTypeList.length})',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedAccountTypeList.clear();
                        _selectedAccountTypeList.addAll(_accountTypeList);
                      });
                    },
                    icon: Icon(
                      Icons.select_all,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showAccountTypeDeleteConfirmation();
                    },
                    icon: Icon(
                      Icons.delete,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () {
                        _selectedAccountTypeList.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                ],
              )
            : AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 70,
                elevation: 3,
                title: Text(
                  'Manage Account Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
              ),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: _accountTypeListWidget(state),
        ),
      ],
    );
  }

  Widget _buildWebView(GetAccountTypeState state, double screenWidth, double screenHeight) {
    return Column(
      children: [
        _selectedAccountTypeList.isNotEmpty
            ? AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 70,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                elevation: 3,
                title: Text(
                  'Selected Account Type (${_selectedAccountTypeList.length})',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedAccountTypeList.clear();
                        _selectedAccountTypeList.addAll(_accountTypeList);
                      });
                    },
                    icon: Icon(
                      Icons.select_all,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showAccountTypeDeleteConfirmation();
                    },
                    icon: Icon(
                      Icons.delete,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: IconButton(
                      onPressed: () {
                        _selectedAccountTypeList.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                ],
              )
            : AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 70,
                elevation: 3,
                title: Text(
                  'Manage Account Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: _accountTypeListWidget(state),
        ),
      ],
    );
  }

  Widget _accountTypeListWidget(GetAccountTypeState state) {
    return Align(
      alignment: Alignment.topLeft,
      child: RefreshIndicator(
        onRefresh: () async {
          _refreshHandler();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                showTrackOnHover: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DataTable(
                      onSelectAll: _onSelectAllAccountType,
                      showCheckboxColumn: true,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAsc,
                      columns: [
                        DataColumn(
                          label: Text('Account Type'),
                          onSort: (columnIndex, ascending) {
                            setState(() {
                              if (columnIndex == _sortColumnIndex) {
                                _sortAsc = _sortNameAsc = ascending;
                              } else {
                                _sortColumnIndex = columnIndex;
                                _sortAsc = _sortNameAsc;
                              }
                              _accountTypeList.sort((user1, user2) => user1.accountType.compareTo(user2.accountType));
                              if (!ascending) {
                                _accountTypeList = _accountTypeList.reversed.toList();
                              }
                            });
                          },
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
                              _accountTypeList.sort((user1, user2) => user1.createdAt.compareTo(user2.createdAt));
                              if (!ascending) {
                                _accountTypeList = _accountTypeList.reversed.toList();
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
                                _accountTypeList.sort((user1, user2) => user1.updatedAt.compareTo(user2.updatedAt));
                                if (!ascending) {
                                  _accountTypeList = _accountTypeList.reversed.toList();
                                }
                              });
                            }),
                        DataColumn(
                          label: Text('Actions'),
                        ),
                      ],
                      rows: _accountTypeList.map((accountType) {
                        return DataRow(
                          key: ValueKey(accountType.id),
                          selected: _selectedAccountTypeList.any((selectedUser) => selectedUser.id == accountType.id),
                          onSelectChanged: (value) => _onSelectAccountTypeChanged(value, accountType),
                          cells: [
                            DataCell(Text(accountType.accountType)),
                            DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(accountType.createdAt.toLocal()))),
                            DataCell(Text(DateFormat('dd MMM yyyy hh:mm a').format(accountType.updatedAt.toLocal()))),
                            DataCell(
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: state is! GetAccountTypeLoadingItemState
                                        ? () {
                                            Navigator.of(context).pushNamed(EditAccountTypeScreen.routeName, arguments: accountType).then((value) {
                                              _refreshHandler();
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
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TextButton.icon(
                                    onPressed: state is! GetAccountTypeLoadingItemState
                                        ? () {
                                            _showAccountTypeDeleteConfirmation(accountType);
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
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _onSelectAllAccountType(value) {
    if (value) {
      setState(() {
        _selectedAccountTypeList.clear();
        _selectedAccountTypeList.addAll(_accountTypeList);
      });
    } else {
      setState(() {
        _selectedAccountTypeList.clear();
      });
    }
  }

  void _onSelectAccountTypeChanged(bool? value, AccountType accountType) {
    if (value!) {
      setState(() {
        _selectedAccountTypeList.add(accountType);
      });
    } else {
      setState(() {
        _selectedAccountTypeList.removeWhere((accType) => accType.id == accountType.id);
      });
    }
  }

  void _showAccountTypeDeleteConfirmation(AccountType accountType) {
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
                _getAccountTypeBloc.add(GetAccountTypeDeleteEvent(
                  accountTypeId: accountType.id,
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

  void showAccountTypeDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete All Account Type'),
          content: Text('Do you really want to delete this account types ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _getAccountTypeBloc.add(
                  GetAccountTypeDeleteAllEvent(
                    accountTypeList: _selectedAccountTypeList.map((item) {
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

  void _refreshHandler() {
    _getAccountTypeBloc.add(GetAccountTypeDataEvent());
  }
}
