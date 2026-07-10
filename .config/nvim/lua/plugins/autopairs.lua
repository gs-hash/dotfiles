return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true, -- 🔥 integracja z treesitter
      ts_config = {
        lua = { 'string' },
        javascript = { 'string', 'template_string' },
        java = false,
      },
    },
    config = function(_, opts)
      local npairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')
      local conds = require('nvim-autopairs.conds')

      npairs.setup(opts)

      -- 🔥 Markdown: ogarnięte ```
      npairs.add_rules({
        Rule('```', '```', 'markdown')
          :with_pair(function(opts)
            -- nie dodawaj jeśli już są ```
            return not opts.line:match('^%s*```')
          end)
          :with_move(function()
            return false
          end)
          :with_cr(function(opts)
            return true
          end)
          :use_key('`'),
      })
    end,
  },
}
