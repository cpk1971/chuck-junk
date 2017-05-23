public class Clock {
    float tempo; // beats per minute
    int sig_upper; // beats per measure
    int sig_lower; // beat value
    int resolution; // note value of resolution

    // state
    int tick_count;
    Event tick;
    Shred @ shred;
    
    // pre-constructor
    120.0 => tempo;
    4 => sig_upper;
    4 => sig_lower;
    16 => resolution; // inverted fraction of whole note
    0 => tick_count;

    fun dur beat_dur() {
        return (60.0 / tempo)::second;
    }

    fun dur measure_dur() {
        return beat_dur() * sig_upper;
    }

    fun dur whole_dur() {
        return beat_dur() * sig_lower;
    }

    fun dur tick_dur() {
        return beat_dur() * sig_lower / resolution;
    }

    fun int running() {
        return shred != null;
    }

    fun int ticks_per_beat() {
        return resolution / sig_lower;
    }

    fun int beat() {
        return tick_count / ticks_per_beat();
    }
    
    fun int measure() {
        return beat() / sig_upper;
    }
    
    fun int mcount() {
        return beat() % sig_upper;
    }

    fun int btick() {
        return tick_count % ticks_per_beat();
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
        while(true) {
            tick.broadcast();
            tick_dur() => now;
            1 +=> tick_count;
        }
    }
}
