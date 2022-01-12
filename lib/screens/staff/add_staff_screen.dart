import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account_type/get_account_type/get_account_type_bloc.dart';
import '../../bloc/staff/add_staff/add_staff_bloc.dart';
import '../../bloc/staff/get_permissions/get_permissions_bloc.dart';
import '../../models/account_type.dart';
import '../../models/local_permission.dart';
import '../../models/permission_group.dart';
import '../../utils/validators.dart';
import '../../widgets/back_button.dart';
import '../../widgets/permission_group_item_widget.dart';
import '../responsive_layout.dart';

class AddStaffScreen extends StatefulWidget {
  static const routeName = '/add-staff';

  AddStaffScreen({Key? key}) : super(key: key);

  @override
  _AddStaffScreenState createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  bool _isInit = true;

  final AddStaffBloc _addStaffBloc = AddStaffBloc();
  final GetPermissionsListBloc _getPermissionsListBloc = GetPermissionsListBloc();
  final GetAccountTypeBloc _getAccountTypeBloc = GetAccountTypeBloc();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _staffData = {
    'email_id': '',
    'password': '',
    'name': '',
    'account_type_id': 0,
    'permissions_arr': [],
  };

  final _passwordController = TextEditingController();
  var _passwordVisible = false;
  var _confirmPasswordVisible = false;

  List<AccountType> _accountTypeList = [];

  List<PermissionGroup> _permissionGroupList = [];
  List<LocalPermission> _localPermissionList = [];

