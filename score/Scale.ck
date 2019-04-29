public class Scale {
    int _offsets[];
    string _type;

    fun static Scale @ from(Note @ root) {
        new Scale @=> Scale @ s;
        root @=> s._root;
        new int[7] @=> s._offsets;
        return s.major();
    }

    fun Scale @ major() {

    }
}
