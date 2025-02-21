import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  List<String> listName = [];
   late Box box;

  @override
  void initState() {
    super.initState();
    storeData();
  }

  Future<void> storeData() async {
    box = await Hive.openBox("student");
    setState(() {
      listName = List<String>.from(box.get('name', defaultValue: []));
    });
    }

  Future<void> addData() async {
    if (nameController.text.isNotEmpty) {
      listName.add(nameController.text);
     var  box = await Hive.openBox("student");
      await box.put("name", listName);
      nameController.clear();
      setState(() {});
    }
  }

  Future<void> deleteData(int index) async {
   var  box = await Hive.openBox("student");
    listName.removeAt(index);
    await box.put("name", listName);
    setState(() {});
    }

  Future<void> editData(int index) async {
    TextEditingController editController =
        TextEditingController(text: listName[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.greenAccent,
          title: Text("Edit Name"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Dialog close
              },
              child: Text("Cancel"),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () async {
                if (editController.text.isNotEmpty) {
                  listName[index] = editController.text;
                  await box.put("name", listName);
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Center(
            child: Text(
          "Home CRUD",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
          ),
          ElevatedButton(onPressed: addData, child: Text("Save")),
          Expanded(
            child: ListView.builder(
              itemCount: listName.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Card(
                    color: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(listName[index]),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    editData(index);
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    deleteData(index);
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
