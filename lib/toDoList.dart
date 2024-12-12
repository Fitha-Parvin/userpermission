import 'package:flutter/material.dart';
import 'package:untitled2/sqflite.dart';




void main() {
  runApp(MaterialApp(
    home: SqMain(),
  ));
}

class SqMain extends StatefulWidget {
  @override
  State<SqMain> createState() => _SqMainState();
}

class _SqMainState extends State<SqMain> {
  bool isLoading = true;
  List<Map<String, dynamic>> noteFromDb = [];

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() async {
    final datas = await SQLHelper.readNotes();
    setState(() {
      noteFromDb = datas;
      isLoading = false;
    });
  }

  final titleController = TextEditingController();
  final noteController = TextEditingController();



  void showForm(int? id) async {
    if (id != null) {
      final existingNote =
      noteFromDb.firstWhere((element) => element['id'] == id);
      titleController.text = existingNote['title'];
      noteController.text = existingNote['note'];
    }

    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      helperStyle: TextStyle(color: Colors.white,
                          fontSize: 30, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: "Enter note",
                      helperStyle: TextStyle(color: Colors.white,
                          fontSize: 30, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await addNote();
                      } else {
                        await updateNote(id);
                      }
                      titleController.text = '';
                      noteController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'ADD NOTE' : 'UPDATE'),
                  )
                ]),
          ),
        ));
  }

  Future addNote() async {
    await SQLHelper.createNote(titleController.text, noteController.text);
    refreshData();
  }

  Future updateNote(int id) async {
    await SQLHelper.updateNote(id, titleController.text, noteController.text);
    refreshData();
  }

  void deleteNote(int id) async {
    await SQLHelper.deleteNote(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Note Deleted"),
    ));
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NOTE PAD",
          style: TextStyle(
              fontSize: 30, color: Colors.pink, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
          itemCount: noteFromDb.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text("${noteFromDb[index]['title']} "),
                subtitle: Text(noteFromDb[index]['note']),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            showForm(noteFromDb[index]['id']);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            deleteNote(noteFromDb[index]['id']);
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () => showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
