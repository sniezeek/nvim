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
  }
}
