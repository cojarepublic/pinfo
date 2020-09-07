import 'package:flutter/foundation.dart';
import 'package:pinfo/models/notes.dart';

class NoteFilter extends ChangeNotifier {
  NoteState _noteState;

  NoteState get noteState => _noteState;
  set noteState(NoteState value) {
    if (value != null && value != _noteState) {
      _noteState = value;
      notifyListeners();
    }
  }

  NoteFilter([this._noteState = NoteState.unspecified]);
}