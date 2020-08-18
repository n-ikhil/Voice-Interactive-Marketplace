const functions = require("firebase-functions");
const express = require("express");
const admin = require("firebase-admin");
const utility = require("./utility");
//https://medium.com/@savinihemachandra/creating-rest-api-using-express-on-cloud-functions-for-firebase-53f33f22979c
admin.initializeApp(functions.config().firebase);
const app = express();
const main = express();

main.use("/api/v1", app);

const db = admin.firestore();
const productDB = db.collection("product");

exports.webApi = functions.https.onRequest(main);

// input is obj with data: "this is a sample query"

app.post("/product_id", async (req, res) => {
  // console.log(req);
  if (!("data" in req.body)) {
    return res.status(400).send("failed");
  }
  console.log("1");
  const inputQuery = req.body["data"];
  console.log(inputQuery);

  const nouns = utility.extractingNouns(inputQuery);
  console.log(nouns);

  var resultProductIDs = [];
  const minNounLength = 4;
  if (nouns.length === 0) {
    print("no nouns found");
    return res.status(400).send("no nouns found in the query");
  } else {
    try {
      const allProducts = await productDB.get();
      allProducts.forEach((snap) => {
        const curItem = snap.data();
        if (nouns.indexOf(curItem.name) > -1) {
          resultProductIDs.push({ id: snap.id, name: curItem["name"] });
        }
      });
    } catch (error) {
      return res.status(400).send(error);
    }
  }
  return res.status(200).send(resultProductIDs);
});
