import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_mangement_provider/autocomplete.dart';

ValueNotifier<List<String>> suggNotifier = ValueNotifier<List<String>>([]);
TextEditingController nameController = TextEditingController();

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    suggNotifier.value = [];
  }

  void updatesuggestion(String query) {
    setState(() {
      suggNotifier.value = trie.autocomplete(query);
    });
  }

  void removename(int index) {
    setState(() {
      suggNotifier.value.removeAt(index);
    });
  }

  void handlesubmit() {
    setState(() {
      suggNotifier.value = [];
    });
  }

  void addStudent(String student) {
    trie.insert(student);
    suggNotifier.value = List.from(suggNotifier.value)..add(student);
    nameController.clear();
  }

  void handleedit(int index) {
    nameController.text = suggNotifier.value[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: TextField(
            controller: nameController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                String oldName = suggNotifier.value[index];
                Trie trie = Trie();
                trie.delete(oldName);

                String newName = nameController.text;

                trie.insert(newName);

                suggNotifier.value[index] = newName;
                suggNotifier.notifyListeners();

                nameController.clear();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showAddDialog() {
    nameController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Student'),
          content: TextField(
            controller: nameController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                addStudent(nameController.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            CupertinoSearchTextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (query) {
                updatesuggestion(query);
              },
              onSubmitted: (query) => handlesubmit(),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: suggNotifier,
                builder: (context, newsugg, child) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: newsugg.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => handleedit(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => removename(index),
                            ),
                          ],
                        ),
                        title: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            newsugg[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
