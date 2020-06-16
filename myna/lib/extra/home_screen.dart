import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../profile_image_upload/image_picker_dialog.dart';
import '../profile_image_upload/image_picker_handler.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin,ImagePickerListener{

  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

submit_photo() async {    

      Map<String, String> headers ={ 'Authorization': ('Token ' ), };  
      var uri = Uri.parse("http://192.168.43.178:8080/profile_image/");
     var request = new http.MultipartRequest("POST", uri);  
      request.headers.addAll(headers);  

      File imageFile = _image;
      var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title,
        style: new TextStyle(
          color: Colors.white
        ),
        ),
      ),
      body: new GestureDetector(
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
                    border:
                        Border.all(color: Colors.red, width: 5.0),
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
                          style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                      onPressed: (){
                          submit_photo();
                        },
                    ),

                ],
                ),

              ),
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