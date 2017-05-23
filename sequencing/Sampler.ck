// we might at some point in the future implement this as a UGen
// so you could just chuck it to a patch.
public class Sampler
{
    Clock @ clock;
    float pattern[];
    SndBuf buf;
    Gain fader;
    Shred @ shred;

    buf => fader;
    0.5 => fader.gain;
    0.0 => buf.gain;
    
    fun static Sampler @ sequence(Clock @ clock, string path, float pattern[]){
        new Sampler @=> Sampler s;
        clock @=> s.clock;
        pattern @=> s.pattern;
        path => s.buf.read;
        return s;
    }

    fun void start() {
        if (shred == null) {
            spork ~ run() @=> shred;
        }
    }

    fun void stop() {
        if (shred != null) {
            shred.exit();
            null => shred;
        }
    }
    
    fun void run() {
        while (true) {
            clock.tick => now;
            clock.tick_count % pattern.cap() => int index;
            if (pattern[index] > 0){
                0 => buf.pos;
                pattern[index] => buf.gain;
            }
        }
    }
}

