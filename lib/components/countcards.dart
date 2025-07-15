import 'package:diaries/models/diary.dart';
import 'package:diaries/models/diarydatabase.dart';
import 'package:flutter/material.dart';
import 'package:diaries/models/notes.dart';
import 'package:provider/provider.dart';

class countcards extends StatelessWidget {
  const countcards({super.key});

  @override
  Widget build(BuildContext context) {
    final diariess = context.watch<Diarydatabase>();

    List<Diary> currentdiaries = diariess.currentDiary;
    List<Note> currentnotescount = diariess.currentNotes;
    // print(currentnotescount.length);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            width: 150,
            height: 94,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: currentdiaries.length),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Text(
                        "$value",
                        style: TextStyle(
                          color: Color.fromRGBO(37, 99, 235, 1),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                // Text(
                //   "${currentdiaries.length}",
                //   style: TextStyle(
                //     color: Color.fromRGBO(37, 99, 235, 1),
                //     fontSize: 30,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(height: 10),
                Text(
                  "Total Diaries",
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            width: 150,
            height: 94,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: currentnotescount.length),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Text(
                      "$value",
                      style: TextStyle(
                        color: Color.fromRGBO(22, 163, 74, 1),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                // Text(
                //   "${currentnotescount.length}",
                //   style: TextStyle(
                //     color: Color.fromRGBO(22, 163, 74, 1),
                //     fontSize: 30,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(height: 10),
                Text(
                  "Total Notes",
                  style: TextStyle(color: Colors.grey[500], fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
