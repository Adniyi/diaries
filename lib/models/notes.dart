import 'package:diaries/models/diary.dart';
import 'package:isar/isar.dart';

part 'notes.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  String? title;
  late String body;
  late DateTime createdAt;
  final diary = IsarLink<Diary>();
}

// This class represents a note with an ID, the ID of the diary it belongs to, the text of the note, and the date it was created.
// The ID is a unique identifier for the note, diaryId links it to a specific diary, text is the content of the note, and createdAt is the timestamp of when the note was created.
