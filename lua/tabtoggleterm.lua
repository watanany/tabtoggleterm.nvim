local constants = {
  FILETYPE = "tabtoggleterm",
}

local M = {}

-- default config
M.config = {
  size = 20,
}

-- neovim window & buffer caches
local termwin = {}
local termbuf = {}

-- hander on exit term
local function build_exit_handler(tab)
  return function(...)
    termwin[tab] = nil
    termbuf[tab] = nil
  end
end

-- toggle term in current tab
function M.tab_toggle_term()
  local tab = vim.api.nvim_get_current_tabpage()

  local window_is_valid = termwin[tab] and vim.api.nvim_win_is_valid(termwin[tab])
  local buffer_is_valid = termbuf[tab] and vim.api.nvim_buf_is_valid(termbuf[tab])

  if not window_is_valid and not buffer_is_valid then
    vim.cmd(string.format("botright split | resize %d", M.config.size))
    local window = vim.api.nvim_get_current_win()
    local buffer = vim.api.nvim_create_buf(false, false)

    vim.cmd(string.format("keepalt buffer %d", buffer))
    vim.fn.jobstart(vim.o.shell, {
      term = true,
      on_exit = build_exit_handler(tab),
    })
    vim.api.nvim_set_option_value("filetype", constants.FILETYPE, { buf = buffer })

    termwin[tab] = window
    termbuf[tab] = buffer
  elseif not window_is_valid and buffer_is_valid then
    vim.cmd(string.format("botright split | resize %d", M.config.size))
    local window = vim.api.nvim_get_current_win()
    local buffer = termbuf[tab]

    vim.cmd(string.format("keepalt buffer %d", buffer))

    termwin[tab] = window
    termbuf[tab] = termbuf[tab]
  elseif window_is_valid and not buffer_is_valid then
    local window = termwin[tab]
    local buffer = vim.api.nvim_create_buf(false, false)

    vim.cmd(string.format("keepalt buffer %d", buffer))
    vim.fn.jobstart(vim.o.shell, {
      term = true,
      on_exit = build_exit_handler(tab),
    })
    vim.api.nvim_set_option_value("filetype", constants.FILETYPE, { buf = buffer })

    termbuf[tab] = buffer
  else
    vim.api.nvim_win_close(termwin[tab], true)

    termwin[tab] = nil
  end
end

-- setup neovim commands
local function setup_commands()
  local command = vim.api.nvim_create_user_command
  command("TabToggleTerm", M.tab_toggle_term, { bang = true })
end

function M.setup(user_prefs)
  M.config = vim.tbl_deep_extend("force", M.config, user_prefs)
  setup_commands()
end

return M
