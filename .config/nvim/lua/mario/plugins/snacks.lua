return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = { enabled = true },
    bigfile = { enabled = true },
    lazygit = { enabled = true },
    indent = {
      animate = {
        enabled = true,
      },
    },
    dashboard = { enabled = true },
    input = { enabled = true },
    words = { enabled = true },
    notifier = {
      enabled = true,
      filter = function(notif)
        return notif.title ~= "pyright" and notif.title ~= "basedpyright"
      end,
    },
    scroll = { enabled = true },
    statuscolumn = {
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = false, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },
  },
  keys = {
    {
      "<leader>lg",
      function()
        Snacks.lazygit()
      end,
      desc = "Open Lazygit",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      { desc = "Delete Current Buffer" },
    },
    {
      "]]",
      function()
        Snacks.words.jump(1, true)
      end,
      desc = "Jump to next reference",
    },
    {
      "[[",
      function()
        Snacks.words.jump(-1, true)
      end,
      desc = "Jump to previous reference",
    },
    {
      "<leader>h",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Show notification history",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files({ hidden = true })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find git",
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.grep({ hidden = true })
      end,
      desc = "Find string in file",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "Find references",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Find Buffers",
    },
    {
      "<leader>u",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo Tree",
    },
    {
      "<leader>fd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Open Diagnostics",
    },
    -- Experimental
    {
      "<leader>sb",
      function()
        Snacks.picker.explorer({ hidden = true })
      end,
      desc = "File explorer",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
  },
}
