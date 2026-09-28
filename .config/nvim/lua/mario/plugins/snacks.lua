return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          tree = true,
          layout = { preset = "sidebar", preview = false },
        },
      },
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    terminal = { enabled = true },
    toggle = { enabled = true },
    gitbrowse = { enabled = true },
    image = {
      enabled = true,
      doc = {
        inline = false,
        float = true,
      },
    },
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
  config = function(_, opts)
    require("snacks").setup(opts)

    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.inlay_hints():map("<leader>uh")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.indent():map("<leader>ug")
  end,
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
      "<leader>tt",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Toggle terminal",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse.open()
      end,
      mode = { "n", "x" },
      desc = "Open in browser",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename file",
    },
    {
      "<leader>iH",
      function()
        Snacks.image.hover()
      end,
      desc = "Show image at cursor",
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
    {
      "<C-n>",
      function()
        Snacks.picker.explorer({ hidden = true })
      end,
      desc = "Open file sidebar",
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
