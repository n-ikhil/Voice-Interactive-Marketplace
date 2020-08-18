import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  String _userID;
  String _emailID;
  String _nickName;
  String _userFirstName;
  String _userLastName;
  String _Address;
  String _mobileNo;

  UserDetail(this._userID, this._emailID, this._nickName, this._userFirstName,
      this._userLastName, this._Address, this._mobileNo);
  UserDetail.fromSnapshot(DocumentSnapshot data) {
    this._userID = data.data["uid"];
    this._emailID = data.data["email"];
    this._nickName = data.data["nickName"];
    this._userFirstName = data.data["userFistName"];
    this._userLastName = data.data["userLastName"];
    this._Address = data.data["address"];
    this._mobileNo = data.data["mobileNo"];
  }

  String get userID => _userID;

  String get emailID => _emailID;

  String get nickName => _nickName;

  String get userFistName => _userFirstName;

  String get userLastName => _userLastName;

  String get address => _Address;

  String get mobileNo => _mobileNo;

  String get userFirstName => _userFirstName;
}
