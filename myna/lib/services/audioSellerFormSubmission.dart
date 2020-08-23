import 'package:myna/models/Category.dart';
import 'package:myna/models/Item.dart';
import 'package:myna/services/SharedObjects.dart';
import 'package:myna/services/apiHandler.dart';

Future audioSellerFormSubmission(
    SharedObjects myModel, Map<String, dynamic> data) async {
  String newProductID, curProductID;
  curProductID = data.containsKey("productID") ? data["productID"] : "NA";
  curProductID = curProductID.toLowerCase();
  if (curProductID == "NA") {
    return Future.error("not found the product");
  }
  bool added = false;
  await productData(curProductID).then((onValue) async {
    print(onValue);
    if (onValue.isNotEmpty && onValue != null && onValue != "") {
      newProductID = onValue;
      added = true;
    }
  });
  if (!added) {
    newProductID = curProductID;
    Category cat = Category.asForm("misc", "misc");
    await myModel.firestoreClientInstance.categoryClient
        .storeSaveCategory("misc"); // just in case !
    await myModel.firestoreClientInstance.productClient
        .storeSaveProduct(cat, newProductID);
    added = true;
  }

  Item newIt;
  newIt = Item.asForm(
    contact: data.containsKey("contact") ? data["contact"] : "NA",
    description: data.containsKey("description") ? data["description"] : "NA",
    imgURL: data.containsKey("imgURL") ? data["imgURL"] : "NA",
    isRentable: data.containsKey("isRentable")
        ? (data["isRentable"] == "yes" ? true : false)
        : true,
    productID: newProductID,
    price: data.containsKey("price") ? int.parse(data["price"].toString()) : 0,
    ownerID: myModel.currentUser.userID,
    ownerNickName: myModel.currentUser.nickName,
    place: myModel.currentLocation.place.subAdministrativeArea +
        " " +
        myModel.currentLocation.place.subLocality,
    postalCode: myModel.currentLocation.place.postalCode,
  );

  await myModel.firestoreClientInstance.itemClient.storeSaveItem(newIt);
  print("saved");
}
