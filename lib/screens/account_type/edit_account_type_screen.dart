import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/widgets/drawer/main_drawer.dart';

import '../../bloc/account_type/edit_account_type/edit_account_type_bloc.dart';
import '../../models/account_type.dart';
import '../../widgets/back_button.dart';
import '../responsive_layout.dart';

class EditAccountTypeScreen extends StatefulWidget {
  static const routeName = '/edit-account-type';

  @override
  _EditAccountTypeScreenState createState() => _EditAccountTypeScreenState();
}

class _EditAccountTypeScreenState extends State<EditAccountTypeScreen> {
  bool _isInit = true;

  final EditAccountTypeBloc _editAccountTypeBloc = EditAccountTypeBloc();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> _editAccountTypeMap = {
    'id': 0,
    'account_type': '',
  };

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    _editAccountTypeBloc.add(EditAccountTypeEditEvent(
      editAccountData: _editAccountTypeMap,
    ));
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final accountType = ModalRoute.of(context)!.settings.arguments as AccountType;
      _editAccountTypeMap = {
        'id': accountType.id,
        'account_type': accountType.accountType,
      };
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<EditAccountTypeBloc, EditAccountTypeState>(
          bloc: _editAccountTypeBloc,
          listener: (context, state) {
            if (state is EditAccountTypeSuccessState) {
              Navigator.of(context).pop(state.accountType);
            } else if (state is EditAccountTypeFailureState) {
              _showSnackMessage(state.message);
            } else if (state is EditAccountTypeExceptionState) {
              _showSnackMessage(state.message);
            }
          },
          builder: (context, state) {
            return state is EditAccountTypeLoadingState
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ResponsiveLayout(
                    smallScreen: _buildMobileTabletView(context, mediaQuery, screenHeight),
                    mediumScreen: _buildMobileTabletView(context, mediaQuery, screenHeight),
                    largeScreen: _buildWebView(context, mediaQuery, screenHeight, screenWidth),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildMobileTabletView(BuildContext context, MediaQueryData mediaQuery, double screenHeight) {
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
                    'Edit Main Category',
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
              SizedBox(
                height: 10,
              ),
              _accountTypeInputField(),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                width: 200,
                child: _updateButton(),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebView(BuildContext context, MediaQueryData mediaQuery, double screenHeight, double screenWidth) {
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
                    'Edit Main Category',
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
              SizedBox(
                height: 10,
              ),
              _accountTypeInputField(),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                width: 200,
                child: _updateButton(),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _updateButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        primary: Theme.of(context).accentColor,
        onPrimary: Colors.white,
      ),
      child: Text(
        'Update',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      onPressed: _submit,
    );
  }

  TextFormField _accountTypeInputField() {
    return TextFormField(
      initialValue: _editAccountTypeMap['account_type'],
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Account Type',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Required Field';
        }
        return null;
      },
      onSaved: (newValue) {
        _editAccountTypeMap['account_type'] = newValue!.trim();
      },
    );
  }
}