  Future<void> _showSnackMessage(String message) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _staffData['permissions_arr'] = _localPermissionList.map((per) => LocalPermission.toJson(per)).toList();
    _addStaffBloc.add(AddStaffRegisterEvent(
      staffData: _staffData,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getAccountTypeBloc.add(GetAccountTypeDataEvent());
      _getPermissionsListBloc.add(GetPermissionsListDataEvent());
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5));

    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<AddStaffBloc, AddStaffState>(
            bloc: _addStaffBloc,
            listener: (context, state) {
              if (state is AddStaffSuccessState) {
                Navigator.of(context).pop(state.staff);
              } else if (state is AddStaffFailureState) {
                _showSnackMessage(state.message);
              } else if (state is AddStaffExceptionState) {
                _showSnackMessage(state.message);
              }
            },
            builder: (context, state) {
              return state is AddStaffLoadingState
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ResponsiveLayout(
                      smallScreen: _buildMobileTabletView(context, mediaQuery, screenHeight, enabledBorder),
                      mediumScreen: _buildMobileTabletView(context, mediaQuery, screenHeight, enabledBorder),
                      largeScreen: _buildWebView(context, mediaQuery, screenHeight, enabledBorder, screenWidth),
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileTabletView(BuildContext context, MediaQueryData mediaQuery, double screenHeight, enabledBorder) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: BackButtonNew(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'Add Staff',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    _buildNameInputField(enabledBorder, context),
                    SizedBox(height: 10),
                    _accountTypeInputField(
                      enabledBorder,
                    ),
                    SizedBox(height: 10),
                    _buildEmailInputField(enabledBorder, context),
                    SizedBox(height: 10),
                    _buildPasswordInputField(enabledBorder, context),
                    SizedBox(height: 10),
                    _buildConfirmPasswordInputField(enabledBorder, context),
                    SizedBox(height: 20),
                    BlocConsumer<GetPermissionsListBloc, GetPermissionsListState>(
                      bloc: _getPermissionsListBloc,
                      listener: (context, state) {
                        if (state is GetPermissionsListSuccessState) {
                          _permissionGroupList = state.permissionGroupList;
                        } else if (state is GetPermissionsListFailureState) {
                          _permissionGroupList = state.permissionGroupList;
                        } else if (state is GetPermissionsListExceptionState) {
                          _permissionGroupList = state.permissionGroupList;
                        }
                      },
                      builder: (context, state) {
                        return state is GetPermissionsLoadingState
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                child: ListView.builder(
                                  itemCount: _permissionGroupList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return PermissionGroupItemWidget(
                                      permissionGroup: _permissionGroupList[index],
                                      isGroupSelected: _permissionGroupList[index].permissions.length != 0
                                          ? _localPermissionList.where((item) => item.permissionGroupId == _permissionGroupList[index].id).toList().length ==
                                              _permissionGroupList[index].permissions.length
                                          : _localPermissionList.any((element) => element.permissionGroupId == _permissionGroupList[index].id),
                                      localPermissionList: _localPermissionList,
                                      onPermissionGroupAdded: (PermissionGroup permissionGroup) {
                                        setState(() {
                                          if (permissionGroup.permissions.length > 0) {
                                            permissionGroup.permissions.forEach((item) {
                                              bool isExist = _localPermissionList.any((ele) => ele.permissionId == item.id && ele.permissionGroupId == item.groupId);
                                              if (!isExist) {
                                                _localPermissionList.add(
                                                  LocalPermission(permissionGroupId: permissionGroup.id, permissionId: item.id),
                                                );
                                              }
                                            });
                                          } else {
                                            bool isExist = _localPermissionList.any((ele) => ele.permissionGroupId == permissionGroup.id);
                                            if (!isExist) {
                                              _localPermissionList.add(
                                                LocalPermission(permissionGroupId: permissionGroup.id, permissionId: 0),
                                              );
                                            }
                                          }
                                        });
                                      },
                                      onPermissionGroupRemoved: (PermissionGroup permissionGroup) {
                                        setState(() {
                                          _localPermissionList.removeWhere((item) => item.permissionGroupId == permissionGroup.id);
                                        });
                                      },
                                      onPermissionAdded: (value) {
                                        setState(() {
                                          bool isExist = _localPermissionList.any((ele) => ele.permissionId == value.id && ele.permissionGroupId == value.groupId);
                                          if (!isExist) {
                                            _localPermissionList.add(
                                              LocalPermission(permissionGroupId: value.groupId, permissionId: value.id),
                                            );
                                          }
                                        });
                                      },
                                      onPermissionRemoved: (value) {
                                        setState(() {
                                          _localPermissionList.removeWhere((item) => item.permissionId == value.id);
                                        });
                                      },
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      child: _submitButton(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebView(BuildContext context, MediaQueryData mediaQuery, double screenHeight, enabledBorder, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: BackButtonNew(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'Add Staff',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
              SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    _buildNameInputField(enabledBorder, context),
                    SizedBox(height: 10),
                    _accountTypeInputField(
                      enabledBorder,
                    ),
                    SizedBox(height: 10),
                    _buildEmailInputField(enabledBorder, context),
                    SizedBox(height: 10),
                    _buildPasswordInputField(enabledBorder, context),
                    SizedBox(height: 10),
                    _buildConfirmPasswordInputField(enabledBorder, context),
                    SizedBox(height: 20),
                    BlocConsumer<GetPermissionsListBloc, GetPermissionsListState>(
                      bloc: _getPermissionsListBloc,
                      listener: (context, state) {
                        if (state is GetPermissionsListSuccessState) {
                          _permissionGroupList = state.permissionGroupList;
                        } else if (state is GetPermissionsListFailureState) {
                          _permissionGroupList = state.permissionGroupList;
                        } else if (state is GetPermissionsListExceptionState) {
                          _permissionGroupList = state.permissionGroupList;
                        }
                      },
                      builder: (context, state) {
                        return state is GetPermissionsLoadingState
                            ? Center(child: CircularProgressIndicator())
                            : Container(
                                child: ListView.builder(
                                  itemCount: _permissionGroupList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return PermissionGroupItemWidget(
                                      permissionGroup: _permissionGroupList[index],
                                      isGroupSelected: _permissionGroupList[index].permissions.length != 0
                                          ? _localPermissionList.where((item) => item.permissionGroupId == _permissionGroupList[index].id).toList().length ==
                                              _permissionGroupList[index].permissions.length
                                          : _localPermissionList.any((element) => element.permissionGroupId == _permissionGroupList[index].id),
                                      localPermissionList: _localPermissionList,
                                      onPermissionGroupAdded: (PermissionGroup permissionGroup) {
                                        setState(() {
                                          if (permissionGroup.permissions.length > 0) {
                                            permissionGroup.permissions.forEach((item) {
                                              bool isExist = _localPermissionList.any((ele) => ele.permissionId == item.id && ele.permissionGroupId == item.groupId);
                                              if (!isExist) {
                                                _localPermissionList.add(
                                                  LocalPermission(permissionGroupId: permissionGroup.id, permissionId: item.id),
                                                );
                                              }
                                            });
                                          } else {
                                            bool isExist = _localPermissionList.any((ele) => ele.permissionGroupId == permissionGroup.id);
                                            if (!isExist) {
                                              _localPermissionList.add(
                                                LocalPermission(permissionGroupId: permissionGroup.id, permissionId: 0),
                                              );
                                            }
                                          }
                                        });
                                      },
                                      onPermissionGroupRemoved: (PermissionGroup permissionGroup) {
                                        setState(() {
                                          _localPermissionList.removeWhere((item) => item.permissionGroupId == permissionGroup.id);
                                        });
                                      },
                                      onPermissionAdded: (value) {
                                        setState(() {
                                          bool isExist = _localPermissionList.any((ele) => ele.permissionId == value.id && ele.permissionGroupId == value.groupId);
                                          if (!isExist) {
                                            _localPermissionList.add(
                                              LocalPermission(permissionGroupId: value.groupId, permissionId: value.id),
                                            );
                                          }
                                        });
                                      },
                                      onPermissionRemoved: (value) {
                                        setState(() {
                                          _localPermissionList.removeWhere((item) => item.permissionId == value.id);
                                        });
                                      },
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      width: 200,
                      child: _submitButton(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildNameInputField(enabledBorder, BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Name',
        prefixIcon: Icon(Icons.person),
        border: enabledBorder,
      ),
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a name!';
        }
        return null;
      },
      onSaved: (value) {
        _staffData['name'] = value;
        print(value);
      },
    );
  }

  TextFormField _buildConfirmPasswordInputField(enabledBorder, BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: enabledBorder,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _confirmPasswordVisible = !_confirmPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_confirmPasswordVisible,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a confirm password!';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match!';
        }
        return null;
      },
    );
  }

  TextFormField _buildPasswordInputField(enabledBorder, BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Password',
        border: enabledBorder,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
      obscureText: !_passwordVisible,
      controller: _passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a password!';
        }
        if (value.length < 8) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) {
        print(value);
        _staffData['password'] = value;
      },
    );
  }

  TextFormField _buildEmailInputField(enabledBorder, BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: enabledBorder,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a email!';
        }
        if (!Validators.isValidEmail(value)) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        print(value);
        _staffData['email_id'] = value;
      },
    );
  }

  Widget _accountTypeInputField(
    enabledBorder,
  ) {
    return BlocConsumer<GetAccountTypeBloc, GetAccountTypeState>(
      bloc: _getAccountTypeBloc,
      listener: (context, state) {
        if (state is GetAccountTypeSuccessState) {
          _accountTypeList = state.accountTypeList;
        } else if (state is GetAccountTypeFailedState) {
          _accountTypeList = state.accountTypeList;
        } else if (state is GetAccountTypeExceptionState) {
          _accountTypeList = state.accountTypeList;
        }
      },
      builder: (context, state) {
        return state is GetAccountTypeLoadingState
            ? TextFormField(
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Please wait..',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.text,
                showCursor: false,
                readOnly: true,
                autofocus: false,
              )
            : DropdownButtonFormField<AccountType>(
                decoration: InputDecoration(
                  // hintText: 'Account Type',
                  prefixIcon: Icon(Icons.people),
                  labelText: 'Staff Type',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  border: enabledBorder,
                ),
                items: _accountTypeList.map((accountType) {
                  return DropdownMenuItem<AccountType>(
                    value: accountType,
                    child: Text(
                      accountType.accountType,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select account type';
                  }
                  return null;
                },
                onChanged: (value) {
                  _staffData['account_type_id'] = value!.id;
                },
                onSaved: (newValue) {
                  _staffData['account_type_id'] = newValue!.id;
                },
              );
      },
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        primary: Theme.of(context).colorScheme.secondary,
        onPrimary: Colors.white,
      ),
      child: Text(
        'Submit',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      onPressed: _submit,
    );
  }
}
