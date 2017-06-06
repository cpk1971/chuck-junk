public class Note {
    int _value; // midi note value
    int _length; // reciprocals of whole
    int _dotted; // true if dotted
    int _triplet; // true if triplet
    int _error; // if the note is invalid
    string _status; // reason for error

    "ok" => _status;

    fun static Note[] of_values(string s[]) {
        new Note[s.size()] @=> Note result[];
        for (0 => int i; i < s.size(); i++) {
            Note.of_value(s[i]) @=> result[i]; 
        }
        return result;
    }

    fun static Note @ of_value(string s) {
       return _parse_note(s); 
    }

    fun int value() {
        return _value;
    }

    fun int value(int value) {
        value => _value;
        return _value;
    }

    fun int value(string s) {
        _parse_note(s) @=> Note @ n;
        n._value => _value;
        n._error => _error;
        n._status => _status;
    }

    fun Note @ with_value(string s) {
        value(s);
        return this;
    }

    fun int length() {
        return _length;
    }

    fun int length(int length) {
        return _length;
    }

    fun int length(string s) {
        _parse_length(s) @=> Note @ n;
        n._length => _length;
        n._dotted => _dotted;
        n._triplet => _triplet;
        n._error => _error;
        n._status => _status;
    }

    fun Note @ with_length(string s) {
        length(s);
        return this;
    }

    fun int error() {
        return _error;
    }

    fun string status() {
        return _status;
    }

    // todo -- a version of this that respects key
    // this version always returns sharps
    fun string value_notation() {
        // this is some impressive bullshit is it not?
        Math.floor((_value - 24) / 12 $ float) $ int=> int octave;
        _value % 12 => int step;
        ["c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "b"] 
            @=> string notes[];
        return notes[step] + octave;
    }

    fun string length_notation() {
        return (_dotted ? "d" : "")
                + (_triplet ? "t" : "")
                + _length;
    }

    // override @object
    fun string toString() {
        return _value + "," + value_notation() + "," + _length + "," 
            + length_notation() + "," + _dotted + "," + _triplet + "," 
            + _error + "," + _status;
    }

    // private
    fun static Note @ _parse_note(string s) {
        new Note @=> Note @ n;

        // no way this could be valid
        if (s.length() < 2) {
            1 => n._error;
            "note string too short" => n._status;
            return n;
        }
        s.lower() => s;
        // i tried making this a global static but all it would do was 
        // cause NPEs so we have to do it this way
        //
        // it's not critical for performance because you're supposed to 
        // use this to generate sequences up front
        "cdefgab" => string notes;
        notes.find(s.charAt(0)) => int base;
        if (base < 0) {
            1 => n._error;
            "invalid note string" => n._status;
            return n;
        }
        1 => int i;
        s.charAt(i) => int maybe_accidental;
        0 => int accidental;
        if (maybe_accidental == 'b') {
           -1 => accidental; 
           1 +=> i;
        } else if (maybe_accidental == '#') {
           1 => accidental;
           1 +=> i;
        }
        s.charAt(i) => int maybe_negative;
        1 => int sign;
        if (maybe_negative == '-') {
            -1 => sign;
            1 +=> i;
        }
        Std.atoi(s.substring(i)) => int octave;
        [0, 2, 4, 5, 7, 9, 11] @=> int NATURALS[];
        (octave * sign) * 12 + 24 + NATURALS[base] + accidental => n._value;
        if (n._value < 0 || n._value > 127) { 
            1 => n._error;
            "octave out of range" => n._status;
        }
        return n;
    }

    fun static Note @ _parse_length(string s) {
        new Note @=> Note @ n;

        s.lower() => s;
        if (s.length() < 1) {
            1 => n._error;
            "duration string too short" => n._status;
            return n;
        }
        0 => int i;
        s.charAt(i) => int modifier;
        if (modifier == 't') {
            1 => n._triplet;
            1 +=> i;
        } else if (modifier == 'd') {
            1 => n._dotted;
            1 +=> i;
        }
        Std.atoi(s.substring(i)) => n._length;
        if (n._length == 0) {
            1 => n._error;
            "duration value invalid" => n._status;
        }
        return n;
    }
}

