import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_login/database/database.dart';
import 'package:phone_login/models/note_model.dart';
import 'package:phone_login/screens/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  late final Note? note;
  late final Function? updateNoteList;


  AddNoteScreen({this.note, this.updateNoteList});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController =TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  String _title = '';
  String? _priority = 'Low';
  String btnText = "Add Note";
  String titleText = "Add Note";
  DateTime _date = DateTime.now();


  @override
  void initState() {
    super.initState();

    if(widget.note != null){
      _title = widget.note!.title!;
      _date = widget.note!.date!;
      _priority = widget.note!.priority!;

      setState(() {
        btnText = "Update Note";
        titleText = "Update Note";
      });
    }
    else{
      setState(() {
        btnText = "Add Note";
        titleText = "Add Note";
      });

    }
    _dateController.text = _dateFormatter.format(_date);

  }


  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _submit(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      print('$_title, $_date, $_priority');

      var note = Note(title: _title, date: _date, priority: _priority);

      if(widget.note == null){
        note.status = 0;
        DatabaseHelper.instance.insertNote(note);

        Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
        );
      }
      else{
        note.id = widget.note!.id;
        note.status = widget.note!.status;
        DatabaseHelper.instance.updateNote(note);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }

      widget.updateNoteList!();
    }

  }

/*  void _handlerDatePicker() async{
    final date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );

    if(date != null && date != _date){
      setState(() {
        _date = date;

      });
      _dateController.text = _dateFormatter.format(date);
    }
  }*/

  void _delete(){
    DatabaseHelper.instance.deleteNote(widget.note!.id!);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_)=> HomeScreen(),
      ),
    );
    widget.updateNoteList!();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical:  80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  /*onTap: ()=> Navigator.pushReplacementNamed(context, MaterialPageRoute(builder: (_) => HomeScreen(),)),*/
                  child: Icon(
                    Icons.arrow_back,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(
                  titleText,
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )
                          ),
                          validator: (input) =>
                          input!.trim().isEmpty ? 'Please enter a note title' : null,
                          onSaved: (input) => _title = input!,
                          initialValue: _title,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),

                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 22.0,
                          iconEnabledColor: Theme.of(context).primaryColor,

                          items: _priorities.map((String priority) {
                            return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,

                                  ),
                                )
                            );
                          }).toList(),
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => _priority == null ? 'Please select a priority level' : null,
                          onChanged: (value){
                            setState(() {
                              _priority = value.toString();
                            });
                          },
                          value: _priority,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),

                        ),
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(
                            btnText,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),

                      ),
                      widget.note != null ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),

                        ),
                        child: ElevatedButton(
                          onPressed: _delete,
                          child: Text(
                            'Delete Note',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:20.0,
                            ),
                          ),
                        ),
                      ): SizedBox.shrink(),

                    ],
                  ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
