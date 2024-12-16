# RegexVM

* Only anchored search, that is, the string must match from start to end.
* No backreferencing possible.
* Limited to 512 backtracking frames.
* Limited to block gas limit.
* Other than that fully featured pattern matching VM.
* TODO: Write a regex compiler to compile to the below instruction set.

## Program structure

* Instructions are read from calldata (CD).
* First 2 CD bytes must declare the length of the instruction bytes.
* The last instruction byte must be the MATCH_END opcode.
* The string must follow directly after the MATCH_END opcode.
* There must be nothing else following the string bytes.
* A progress opcode must not follow another progress opcode directly (ie. no back to back progress checks, it would ruin the memory)
* Matching is always anchored to the beginning and end, therefore there is no anchor opcodes.
* Staticcalls to the contract should be made with gas limit.
* 1024 stack size limits us to max 512 backtracking frames.

## Instructions

* 00 CHAR1 - The next byte in the program is compared against the byte at SP
* 01 CHAR2 - The next two bytes in the program are compared against the two bytes at SP
* 02 CHAR3
* 03 CHAR4
* 04 CHAR5
* 05 CHAR6
* 06 CHAR7
* 07 CHAR8
* 08 CHAR9
* 09 CHAR10
* 0a CHAR11
* 0b CHAR12
* 0c CHAR13
* 0d CHAR14
* 0e CHAR15
* 0f CHAR16
* 10 CHAR17
* 11 CHAR18
* 12 CHAR19
* 13 CHAR20
* 14 CHAR21
* 15 CHAR22
* 16 CHAR23
* 17 CHAR24
* 18 CHAR25
* 19 CHAR26
* 1a CHAR27
* 1b CHAR28
* 1c CHAR29
* 1d CHAR30
* 1e CHAR31
* 1f CHAR32 - The next 32 bytes in the program are compared against the 32 bytes at SP
* 20 BITMAP16 - The next 16 bytes in the program are used as a bitmap to check the byte at SP matches the class
* 21 BITMAP32 - The next 32 bytes in the program are used as a bitmap to check the byte at SP matches the class
* 22 ANY - Matches any single character in SP
* 24 RANGE_ASCII - The next byte and the following byte are used to check the the byte at SP is within it.
* 25 RANGE_UNICODE - The next two bytes and the two bytes following that are used to check the two bytes at SP are within it.
* 26 JUMP1 - The PC is set to the next byte in the program.
* 27 JUMP2 - The PC is set to the next two bytes in the program
* 28 SPLIT1 - The next byte in the program will be set as the PC when the current execution fails.
* 29 SPLIT2 - The next two bytes in the program will be set as the PC when the current execution fails.
* 2a MATCH_END - Returns success if the string is fully consumed. Combination of ANCHOR and MATCH.
