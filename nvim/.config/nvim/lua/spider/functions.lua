-- Basic autocommands
local augroup = vim.api.nvim_create_augroup('UserConfig', {})

-- Set filetype-specific settings
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = { 'lua', 'python' },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup,
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand('~/.vim/undodir')
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end

-- y kopiuje do schowka, ale tylko w trybie wizualnym
if vim.fn.has('clipboard') == 1 then
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      if vim.v.event.operator == 'y' and vim.v.event.visual then
        vim.fn.setreg('+', vim.fn.getreg('"'))
      end
    end,
  })
end

-- Podświetlanie trailing whitespace (inteligentne)
local ns = vim.api.nvim_create_namespace('trailing_whitespace')

vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg = '#ff4444' })

local function highlight_trailing_whitespace()
  local bufnr = 0
  local win = 0
  local cursor_line = vim.api.nvim_win_get_cursor(win)[1]

  local start_line = vim.fn.line('w0')
  local end_line = vim.fn.line('w$')

  vim.api.nvim_buf_clear_namespace(bufnr, ns, start_line - 1, end_line)

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  for i, line in ipairs(lines) do
    local lnum = start_line + i - 1

    if lnum ~= cursor_line then
      local start = line:find('%s+$')
      if start then
        vim.api.nvim_buf_add_highlight(bufnr, ns, 'TrailingWhitespace', lnum - 1, start - 1, -1)
      end
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMoved', 'InsertLeave', 'WinScrolled' }, {
  callback = highlight_trailing_whitespace,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  end,
})

-- usuwane spacji z końca linii automatycznie przy zapisie
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- Podświetlanie mieszania TAB i spacji
local ns_mix = vim.api.nvim_create_namespace('mixed_indent')

vim.api.nvim_set_hl(0, 'MixedIndent', { bg = '#ffaa00' })

local function highlight_mixed_indent()
  local bufnr = 0

  local start_line = vim.fn.line('w0')
  local end_line = vim.fn.line('w$')

  vim.api.nvim_buf_clear_namespace(bufnr, ns_mix, start_line - 1, end_line)

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  for i, line in ipairs(lines) do
    local lnum = start_line + i - 1

    local indent = line:match('^%s+')

    if indent then
      if indent:find(' \t') or indent:find('\t ') then
        vim.api.nvim_buf_add_highlight(bufnr, ns_mix, 'MixedIndent', lnum - 1, 0, #indent)
      end
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMoved', 'InsertLeave', 'WinScrolled' }, {
  callback = highlight_mixed_indent,
})

-- Wyłączenie tworzenie komentarzy w liniach bezpośrednio pod istniejącym komentarzami
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Zawijanie tekstu
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
})

-- sprawdzanie pisowni w plikach
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'gitcommit', 'text' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rs',
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
