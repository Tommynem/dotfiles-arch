-- Modern JavaScript/Web Debugging Configuration (2025)
local dap = require("dap")
local dapui = require("dapui")

-- Configure js-debug-adapter for modern JavaScript debugging
-- Note: Install js-debug-adapter manually via Mason or npm if needed
local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

-- Only configure if js-debug-adapter is available
if vim.fn.isdirectory(js_debug_path) == 1 then
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        js_debug_path .. "/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
else
  -- Fallback: simple node debugger
  dap.adapters["pwa-node"] = {
    type = "executable",
    command = "node",
    args = { "-e", "require('inspector').open(9229, '127.0.0.1', true); require('fs').writeFileSync('/tmp/node-debug-ready', 'ready')" },
  }
end

-- SvelteKit debugging configuration
dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch SvelteKit Dev Server",
    program = "${workspaceFolder}/node_modules/@sveltejs/kit/src/exports/vite/dev/index.js",
    args = { "dev" },
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
    env = {
      NODE_ENV = "development",
    },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    skipFiles = {
      "<node_internals>/**",
      "**/node_modules/**",
    },
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Debug SvelteKit Build",
    program = "${workspaceFolder}/build/index.js",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    outFiles = { "${workspaceFolder}/build/**/*.js" },
    skipFiles = {
      "<node_internals>/**",
      "**/node_modules/**",
    },
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to SvelteKit Process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    skipFiles = {
      "<node_internals>/**",
      "**/node_modules/**",
    },
  },
}

-- JavaScript debugging (same as TypeScript)
dap.configurations.javascript = dap.configurations.typescript

-- Svelte file debugging (handled via TypeScript)
dap.configurations.svelte = dap.configurations.typescript

-- Auto-open DAP UI when debugging starts
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Catppuccin DAP sign integration
local sign = vim.fn.sign_define
sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})

-- Enhanced DAP UI configuration for web development
dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 10,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "⏸",
      play = "▶",
      step_into = "⏎",
      step_over = "⏭",
      step_out = "⏮",
      step_back = "b",
      run_last = "▶▶",
      terminate = "⏹",
      disconnect = "⏏",
    },
  },
})