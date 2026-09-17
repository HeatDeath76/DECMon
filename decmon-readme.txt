          DECMon v1.2 – Command Summary

GENERAL
-------
Commands use space- or comma-separated parameters.
Quotes preserve spaces and commas inside a parameter.
Addresses accepted in:
  49152        (decimal)
  $C000        (hex)
  P192:0       (page:offset)
Bytes accepted in:
  147          (decimal)
  $C0          (hex)
Decimal numbers may include + and - operators:
  49152+2-38
  -2+36


MEMORY / EXECUTION
------------------
SYS [addr]                Execute machine code
RUN [addr]                Alias for SYS
                          (no addr reuses last SYS/RUN address)
MEM                       Show BASIC memory layout

PEEK <addr>               Show 10 bytes starting at address
GRID <addr> [num]         Show grid of memory cells in hex, 8 per row
                          (starts from addr)
                          (if num is absent, defaults to 8 lines)
						  (num must be larger than 0 and less than 21)
POKE <addr> <b1> [b2...]  Write one or more bytes [up to 9]
                          (SUPPRESS applies)
INIT <start> <end> [byte] Fills start through end inclusive with byte
NEW <start> <end> [byte]  Alias for INIT
                          (no byte uses default 96 (RTS opcode))
                          (SUPPRESS applies)
G <addr> <b1> [b2...]     Write bytes without normal POKE echo
                          (SUPPRESS applies)
                          (triggered by pressing return in GRID view)
SUPPRESS [ON|OFF]         Show/change write suppression
                          (affects POKE/G/INIT and assembler writes)


ASSEMBLER ENTRY
---------------
[A] <addr> <byte> [addr|byte] [byte] 
                          Write one instruction directly using byte/address values
                          (SUPPRESS applies)
                          (triggered by pressing return in LIST entry)
                          (omitting A suppresses messages)


RANGES / DISPLAY
----------------
RANGE [<start> <end>]     Show/set default LIST range
LIST [<start> [end]]      Dump memory as editable addr/byte lines
                          (no args uses default RANGE)
PD <p:o>                  Page/offset → decimal
DP <addr>                 Decimal → page/offset


NUMBER CONVERSION
-----------------
HD <$hex>                 Hex → decimal
DH <num>                  Decimal → hex
SPLIT <addr>              Address → low byte, high byte
                          (decimal and hex)
COMP <l byte> <h byte>    Low byte, high byte → address
						  (decimal and hex)
TWOSC <num>               Branch interval → two's complement
                          (range -128 to 127; decimal and hex)


DISK
----
SAVE <name> <dev> <start> <end>
LOAD <name> <dev>

  dev = 8 (disk) or 1 (tape)

  SAVE writes start through end, inclusive
  LOAD loads to original address


MISC
----
HELP / H / ?              Show command list
X / EXIT                  Exit DECMon


NOTES
-----
• Max 10 parameters per command
• Spaces and commas separate parameters outside quotes
• Computed decimal expressions are resolved before use
• LIST pauses every ~20 lines
• RETURN key exits LIST paging
