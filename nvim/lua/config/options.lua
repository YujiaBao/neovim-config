local opt = vim.opt

-- Set Leader Key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Visuals
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.scrolloff = 7           -- Keep cursor away from edges
opt.signcolumn = 'yes'      -- Prevent text shifting for git signs
opt.cursorline = true

-- Indentation (Python standard)
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

-- Search
opt.ignorecase = true
opt.smartcase = true

-- System
opt.clipboard = "unnamedplus" -- Sync with Mac clipboard
opt.undofile = true           -- Persistent undo
opt.updatetime = 250          -- Faster completion update
opt.timeoutlen = 300          -- Faster key sequence completion

-- Disable netrw (Using neo-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
