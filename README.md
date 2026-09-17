# DECMon

DECMon is a machine-language "workbench" development environment for the
Commodore 64, written entirely in BASIC V2.

It is intended as a bridge between BASIC programming and 6502 machine
language, using the C64's normal BASIC environment and screen editor rather
than requiring a separate monitor or assembler.

DECMon is designed around incremental, interactive construction and inspection
of machine-language programs directly in memory.

## Files

- `decmon.prg`  
  The actual Commodore 64 BASIC program. This is the authoritative runnable
  version of DECMon.

- `decmon.d64`  
  A D64 disk image containing `decmon.prg`, ready for use with an emulator,
  disk-image tool, or compatible Commodore hardware.

- `decmon.bas`  
  A human-readable text listing of the BASIC program, provided mainly for
  convenient reading, searching, comparison, and viewing in modern text
  editors.

- `decmon-readme.txt`  
  Command quick reference.

- `decmon-manual.pdf`  
  Full reference manual and development notes.

- `decmon-manual-link.txt`  
  Link to the live work-in-progress Google Doc for decmon-manual.pdf.

## PETSCII Characters

`decmon.prg` contains literal PETSCII control characters on BASIC lines
3210, 3250, 11470, 11500, 11530, 11555, 11570, amd11590..

These characters are not reproduced in `decmon.bas`.

In all cases, they are a left-cursor keycode immediately prior to the comma in the string literal.
They are purely cosmetic, and serve purely to cause the comma to be immediately adjacent to the number,
which is not otherwise possible with PRINT.

Lines 3205 and 3245 show the strings containing the character in visible commented form.

The `.prg` file should therefore be considered authoritative where the text
listing differs from the original tokenized BASIC program.

## Using DECMon

The simplest way to try DECMon is to mount `decmon.d64` and load the program
normally from BASIC:

    LOAD "DECMON",8
    RUN

Alternatively, `decmon.prg` may be loaded directly by any emulator or tool
that supports Commodore PRG files.

See `decmon-readme.txt` for a command summary and `decmon-manual.pdf` for the
complete documentation.

## Development

DECMon is developed directly as a Commodore 64 BASIC V2 program.

Development versions are edited, tested, and saved as tokenized BASIC PRG
files. The text listing is generated from the working program for convenient
inspection and version comparison.

Release disk images and PRG files are created from tested development
versions.

## Project Status

DECMon is under active development.

The manual may contain documentation for features currently being developed
or planned for future versions.

## License

See `LICENSE.txt`.

This repository is the official upstream repository for DECMon.

## Contact Me

You can reach me with any questions or suggestions at dsunley@gmail.com
