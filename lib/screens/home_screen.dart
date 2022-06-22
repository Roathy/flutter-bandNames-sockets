import 'dart:io';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../models/band_model.dart';
import '../services/socket_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('current-bands', _currentBandsHandler);

    super.initState();
  }

  _currentBandsHandler(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('current-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(
      context,
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
              padding: EdgeInsets.only(right: 15),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(
                      Icons.online_prediction,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.offline_bolt,
                      color: Colors.red,
                    ))
        ],
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 21),
          margin: EdgeInsets.symmetric(vertical: 21),
          child: _votesGraph(),
        ),
        Container(
          width: double.infinity,
          height: size.height * 0.6,
          child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, int index) => _bandTile(bands[index]),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: inputNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        socketService.socket.emit('delete-band', {'id': band.id});
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 9),
        color: Colors.red,
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(
              width: 21,
            ),
            Text(
              'Delete band',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
      child: ListTile(
        tileColor: band.votes % 2 == 0 ? Colors.blue : Colors.white,
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 21),
        ),
        onTap: () {
          socketService.socket.emit('vote-for-band', {"id": band.id});
        },
      ),
    );
  }

  inputNewBand() {
    final textController = TextEditingController();
    final socketService = Provider.of<SocketService>(context, listen: false);

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('New band name'),
                content: TextField(controller: textController),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      socketService.socket
                          .emit('add-new-band', {'name': textController.text});
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                    elevation: 6,
                    textColor: Colors.blue,
                  )
                ],
              ));
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New Band Name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () {
                  socketService.socket
                      .emit('add-new-band', {'name': textController.text});
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget _votesGraph() {
    Map<String, double> dataMap = {};
    List<Color> colorList = [
      Color(0xffff6961),
      Color(0xff77dd77),
      Color(0xfffdfd96),
      Color(0xff84b6f4),
      Color(0xfffdcae1),
    ];

    bands.forEach(
      (band) => {dataMap.putIfAbsent(band.name, () => band.votes.toDouble())},
    );

    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 33,
      
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,

      //centerText: "HYBRID",
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        //legendShape: _BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 0,
      ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    );
  }
}
