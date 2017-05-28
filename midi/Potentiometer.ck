public class Potentiometer {
    int id;
    string name;
    int value;

    fun float zeroOne() {
        return (value $ float) / 127;
    }

    fun float minusPlus() {
        return ((value - 64) $ float) / 63;
    }
}
