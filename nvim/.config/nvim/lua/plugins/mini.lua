return {
  'nvim-mini/mini.nvim',
  version = '*',
  config = function()
    require('mini.files').setup()
    require('mini.comment').setup()
    require('mini.surround').setup()
  end,
}
