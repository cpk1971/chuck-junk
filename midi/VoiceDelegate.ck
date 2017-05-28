public interface VoiceDelegate {
    fun pure void voice_on(int voice, int note, int velocity);
    fun pure void voice_off(int voice, int note);
}
