local map = vim.keymap.set

-- Fast Save/Quit
map("n", "<leader>w", ":w!<CR>", { desc = "Save File" })
map("n", "<leader>q", ":q!<CR>", { desc = "Quit" })

-- Clear Search Highlights
map("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear Highlights" })

-- Lazy.nvim
map("n", "<leader>l", ":Lazy<CR>", { desc = "Lazy Dashboard" })
map("n", "<leader>m", ":Mason<CR>", { desc = "Mason Dashboard" })

-- Window Resizing (Optional, since you use tmux)
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Fold Levels
map("n", "z0", ":set foldlevel=0<CR>", { desc = "Close All Folds" })
map("n", "z1", ":set foldlevel=1<CR>", { desc = "Show Level 1 (Classes)" })
map("n", "z2", ":set foldlevel=2<CR>", { desc = "Show Level 2 (Methods)" })
map("n", "z3", ":set foldlevel=3<CR>", { desc = "Show Level 3" })
map("n", "z4", ":set foldlevel=4<CR>", { desc = "Show Level 4" })

-- Intuitive Fold Toggling
map("n", "zO", "zR", { desc = "Open All Folds" })
map("n", "zC", "zM", { desc = "Close All Folds" })

