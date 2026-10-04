-- starts in insert mode
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    if vim.opt.buftype:get() == "terminal" then
      vim.cmd(":startinsert")
    end
  end,
})

--Find the ID of a window containing a terminal
local function findTerminalWindow(termBufID)
  local termWin = nil
  local wins = vim.api.nvim_list_wins()
  for _, v in pairs(wins) do
    if termBufID == vim.api.nvim_win_get_buf(v) then
      termWin = v
      break
    end
  end
  return termWin
end

--Find a terminal buffer
local function findBufferID()
  for _, v in pairs(vim.api.nvim_list_bufs()) do
    if string.find(vim.api.nvim_buf_get_name(v), "term://") then
      return v
    end
  end
  return nil
end

--configure the terminal window
local function getTermConfig()
  local splitWinHeight = math.floor(vim.api.nvim_win_get_height(0) * 0.40)
  -- in case of open terminal when a float window is open
  if splitWinHeight < 1 then
    splitWinHeight = 5
  end

  local termConfig = {
    win = 0,
    height = splitWinHeight,
    split = "below",
    style = "minimal",
  }

  return termConfig
end

local function toggleTerminal()
  local termBufID = findBufferID()

  if termBufID then
    -- if the current buffer is a terminal, we want to hide it
    if vim.bo.buftype == "terminal" then
      local winID = vim.api.nvim_get_current_win()
      vim.api.nvim_win_hide(winID)
    else
      -- if the terminal window is currently active, switch focus to it, otherwise open the terminal buffer in a
      -- new window
      local termWin = findTerminalWindow(termBufID)
      if termWin then
        vim.api.nvim_set_current_win(termWin)
      else
        vim.api.nvim_open_win(termBufID, true, getTermConfig())
      end
    end
  else
    -- if no terminal window/buffer exists, create one
    termBufID = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_open_win(termBufID, true, getTermConfig())
    vim.cmd("term")
    vim.cmd("syntax-off")
  end
end

vim.keymap.set("n", "<leader>t", toggleTerminal, { desc = "Open or switch to terminal" })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
