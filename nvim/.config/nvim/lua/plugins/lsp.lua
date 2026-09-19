return {
  'neovim/nvim-lspconfig',
  dependencies = { 'hrsh7th/cmp-nvim-lsp' },
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local keymaps = require('spider.lsp_keymaps')

    local group = vim.api.nvim_create_augroup('lsp_keymaps', { clear = true })
    vim.api.nvim_create_autocmd('LspAttach', {
      group = group,
      callback = function(args)
        keymaps.on_attach(nil, args.buf)
      end,
    })

    local function enable(server, executable, config)
      if vim.fn.executable(executable) == 0 then
        return
      end

      vim.lsp.config(
        server,
        vim.tbl_deep_extend('force', {
          capabilities = capabilities,
        }, config or {})
      )
      vim.lsp.enable(server)
    end

    enable('lua_ls', 'lua-language-server')
    enable('texlab', 'texlab')
    enable('html', 'vscode-html-language-server')
    if vim.fn.executable('roslyn-language-server') == 0 then
      enable('csharp_ls', 'csharp-ls')
    end

    enable('rust_analyzer', 'rust-analyzer', {
      settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
          },
          check = {
            command = 'clippy',
          },
        },
      },
    })
    enable('bashls', 'bash-language-server')
  end,
}
