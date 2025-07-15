// import 'package:diaries/main.dart';
import 'package:diaries/models/diary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diaries/models/diarydatabase.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({super.key});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  // ignore: non_constant_identifier_names
  final TextEditingController title_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController content_controller = TextEditingController();
  // ignore: non_constant_identifier_names
  bool is_Recording = true;
  // ignore: non_constant_identifier_names
  bool is_SpeechToText = false;

  final SpeechToText speechToText = SpeechToText();

  final List<IconData> IconList = [
    Icons.emoji_emotions,
    Icons.book,
    Icons.class_outlined,
    Icons.work,
    Icons.local_post_office,
    Icons.read_more_outlined,
  ];

  @override
  void initState() {
    super.initState();
    initspeech();
    // Initialize the speech to text functionality
  }

  void initspeech() async {
    is_SpeechToText = await speechToText.initialize();
    setState(() {
      is_Recording = false;
    });
  }

  void startRecording() async {
    if (is_SpeechToText) {
      setState(() {
        is_Recording = true;
      });
      await speechToText.listen(
        onResult: (result) {
          setState(() {
            content_controller.text += " ${result.recognizedWords}";
          });
        },
        pauseFor: Duration(seconds: 20),
        listenFor: Duration(minutes: 1),
        localeId: "en_US",
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Speech to text not available")));
    }
  }

  void stopRecording() async {
    if (is_SpeechToText) {
      setState(() {
        is_Recording = false;
      });
      await speechToText.stop();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Speech to text not available")));
    }
  }

  @override
  void dispose() {
    title_controller.dispose();
    content_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Header
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Note",
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: speechToText.isListening
                                ? stopRecording
                                : startRecording,
                            child: Icon(
                              speechToText.isListening
                                  ? Icons.mic
                                  : Icons.mic_off,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.0),
                        GestureDetector(
                          onTap: () {
                            _showdiarymodels(context);
                          },
                          child: Container(
                            width: 100.0,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.save_outlined, color: Colors.white),
                                SizedBox(width: 4.0),
                                Text(
                                  "Save",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
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
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  controller: title_controller,
                  decoration: InputDecoration(
                    hintText: "Title here...",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary,
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
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  controller: content_controller,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hint: Text(
                      "Content here...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showdiarymodels(BuildContext outercontext) {
    // final diaries = outercontext.watch<Diarydatabase>();
    final diaries = Provider.of<Diarydatabase>(outercontext, listen: false);

    List<Diary> currentdiaries = diaries.currentDiary;
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: false,
      context: outercontext,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          // ⬅️ Needed to update UI inside modal
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.4,
              maxChildSize: 0.95,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: Text(
                          "Diary Categories",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: currentdiaries.length,
                        itemBuilder: (context, index) {
                          final category = currentdiaries[index];
                          final icons = IconList[category.id % IconList.length];

                          return InkWell(
                            onTap: () async {
                              if (content_controller.text.isNotEmpty) {
                                await diaries.addNote(
                                  title_controller.text,

                                  content_controller.text,
                                  DateTime.now(),
                                  category,
                                );
                                // setState(() {});

                                // // 3. Close the modal
                                Navigator.of(
                                  context,
                                ).pop(); // Close bottom sheet

                                ScaffoldMessenger.of(outercontext).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      padding: EdgeInsets.all(16),
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                  "Note saved to '${category.name}'",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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

                                // 4. Exit the note page
                                // Navigator.of(outercontext).pushReplacement(
                                //   MaterialPageRoute(
                                //     builder: (context) => MyApp(),
                                //   ),
                                // );
                                title_controller.clear();
                                content_controller.clear();
                              } // Exit full note screen
                              else {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(outercontext).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Container(
                                      padding: EdgeInsets.all(16),
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFC72C41),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.cancel_outlined,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                  "Cannot Save empty note to '${category.name}'",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      icons,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.inversePrimary,
                                      ),
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
              ),
            );
          },
        );
      },
    );
  }
}
