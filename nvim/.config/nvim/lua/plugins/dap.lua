return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap = require('dap')

    dap.set_log_level('INFO')
    dap.configurations.java = {
      {
        type = 'java',
        request = 'attach',
        name = 'Attach Spring Boot',
        hostName = '127.0.0.1',
        port = 5005,
      },
    }

    -- C#
    local netcoredbg = vim.fn.exepath('netcoredbg')
    local local_netcoredbg = vim.fn.expand('~/.local/share/netcoredbg/netcoredbg')
    if netcoredbg == '' and vim.fn.executable(local_netcoredbg) == 1 then
      netcoredbg = local_netcoredbg
    end

    if netcoredbg ~= '' then
      dap.adapters.coreclr = {
        type = 'executable',
        command = netcoredbg,
        args = { '--interpreter=vscode' },
      }

      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'Launch',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end,
        },
      }
    end

    -- Rust
    local codelldb = vim.fn.exepath('codelldb')
    local local_codelldb = vim.fn.expand('~/.local/share/codelldb/extension/adapter/codelldb')
    if codelldb == '' and vim.fn.executable(local_codelldb) == 1 then
      codelldb = local_codelldb
    end

    if codelldb ~= '' then
      dap.adapters.codelldb = {
        type = 'executable',
        command = codelldb,
      }

      dap.configurations.rust = {
        {
          name = 'Launch Rust',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
    end
  end,
}
