return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        markdown = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        java = { 'google-java-format' },
        cs = { 'csharpier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'never',
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
