. ./env
DRIVER=midi/drivers/NovationLaunchKey25.ck

echo $MIDI_LIB $DRIVER
chuck $MIDI_LIB $DRIVER test/NovationTest2.ck
