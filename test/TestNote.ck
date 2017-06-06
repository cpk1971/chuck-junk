Note.of_value("C4").with_length("D4") @=> Note @ n;
derp(n);
Note.of_value("Ab3").with_length("T4") @=> n;
derp(n);
Note.of_value("D#-1").with_length("2") @=> n;
derp(n);

Note.of_values(["C4", "E4", "G4"]) @=> Note x[];
derp(x[2]);

fun void derp(Note @ n) {
    <<< n.toString() >>>;
}
