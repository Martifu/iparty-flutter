import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatelessWidget {

  TabScreen(this.listType);
  final String listType;

  @override
  Widget build(BuildContext context) {
    final items = List<String>.generate(50, (i) => "Item $i");

    return Theme(
      data: ThemeData(
        accentColor: Color(0xffDA4720),
        accentTextTheme: TextTheme(bodyText1: TextStyle()),
        brightness: Brightness.dark,
        primaryColor: Color(0xff219762),
         backgroundColor: Color(0xFF191719)
      ),
          child:  Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
        body:  ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${items[index]}'),
                );
              },
            )

      ),
    );
  }
}