public class Chord {
    int  _midis[];
    Note @ _root;
    string _notation;

    fun static Chord @ from(Note @ note) {
        new Chord @=> Chord @ c;
        note.copy() @=> c._root;
        new int[3] @=> c._midis;
        "" => _notation;
        return c;
    }

    // constructives
    //
    // change the characteristics of the chord and wipe out
    // all additives and inversions

    fun Chord @ major() {
        _midis.size(3);
        _root.value() => _midis[0];
        _midis[0] + 4 => _midis[1];
        _midis[0] + 7 => _midis[2];
        "" => _notation;
        return this;
    }

    fun Chord @ minor() {
        major();
        1 -=> _midis[1];
        "m" => _notations;
        return this;
    }

    fun Chord @ diminished() {
        minor();

    }

    fun Note[] @ to_notes() {
        new Note[_midis.size()] @=> Note result[];
        for (0 => int i; i < result.size(); i++) {
            _root.copy() @=> result[i];
            result[i].value(_midis[i]);
        }
        return result;
    }

    fun Chord @ copy() {
        new Chord @=> Chord @ c;
        _root => c._root;
        new int[_midis.size()] @=> _midis;
        for (0 => int i; i < _midis.size(); i++) {
            _midis[i] => c._midis[i];
        }
        _notation => c._notation;
        return c;
    }
}
