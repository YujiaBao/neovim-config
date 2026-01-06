-- Bootstrap lazy.nvim (Auto-install)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup and load plugins from lua/plugins/
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})
