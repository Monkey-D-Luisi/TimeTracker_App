import 'package:flutter/material.dart';
import 'package:timetracker_app/page_intervals.dart';
import 'package:timetracker_app/tree.dart' hide getTree;
import 'package:timetracker_app/requests.dart';
import 'page_add_activity.dart';
import 'dart:async';

class PageActivities extends StatefulWidget {
  int id;

  PageActivities(this.id);

  @override
  _PageActivitiesState createState() => _PageActivitiesState();
}


class _PageActivitiesState extends State<PageActivities> {
  late int id;
  late Future<Tree> futureTree;
  late Timer _timer;
  static const int periodeRefresh = 2;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    futureTree = getTree(id);
    _activateTimer();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tree>(
      future: futureTree,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data!.root.name),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.home),
                    onPressed: () {
                      while(Navigator.of(context).canPop()) {
                        print("pop");
                        Navigator.of(context).pop();
                      }
                      PageActivities(0);
                    }),
                //TODO other actions
              ],
            ),
            body: Column( children: <Widget> [
              Padding(
                padding: EdgeInsets.all(15),
              ),
              if(snapshot.data!.root is Project)
                ElevatedButton(
                  child: Text('Add a new Activity'),
                  onPressed: () =>  _addActivityToProject(),
                ),
              Expanded(child:
                ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: snapshot.data!.root.children.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildRow(snapshot.data!.root.children[index], index),
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                ),
              )]
          ));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildRow(Activity activity, int index) {
    String strDuration = formatDuration(activity.duration);
    if (activity is Project) {
      return ListTile(
        title: Text('${activity.name}'),
        trailing: Text('$strDuration'),
        onTap: () => _navigateDownActivities(activity.id),
        leading: Icon(Icons.work),
      );
    } else if (activity is Task) {
      Task task = activity as Task;
      Widget trailing;
      trailing = RichText(
          text:
            TextSpan(
              children: [
                TextSpan(text: '$strDuration',
                  style: TextStyle(fontSize: 20),),
                if(task.active)
                  WidgetSpan(
                    child: Icon(Icons.timer),
                  ),
                ],
              ),
            );

      return ListTile(
        title: Text('${activity.name}'),
        trailing: trailing,
        onTap: () => _navigateDownIntervals(activity.id),
        onLongPress: () {
          if (activity.active) {
            //activity.active = false;
            stop(activity.id);
            _refresh();
          } else {
            //activity.active = true;
            start(activity.id);
            _refresh();
          }
        },
        leading: Icon(Icons.task),
      );
    }
    else
      return ListTile();
  }

  String formatDuration(int duration) => Duration(seconds: duration).toString().split('.').first;

  void _navigateDownActivities(int childId) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageActivities(childId),
    )).then( (var value) {
      _activateTimer();
    });
  }

  void _navigateDownIntervals(int childId) {
    _timer.cancel();
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageIntervals(childId),
    )).then( (var value) {
      _activateTimer();
    });
  }

  void _refresh() async {
    futureTree = getTree(id);
    setState(() {});
  }

  void _activateTimer() {
    _timer = Timer.periodic(Duration(seconds: periodeRefresh), (Timer t) {
      _refresh();
    });
  }

  void _addActivityToProject() {
    _timer.cancel();   // we can not do just _refresh() because then the up arrow doesnt appear in the appbar
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PageAddActivity(id),
    )).then( (var value) {
      _activateTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}