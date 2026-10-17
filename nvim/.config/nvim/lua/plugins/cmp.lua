return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    {
      'hrsh7th/cmp-nvim-lsp',
      config = function()
        local source = require('cmp_nvim_lsp.source')
        local original_execute = source.execute

        -- cmp-nvim-lsp sends commands to the server even when they have a local handler.
        -- Roslyn's complex completions must apply their edits through that local handler.
        source.execute = function(self, item, callback)
          local command = item.command
          local client = self.client
          local handler = command
            and ((client.commands or {})[command.command] or vim.lsp.commands[command.command])

          if handler and not client:is_stopped() then
            client:exec_cmd(command, { bufnr = vim.api.nvim_get_current_buf() })
            -- exec_cmd does not invoke a callback for locally handled commands.
            return callback()
          end

          return original_execute(self, item, callback)
        end
      end,
    },
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'rafamadriz/friendly-snippets',
  },

  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- 🔥 działa jak trzeba

        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          elseif cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-e>'] = cmp.mapping.abort(),
      }),

      sources = cmp.config.sources({
        { name = 'nvim_lsp', keyword_length = 3 },
        { name = 'luasnip', keyword_length = 3 },
        { name = 'path', keyword_length = 3 },
        { name = 'buffer', keyword_length = 3 },
      }),

      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
    })
  end,
}
