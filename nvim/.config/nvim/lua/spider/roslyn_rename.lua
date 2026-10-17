local M = {}

function M.setup()
  local pending = {}
  local group = vim.api.nvim_create_augroup('spider_roslyn_rename', { clear = true })

  -- Neovim updates the document URI on save, but edits/formatting can happen first.
  -- Detach while the old name is still available, flushing changes before didClose.
  vim.api.nvim_create_autocmd('BufFilePre', {
    group = group,
    callback = function(args)
      local ids = {}
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf, name = 'roslyn' })) do
        ids[#ids + 1] = client.id
        vim.lsp.buf_detach_client(args.buf, client.id)
      end
      pending[args.buf] = ids
    end,
  })

  vim.api.nvim_create_autocmd('BufFilePost', {
    group = group,
    callback = function(args)
      local ids = pending[args.buf] or {}
      pending[args.buf] = nil
      for _, id in ipairs(ids) do
        local client = vim.lsp.get_client_by_id(id)
        if client and not client:is_stopped() then
          -- Reattach synchronously: mini.files writes immediately after renaming.
          vim.lsp.buf_attach_client(args.buf, id)
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd('BufWipeout', {
    group = group,
    callback = function(args)
      pending[args.buf] = nil
    end,
  })
end

return M
