import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/Category.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/models/Product.dart';
import 'package:myna/services/sharedservices.dart';
import 'package:intl/intl.dart';

class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // UserDetail curUser;
  Category curCategory;
  Product curProduct;
  bool isRentable = false;
  bool showSpinner = false;
  sharedServices _sharedServices;
  Placemark place;
  File _image;
  String _imageName = "Add image";

  List<Category> allCats = [];
  List<Product> allProds = [];

  FirebaseUser curUser;

  TextEditingController _newPriceTextController;
  TextEditingController _newCategoryTextController;
  TextEditingController _newProductTextController;
  TextEditingController _newDescriptionTextController;
  TextEditingController _newContactTextController;

  @override
  void initState() {
    _sharedServices = sharedServices();
    _newPriceTextController = TextEditingController();
    _newCategoryTextController = TextEditingController();
    _newProductTextController = TextEditingController();
    _newDescriptionTextController = TextEditingController();
    _newContactTextController = TextEditingController();

    // this._sharedServices = sharedServices();
    super.initState();
    loadCategories();
    loadCurrentLocation();
  }

  void loadCurrentLocation() {
    sharedServices.getCurrentLocation().then((onValue) {
      this.setState(() {
        place = onValue;
      });
    });
  }

  void loadCategories() {
    this.setState(() {
      showSpinner = true;
    });
    this
        ._sharedServices
        .FirestoreClientInstance
        .categoryClient
        .storeGetCategories()
        .then((onValue) {
      this.setState(() {
        allCats = onValue;
        showSpinner = false;
      });
    }).catchError((_) {
      this.setState(() {
        this.showSpinner = false;
      });
    });
  }

  void loadProducts(String id) {
    this.setState(() {
      showSpinner = true;
    });
    this
        ._sharedServices
        .FirestoreClientInstance
        .productClient
        .storeGetProductsOnCategories(id)
        .then((onValue) {
      setState(() {
        this.allProds = onValue;
        this.showSpinner = false;
      });
    }).catchError((_) {
      this.setState(() {
        this.showSpinner = false;
      });
    });
  }

  void submitForm() async {
    curUser = _sharedServices.currentUser;

    if (place == null) {
      print("place not found; exiting submision");
    }
    setState(() {
      showSpinner = true;
    });
    String imgURL;
    if (_image != null) {
      print("saving  the image");
      String curDateTime =
          DateFormat('EEE|d|MMM-kk:mm:ss').format(DateTime.now());
      imgURL = await _sharedServices.FirestoreClientInstance.storageClient
          .uploadItemImage(_image, curUser.uid + ":" + curDateTime);
      print("image saved with url $imgURL");
      if (imgURL == null) {
        setState(() {
          showSpinner = false;
        });
        print("error uploading the image");
        return;
      }
    }
    print(curCategory);
    print(curProduct);
    print(curUser);
    String postalCode = place.postalCode;
    print("current postal code $postalCode");
    Item _newItem = Item.asForm(
        productID: curProduct.id,
        ownerID: curUser.uid,
        postalCode: postalCode,
        isRentable: isRentable,
        contact: _newContactTextController.text,
        description: _newDescriptionTextController.text,
        place: place.subAdministrativeArea + " " + place.subLocality,
        price: int.parse(_newPriceTextController.text),
        imgURL: imgURL);
    await _sharedServices.FirestoreClientInstance.itemClient
        .storeSaveItem(_newItem)
        .then((documentID) {
      print("saved the item");
      Navigator.pop(context);
    }).catchError((onError) {
      print("error saving");
    });
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(APP_NAME)),
      body: Column(
        children: <Widget>[
          DropdownButtonFormField(
            onChanged: (value) {
              if (value.id == "-1") {
                showNewCategoryDialog(context);
              } else {
                loadProducts(value.id);
                this.setState(() {
                  curCategory = value;
                });
              }
            },
            // initialValue: 'Male',
            hint: Text(
                curCategory != null ? curCategory.name : 'Select category'),
            items: [...allCats, Category.sample()]
                .map((cat) =>
                    DropdownMenuItem(value: cat, child: Text(cat.name)))
                .toList(),
          ),
          DropdownButtonFormField(
            onChanged: (value) {
              if (value.id == "-1") {
                showNewProductDialog(context);
              } else {
                this.setState(() {
                  curProduct = value;
                });
              }
            },
            hint: Text(curProduct != null ? curProduct.name : "Select Product"),
            items: [...allProds, Product.sample()]
                .map((prod) =>
                    DropdownMenuItem(value: prod, child: Text(prod.name)))
                .toList(),
          ),
          TextField(
            controller: _newPriceTextController,
            decoration: InputDecoration(labelText: "Expected price"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
          ),
          TextField(
            controller: _newContactTextController,
            decoration: InputDecoration(labelText: "contact number"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
          ),
          TextField(
            controller: _newDescriptionTextController,
            decoration: InputDecoration(
                labelText:
                    "description of item"), // Only numbers can be entered
          ),
          CheckboxListTile(
            title: Text("Availible for rent"),
            value: isRentable,
            onChanged: (bool newValue) {
              setState(() {
                isRentable = newValue;
              });
            },
            controlAffinity: ListTileControlAffinity.trailing,
          ),
          FlatButton.icon(
              onPressed: this.getImage,
              icon: Icon(Icons.image),
              label: Text(_imageName)),
          FlatButton.icon(
              onPressed: this.submitForm,
              icon: Icon(Icons.add),
              label: Text("submit")),
          showSpinner ? LoadingWidget() : Container(width: 0, height: 0),
        ],
      ),
    );
  }

  void showNewCategoryDialog(context) {
    showDialog(
        child: Dialog(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "add new category"),
                controller: _newCategoryTextController,
              ),
              FlatButton(
                child: Text("Save"),
                onPressed: () {
                  print("writing category");
                  setState(() {
                    showSpinner = true;
                  });
                  _sharedServices.FirestoreClientInstance.categoryClient
                      .storeSaveCategory(_newCategoryTextController.text)
                      .then((cat) {
                    print("At main");
                    print(cat);
                    setState(() {
                      curCategory = cat;
                      loadProducts(cat.id);
                      allCats = [...allCats, cat];
                      showSpinner = false;
                    });
                  }).catchError((onError) {
                    print(onError);
                    print("new category not written");
                    setState(() {
                      showSpinner = false;
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        context: context);
  }

  void showNewProductDialog(context) {
    showDialog(
        child: Dialog(
          child: Column(
            children: <Widget>[
              DropdownButtonFormField(
                value: curCategory,
                onChanged: (value) {
                  loadProducts(value.id);
                  this.setState(() {
                    curCategory = value;
                  });
                },
                // initialValue: 'Male',
                hint: Text(
                    curCategory != null ? curCategory.name : 'Select category'),
                items: allCats
                    .map((cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat.name)))
                    .toList(),
              ),
              TextField(
                decoration: InputDecoration(hintText: "add new product"),
                controller: _newProductTextController,
              ),
              FlatButton(
                child: Text("Save"),
                onPressed: () {
                  setState(() {
                    showSpinner = true;
                  });
                  _sharedServices.FirestoreClientInstance.productClient
                      .storeSaveProduct(
                          curCategory, _newProductTextController.text)
                      .then((onValue) {
                    setState(() {
                      curProduct = onValue;
                      allProds = [...allProds, curProduct];
                      showSpinner = false;
                    });
                    setState(() {
                      showSpinner = false;
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        context: context);
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageName = (image.path.split(Platform.pathSeparator).last);
      _image = image;
    });
  }
}
