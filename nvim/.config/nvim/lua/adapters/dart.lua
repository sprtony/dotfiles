local dap = require "dap"

dap.adapters.dart = {
    type = "executable",
    command = "node",
    args = {os.getenv('HOME').."/repos/Dart-Code/out/dist/debug.js", "flutter"}
    -- command= "dart",
    -- args = {"debug_adapter"}
}

dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch flutter",
    dartSdkPath = os.getenv('HOME').."/Library/flutter/bin/cache/dart-sdk/",
    flutterSdkPath = os.getenv('HOME').."/Library/flutter",
    -- program = "${workspaceFolder}/lib/main.dart",
    program = "${file}",
    cwd = "${workspaceFolder}",
  }
}
