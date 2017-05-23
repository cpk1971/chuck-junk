Clock c;
128 => c.resolution;
c.start();

while(true) {
    c.tick => now;
    <<< c.measure(), c.mcount(), c.btick() >>>;
}
