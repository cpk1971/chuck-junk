public class Potentiometer {
    int id;
    string name;
    int value;

    fun float zeroOne() {
        return (value $ float) / 127;
    }

    fun float minusPlus() {
        return ((value - 64) $ float) / (value < 64 ? 64 : 63);
    }

    fun void debug() {
        <<< "Potentiometer: ", id, name, value, zeroOne(), minusPlus() >>>;
    }
}
