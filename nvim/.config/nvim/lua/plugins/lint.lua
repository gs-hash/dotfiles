return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            sh = { "shellcheck" },
            bash = { "shellcheck" },
            zsh = { "shellcheck" },
        }

        local group = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({
            "BufWritePost",
            "BufReadPost",
            "InsertLeave",
        }, {
            group = group,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
