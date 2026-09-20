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
        razor = { lsp_format = 'fallback' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
      },
      format_on_save = function(bufnr)
        local is_razor = vim.bo[bufnr].filetype == 'razor'
        return {
          timeout_ms = is_razor and 2000 or 500,
          lsp_format = is_razor and 'fallback' or 'never',
        }
      end,
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
