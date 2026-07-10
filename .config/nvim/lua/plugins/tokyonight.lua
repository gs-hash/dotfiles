return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = { style = 'storm' },
  config = function()
    -- load the colorscheme here
    require('tokyonight').setup({
      transparent = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
    })
    vim.cmd([[colorscheme tokyonight]])
  end,
}
