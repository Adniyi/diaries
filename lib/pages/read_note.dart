import 'package:diaries/models/diarydatabase.dart';
import 'package:diaries/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class ReadNote extends StatefulWidget {
  const ReadNote({super.key, required this.id});
  final int id;

  @override
  State<ReadNote> createState() => _ReadNoteState();
}

class _ReadNoteState extends State<ReadNote> {
  bool isPlaying = false;
  final FlutterTts fluttertts = FlutterTts();
  Map? _currentlanguage;
  List<Map> languages = [];
  int? _currentwordStartIndex;
  int? _currentwordEndIndex;

  @override
  void initState() {
    super.initState();
    // Schedule the fetch operation to run after the current frame is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final db = Provider.of<Diarydatabase>(context, listen: false);
      db.fetchonenote(widget.id);
    });

    _initTTS();
    // final db = Provider.of<Diarydatabase>(context, listen: false);
    // db.fetchonenote(widget.id);
  }

  void _initTTS() {
    fluttertts.setProgressHandler((
      String text,
      int start,
      int end,
      String word,
    ) {
      setState(() {
        _currentwordStartIndex = start;
        _currentwordEndIndex = end;
      });
    });
    fluttertts.getVoices.then((data) {
      languages = List<Map>.from(data);
      setState(() {
        languages = languages
            .where((language) => language['name'].contains("en"))
            .toList();
        if (languages.isNotEmpty) {
          _currentlanguage = languages.first;
          _setLanguage(_currentlanguage!);
        } else {
          _currentlanguage = null;
        }
      });
    });
  }

  void _setLanguage(Map language) {
    if (language["name"] != null && language["local"] != null) {
      fluttertts.setVoice({
        "name": language["name"],
        "local": language['local'],
      });
      fluttertts.setLanguage(language['local']);
      fluttertts.setPitch(1.0);
      fluttertts.setSpeechRate(0.5);
      print("Language set to: ${language['name']} (${language['local']})");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Diarydatabase>(
      builder: (context, diary, child) {
        final note = diary.singlenote;
        if (note == null) {
          return Scaffold(
            appBar: AppBar(title: Text("Loading..."), toolbarHeight: 20.0),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildReadNotePage(note);
      },
    );
  }

  Scaffold _buildReadNotePage(Note? note) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 25.0),
        title: Text(note?.title ?? "Title ${widget.id}"),
        centerTitle: true,
        actions: [
          DropdownButton(
            value: _currentlanguage,
            items: languages
                .map(
                  (voice) => DropdownMenuItem<Map>(
                    value: voice,
                    child: Text(voice['name'].substring(0, 10) + '...'),
                  ),
                )
                .toList(),
            onChanged: (Map? newvalue) {
              setState(() {
                _currentlanguage = newvalue;
              });
              if (newvalue != null) {
                _setLanguage(newvalue);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: note!.body.substring(
                              0,
                              _currentwordStartIndex,
                            ),
                          ),
                          if (_currentwordStartIndex != null)
                            TextSpan(
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.inversePrimary,
                              ),
                              text: note.body.substring(
                                _currentwordStartIndex!,
                                _currentwordEndIndex,
                              ),
                            ),
                          if (_currentwordEndIndex != null)
                            TextSpan(
                              text: note.body.substring(_currentwordEndIndex!),
                            ),
                        ],
                      ),
                    ),
                    // Text(
                    //   textAlign: TextAlign.left,
                    //   note!.body,
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     color: Theme.of(context).colorScheme.inversePrimary,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // DropdownButton(
          //   value: _currentlanguage,
          //   items: languages
          //       .map(
          //         (voice) => DropdownMenuItem<Map>(
          //           value: voice,
          //           child: Text(voice['name'].substring(0, 10) + '...'),
          //         ),
          //       )
          //       .toList(),
          //   onChanged: (Map? newvalue) {
          //     setState(() {
          //       _currentlanguage = newvalue;
          //     });
          //     if (newvalue != null) {
          //       _setLanguage(newvalue);
          //     }
          //   },
          // ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () async {
                // if (note.body.trim().isEmpty) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(content: Text("Note is empty or invalid for TTS")),
                //   );
                // }
                // return;
                if (isPlaying) {
                  await fluttertts.stop();
                  print("Track stopped");
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  await fluttertts.speak(note.body);
                  print("Track played");
                  setState(() {
                    isPlaying = true;
                  });
                }
                fluttertts.setCompletionHandler(() {
                  isPlaying = false;
                });
              },
              child: Icon(
                isPlaying ? Icons.pause : Icons.volume_up_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          SizedBox(height: 16),
          // FloatingActionButton(
          //   onPressed: () async {
          //     await fluttertts.stop();
          //     // if (!isPlaying) {
          //     //   print("Tracked stopped");
          //     // }
          //     print("Tracked stopped");
          //     setState(() {
          //       isPlaying = false;
          //     });
          //     return;
          //   },
          //   child: Icon(
          //     Icons.stop,
          //     color: Theme.of(context).colorScheme.inversePrimary,
          //   ),
          // ),
        ],
      ),
    );
  }
}
