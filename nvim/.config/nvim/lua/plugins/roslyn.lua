return {
  'seblyng/roslyn.nvim',
  dependencies = { 'hrsh7th/cmp-nvim-lsp' },
  opts = {},
  config = function(_, opts)
    vim.lsp.config('roslyn', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      cmd = { 'roslyn-language-server', '--stdio' },
    })

    require('roslyn').setup(opts)
  end,
}
