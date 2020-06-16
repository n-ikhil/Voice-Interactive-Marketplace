import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//import 'package:myna/chat_Page.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import '../profile_image_upload/image_picker_dialog.dart';
import 'package:async/async.dart';
import '../model/contact.dart';
import 'buyer/buyer_ui.dart';

enum AuthMode { LOGIN, SINGUP }

class SigninPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SigninPage>
    with TickerProviderStateMixin, ImagePickerListener {

  double screenHeight;
  AuthMode _authMode = AuthMode.LOGIN;
  String _email;
  String _password;
  bool _location = false;
  File _image;
  List<String> _userTypes = <String>['', 'supplier', 'screen.seller.buyer'];
  List<String> category_list = <String>[
    '',
    'seeds',
    'chemical',
    'instruments',
    'vehicles'
  ];
  String _userType = '';
  String category = '';
  Contact newContact = new Contact();
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  validateAndSubmit(BuildContext context) {
    setState(() {});
    String userId = _email;
    print('Signed in: $userId, with password $_password .');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatBoatScreen()),
    );
  }

  void submit_photo() async {
    Map<String, String> headers = {
      'Authorization': ('Token '),
    };
    var uri = Uri.parse("http://192.168.43.178:8080/profile_image/");
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);

    File imageFile = _image;
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    request.files.add(new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path)));

    var response = await request.send();
    print("nice");
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  bool isValidEmail(String input) {
    if (input.isEmpty)
      return false;
    else {
      final RegExp regex = new RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
      return regex.hasMatch(input);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            lowerHalf(context),
            upperHalf(context),
            _authMode == AuthMode.LOGIN
                ? loginCard(context)
                : singUpCard(context),
            pageTitle(),
          ],
        ),
      ),
    );
  }

  Widget showAddphoto() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Icon(
        Icons.add_a_photo,
        color: Colors.brown[400],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.home,
            size: 48,
            color: Colors.lightGreen[700],
          ),
          Text(
            "Myna App",
            style: TextStyle(
              fontSize: 34,
              color: Colors.yellow[900],
              fontWeight: FontWeight.bold,
              background: Paint()..color = Colors.yellowAccent[100],
            ),
          )
        ],
      ),
    );
  }

  Widget loginCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 4),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => isValidEmail(value)
                        ? null
                        : 'Please enter a valid email address',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'Enter a password',
                      labelText: 'password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {},
                        child: Text("Forgot Password ?"),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      FlatButton(
                        child: Text("Login"),
                        color: Color(0xFF4B9DFE),
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        // onPressed:  _submitForm,
                        onPressed: validateAndSubmit(context),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "Don't have an account ?",
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.SINGUP;
                });
              },
              textColor: Colors.black87,
              child: Text("Create Account"),
            )
          ],
        )
      ],
    );
  }

  bool isValidPhoneNumber(String input) {
    print(input);
    final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }

  Widget _showPic(BuildContext context) {
    return new GestureDetector(
      onTap: () => imagePicker.showDialog(context),
      child: new Center(
        child: _image == null
            ? new Stack(
                children: <Widget>[
                  new Center(
                    child: new CircleAvatar(
                      radius: 80.0,
                      backgroundColor: const Color(0xFF778899),
                    ),
                  ),
                  new Center(
                    child: new Image.asset("assets/photo_camera.png"),
                  ),
                ],
              )
            : new Column(
                children: <Widget>[
                  Container(
                    height: 160.0,
                    width: 160.0,
                    decoration: new BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: new DecorationImage(
                        // image: new ExactAssetImage(_image.path),
                        image: FileImage(_image),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.red, width: 5.0),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(80.0)),
                    ),
                  ),
                  new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue,
                    child: new Text('Upload',
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.white)),
                    onPressed: () {
                      submit_photo();
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Widget singUpCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: screenHeight / 5),
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _showPic(context),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter the your name',
                      labelText: 'Your Name',
                    ),
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      new WhitelistingTextInputFormatter(
                          new RegExp(r'^[()\d -]{1,15}$')),
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (val) {},
                    validator: (value) {
                      return isValidPhoneNumber(value)
                          ? null
                          : 'Phone number must be entered as (###)###-####';
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'Enter a password',
                      labelText: 'password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'Enter the password again',
                      labelText: 'confirm password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.home),
                      hintText: 'Enter address',
                      labelText: 'Address',
                    ),
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                  Text(
                    " type manually or use Gps location",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Gps_location',
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.blue)),
                      new FloatingActionButton(
                          heroTag: "btn3",
                          child: this._location
                              ? Icon(Icons.gps_fixed)
                              : Icon(Icons.gps_not_fixed),
                          onPressed: () {
                            setState(
                              () {
                                _location = _location ? false : true;
                              },
                            );
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.group_add),
                          labelText: 'user_type',
                        ),
                        isEmpty: _userType == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            value: _userType,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                _userType = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _userTypes.map((String value) {
                              return new DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'Please select a user_type';
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _userType == "screen.seller.buyer"
                      ? Text("")
                      : new FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                icon: const Icon(Icons.category),
                                labelText: 'Category',
                              ),
                              isEmpty: category == '',
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton(
                                  value: category,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      category = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                  items: category_list.map((String value) {
                                    return new DropdownMenuItem(
                                      value: value,
                                      child: new Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                          validator: (val) {
                            return val != ''
                                ? null
                                : 'Please select a category';
                          },
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "* Password must be at least 8 characters and include a special character and number",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      FlatButton(
                        child: Text("Sign Up"),
                        color: Color(0xFF4B9DFE),
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 38, right: 38, top: 15, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text(
              "Already have an account?",
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  _authMode = AuthMode.LOGIN;
                });
              },
              textColor: Colors.black87,
              child: Text("Login"),
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FlatButton(
            child: Text(
              "Terms & Conditions",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/iitrpr_logo.jpeg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight / 2,
        color: Color(0xFFECF0F3),
      ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }
}
