// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

library Opcode {
    bytes1 constant         CHAR1 = 0x00;
    bytes1 constant         CHAR2 = 0x01;
    bytes1 constant         CHAR3 = 0x02;
    bytes1 constant         CHAR4 = 0x03;
    bytes1 constant         CHAR5 = 0x04;
    bytes1 constant         CHAR6 = 0x05;
    bytes1 constant         CHAR7 = 0x06;
    bytes1 constant         CHAR8 = 0x07;
    bytes1 constant         CHAR9 = 0x08;
    bytes1 constant        CHAR10 = 0x09;
    bytes1 constant        CHAR11 = 0x0a;
    bytes1 constant        CHAR12 = 0x0b;
    bytes1 constant        CHAR13 = 0x0c;
    bytes1 constant        CHAR14 = 0x0d;
    bytes1 constant        CHAR15 = 0x0e;
    bytes1 constant        CHAR16 = 0x0f;
    bytes1 constant        CHAR17 = 0x10;
    bytes1 constant        CHAR18 = 0x11;
    bytes1 constant        CHAR19 = 0x12;
    bytes1 constant        CHAR20 = 0x13;
    bytes1 constant        CHAR21 = 0x14;
    bytes1 constant        CHAR22 = 0x15;
    bytes1 constant        CHAR23 = 0x16;
    bytes1 constant        CHAR24 = 0x17;
    bytes1 constant        CHAR25 = 0x18;
    bytes1 constant        CHAR26 = 0x19;
    bytes1 constant        CHAR27 = 0x1a;
    bytes1 constant        CHAR28 = 0x1b;
    bytes1 constant        CHAR29 = 0x1c;
    bytes1 constant        CHAR30 = 0x1d;
    bytes1 constant        CHAR31 = 0x1e;
    bytes1 constant        CHAR32 = 0x1f;
    bytes1 constant      BITMAP16 = 0x20;
    bytes1 constant      BITMAP32 = 0x21;
    bytes1 constant           ANY = 0x22;
    bytes1 constant   RANGE_ASCII = 0x23;
    bytes1 constant RANGE_UNICODE = 0x24;
    bytes1 constant         JUMP1 = 0x25;
    bytes1 constant         JUMP2 = 0x26;
    bytes1 constant        SPLIT1 = 0x27;
    bytes1 constant        SPLIT2 = 0x28;
    bytes1 constant      PROGRESS = 0x29;
    bytes1 constant     MATCH_END = 0x2a;
}

library RegexVmHelper {
    function addStartEnd(bytes memory instructions) internal view returns (bytes memory) {
        bytes memory program = abi.encodePacked(instructions, Opcode.MATCH_END);
        bytes2 len = bytes2(uint16(program.length + 2));
        return abi.encodePacked(len, program);
    }
}

contract BasicTest is Test {
    address regexVM;

    function setUp() public {
        regexVM = HuffDeployer.deploy("RegexVM");
    }

    function test_char1() public {
        // regex: `^i$`
        bytes memory program = RegexVmHelper.addStartEnd(abi.encodePacked(
            Opcode.CHAR1,
            hex'69'
        ));

        bytes memory str = hex'69';

        (bool success, bytes memory data) = regexVM.staticcall(abi.encodePacked(program, str));

        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));
    }

    function test_fail_char1() public {
        bytes memory program = RegexVmHelper.addStartEnd(abi.encodePacked(
            Opcode.CHAR1,
            hex'69'
        ));
        bytes memory str = hex'66';
        (bool success, bytes memory data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertFalse(abi.decode(data, (bool)));
    }

    function test_failempty_char1() public {
        bytes memory program = RegexVmHelper.addStartEnd(abi.encodePacked(
            Opcode.CHAR1,
            hex'69'
        ));
        bytes memory str = hex'';
        (bool success, bytes memory data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertFalse(abi.decode(data, (bool)));
    }

    function test_faillong_char1() public {
        bytes memory program = RegexVmHelper.addStartEnd(abi.encodePacked(
            Opcode.CHAR1,
            hex'69'
        ));
        bytes memory str = hex'6969';
        (bool success, bytes memory data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertFalse(abi.decode(data, (bool)));
    }

    function test_employer_string() public {
        // regex: `employ(|er|ee|ment|ing|able)`
        bytes memory program = RegexVmHelper.addStartEnd(abi.encodePacked(
            abi.encodePacked(
                Opcode.CHAR6,
                "employ",

                Opcode.SPLIT1,
                hex'0c', // to second split' // 0x0b

                Opcode.MATCH_END,

                Opcode.SPLIT1
            ),
            abi.encodePacked(
                hex'12', // to ee

                Opcode.CHAR2,
                "er",

                Opcode.MATCH_END,

                Opcode.SPLIT1,
                hex'18', // to ment

                Opcode.CHAR2,
                "ee",

                Opcode.MATCH_END
            ),
            abi.encodePacked(
                Opcode.SPLIT1,
                hex'20', // to ing

                Opcode.CHAR4,
                "ment",

                Opcode.MATCH_END,

                Opcode.SPLIT1,
                hex'27', // to able

                Opcode.CHAR3,
                "ing",

                Opcode.MATCH_END,

                Opcode.CHAR4,
                "able"
            )
        ));

        emit log_bytes(program);

        string memory str = "employ";
        (bool success, bytes memory data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));

        str = "employer";
        (success, data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));

        str = "employee";
        (success, data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));

        str = "employment";
        (success, data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));

        str = "employing";
        (success, data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));

        str = "employable";
        (success, data) = regexVM.staticcall(abi.encodePacked(program, str));
        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));
    }

    function test_range_unicode(bytes2 char) public {
        // all chinese chars
        bytes memory program = RegexVmHelper.addStartEnd(abi.encodePacked(
            Opcode.RANGE_UNICODE,
            hex'4E00'
            hex'9FFF'
        ));

        // clamp to the target range
        // U+4E00..U+9FFF
        char = bytes2(uint16(bound(uint16(char), 19968, 40959)));

        (bool success, bytes memory data) = regexVM.staticcall(abi.encodePacked(program, char));
        assertTrue(success);
        assertTrue(abi.decode(data, (bool)));
    }

    function test_fail_range_unicode(bytes2 char) public {
        // all chinese chars
        bytes memory program = RegexVmHelper.addStartEnd(abi.encodePacked(
            Opcode.RANGE_UNICODE,
            hex'4E00'
            hex'9FFF'
        ));

        // ignore correct range
        // U+4E00..U+9FFF
        vm.assume(uint16(char) > 40959 || uint16(char) < 19968);

        (bool success, bytes memory data) = regexVM.staticcall(abi.encodePacked(program, char));
        assertTrue(success);
        assertFalse(abi.decode(data, (bool)));
    }
}
