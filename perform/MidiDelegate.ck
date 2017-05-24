public interface MidiDelegate {
    fun pure void noteOn(int note, int velocity);
    fun pure void noteOff(int note);
    fun pure void control(int channel, int value);
}
