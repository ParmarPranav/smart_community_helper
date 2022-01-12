import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt_admin_app/bloc/get_account_type_drop_down/get_account_type_drop_down_bloc.dart';
import 'package:food_hunt_admin_app/models/account_type_drop_down.dart';
import 'package:food_hunt_admin_app/screens/main_screen.dart';

import '../bloc/authentication_login/authentication_login_bloc.dart';
import '../screens/responsive_layout.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isInit = true;
  List<AccountTypeDropDown> _accountTypeList = [];

  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  final Map<String, dynamic> _loginData = {
    'email': '',
    'password': '',
    'account_type_id': 0,
  };
  var _loginPasswordVisible = false;

  Future<void> _login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    _loginFormKey.currentState!.save();
    BlocProvider.of<AuthenticationLoginBloc>(context).add(
      AuthenticationLoggedInEvent(
        data: _loginData,
      ),
    );
  }

  Future<void> _showSnackMessage(String message) async {
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
      BlocProvider.of<AuthenticationLoginBloc>(context).add(AuthenticationAutoLoggedInEvent());
      BlocProvider.of<GetAccountTypeDropDownBloc>(context).add(GetAccountTypeDropDownDataEvent());
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: screenWidth,
            height: screenHeight - mediaQuery.padding.top,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black38,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight - mediaQuery.padding.top,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResponsiveLayout(
                          smallScreen: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _loginMobileView(screenHeight, screenWidth, mediaQuery, context),
                          ),
                          mediumScreen: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _loginTabletView(screenHeight, screenWidth, mediaQuery, context),
                          ),
                          largeScreen: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _loginWebView(screenHeight, screenWidth, mediaQuery, context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginMobileView(
    double screenHeight,
    double screenWidth,
    MediaQueryData mediaQuery,
    BuildContext context,
  ) {
    return BlocListener<AuthenticationLoginBloc, AuthenticationLoginState>(
      listener: (context, state) {
        if (state is AuthenticationLoginSuccessState) {
          Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
        } else if (state is AuthenticationLoginFailureState) {
          _showSnackMessage(state.message);
        } else if (state is AuthenticationLoginExceptionState) {
          _showSnackMessage(state.message);
        }
      },
      child: BlocBuilder<AuthenticationLoginBloc, AuthenticationLoginState>(
        builder: (context, state) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildLogoWidget(
                    mediaQuery: mediaQuery,
                    screenHeight: screenHeight * 0.10,
                    screenWidth: 150,
                  ),
                  Container(
                    width: screenWidth * 0.80,
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _emailInputField(mediaQuery, context),
                          const SizedBox(
                            height: 10,
                          ),
                          _passwordInputField(context, mediaQuery),
                          const SizedBox(height: 10),
                          _accountTypeInputField(mediaQuery),
                          const SizedBox(height: 20),
                          state is AuthenticationLoginLoadingState
                              ? const CircularProgressIndicator()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: _loginButton(),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _loginTabletView(
    double screenHeight,
    double screenWidth,
    MediaQueryData mediaQuery,
    BuildContext context,
  ) {
    return BlocListener<AuthenticationLoginBloc, AuthenticationLoginState>(
      listener: (context, state) {
        if (state is AuthenticationLoginSuccessState) {
          Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
        } else if (state is AuthenticationLoginFailureState) {
          _showSnackMessage(state.message);
        } else if (state is AuthenticationLoginExceptionState) {
          _showSnackMessage(state.message);
        }
      },
      child: BlocBuilder<AuthenticationLoginBloc, AuthenticationLoginState>(
        builder: (context, state) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: screenWidth * 0.70,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildLogoWidget(
                    mediaQuery: mediaQuery,
                    screenHeight: screenHeight * 0.10,
                    screenWidth: 160,
                  ),
                  Container(
                    width: screenWidth * 0.60,
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _loginFormKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _emailInputField(mediaQuery, context),
                            const SizedBox(height: 10),
                            _passwordInputField(context, mediaQuery),
                            const SizedBox(height: 10),
                            _accountTypeInputField(mediaQuery),
                            const SizedBox(height: 20),
                            if (state is AuthenticationLoginLoadingState)
                              const CircularProgressIndicator()
                            else
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 200,
                                    child: _loginButton(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _loginWebView(
    double screenHeight,
    double screenWidth,
    MediaQueryData mediaQuery,
    BuildContext context,
  ) {
    return BlocListener<AuthenticationLoginBloc, AuthenticationLoginState>(
      listener: (context, state) {
        if (state is AuthenticationLoginSuccessState) {
          Navigator.of(context).pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
        } else if (state is AuthenticationLoginFailureState) {
          _showSnackMessage(state.message);
        } else if (state is AuthenticationLoginExceptionState) {
          _showSnackMessage(state.message);
        }
      },
      child: BlocBuilder<AuthenticationLoginBloc, AuthenticationLoginState>(
        builder: (context, state) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: screenWidth * 0.50,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth * 0.40,
                    child: _buildLogoWidget(
                      mediaQuery: mediaQuery,
                      screenWidth: 160,
                      screenHeight: screenHeight * 0.10,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.40,
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _loginFormKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _emailInputField(mediaQuery, context),
                            const SizedBox(height: 10),
                            _passwordInputField(context, mediaQuery),
                            const SizedBox(height: 10),
                            _accountTypeInputField(mediaQuery),
                            const SizedBox(height: 20),
                            if (state is AuthenticationLoginLoadingState)
                              const CircularProgressIndicator()
                            else
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 200,
                                    child: _loginButton(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _accountTypeInputField(MediaQueryData mediaQuery) {
    return BlocConsumer<GetAccountTypeDropDownBloc, GetAccountTypeDropDownState>(
      listener: (context, state) {
        if (state is GetAccountTypeDropDownSuccessState) {
          _accountTypeList = state.accountTypeList;
        } else if (state is GetAccountTypeDropDownFailedState) {
          _accountTypeList = state.accountTypeList;
          _showSnackMessage(state.message);
        } else if (state is GetAccountTypeDropDownExceptionState) {
          _accountTypeList = state.accountTypeList;
          _showSnackMessage(state.message);
        }
      },
      builder: (context, state) {
        if (state is GetAccountTypeDropDownLoadingState) {
          return const CircularProgressIndicator();
        } else {
          return DropdownButtonFormField<AccountTypeDropDown>(
            decoration: const InputDecoration(
              // hintText: 'Account Type',
              prefixIcon: Icon(Icons.people),
              labelText: 'Account Type',
              labelStyle: TextStyle(
                fontSize: 14,
              ),
            ),
            items: _accountTypeList.map((accountType) {
              return DropdownMenuItem<AccountTypeDropDown>(
                value: accountType,
                child: Text(
                  accountType.accountType,
                  style: const TextStyle(
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
              _loginData['account_type_id'] = value!.id;
              FocusScope.of(context).unfocus();
            },
            onSaved: (newValue) {
              _loginData['account_type_id'] = newValue!.id;
            },
          );
        }
      },
    );
  }

  Widget _buildLogoWidget({
    required MediaQueryData mediaQuery,
    required double screenHeight,
    required double screenWidth,
  }) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            "assets/images/app_logo.png",
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }

  Widget _emailInputField(MediaQueryData mediaQuery, BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        // hintText: 'Email',
        prefixIcon: Icon(
          Icons.email_outlined,
        ),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.grey,
        //     width: 1.0,
        //   ),
        //   borderRadius: BorderRadius.circular(12),
        // ),
      ),
      style: const TextStyle(
        fontSize: 14,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a email!';
        }
        if (!value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        _loginData['email'] = value!;
      },
    );
  }

  Widget _passwordInputField(BuildContext context, MediaQueryData mediaQuery) {
    return TextFormField(
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Password',
        // hintText: 'Password',
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.grey,
        //     width: 1.0,
        //   ),
        //   borderRadius: BorderRadius.circular(12),
        // ),
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _loginPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _loginPasswordVisible = !_loginPasswordVisible;
            });
          },
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
      ),
      obscureText: !_loginPasswordVisible,
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
        _loginData['password'] = value!;
      },
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        primary: Theme.of(context).primaryColor,
        onPrimary: Colors.white,
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      onPressed: _login,
    );
  }
}
