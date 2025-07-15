import 'package:diaries/main.dart';
import 'package:diaries/models/diary.dart';
import 'package:diaries/models/diarydatabase.dart';
import 'package:diaries/models/notes.dart';
import 'package:diaries/pages/editpage.dart';
import 'package:diaries/pages/read_note.dart';
import 'package:diaries/utils/datetimeconverter.dart';
// import 'package:diaries/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:characters/characters.dart';

class DiaryCollections extends StatefulWidget {
  const DiaryCollections({super.key, required this.diary});
  final Diary diary;

  @override
  State<DiaryCollections> createState() => _DiaryCollectionsState();
}

class _DiaryCollectionsState extends State<DiaryCollections> {
  final List<List<String>> notelist = [
    // ['Title', 'Content', 'Date']
    [
      'Lorem1',
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. At nostrum sequiearum fuga voluptas cupiditate doloribus, provident obcaecati, itaque",
      "10 May 2022",
    ],
    [
      'Lorem2',
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. At nostrum sequiearum fuga voluptas cupiditate doloribus, provident obcaecati, itaque",
      "10 May 2022",
    ],
    [
      'Lorem3',
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. At nostrum sequiearum fuga voluptas cupiditate doloribus, provident obcaecati, itaque",
      "10 May 2022",
    ],
    [
      'Lorem4',
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. At nostrum sequiearum fuga voluptas cupiditate doloribus, provident obcaecati, itaque",
      "10 May 2022",
    ],
  ];

  void _loadreadpage(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReadNote(id: id)),
    );
  }

  void _editnote(int id, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNote(id: id, note: note),
      ),
    );
  }

  void _back() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Diarydatabase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: _back,
          child: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(widget.diary.name),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: FutureBuilder<List<Note>>(
        future: db.fetchNotesForDiary(widget.diary),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notes found."));
          }

          final notes = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: notes.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return GestureDetector(
                        onTap: () {
                          _loadreadpage(note.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            color: Theme.of(context).colorScheme.secondary,
                            child: GridTile(
                              header: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(note.title ?? "Title ${note.id}"),
                                    GestureDetector(
                                      onTap: () => _editnote(note.id, note),
                                      child: Icon(Icons.edit_note),
                                    ),
                                  ],
                                ),
                              ),
                              footer: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatteddate(note.createdAt)),
                                    GestureDetector(
                                      onTap: () {
                                        // print("Delete Note: ${note[0]}");
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Are you sure you want to delete the note: ${note.title ?? "Title ${notes[index]}"}",
                                              ),
                                              content: SizedBox(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                        notes.remove(note);
                                                        db.deleteNote(note.id);
                                                        // notelist.remove(note);
                                                        // setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(Icons.delete_outlined),
                                    ),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Center(
                                  child: Text(
                                    note.body.characters.length > 80
                                        ? "${note.body.characters.take(80).toString()}..."
                                        : note.body,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
