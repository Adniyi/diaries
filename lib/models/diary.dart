import 'package:diaries/models/notes.dart';
import 'package:isar/isar.dart';

part 'diary.g.dart';

@Collection()
class Diary {
  Id id = Isar.autoIncrement;
  late String name;
  late DateTime createdAt;

  @Backlink(to: "diary")
  final note = IsarLinks<Note>();
}

// This class represents a diary entry with an ID and a title.
// The ID is a unique identifier for the diary, and the title is the name of the diary.
