# DICTIONARY

Comprehensive documentation can be found on the [MARS Website](https://courses.missouristate.edu/kenvollmar/mars/help/MarsHelpIntro.html).

Added for ease of use when developing MIPS programs.

## Include

**.include : include multiple files**

```
.include "another_file.asm"
```

requirement: they must be in the same dir

---

## Macros

**.macro : basically functions, we will use these to make code readable and easier to develop, as the program gets larger and larger.**

for example, a simple macro that terminates the program:

```
.macro done     #macro called done
    li $v0, 10  #system terminate code
    syscall     #request

.end_macro      #macro definition ends here

```

macros may also take registers or immediate vals as arguments (very similar to C) like such:

```
.macro printInt (%x)     #macro called printInt
    li $v0, 1            #read integer code
    add $a0, $zero, %x   #load integer value into an address register
    syscall              #request
.end_macro               #end macro define
```

given the macro name printInt, **both of the following** macro invocations are valid:

1. `printInt ($s0)`
2. `printInt 10`

---

## Game Utilities:

[Syscall Documentation at MARS website](https://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html)

Note that sevice codes 30 or above are exclusive to the MARS application. This is not a problem, since the game is exclusively self-contained within MARS.

### Time and Timer Management

| Service     | $v0 Code | Argument Registers | Notes                                                                                  |
| ----------- | -------- | ------------------ | -------------------------------------------------------------------------------------- |
| System time | 30       | takes none         | Since MARS is a java application, the system time is sourced using JSE from Unix epoch |

> as java.util.Date.getTime()

### Random Number Generator

| Service    | $v0 Code | Argument Registers      | Notes |
| ---------- | -------- | ----------------------- | ----- |
| set seed   | 40       | $a0 : i.d. of pseudorng |       |
| random int | 41       | $a0 : i.d. of pseduorng |       |

Uses underlying Java pseudorandom number generators provided by the java.util.Random class. Each stream (identified by $a0 contents) is modeled by a different Random object. There are no default seed values, so use the Set Seed service (40) if replicated random sequences are desired.

### Tone Generator via Musical Instrument Digital Interface (MIDI)

| Service              | $v0 Code | Argument Registers       | Notes                                                                          |
| -------------------- | -------- | ------------------------ | ------------------------------------------------------------------------------ |
| MIDI Output          | 31       | $a0 : pitch - 0-127      | see below                                                                      |
|                      |          | $a1 : duration - ms      |                                                                                |
|                      |          | $a2 : instrument - 0-127 |                                                                                |
|                      |          | $a3 : volume - 0-127     |                                                                                |
| MIDI out synchronous | ^        | ^                        | Same as MIDI output; however generates tone then sleep for the tone's duration |

> as javax.sound.midi package

#### **pitch ($a0)** :

Accepts a positive byte value (0-127) that denotes a pitch as it would be represented in MIDI. Each number is one semitone / half-step in the chromatic scale.

0 represents a very low C and 127 represents a very high G (a standard 88 key piano begins at 9-A and ends at 108-C).
If the parameter value is outside this range, it applies a default value 60 which is the same as middle C on a piano. From middle C, all other pitches in the octave are as follows:

| Code | Tone    | Code | Tone    |
| ---- | ------- | ---- | ------- |
| 61   | C# / Db | 62   | D       |
| 63   | D# / Eb | 64   | E / Fb  |
| 65   | E# / F  | 66   | F# / Gb |
| 67   | G       | 68   | G# / Ab |
| 69   | A       | 70   | A# / Bb |
| 71   | B / Cb  | 72   | B# / C  |

> Note: To produce these pitches in other octaves, add or subtract multiples of 12.

#### **duration in milliseconds ($a1)** :

Accepts a positive integer value that is the length of the tone in milliseconds. If the parameter value is negative, it applies a default value of one second (1000 milliseconds).

#### **instrument ($a2)** :

Accepts: (0-127)
Default: 0 as Acoustic GP
The 128 available patches are divided into instrument families of 8:

| Code  | Tone                 | Code    | Tone          |
| ----- | -------------------- | ------- | ------------- |
| 0-7   | Piano                | 64-71   | Reed          |
| 8-15  | Chromatic Percussion | 72-79   | Pipe          |
| 16-23 | Organ                | 80-87   | Synth Lead    |
| 24-31 | Guitar               | 88-95   | Synth Pad     |
| 32-39 | Bass                 | 96-103  | Synth Effects |
| 40-47 | Strings              | 104-111 | Ethnic        |
| 48-55 | Ensemble             | 112-119 | Percussion    |
| 56-63 | Brass                | 120-127 | Sound Effects |

For a full list of General MIDI instruments, see www.midi.org/about-midi/gm/gm1sound.shtml.
The General MIDI channel 10 percussion key map is not relevant to the toneGenerator method because it always defaults to MIDI channel 1.

#### **volume ($a3)** :

Accepts: (0-127) where 127 is the loudest and 0 is silent. This value denotes MIDI velocity which refers to the initial attack of the tone.
Default value : 100.
MIDI velocity measures how hard a note on (or note off) message is played, perhaps on a MIDI controller like a keyboard. Most MIDI synthesizers will translate this into volume on a logarithmic scale in which the difference in amplitude decreases as the velocity value increases.
