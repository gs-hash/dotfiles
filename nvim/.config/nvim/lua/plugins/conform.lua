return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        markdown = { 'prettier' },
        java = { 'google-java-format' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = false,
      },
      formatters = {
        shfmt = {
          prepend_args = {
            '-i',
            '4',
            '-ci',
          },
        },
      },
    })
  end,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format()
      end,
      desc = 'Format',
    },
  },
}
