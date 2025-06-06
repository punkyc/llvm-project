import os

import dap_server
import lldbdap_testcase
from lldbsuite.test import lldbtest, lldbutil
from lldbsuite.test.decorators import *


class TestDAP_commands(lldbdap_testcase.DAPTestCaseBase):
    def test_command_directive_quiet_on_success(self):
        program = self.getBuildArtifact("a.out")
        command_quiet = (
            "settings set target.show-hex-variable-values-with-leading-zeroes false"
        )
        command_not_quiet = (
            "settings set target.show-hex-variable-values-with-leading-zeroes true"
        )
        self.build_and_launch(
            program,
            initCommands=["?" + command_quiet, command_not_quiet],
            terminateCommands=["?" + command_quiet, command_not_quiet],
            stopCommands=["?" + command_quiet, command_not_quiet],
            exitCommands=["?" + command_quiet, command_not_quiet],
        )
        full_output = self.collect_console(
            timeout_secs=1.0,
            pattern=command_not_quiet,
        )
        self.assertNotIn(command_quiet, full_output)
        self.assertIn(command_not_quiet, full_output)

    def do_test_abort_on_error(
        self,
        use_init_commands=False,
        use_launch_commands=False,
        use_pre_run_commands=False,
        use_post_run_commands=False,
    ):
        program = self.getBuildArtifact("a.out")
        command_quiet = (
            "settings set target.show-hex-variable-values-with-leading-zeroes false"
        )
        command_abort_on_error = "settings set foo bar"
        commands = ["?!" + command_quiet, "!" + command_abort_on_error]
        self.build_and_launch(
            program,
            initCommands=commands if use_init_commands else [],
            launchCommands=commands if use_launch_commands else [],
            preRunCommands=commands if use_pre_run_commands else [],
            postRunCommands=commands if use_post_run_commands else [],
            expectFailure=True,
        )
        full_output = self.collect_console(
            timeout_secs=1.0,
            pattern=command_abort_on_error,
        )
        self.assertNotIn(command_quiet, full_output)
        self.assertIn(command_abort_on_error, full_output)

    def test_command_directive_abort_on_error_init_commands(self):
        self.do_test_abort_on_error(use_init_commands=True)

    def test_command_directive_abort_on_error_launch_commands(self):
        self.do_test_abort_on_error(use_launch_commands=True)

    def test_command_directive_abort_on_error_pre_run_commands(self):
        self.do_test_abort_on_error(use_pre_run_commands=True)

    def test_command_directive_abort_on_error_post_run_commands(self):
        self.do_test_abort_on_error(use_post_run_commands=True)

    def test_command_directive_abort_on_error_attach_commands(self):
        command_quiet = (
            "settings set target.show-hex-variable-values-with-leading-zeroes false"
        )
        command_abort_on_error = "settings set foo bar"
        program = self.build_and_create_debug_adapter_for_attach()
        resp = self.attach(
            program=program,
            attachCommands=["?!" + command_quiet, "!" + command_abort_on_error],
            expectFailure=True,
        )
        self.assertFalse(resp["success"], "expected 'attach' failure")
        full_output = self.collect_console(
            timeout_secs=1.0,
            pattern=command_abort_on_error,
        )
        self.assertNotIn(command_quiet, full_output)
        self.assertIn(command_abort_on_error, full_output)
