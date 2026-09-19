return {
  'lervag/vimtex',
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = vim.fn.has('macunix') == 1 and 'skim' or 'zathura'

    -- kompilacja
    vim.g.vimtex_compiler_method = 'latexmk'

    -- quickfix zamiast spamu
    vim.g.vimtex_quickfix_mode = 0

    -- ignoruj warningi
    vim.g.vimtex_quickfix_ignore_filters = {
      'Underfull',
      'Overfull',
    }
    vim.g.vimtex_compiler_latexmk = {
      executable = 'latexmk',
      options = {
        '-lualatex',
        '-interaction=nonstopmode',
        '-synctex=1',
      },
    }
    vim.g.vimtex_compiler_latexmk_engines = {
      _ = '-lualatex',
    }
  end,
}
