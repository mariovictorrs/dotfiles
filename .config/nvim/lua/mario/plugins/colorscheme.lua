return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    -- config = function()
    --   vim.cmd.colorscheme("tokyonight-moon")
    -- end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
    opts = {
      integrations = {
        dap = true,
        dap_ui = true,
        cmp = true,
        blink_cmp = true,
        dashboard = true,
        gitsigns = true,
        headlines = true,
        dropbar = {
          enabled = false,
          color_mode = true, -- enable color for kind's texts, not just kind's icons
        },
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        harpoon = true,
        illuminate = {
          enabled = true,
          lsp = false,
        },
      },
    },
  },
}
