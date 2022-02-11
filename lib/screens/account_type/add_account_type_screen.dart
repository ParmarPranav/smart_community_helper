import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/account_type/add_account_type/add_account_type_bloc.dart';
import 'package:food_hunt_admin_app/utils/project_constant.dart';
import 'package:food_hunt_admin_app/widgets/back_button.dart';

import '../responsive_layout.dart';

class AddAccountTypeScreen extends StatefulWidget {
  static const routeName = '/add-account-type';

  @override
  _AddAccountTypeScreenState createState() => _AddAccountTypeScreenState();
}

class _AddAccountTypeScreenState extends State<AddAccountTypeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AddAccountTypeBloc _accountTypeBloc = AddAccountTypeBloc();
  final Map<String, dynamic> _addAccountTypeMap = {
    'account_type': '',
    'created_by': '',
  };

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    _accountTypeBloc.add(AddAccountTypeAddEvent(
      addAccountTypeData: _addAccountTypeMap,
    ));
  }

  void _showSnackMessage(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: ProjectConstant.WorkSansFontRegularTextStyle(
          fontSize: 18,
          fontColor: Colors.black,
        ),),
        duration: Duration(seconds: 2),
      ),
    );
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
        body: BlocConsumer<AddAccountTypeBloc, AddAccountTypeState>(
          bloc: _accountTypeBloc,
          listener: (context, state) {
            if (state is AddAccountTypeSuccessState) {
              Navigator.of(context).pop(state.accountType);
            } else if (state is AddAccountTypeFailureState) {
              _showSnackMessage(state.message);
            } else if (state is AddAccountTypeExceptionState) {
              _showSnackMessage(state.message);
            }
          },
          builder: (context, state) {
            return state is AddAccountTypeLoadingState
                ? const Center(
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
                    'Add Account Type',
                    style: ProjectConstant.WorkSansFontBoldTextStyle(
                      fontSize: 20,
                      fontColor: Colors.black,
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
              _mainCategoryNameInputField(),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 55,
                width: 200,
                child: _submitButton(),
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
                    'Add Account Type',
                    style: ProjectConstant.WorkSansFontBoldTextStyle(
                      fontSize: 20,
                      fontColor: Colors.black,
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
              _mainCategoryNameInputField(),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                width: 200,
                child: _submitButton(),
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

  TextFormField _mainCategoryNameInputField() {
    return TextFormField(
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
        _addAccountTypeMap['account_type'] = newValue!.trim();
      },
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        primary: Theme.of(context).primaryColor,
        onPrimary: Colors.white,
      ),
      child: Text(
        'Submit',
        style: ProjectConstant.WorkSansFontSemiBoldTextStyle(
          fontSize: 18,
          fontColor: Colors.black,
        ),
      ),
      onPressed: _submit,
    );
  }
}
