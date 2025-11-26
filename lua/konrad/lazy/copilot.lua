return {
    "supermaven-inc/supermaven-nvim",
    config = function()
        require("supermaven-nvim").setup({})
    end,
}
    --[[
return {
{
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_max_lines = 3
      vim.g.copilot_filetypes = {
        ["*"] = true,
        ["markdown"] = false,
      }
    end
  },
{
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          ["*"] = true,
          ["markdown"] = false,
        },
      })
    end,
  },
    {
        "folke/sidekick.nvim",
        event = "VeryLazy",
        opts = {
            nes = {
                debounce = 100,
                diff = { inline = "words" },
            },
            cli = {
                mux = { backend = "tmux", enabled = true },
            },
        },
        keys = {
            {
                "<Tab>",
                function()
                    if require("sidekick").nes_jump_or_apply() then
                        return
                    end

                    if vim.lsp.inline_completion.get() then
                        return
                    end

                    return "<tab>"
                end,
                mode = { "i", "n" },
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
        },
  },
}
]]
