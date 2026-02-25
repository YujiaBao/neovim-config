return {
  -- Gruvbox Theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "dark" -- Ensure dark mode
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Detect and display the active Python interpreter in the statusline.
      -- Priority: .venv (uv/venv) > CONDA_DEFAULT_ENV > VIRTUAL_ENV > system python
      -- Results are cached per working directory to avoid subprocess overhead.
      local cache = {}

      local function python_version(python_path)
        local out = vim.fn.system(python_path .. " --version 2>&1")
        return out:match("%d+%.%d+") or "?"
      end

      -- Walk upward from `start` looking for a directory containing any of the
      -- given markers, but stop once we leave the git repo (i.e. after checking
      -- the directory that contains .git). Returns start if nothing is found.
      local function find_root(start, ...)
        local markers = { ... }
        local dir = start
        while true do
          for _, m in ipairs(markers) do
            if vim.fn.filereadable(dir .. "/" .. m) == 1
              or vim.fn.isdirectory(dir .. "/" .. m) == 1 then
              return dir
            end
          end
          -- Stop after checking the git root; don't escape the repo.
          local parent = vim.fn.fnamemodify(dir, ":h")
          if vim.fn.isdirectory(dir .. "/.git") == 1 or parent == dir then
            return start
          end
          dir = parent
        end
      end

      local function python_env()
        local cwd = vim.fn.getcwd()
        if cache[cwd] then return cache[cwd] end

        local root = find_root(cwd, "uv.lock", ".venv")
        local label
        local venv_python = root .. "/.venv/bin/python"

        if vim.fn.executable(venv_python) == 1 then
          label = " .venv " .. python_version(venv_python)
        elseif vim.fn.filereadable(root .. "/uv.lock") == 1 then
          local py = vim.fn.trim(vim.fn.system(
            "cd " .. vim.fn.shellescape(root)
            .. " && uv run python -c 'import sys; print(sys.executable)' 2>/dev/null"
          ))
          label = (py ~= "" and vim.fn.executable(py) == 1)
            and (" uv " .. python_version(py))
            or ""
        elseif vim.env.CONDA_DEFAULT_ENV then
          local py = vim.fn.exepath("python3")
          label = " conda:" .. vim.env.CONDA_DEFAULT_ENV .. " " .. python_version(py)
        elseif vim.env.VIRTUAL_ENV then
          local py = vim.env.VIRTUAL_ENV .. "/bin/python"
          local name = vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t")
          label = " " .. name .. " " .. python_version(py)
        else
          local py = vim.fn.exepath("python3")
          label = py ~= "" and (" sys " .. python_version(py)) or ""
        end

        cache[cwd] = label   -- keyed by cwd so DirChanged invalidates correctly
        return label
      end

      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function() cache = {} end,
      })

      require("lualine").setup({
        options = { theme = "gruvbox" },
        sections = {
          lualine_x = { python_env, "encoding", "fileformat", "filetype" },
        },
      })
    end,
  },
}
