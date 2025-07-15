import 'package:diaries/pages/read_note.dart';
import 'package:flutter/material.dart';
import 'package:diaries/models/diarydatabase.dart'; // Your Diarydatabase model
import 'package:diaries/models/notes.dart'; // Your Note model

class DataSearch extends SearchDelegate<Note?> {
  // Changed to Note? if a note might not be found

  final Diarydatabase diaryDatabase; // This will hold your database instance
  final List<Note?> allNotes; // To store all notes for searching

  // Constructor to receive the database instance and potentially all notes upfront
  DataSearch({required this.diaryDatabase, required this.allNotes});

  // You might want to manage recent searches.
  // This could also be persisted using shared_preferences or Isar if you want them to be permanent.
  final List<String> recentSearches = []; // Store search queries as strings

  @override
  ThemeData appBarTheme(BuildContext context) {
    // Customize the theme of the search bar
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: theme.colorScheme.inversePrimary),
        border: InputBorder.none,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:
            theme.appBarTheme.backgroundColor, // Use app's AppBar color
        foregroundColor: theme
            .appBarTheme
            .foregroundColor, // Use app's AppBar foreground color
        elevation: theme.appBarTheme.elevation,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor:
            theme.colorScheme.inversePrimary, // Color of the blinking cursor
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Actions for the AppBar of the search page
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null); // Close search if query is empty
          } else {
            query = ''; // Clear the query
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Leading icon (typically a back button)
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(
          context,
          null,
        ); // Close search and return null (no result selected)
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show results when the user presses enter or taps a suggestion
    if (query.isEmpty) {
      return Center(child: Text("Type something to search"));
    }

    // Filter notes based on the query
    final suggestionList = allNotes.where((note) {
      return note!.title!.toLowerCase().contains(query.toLowerCase()) ||
          note.body.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Add query to recent searches (optional, for persistent storage)
    if (!recentSearches.contains(query) && suggestionList.isNotEmpty) {
      recentSearches.add(query);
      // You could save recentSearches to SharedPreferences/Isar here
    }

    if (suggestionList.isEmpty) {
      return Center(child: Text("No results found for \"${query}\""));
    }

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final Note? note = suggestionList[index];
        return ListTile(
          trailing: Text(note!.diary.value!.name),
          leading: const Icon(Icons.note),
          title: Text(note.title!),
          subtitle: Text(
            note.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            // This is the chosen result. Close the search and pass the selected note back.
            close(context, note);
            // You might navigate to the ReadNote page here, or handle it where showSearch is called.
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ReadNote(id: note.id)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Check if the are notes
    if (allNotes.isEmpty) {
      return Center(child: Text("No notes available to search"));
    }
    // Show suggestions as the user types
    final List<Note?> suggestionList = allNotes.where((note) {
      return note!.title!.toLowerCase().contains(query.toLowerCase()) ||
          note.body.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final Note? note = suggestionList[index];
        return suggestionList.isEmpty
            ? Center(child: Text("No notes to search"))
            : ListTile(
                trailing: Text(note!.diary.value!.name),
                leading: query.isEmpty
                    ? const Icon(Icons.history)
                    : const Icon(Icons.search),
                title: Text(note.title!),
                // Highlight the matching part of the query (optional, but good UX)
                subtitle: query.isEmpty
                    ? null
                    : Text(
                        note.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                onTap: () {
                  if (query.isEmpty) {
                    query = note
                        .title!; // For recent searches, set query and show results
                  } else {
                    // If it's a filtered suggestion, set query and show results
                    query = note
                        .title!; // Or `query = suggestionList[index].body` if you prefer searching on body too
                  }
                  showResults(
                    context,
                  ); // Show results for the selected suggestion
                },
              );
      },
    );
  }
}
