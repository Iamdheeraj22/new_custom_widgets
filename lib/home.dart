import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> peoples = [
  "Mahendra Bahubali",
  "Devsena",
  "Kattpaa",
  "Maheshmati",
  "Bhalaldev",
];

List<String> _autocomplete = [];

bool _isEmpty = false;
String? selectedText = "";
TextEditingController controller = TextEditingController();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _autocomplete = peoples;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: Colors.cyan,
        child: Stack(
          children: [
            Center(
              child: Text(
                controller.text.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 48, left: 2, right: 2),
                padding: const EdgeInsets.only(bottom: 5),
                child: Visibility(
                    visible: _isEmpty,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListView.builder(
                          itemCount: _autocomplete.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = _autocomplete.elementAt(index);
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedText = _autocomplete[index];
                                  controller.text =
                                      "${controller.text} $selectedText";
                                  selectedText = "";
                                  _isEmpty = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 12, right: 12),
                                child: SubstringHighlight(
                                  text: "@" + item,
                                  term: controller.text,
                                  textStyleHighlight:
                                      TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            );
                          }),
                    )),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 55,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1)),
                child: TextField(
                  controller: controller,
                  onChanged: (vl) {
                    check(vl);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  check(String vl) {
    if (vl.isEmpty) {
      setState(() {
        _isEmpty = false;
      });
    } else {
      List<String> results = [];
      if (vl.startsWith("@") && vl.length == 1) {
        _isEmpty = true;
        results = peoples;
      } else {
        setState(() {
          _isEmpty = true;
          var x = vl.substring(1);
          if (x.isNotEmpty) {
            results = peoples
                .where((user) => user.toLowerCase().contains(x.toLowerCase()))
                .toList();
          }
        });
      }
      setState(() {
        _autocomplete = results;
      });
    }
  }
}
