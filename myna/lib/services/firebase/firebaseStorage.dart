import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class firebaseClientStorage {
  FirebaseStorage _storage;

  firebaseClientStorage() {
    _storage = FirebaseStorage();
  }

  Future uploadItemImage(File image, String imageName) async {
    print(imageName);
    StorageTaskSnapshot snapshot =
        await _storage.ref().child(imageName).putFile(image).onComplete;
    String url;
    print(snapshot.error.toString() + "errors uploading");
    if (snapshot.error == null) {
      print(snapshot.toString() + " sucess");
      url = await snapshot.ref.getDownloadURL();
    }
    return url;
  }
}
