import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        SingleChildScrollPage.ROUTE: (_) => SingleChildScrollPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StreamController<Settings> _streamController = StreamController<Settings>.broadcast();
  final ScrollController _scrollController = ScrollController();
  Settings _settings = Settings();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    drawer: Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            ListTile(
              title: Text("Scroll anchor"),
              trailing: DropdownButton<double>(
                value: _settings.anchor,
                items: [
                  DropdownMenuItem(
                    child: Text("0"),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text("0.5"),
                    value: .5,
                  ),
                  DropdownMenuItem(
                    child: Text("1"),
                    value: 1,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _settings.anchor = value;
                  });
                },
              ),
            ),
            SwitchListTile(
              title: Text("Render negative infinite list"),
              value: _settings.multiDirection,
              onChanged: (value) {
                setState(() {
                  _settings.multiDirection = value;
                });
              },
            ),
            ListTile(
              title: Text("Max number of items"),
              trailing: DropdownButton<int>(
                value: _settings.maxCount == null ? -1 : _settings.maxCount,
                items: [
                  DropdownMenuItem(
                    child: Text("Infinite"),
                    value: -1,
                  ),
                ]..addAll(
                    [0, 10, 20, 30, 40].map((value) => DropdownMenuItem(
                        child: Text(value.toString()),
                        value: value
                    ))
                ),
                onChanged: (value) {
                  setState(() {
                    _settings.maxCount = value == -1 ? null : value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Min number of items"),
              trailing: DropdownButton<int>(
                value: _settings.minCount == null ? -1 : _settings.minCount,
                items: [
                  DropdownMenuItem(
                    child: Text("Infinite"),
                    value: -1,
                  ),
                ]..addAll(
                    [0, -10, -20, -30, -40].map((value) => DropdownMenuItem(
                        child: Text(value.toString()),
                        value: value
                    ))
                ),
                onChanged: (value) {
                  setState(() {
                    _settings.minCount = value == -1 ? null : value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Header alignment"),
              trailing: DropdownButton<HeaderAlignment>(
                value: _settings.alignment,
                items: [
                  DropdownMenuItem(
                    child: Text("Top left"),
                    value: HeaderAlignment.topLeft,
                  ),
                  DropdownMenuItem(
                    child: Text("Top right"),
                    value: HeaderAlignment.topRight,
                  ),
                  DropdownMenuItem(
                    child: Text("Bottom left"),
                    value: HeaderAlignment.bottomLeft,
                  ),
                  DropdownMenuItem(
                    child: Text("Bottom right"),
                    value: HeaderAlignment.bottomRight,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _settings.alignment = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Scroll direction"),
              trailing: DropdownButton<Axis>(
                value: _settings.scrollDirection,
                items: [
                  DropdownMenuItem(
                    child: Text("Vertical"),
                    value: Axis.vertical,
                  ),
                  DropdownMenuItem(
                    child: Text("Horizontal"),
                    value: Axis.horizontal,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _settings.scrollDirection = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Scroll physics"),
              trailing: DropdownButton<ScrollPhysicsEnum>(
                value: _settings.physicsType,
                items: [
                  DropdownMenuItem(
                    child: Text("Platform"),
                    value: ScrollPhysicsEnum.PLATFORM,
                  ),
                  DropdownMenuItem(
                    child: Text("Android"),
                    value: ScrollPhysicsEnum.ANDROID,
                  ),
                  DropdownMenuItem(
                    child: Text("iOS"),
                    value: ScrollPhysicsEnum.IOS,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _settings.physicsType = value;
                  });
                },
              ),
            ),
            Center(
              child: RaisedButton(
                  child: Text("Scroll to center"),
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: Duration(seconds: 1),
                      curve: Curves.linearToEaseOut,
                    );
                  }
              ),
            ),
            Center(
              child: RaisedButton(
                  child: Text("Go to sigle example"),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SingleChildScrollPage.ROUTE);
                  }
              ),
            ),
          ],
        ),
      ),
    ),
    body: ScrollWidget(
      settings: _settings,
      scrollController: _scrollController,
      stream: _streamController.stream,
    ),
  );

  @override
  void dispose() {
    super.dispose();

    _streamController.close();
  }
}

class ScrollWidget extends StatelessWidget {
  final Stream<Settings> stream;
  final ScrollController scrollController;
  final Settings settings;

  const ScrollWidget({
    Key key,
    this.stream,
    this.scrollController,
    this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InfiniteList(
    /// when direction changes dynamically, Flutter
    /// won't rerender scroll completely,
    /// which means that gesture detector on scroll itself
    /// remains from original direction
    key: Key(settings.scrollDirection.toString()),
    scrollDirection: settings.scrollDirection,
    anchor: settings.anchor,
    controller: scrollController,
    direction: settings.multiDirection ? InfiniteListDirection.multi : InfiniteListDirection.single,
    minChildCount: settings.minCount,
    maxChildCount: settings.maxCount,
    physics: settings.physics,
    builder: (context, index) {
      final date = DateTime.now().add(
          Duration(
            days: index,
          )
      );

      return InfiniteListItem(
        headerAlignment: settings.alignment,
        headerStateBuilder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.withOpacity(1 - state.position),
            ),
            height: 70,
            width: 70,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat.MMM().format(date),
                  style: TextStyle(
                    height: .7,
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          );
        },
        contentBuilder: (context) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueAccent,
          ),
          margin: settings.contentMargin,
          padding: EdgeInsets.all(8),
          height: settings.contentHeight,
          width: settings.contentWidth,
          child: Text(
            DateFormat.yMMMMd().format(date),
            style: TextStyle(
                fontSize: 18,
                color: Colors.white
            ),
          ),
        ),
        minOffsetProvider: (state) => 80,
      );
    },
  );

}

enum ScrollPhysicsEnum {
  PLATFORM,
  IOS,
  ANDROID,
}

class Settings {
  int minCount;
  int maxCount;
  bool multiDirection;
  HeaderAlignment alignment;
  double anchor;
  Axis scrollDirection;
  ScrollPhysicsEnum physicsType;

  bool get scrollVertical => scrollDirection == Axis.vertical;

  ScrollPhysics get physics {
    switch (physicsType) {
      case ScrollPhysicsEnum.PLATFORM:
        return null;

      case ScrollPhysicsEnum.ANDROID:
        return ClampingScrollPhysics();

      case ScrollPhysicsEnum.IOS:
        return BouncingScrollPhysics();
    }

    return null;
  }

  double get contentHeight {
    if (scrollVertical) {
      return 300;
    }

    return double.infinity;
  }

  double get contentWidth {
    if (scrollVertical) {
      return double.infinity;
    }

    return 300;
  }

  EdgeInsets get contentMargin {
    if (scrollVertical) {
      if ([HeaderAlignment.topRight, HeaderAlignment.bottomRight].contains(this.alignment)) {
        return EdgeInsets.only(
          left: 10,
          top: 5,
          bottom: 5,
          right: 90,
        );
      }

      return EdgeInsets.only(
        left: 90,
        bottom: 5,
        top: 5,
        right: 10,
      );
    }

    if ([HeaderAlignment.topRight, HeaderAlignment.topLeft].contains(this.alignment)) {
      return EdgeInsets.only(
        left: 5,
        top: 90,
        bottom: 10,
        right: 5,
      );
    }

    return EdgeInsets.only(
      left: 5,
      bottom: 90,
      top: 10,
      right: 5,
    );
  }

  Settings({
    this.minCount,
    this.maxCount,
    this.alignment = HeaderAlignment.topLeft,
    this.multiDirection = false,
    this.anchor = 0,
    this.scrollDirection = Axis.vertical,
    this.physicsType = ScrollPhysicsEnum.PLATFORM,
  });
}



class SingleChildScrollPage extends StatefulWidget {
  static const String ROUTE = "/single-child";

  @override
  _SingleChildScrollPageState createState() => _SingleChildScrollPageState();
}

class _SingleChildScrollPageState extends State<SingleChildScrollPage> {
  static const double _headerHeight = 50;

  StreamController<StickyState<String>> _headerStream;

  @override
  void initState() {
    super.initState();

    _headerStream = StreamController<StickyState<String>>.broadcast();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Single element example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: height,
              color: Colors.lightBlueAccent,
              child: Placeholder(),
            ),
            StickyListItem<String>(
              streamSink: _headerStream.sink,
              minOffsetProvider: (_) => _headerHeight,
              header: Container(
                height: _headerHeight,
                width: double.infinity,
                color: Colors.orange,
                child: Center(
                  child: StreamBuilder<StickyState<String>>(
                    stream: _headerStream.stream,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      final position = (snapshot.data.position * 100).round();

                      return Text('Position: $position%');
                    },
                  ),
                ),
              ),
              content: Container(
                height: height - _headerHeight,
                padding: const EdgeInsets.only(top: _headerHeight),
                color: Colors.blueAccent,
                child: Placeholder(),
              ),
              itemIndex: "single-child",
            ),
            Container(
              height: height,
              color: Colors.cyan,
              child: Placeholder(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _headerStream.close();
  }
}
