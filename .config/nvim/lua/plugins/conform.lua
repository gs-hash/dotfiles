return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        markdown = { 'prettier' },
        java = { 'google-java-format' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = false,
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
