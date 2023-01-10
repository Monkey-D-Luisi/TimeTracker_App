import 'package:flutter/material.dart';
import 'requests.dart';

class PageAddActivity extends StatefulWidget {
  int id;
  PageAddActivity(this.id);

  @override
  _PageCreateState createState() => _PageCreateState();
}

class _PageCreateState extends State<PageAddActivity> {
  late int id;
  String pName = "";

  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  var _activityType = ['Project', 'Task'];
  var _list = ['Software Design', 'pipo', 'prueba'];
  String _vistaType = 'Select the type of the Activity that you want to add';
  String _vistaProjects = 'Select the project that you want to add it to';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Add an activity'),
      ),
      body: Center(child:
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 30),
              TextFormField(
                onChanged: (value) {
                  pName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Name of the Activity',
                ),
              ),
              DropdownButton(   //Type of the activity
                items: _activityType.map((String a){
                  return DropdownMenuItem(
                      value: a,
                      child: Text(a));
                }).toList(),
                onChanged: (_value) => {
                  setState((){
                    _vistaType = _value!;
                  })
                },
                hint: Text(_vistaType),
              ),
              DropdownButton(
                  items: _list.map((String a){
                    return DropdownMenuItem(
                        value: a,
                        child: Text(a));
                  }).toList(),
                  onChanged: (_value) => {
                    setState((){
                      _vistaProjects = _value!;
                    })
                  },
                hint: Text(_vistaProjects),
              ),

              ElevatedButton(
                child: Text('Añadir'),
                onPressed: _vistaType == 'Project' ? () => addProject(true, _vistaProjects) : () => addTask(false, _vistaProjects),
              ),
              const SizedBox(height: 30),
            ],
          )
      ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }

  void addProject(bool isProject, String fName) {
    print(pName);
    print(id);
    print(isProject);

    addActivityToProject(isProject, pName, fName);
    if (Navigator.of(context).canPop()) {
      print("pop");
      Navigator.of(context).pop();
    }
  }

  void addTask(bool isProject, String fName) {
    print(pName);
    print(id);
    print(isProject);

    addActivityToProject(isProject, pName, fName);
    if (Navigator.of(context).canPop()) {
      print("pop");
      Navigator.of(context).pop();
    }
  }

}