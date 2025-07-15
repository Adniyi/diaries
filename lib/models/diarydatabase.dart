import 'package:diaries/models/diary.dart';
import 'package:diaries/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class Diarydatabase extends ChangeNotifier {
  static late Isar isar;

  // INITIALIZE THE DATABASE
  static Future<void> initalize() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [DiarySchema, NoteSchema],
        directory: dir.path,
        inspector: true,
      );
    }
  }

  // list of Diaries and Notes

  final List<Diary> currentDiary = [];
  final List<Note> currentNotes = [];
  Note? _singlenote;
  Note? get singlenote => _singlenote;
  // Create new Diary and Note
  // Create new Diary
  Future<void> addDiary(String name, DateTime createdAt) async {
    final newDiary = Diary()..name = name;
    newDiary.createdAt = createdAt;
    await isar.writeTxn(() => isar.diarys.put(newDiary));

    //re-read from the database
    fetchDiaries();
  }

  // Read all the diaries
  Future<void> fetchDiaries() async {
    List<Diary> fetcheddiaries = await isar.diarys.where().findAll();
    currentDiary.clear();
    currentDiary.addAll(fetcheddiaries);
    notifyListeners();
  }

  // Update a diary
  Future<void> updatediary(int id, String newname) async {
    final existingdiary = await isar.diarys.get(id);
    if (existingdiary != null) {
      existingdiary.name = newname;
      existingdiary.createdAt = DateTime.now();
      await isar.writeTxn(() => isar.diarys.put(existingdiary));
      await fetchDiaries();
    }
  }

  // Delete a diairy
  Future<void> deletedairy(int id) async {
    // await isar.writeTxn(() => isar.diarys.delete(id));
    await isar.writeTxn(() async {
      // Bulk delete all notes where note.diary == this diary
      await isar.notes.filter().diary((q) => q.idEqualTo(id)).deleteAll();
      await isar.diarys.delete(id);
    });
    // re-read from database
    // This will also delete all notes associated with this diary
    await fetchDiaries();
    await fetchnotes();
  }

  // CRUD OPERATIONS FOR NOTES
  // Future<void> addNote(
  //   String title,
  //   String body,
  //   DateTime createdAt,
  //   Diary diary,
  // ) async {
  //   final newNote = Note()
  //     ..title = title
  //     ..body = body
  //     ..createdAt = createdAt;

  //   newNote.diary.value = diary;

  //   await isar.writeTxn(() async {
  //     isar.notes.put(newNote);
  //     newNote.diary.save();
  //   });

  //   // re-read from database
  //   fetchnotes();
  // }

  Future<void> addNote(
    String title,
    String body,
    DateTime createdAt,
    Diary diary,
  ) async {
    final newNote = Note()
      ..title = title
      ..body = body
      ..createdAt = createdAt;

    newNote.diary.value = diary;

    await isar.writeTxn(() async {
      await isar.notes.put(newNote);
      await newNote.diary.save(); // ✅ Must be inside the txn
    });

    await fetchnotes();
  }

  Future<void> fetchnotes() async {
    List<Note> allnotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(allnotes);
    notifyListeners();
  }

  Future<void> fetchonenote(int id) async {
    // Fetch the note by ID
    _singlenote = null; // Reset the single note before fetching
    notifyListeners();
    final existingNote = await isar.notes.get(id);
    _singlenote = existingNote; // This handles both null and non-null cases
    notifyListeners();
  }

  Future<void> updateNote(
    int id,
    String? title,
    String body,
    DateTime createdAt,
  ) async {
    final existingnote = await isar.notes.get(id);
    if (existingnote != null) {
      existingnote.body = body;
      existingnote.title = title;
      existingnote.createdAt = createdAt;
      await isar.writeTxn(() => isar.notes.put(existingnote));
      await fetchnotes();
    }
  }

  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchnotes();
  }

  Future<List<Note>> fetchNotesForDiary(Diary diary) async {
    await diary.note.load(); // Load the backlink
    return diary.note.toList(); // Return the notes
  }

  Future<int> getNoteCountForDiary(Diary diary) async {
    await diary.note.load(); // Load all linked notes
    return diary.note.length; // Return count
  }

  Future<void> deleteDiaryAndNotes(Diary diary) async {
    await isar.writeTxn(() async {
      // Bulk delete all notes where note.diary == this diary
      await isar.notes.filter().diary((q) => q.idEqualTo(diary.id)).deleteAll();

      // Then delete the diary
      await isar.diarys.delete(diary.id);
    });

    await fetchDiaries();
    await fetchnotes();
  }
}
