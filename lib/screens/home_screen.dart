import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'mago de oz', votes: 666),
    Band(id: '2', name: 'nightwish', votes: 55),
    Band(id: '3', name: 'falling in reverse', votes: 222),
    Band(id: '4', name: 'falling in reverse', votes: 333),
    Band(id: '5', name: 'falling in reverse', votes: 444),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Band Names',
            style: TextStyle(color: Colors.white),
          )),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, int index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: readNewBand,
        elevation: 1,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        //TODO:delete from server
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 9),
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
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18),
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
          print(band.name);
        },
      ),
    );
  }

  readNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New band name'),
              content: TextField(controller: textController),
              actions: [
                MaterialButton(
                  onPressed: () {
                    addNewBand(textController.text);
                  },
                  child: Text('Add'),
                  elevation: 6,
                  textColor: Colors.blue,
                )
              ],
            );
          });
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
                  addNewBand(textController.text);
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

  addNewBand(String bandName) {
    print(bandName);
    if (bandName.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: bandName, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}

//votes: bands.contains(bandName) ? votes: 0 :