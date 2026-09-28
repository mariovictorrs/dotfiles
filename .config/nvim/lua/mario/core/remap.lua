vim.g.mapleader = " "

-- QOL keymaps
vim.keymap.set("n", "<C-f>", ":noh<CR>", { desc = "Remove highligth after search", silent = true })
vim.keymap.set("n", "<leader>s", ":set list!<CR>", { desc = "Show hidden chars", silent = true })

-- Save file with <C-s>
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
