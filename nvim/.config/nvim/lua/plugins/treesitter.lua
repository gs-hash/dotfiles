return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local treesitter = require('nvim-treesitter')
      local languages = {
        'c',
        'c_sharp',
        'html',
        'java',
        'markdown',
        'python',
        'razor',
      }

      treesitter.setup()

      local installed = treesitter.get_installed('parsers')
      local missing = vim.tbl_filter(function(language)
        return not vim.list_contains(installed, language)
      end, languages)

      if #missing > 0 then
        treesitter.install(missing):wait(300000)
      end

      local group = vim.api.nvim_create_augroup('treesitter_config', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = { 'c', 'cs', 'html', 'java', 'markdown', 'python', 'razor' },
        callback = function(args)
          vim.treesitter.start(args.buf)
          if vim.bo[args.buf].filetype ~= 'razor' then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
