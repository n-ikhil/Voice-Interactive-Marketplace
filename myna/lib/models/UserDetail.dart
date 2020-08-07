import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  String _EmailId;
  String _nickName;
  String _userFistName;
  String _userLastName;
  String _Address;
  int    _mobileNo;

  UserDetail(this._EmailId, this._nickName, this._userFistName,
      this._userLastName, this._Address, this._mobileNo);

  UserDetail.fromSnapshot(DocumentSnapshot data) {
    this._EmailId = data.documentID;
    this._nickName = data.data["nickName"];
    this._userFistName = data.data["userFistName"];
    this._userLastName = data.data["userLastName"];
    this._Address = data.data["address"];
    this._mobileNo = data.data["mobileNo"];
  }

  String get EmailId => _EmailId;

  String get nickName => _nickName;

  String get userFistName => _userFistName;

  String get userLastName => _userLastName;

  String get Address => _Address;

  int get mobileNo => _mobileNo;

}
