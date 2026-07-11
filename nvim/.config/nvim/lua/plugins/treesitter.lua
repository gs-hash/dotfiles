return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      ensure_installed = {
        'c',
        'html',
        'python',
        'java',
        'markdown',
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
