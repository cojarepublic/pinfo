import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Note extends ChangeNotifier {
  final String id;
  String title;
  String content;
  Color color;
  NoteState state;
  final DateTime createdAt;
  DateTime modifiedAt;

  Note({
    this.id,
    this.title,
    this.color,
    this.content,
    this.state,
    this.createdAt,
    this.modifiedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.modifiedAt = modifiedAt ?? DateTime.now();

  static List<Note> fromQuery(QuerySnapshot snapshot) =>
      snapshot != null ? snapshot.toNotes() : [];

  bool get pinned => state == NoteState.pinned;

  int get stateValue => (state ?? NoteState.unspecified).index;

  bool get isNotEmpty =>
      title?.isNotEmpty == true || content?.isNotEmpty == true;

  String get strLastModified => DateFormat.MMMd().format(modifiedAt);

  void update(Note other, {bool UpdateTimestamp = true}) {
    title = other.title;
    content = other.content;
    color = other.color;
    state = other.state;

    if (updateTimestamp || other.modifiedAt == true) {
      modifiedAt = DateTime.now();
    } else {
      modifiedAt = other.modifiedAt;
    }
    notifyListeners();
  }

  Note updateWith({
    String title,
    String content,
    Color color,
    NoteState state,
    bool updateTimestamp = true,
  }) {
    if (title != null) this.title = title;
    if (content != null) this.content = content;
    if (color != null) this.color = color;
    if (state != null) this.state = state;
    if (updateTimestamp) modifiedAt = DateTime.now();
    notifyListeners();
    return this;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'color': color?.value,
        'state': stateValue,
        'createdAt': (createdAt ?? DateTime.now()).millisecondsSinceEpoch,
        'modifiedAt': (modifiedAt ?? DateTime.now()).millisecondsSinceEpoch,
      };

  Note copy({bool updateTimeStamp = false}) => Note(
        id: id,
        createdAt:
            (updateTimeStamp || createdAt == null) ? DateTime.now() : createdAt,
      )..update(this, updateTimestamp: updateTimestamp);

  @override
  bool operator ==(Object other) =>
      other is Note &&
      (other.id ?? '') == (id ?? '') &&
      (other.title ?? '') == (title ?? '') &&
      (other.content ?? '') == (content ?? '') &&
      other.stateValue == stateValue &&
      (other.color ?? 0) == (color ?? 0);

  @override
  // TODO: implement hashCode
  int get hashCode => id?.hashCode ?? super.hashCode;
}

enum NoteState {
  unspecified,
  pinned,
  archived,
  deleted,
}

extension NoteStateX on NoteState {
  bool get canCreate => this <= NoteState.pinned;

  bool get canEdit => this < NoteState.deleted;

  bool operator < (NoteState other) => (this?.index ?? 0) < (other?.index ?? 0);
  bool operator <= (NoteState other) => (this?.index ?? 0) <= (other?.index ?? 0);

  String get message {
    switch (this) {
      case NoteState.archived :
        return 'Note archived';
      case NoteState.deleted :
        return 'Note moved to trash.';
      default:
        return '';
    }
  }

  String get filterName {
    switch (this) {
      case NoteState.archived :
        return 'Archived';
      case NoteState.deleted :
        return 'Trash';
      default:
        return '';
    }
  }

  String get emptResultMessage {
    switch (this) {
      case NoteState.archived :
        return 'Archived notes appear here.';
      case NoteState.deleted :
        return 'Notes in trash appear here.';
      default:
        return 'Notes you add appear here.';
    }
  }
}
