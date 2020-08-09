import 'package:flutter/material.dart';
import 'package:myna/components/ListItem.dart';
import 'package:myna/components/Loading.dart';
import 'package:myna/constants/variables/ROUTES.dart';
import 'package:myna/main.dart';

// https://medium.com/@thedome6/how-to-create-a-searchable-filterable-listview-in-flutter-4faf3e300477

class SearchableList extends StatefulWidget {
  final List<dynamic> list;
  final Function fetch;

  SearchableList({this.list, this.fetch});

  @override
  State<StatefulWidget> createState() => _SearchableListState();
}

class _SearchableListState extends State<SearchableList> {
  TextEditingController controller = TextEditingController();
  String filter, loadMsg = "";
  int loadState = 1, strLenTriggerSearch = 3; // 1 loading, 2 loaded
  List<dynamic> resList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                labelText: "search here...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
            controller: controller,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(this.loadMsg),
          ),
          this.loadState == 2
              ? Expanded(
                  child: ListView.builder(
                      itemCount: resList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return filter == null || filter == ""
                            ? ListItem(resList[index].name, () {
                                Navigator.pushNamed(context, itemList,
                                    arguments: {"id": resList[index].id});
                              })
                            : resList[index]
                                    .name
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? ListItem(resList[index].name, () {
                                    Navigator.pushNamed(context, itemList,
                                        arguments: {"id": resList[index].id});
                                  })
                                : Container();
                      }))
              : LoadingWidget()
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    strLenTriggerSearch = context
        .dependOnInheritedWidgetOfExactType<MyInheritedWidget>()
        .firebaseInstance
        .firestoreClient
        .constantClient.constants["strLenTriggerSearch"];
  }

  @override
  void didUpdateWidget(SearchableList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.list != null) {
      resList = widget.list;
      loadState = 2;
    }
  }

  @override
  initState() {
    super.initState();
    if (widget.list != null) {
      resList = widget.list;
      loadState = 2;
    }
    if (widget.list == null && widget.fetch != null) {
      resList = [];
      loadState = 2;
    }

    controller.addListener(() {
      if (controller.text.length == strLenTriggerSearch) {
        if (widget.fetch != null) initFetching(controller.text);
      }
      setState(() {
        filter = controller.text;
      });
    });
  }

  void initFetching(String str) {
    this.setState(() {
      loadMsg = "loading";
      loadState = 1;
    });
    this.startFetching(str);
  }

  void startFetching(String str) {
    if (widget.fetch != null) {
      widget.fetch(str).then((data) {
        this.endFetching(data);
      });
    }
  }

  void endFetching(List<dynamic> data) {
    this.setState(() {
      loadMsg = data.isEmpty ? "No results found" : "results";
      resList = data;
      loadState = 2;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
