import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Hexagon Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int depth = 1;
  List<int> depths = [0, 1, 2, 3, 4];
  HexagonType type = HexagonType.FLAT;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Grid'),
              Tab(text: 'V-Offset-Grid'),
              Tab(text: 'H-Offset-Grid'),
              Tab(text: 'Other'),
            ],
          ),
          title: Text(widget.title),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                Positioned.fill(child: _buildGrid(type)),
                Align(
                  alignment: Alignment.topRight,
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<HexagonType>(
                            onChanged: (value) => this.setState(() {
                              type = value;
                            }),
                            value: type,
                            items: [
                              DropdownMenuItem<HexagonType>(
                                value: HexagonType.FLAT,
                                child: Text('Flat'),
                              ),
                              DropdownMenuItem<HexagonType>(
                                value: HexagonType.POINTY,
                                child: Text('Pointy'),
                              )
                            ],
                            selectedItemBuilder: (context) => [
                              Center(child: Text('Flat')),
                              Center(child: Text('Pointy')),
                            ],
                          ),
                          DropdownButton<int>(
                            onChanged: (value) => this.setState(() {
                              depth = value;
                            }),
                            value: depth,
                            items: depths
                                .map((e) => DropdownMenuItem<int>(
                                      value: e,
                                      child: Text('Depth: $e'),
                                    ))
                                .toList(),
                            selectedItemBuilder: (context) {
                              return depths
                                  .map((e) => Center(child: Text('Depth: $e')))
                                  .toList();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildVerticalGrid(),
            _buildHorizontalGrid(),
            _buildMore(size),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(HexagonType type) {
    return InteractiveViewer(
        minScale: 0.1,
        maxScale: 8.0,
        child: HexagonGrid(
          hexType: type,
          color: Colors.pink,
          depth: depth,
          buildTile: (coordinates) => HexagonWidgetBuilder(
            padding: 2.0,
            cornerRadius: 8.0,
            child: Text(
                '${coordinates.x}, ${coordinates.y}, ${coordinates.z}\n  ${coordinates.q}, ${coordinates.r}'),
          ),
        ));
  }

  Widget _buildHorizontalGrid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: HexagonOffsetGrid.oddPointy(
        color: Colors.black54,
        columns: 9,
        rows: 4,
        buildTile: (col, row) => row.isOdd && col.isOdd
            ? null
            : HexagonWidgetBuilder(
                elevation: col.toDouble(),
                padding: row.isOdd ? 4.0 : 1.0,
                cornerRadius: row.isOdd ? 24.0 : null,
                color: col == 1 || row == 1 ? Colors.lightBlue.shade200 : null,
                child: Text('$col, $row'),
              ),
      ),
    );
  }

  Widget _buildVerticalGrid() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HexagonOffsetGrid.evenFlat(
            color: Colors.yellow.shade100,
            columns: 5,
            rows: 10,
            buildTile: (col, row) => HexagonWidgetBuilder(
              color: row.isEven ? Colors.yellow : Colors.orangeAccent,
              elevation: 2.0,
              padding: 2.0,
            ),
            buildChild: (col, row) => Text('$col, $row'),
          ),
        ],
      ),
    );
  }

  Widget _buildMore(Size size) {
    var padding = 8.0;
    var w = (size.width - 4 * padding) / 2;
    var h = 150.0;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(padding),
                child: HexagonWidget.flat(
                  width: w,
                  child: AspectRatio(
                    aspectRatio: HexagonType.FLAT.ratio,
                    child: Image.asset(
                      'assets/bee.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: HexagonWidget.pointy(
                  width: w,
                  child: AspectRatio(
                    aspectRatio: HexagonType.POINTY.ratio,
                    child: Image.asset(
                      'assets/tram.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: HexagonWidget.flat(
                  height: h,
                  color: Colors.orangeAccent,
                  child: Text('flat\nheight: ${h.toStringAsFixed(2)}'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: HexagonWidget.pointy(
                  height: h,
                  color: Colors.red,
                  child: Text('pointy\nheight: ${h.toStringAsFixed(2)}'),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: HexagonWidget.flat(
              width: w,
              color: Colors.limeAccent,
              elevation: 0,
              child: Text('flat\nwidth: ${w.toStringAsFixed(2)}\nelevation: 0'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: HexagonWidget.pointy(
              width: w,
              color: Colors.lightBlue,
              child: Text('pointy\nwidth: ${w.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }
}
