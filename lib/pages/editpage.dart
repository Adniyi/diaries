import 'package:diaries/components/note_action_buttons.dart';
// import 'package:diaries/components/snackbar.dart';
import 'package:diaries/models/diarydatabase.dart';
// import 'package:diaries/models/diary.dart';
// import 'package:diaries/pages/diary_collections.dart';
import 'package:flutter/material.dart';
import 'package:diaries/models/notes.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.id, required this.note});
  final int id;
  final Note note;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  // ignore: non_constant_identifier_names
  bool is_Recording = true;
  // ignore: non_constant_identifier_names
  bool is_SpeechToText = false;

  final SpeechToText speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the existing note's data
    _titleController = TextEditingController(text: widget.note.title ?? '');
    _contentController = TextEditingController(text: widget.note.body);
    initspeech();

    // // Initially, let's assume notes are displayed in read-only mode.
    // // If you want them editable by default, set _isEditing to true.
    // _isEditing = false;
  }

  void initspeech() async {
    await speechToText.stop();
    bool available = await speechToText.initialize();
    setState(() {
      is_SpeechToText = available;
      is_Recording = false;
    });
  }

  void startRecording() async {
    if (is_SpeechToText) {
      await speechToText.listen(
        onResult: (result) {
          setState(() {
            _contentController.text += " ${result.recognizedWords}";
          });
        },
        pauseFor: Duration(seconds: 20),
        listenFor: Duration(minutes: 1),
        localeId: "en_US",
      );

      setState(() {
        is_Recording = true;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Speech to text not available")));
    }
  }

  void stopRecording() async {
    if (is_SpeechToText) {
      await speechToText.stop();

      setState(() {
        is_Recording = false;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Speech to text not available")));
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _back() {
    Navigator.pop(context);
    setState(() {});
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => DiaryCollections(diary: diary)),
    // );
  }

  void _save() {
    if (_titleController.text == widget.note.title &&
        _contentController.text == widget.note.body) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: EdgeInsets.all(16),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(Icons.cancel_outlined, size: 30, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Error",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'No changes to save.',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      return;
    }

    final db = context.read<Diarydatabase>();
    db.updateNote(
      widget.id,
      _titleController.text,
      _contentController.text,
      widget.note.createdAt,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(16),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              Icon(Icons.check, size: 30, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Success",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Note saved successfully!',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  // void _isediting() {
  //   setState(() {
  //     isreading = !isreading;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              //Header
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit Note",
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        NoteActionButtons(
                          iconcolor: Colors.black,
                          onTap: is_Recording ? stopRecording : startRecording,
                          color: Colors.grey.shade300,
                          icon: speechToText.isListening
                              ? Icons.mic
                              : Icons.mic_off,
                        ),
                        SizedBox(width: 6.0),
                        NoteActionButtons(
                          onTap: () => _save(),
                          width: 50.0,
                          color: Colors.black,
                          icon: Icons.save_outlined,
                          iconcolor: Colors.white,
                        ),
                        SizedBox(width: 6.0),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            // color: Colors.black,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _back();
                            },
                            child: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // SizedBox(height: ),
              //Body
              // Title TextField
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 20,
                  right: 20,
                  bottom: 0,
                ),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hint: Text(
                      "Title here...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 20,
                  right: 20,
                  bottom: 0,
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hint: Text(
                      "Content here...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              // Recording button
              // Padding(
              //   padding: const EdgeInsets.only(top: 320.0),
              //   child: FloatingActionButton(
              //     onPressed: () {},
              //     child: Icon(Icons.keyboard_voice_outlined),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
