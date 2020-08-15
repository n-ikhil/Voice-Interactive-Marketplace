import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/constants/variables/common.dart';
import 'package:myna/models/Category.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/models/Product.dart';
import 'package:myna/services/sharedservices.dart';

class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // UserDetail curUser;
  Category curCategory;
  Product curProduct;
  bool isPublic = true;
  bool isRentable = false;
  bool showSpinner = false;
  sharedServices _sharedServices;

  List<Category> allCats = [];
  List<Product> allProds = [];

  FirebaseUser curUser;

  TextEditingController _newCategoryTextController;
  TextEditingController _newProductTextController;
  @override
  void initState() {
    _newCategoryTextController = TextEditingController();
    _newProductTextController = TextEditingController();
    this._sharedServices = sharedServices();
    super.initState();
    loadCategories();
    print(curUser);
    print("init state new item");
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
    setState(() {
      showSpinner = true;
    });
    curUser = _sharedServices.currentUser;
    print(curCategory);
    print(curProduct);
    print(curUser);
    String postalCode = await sharedServices.getPostalCode();
    print("current postal code $postalCode");
    Item _newItem = Item.asForm(
        productID: curProduct.id,
        ownerID: curUser.uid,
        isPublic: isPublic,
        postalCode: postalCode,
        isRentable: isRentable);
    await _sharedServices.FirestoreClientInstance.itemClient
        .storeSaveItem(_newItem)
        .then((_) {
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
          CheckboxListTile(
            title: Text("Show contact to public"),
            value: isPublic,
            onChanged: (bool newValue) {
              setState(() {
                isPublic = newValue;
              });
            },
            controlAffinity: ListTileControlAffinity.trailing,
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
}
