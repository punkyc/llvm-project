# encoding: utf-8
"""
Test lldb data formatter subsystem.
"""


import lldb
from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import *
from lldbsuite.test import lldbutil

from ObjCDataFormatterTestCase import ObjCDataFormatterTestCase


class ObjCDataFormatterNSError(ObjCDataFormatterTestCase):
    def test_nserror_with_run_command(self):
        """Test formatters for NSError."""
        self.appkit_tester_impl(self.nserror_data_formatter_commands, True)

    @skipUnlessDarwin
    def test_nserror_with_run_command_no_const(self):
        """Test formatters for NSError."""
        self.appkit_tester_impl(self.nserror_data_formatter_commands, False)

    def nserror_data_formatter_commands(self):
        self.expect(
            "frame variable nserror", substrs=['domain: @"Foobar" - code: -1234']
        )

        # The NSError data formatter will not apply to an NSError** after
        # https://github.com/llvm/llvm-project/pull/138209
        # "Add --pointer-match-depth option to type summary add command."
        #
        # Decide if we'll update the objc formatters to 
        # dereference an additional depth level to keep this
        # test working, or if we should drop the behavior.
        #self.expect(
        #    "frame variable nserrorptr", substrs=['domain: @"Foobar" - code: -1234']
        #)

        self.expect("frame variable nserror->_userInfo", substrs=["2 key/value pairs"])

        self.expect(
            "frame variable nserror->_userInfo --ptr-depth 1 -d run-target",
            substrs=['@"a"', "1", '@"b"', "2"],
        )
