return {
  'seblyng/roslyn.nvim',
  dependencies = { 'hrsh7th/cmp-nvim-lsp' },
  opts = {},
  config = function(_, opts)
    local html_document = require('roslyn.razor.htmlDocument')

    if not html_document.virtual_buffer_fix_applied then
      local original_new = html_document.new
      local original_set_content = html_document.setContent

      html_document.new = function(uri)
        local document = original_new(uri)
        vim.fn.bufload(document.buf)
        vim.bo[document.buf].filetype = 'html'
        return document
      end

      html_document.setContent = function(document, checksum, content)
        original_set_content(document, checksum, content)
        if vim.api.nvim_buf_is_valid(document.buf) then
          vim.bo[document.buf].modified = false
        end
      end

      html_document.virtual_buffer_fix_applied = true
    end

    vim.lsp.config('roslyn', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      cmd = { 'roslyn-language-server', '--stdio' },
    })

    require('roslyn').setup(opts)
  end,
}
