local map = vim.keymap.set

-- Fast Save/Quit
map("n", "<leader>w", ":w!<CR>", { desc = "Save File" })
map("n", "<leader>q", ":q!<CR>", { desc = "Quit" })

-- Clear Search Highlights
map("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear Highlights" })

-- Window Resizing (Optional, since you use tmux)
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")
