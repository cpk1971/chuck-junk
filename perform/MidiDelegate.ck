public interface MidiDelegate {
    fun pure void noteOn(int voice, int note, int velocity);
    fun pure void noteOff(int voice, int note);
    fun pure void control(int channel, int value);
}
