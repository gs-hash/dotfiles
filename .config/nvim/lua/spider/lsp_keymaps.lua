local M = {}

function M.on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- 🔎 nawigacja (Telescope)
  map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
  map('n', 'gD', '<cmd>Telescope lsp_definitions<cr>', 'Definitions (Telescope)')
  map('n', 'gr', function()
    require('telescope.builtin').lsp_references({
      show_line = false,
    })
  end, 'References')
  map('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', 'Implementation')
  map('n', '<leader>ds', function()
    require('telescope.builtin').lsp_document_symbols({
      symbols = { 'function', 'method', 'class' },
    })
  end, 'Document symbols')
  map('n', '<leader>ws', function()
    require('telescope.builtin').lsp_dynamic_workspace_symbols()
  end, 'Workspace symbols')
  map('n', '<leader>pd', function()
    require('telescope.builtin').lsp_definitions({
      jump_type = 'never',
    })
  end, 'Peek definition')
  -- 📖 info
  map('n', 'K', vim.lsp.buf.hover, 'Hover')
  -- map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')

  -- ✏️ akcje
  map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
  map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')

  -- 🧹 format
  map('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, 'Format')

  -- ⚠️ diagnostyka
  map('n', '[d', vim.diagnostic.goto_prev, 'Prev diagnostic')
  map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
  map('n', '<leader>e', vim.diagnostic.open_float, 'Line diagnostics')
  map('n', '<leader>q', vim.diagnostic.setqflist, 'Diagnostics (quickfix)')
end

return M
