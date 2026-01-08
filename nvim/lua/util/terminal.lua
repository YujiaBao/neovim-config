local M = {}

local float_term_bufs = {}
local active_float_idx = 1

local function get_float_tabs()
  local status = ""
  local valid_bufs = {}
  for _, buf in ipairs(float_term_bufs) do
    if vim.api.nvim_buf_is_valid(buf) then
      table.insert(valid_bufs, buf)
    end
  end
  float_term_bufs = valid_bufs

  for i, buf in ipairs(float_term_bufs) do
    if i == active_float_idx then
      status = status .. "[" .. i .. "]"
    else
      status = status .. " " .. i .. " "
    end
  end
  if #float_term_bufs == 0 then return " Terminal " end
  return " Terminals: " .. status .. " "
end

function M.switch_float_terminal(delta)
  if #float_term_bufs <= 1 then return end
  
  -- Find current terminal to close its window
  local cur_buf = float_term_bufs[active_float_idx]
  for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
    if term.bufnr == cur_buf then
      term:close()
      break
    end
  end

  active_float_idx = active_float_idx + delta
  if active_float_idx > #float_term_bufs then active_float_idx = 1 end
  if active_float_idx < 1 then active_float_idx = #float_term_bufs end

  local next_buf = float_term_bufs[active_float_idx]
  
  local target_term = nil
  for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
    if term.bufnr == next_buf then
      target_term = term
      break
    end
  end

  if target_term then
    target_term:toggle()
  else
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new({ bufnr = next_buf, direction = "float" })
    term:toggle()
  end
end

function M.create_new_float_terminal()
  local next_id = 1
  local existing_ids = {}
  for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
    existing_ids[term.id] = true
  end
  while existing_ids[next_id] do
    next_id = next_id + 1
  end
  require("toggleterm").toggle(next_id, nil, nil, "float")
end

function M.toggle_main_float()
  if #float_term_bufs == 0 then
    require("toggleterm").toggle(1, nil, nil, "float")
  else
    if active_float_idx > #float_term_bufs then active_float_idx = #float_term_bufs end
    local buf = float_term_bufs[active_float_idx]
    
    -- Self-healing: Ensure buffer is valid
    if not vim.api.nvim_buf_is_valid(buf) then
      table.remove(float_term_bufs, active_float_idx)
      if #float_term_bufs == 0 then
        active_float_idx = 1
        require("toggleterm").toggle(1, nil, nil, "float")
        return
      end
      if active_float_idx > #float_term_bufs then active_float_idx = 1 end
      buf = float_term_bufs[active_float_idx]
    end

    local target_term = nil
    local terminals = require("toggleterm.terminal").get_all(true)
    
    -- First pass: look for OPEN terminal with this buffer
    for _, term in pairs(terminals) do
      if term.bufnr == buf and term:is_open() then
        target_term = term
        break
      end
    end
    
    -- Second pass: if none open, look for any terminal with this buffer
    if not target_term then
        for _, term in pairs(terminals) do
          if term.bufnr == buf then
            target_term = term
            break
          end
        end
    end
    
    if target_term then
      target_term:toggle()
    else
      local Terminal = require("toggleterm.terminal").Terminal
      local term = Terminal:new({ bufnr = buf, direction = "float" })
      term:toggle()
    end
  end
end

function M.on_open(term)
  vim.cmd("startinsert!")
  if term.direction == "float" then
    -- Add to tracking if not present
    local found = false
    for i, buf in ipairs(float_term_bufs) do
      if buf == term.bufnr then 
        active_float_idx = i
        found = true 
        break 
      end
    end
    if not found then
      table.insert(float_term_bufs, term.bufnr)
      active_float_idx = #float_term_bufs
    end

    local config = vim.api.nvim_win_get_config(term.window)
    config.title = get_float_tabs()
    config.title_pos = "center"
    vim.api.nvim_win_set_config(term.window, config)
  end
end

function M.on_exit(term)
  if term.direction == "float" then
    for i, buf in ipairs(float_term_bufs) do
      if buf == term.bufnr then
        table.remove(float_term_bufs, i)
        if active_float_idx > #float_term_bufs then
          active_float_idx = math.max(1, #float_term_bufs)
        end
        break
      end
    end
    
    if #float_term_bufs > 0 then
      vim.defer_fn(function()
        M.toggle_main_float()
      end, 20)
    end
  end
end

return M
