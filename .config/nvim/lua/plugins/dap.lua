return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap = require('dap')

    dap.set_log_level('TRACE')
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
    dap.adapters.coreclr = {
      type = 'executable',
      command = 'netcoredbg',
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

    -- Rust
    dap.adapters.codelldb = {
      type = 'executable',
      command = vim.fn.expand('~/.local/share/codelldb/extension/adapter/codelldb'),
    }

    dap.configurations.rust = {
      {
        name = 'Launch Rust',
        type = 'codelldb',
        request = 'launch',
        program = function()
          -- 🔨 build projektu
          os.execute('cargo build')

          local cwd = vim.fn.getcwd()
          local target = cwd .. '/target/debug/'

          -- 🧠 spróbuj zgadnąć nazwę binarki (nazwa folderu)
          local default = target .. vim.fn.fnamemodify(cwd, ':t')

          -- jeśli istnieje → użyj
          if vim.fn.filereadable(default) == 1 then
            return default
          end

          -- fallback → wybór ręczny
          return vim.fn.input('Executable: ', target, 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
  end,
}
