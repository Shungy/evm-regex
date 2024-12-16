# RegexVM

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
* 22 ANY
