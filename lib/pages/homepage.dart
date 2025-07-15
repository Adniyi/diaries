import 'package:diaries/models/diary.dart';
import 'package:diaries/models/diarydatabase.dart';
import 'package:diaries/models/notes.dart';
import 'package:diaries/pages/diary_collections.dart';
import 'package:diaries/pages/read_note.dart';
import 'package:diaries/providers/notes_search.dart';
import 'package:flutter/material.dart';
import 'package:diaries/components/countcards.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController editingController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  // final SlidableController slidableController = SlidableController();

  // Placeholder data
  final diaries = [
    {1, "Personal", 12},
    {2, "Work", 8},
    {3, "Ideas", 15},
    {4, "Travel", 6},
    {5, "Learning", 23},
    {6, "Fun", 23},
  ];

  final List<Color> iconColors = [
    const Color.fromARGB(255, 112, 159, 241),
    const Color.fromARGB(255, 171, 139, 228),
    const Color.fromARGB(255, 169, 250, 242),
    const Color.fromARGB(255, 243, 195, 133),
    const Color.fromARGB(255, 253, 154, 187),
    const Color.fromARGB(255, 168, 248, 171),
    const Color.fromARGB(255, 162, 238, 248),
    const Color.fromARGB(255, 255, 232, 161),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _readDiaries();
  }

  void _createnewdiary() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create a new Diary"),
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Diary name....",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      child: Text("Cancle"),
                      onPressed: () {
                        Navigator.pop(context);
                        controller.clear();
                      },
                    ),
                    SizedBox(width: 10),
                    MaterialButton(
                      child: Text("Create"),
                      onPressed: () {
                        context.read<Diarydatabase>().addDiary(
                          controller.text,
                          DateTime.now(),
                        );
                        Navigator.pop(context);
                        controller.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _readDiaries() {
    context.watch<Diarydatabase>().fetchDiaries();
    context.watch<Diarydatabase>().fetchnotes();
  }

  void _newpage(Diary diary) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DiaryCollections(diary: diary)),
    );
  }

  void _editDiary(int id, TextEditingController newname) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Diary"),
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newname,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "New diary name...",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                        newname.clear();
                      },
                    ),
                    SizedBox(width: 10),
                    MaterialButton(
                      child: Text("Update"),
                      onPressed: () {
                        context.read<Diarydatabase>().updatediary(
                          id,
                          newname.text,
                        );
                        Navigator.pop(context);
                        newname.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteDiary(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this diary?"),
          content: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 30),
                MaterialButton(
                  child: Text("Yes"),
                  onPressed: () {
                    context.read<Diarydatabase>().deletedairy(id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final diariess = context.watch<Diarydatabase>();

    List<Diary> currentdiaries = diariess.currentDiary;
    List<Note> currentnotescount = diariess.currentNotes;

    return Scaffold(
      // backgroundColor: Colors.grey[200],
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async {
          _readDiaries();
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Diaries",
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.inversePrimary,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              "Organize your notes",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _createnewdiary,
                          child: Container(
                            // width: 200.0,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  "New Diary",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    //search bar
                    Container(
                      height: 50,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: TextField(
                        cursorColor: Theme.of(
                          context,
                        ).colorScheme.inversePrimary,
                        style: TextStyle(fontSize: 20.5, color: Colors.black),
                        controller: searchController,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Search diaries and notes..",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 19.5,
                          ),
                          // icon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          enabledBorder: InputBorder.none,
                        ),
                        onTap: () {
                          _openSearchDelegate(
                            context,
                            diariess,
                            currentnotescount,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    // Total diaries and Total notes card
                    countcards(),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsetsGeometry.all(10),
                      child: Text(
                        "Your Diaries",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // SizedBox(height: 5),
                    // Container(
                    //   child: Row(
                    //     children: [
                    //       ElevatedButton(
                    //         onPressed: () =>
                    //             _themeChanger.setTheme(ThemeData.dark()),
                    //         child: Text("Dark"),
                    //       ),
                    //       ElevatedButton(
                    //         onPressed: () =>
                    //             _themeChanger.setTheme(ThemeData.light()),
                    //         child: Text("light"),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 5),
                    currentdiaries.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Center(
                              child: Text(
                                "No diaries found",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: currentdiaries.length,
                            itemBuilder: (context, index) {
                              final diary = currentdiaries[index];
                              final iconColor =
                                  iconColors[diary.id % iconColors.length];
                              return GestureDetector(
                                onTap: () {
                                  _newpage(diary);
                                },
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 5,
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                  elevation: 0,
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          icon: Icons.edit,
                                          backgroundColor:
                                              Colors.blueAccent.shade200,
                                          onPressed: (context) => _editDiary(
                                            diary.id,
                                            editingController,
                                          ),
                                          // label: "Edit",
                                        ),
                                        SlidableAction(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          icon: Icons.delete,
                                          backgroundColor:
                                              Colors.redAccent.shade200,
                                          onPressed: (context) =>
                                              _deleteDiary(diary.id),
                                          // label: "Delete",
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: iconColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5.0,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.folder_open,
                                                    color: Color.fromRGBO(
                                                      42,
                                                      43,
                                                      46,
                                                      1,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      // "Personal",
                                                      diary.name,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.note_outlined,
                                                        ),
                                                        SizedBox(width: 3),
                                                        Text(
                                                          "${diary.note.length} Notes",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text("Last updated"),
                                            SizedBox(height: 3),
                                            Text(
                                              "${DateTime.now().difference(diary.createdAt).inHours} hours ago",
                                            ),
                                          ],
                                        ),
                                      ),
                                      // subtitle: Text("Personal"),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: ,
    );
  }

  void _openSearchDelegate(
    BuildContext context,
    Diarydatabase db,
    List<Note> notes,
  ) async {
    final Note? selectedNote = await showSearch<Note?>(
      context: context,
      delegate: DataSearch(
        diaryDatabase: db,
        allNotes: notes, // Pass the all notes list
      ),
    );
    if (selectedNote != null) {
      // User selected a note from the search results
      // You can decide what to do with the selected note
      // For instance, navigate to the ReadNote page:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ReadNote(id: selectedNote.id)),
      );
    }

    // if (selectedNote != null) {
    //   searchController.text = selectedNote.title!; // Or query that led to it
    // }
    searchController.clear();
  }
}
