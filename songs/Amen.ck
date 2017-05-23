// patterns

// ride cymbal -- we'll mute them a bit by multiplying them by 0.3
// and then we'll accent on tick 42
[1.0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
 1.0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
 1.0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
 1.0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0] @=> float amen_ride[];
for( 0 => int i; i < amen_ride.cap(); i++ ) amen_ride[i] * 0.3 => amen_ride[i];
1.0 => amen_ride[42];

// snare
[0.0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1,
 0.0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1,
 0.0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0,
 0.0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0] @=> float amen_snare[];

// kick
[1.0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
 1.0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
 1.0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
 0.0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0] @=> float amen_kick[];

// crash is silent except for tick 58
float amen_crash[64];
1.0 => amen_crash[58];

Clock c;
Sampler s[4];
Sampler.sequence(c, "media/ride.aif", amen_ride) @=> s[0];
Sampler.sequence(c, "media/kick.aif", amen_kick) @=> s[1];
Sampler.sequence(c, "media/snare.aif", amen_snare) @=> s[2];
Sampler.sequence(c, "media/crash.aif", amen_crash) @=> s[3];

for (0 => int i; i < s.cap(); i++) {
    s[i].fader => dac;
    s[i].start();
}
c.start();

1::hour => now;
