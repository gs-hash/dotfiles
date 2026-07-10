return {
  'neovim/nvim-lspconfig',
  config = function()
    -- 🧠 wspólne capabilities (jeśli używasz cmp to tu podepniesz)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- 🌙 LUA
    vim.lsp.config('lua_ls', {
      capabilities = capabilities,
    })
    vim.lsp.enable('lua_ls')

    -- 📄 LATEX
    vim.lsp.config('texlab', {})
    vim.lsp.enable('texlab')

    -- C#
    vim.lsp.config('csharp_ls', {
      cmd = { 'csharp-ls' },
      filetypes = { 'cs' },
      root_markers = {
        '*.sln',
        '*.csproj',
        '.git',
      },
    })

    vim.lsp.enable('csharp_ls')

    -- 🦀 RUST (tu dokładamy)
    vim.lsp.config('rust_analyzer', {
      capabilities = capabilities,
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
    vim.lsp.enable('rust_analyzer')
  end,
}
