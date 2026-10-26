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
          cwd = '${workspaceFolder}',
          env = function()
            local path = vim.fn.getcwd() .. '/Properties/launchSettings.json'
            if vim.fn.filereadable(path) == 0 then
              return {}
            end

            local ok, settings = pcall(function()
              return vim.json.decode(table.concat(vim.fn.readfile(path), '\n'))
            end)
            if not ok or type(settings) ~= 'table' or type(settings.profiles) ~= 'table' then
              vim.notify('Invalid launchSettings.json: ' .. path, vim.log.levels.ERROR)
              return dap.ABORT
            end

            local names = {}
            for name, profile in pairs(settings.profiles) do
              if type(profile) == 'table' and profile.commandName == 'Project' then
                table.insert(names, name)
              end
            end
            table.sort(names)
            if #names == 0 then
              vim.notify('No Project profiles in ' .. path, vim.log.levels.ERROR)
              return dap.ABORT
            end

            local index = 1
            if #names > 1 then
              local choices = { 'Select launchSettings.json profile:' }
              for i, name in ipairs(names) do
                table.insert(choices, i .. '. ' .. name)
              end
              index = vim.fn.inputlist(choices)
            end
            if not names[index] then
              return dap.ABORT
            end

            local profile = settings.profiles[names[index]]
            local env = vim.deepcopy(profile.environmentVariables or {})
            if profile.applicationUrl then
              env.ASPNETCORE_URLS = profile.applicationUrl
            end
            return env
          end,
          program = function()
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end,
        },
      }
      dap.configurations.razor = dap.configurations.cs
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
