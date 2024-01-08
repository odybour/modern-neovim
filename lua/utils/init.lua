local M = {}

M.root_patterns = { ".git", "lua" }

local function default_on_open(term)
  vim.cmd "startinsert"
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

function M.open_term(cmd, opts)
  opts = opts or {}
  opts.size = opts.size or vim.o.columns * 0.5
  opts.direction = opts.direction or "float"
  opts.on_open = opts.on_open or default_on_open
  opts.on_exit = opts.on_exit or nil
  opts.dir = opts.dir or "git_dir"

  local Terminal = require("toggleterm.terminal").Terminal
  local new_term = Terminal:new {
    cmd = cmd,
    dir = opts.dir,
    auto_scroll = false,
    close_on_exit = false,
    on_open = opts.on_open,
    on_exit = opts.on_exit,
  }
  new_term:open(opts.size, opts.direction)
end

function M.quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd "qa!"
      end
    end)
  else
    vim.cmd "qa!"
  end
end

function M.fg(name)
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

function M.bg(group, color)
  vim.cmd("hi " .. group .. " guibg=" .. color)
end

function M.fg_bg(group, fg_color, bg_color)
  vim.cmd("hi " .. group .. " guifg=" .. fg_color .. " guibg=" .. bg_color)
end

function M.find_files()
  local opts = {}
  local telescope = require "telescope.builtin"

  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

function M.reload_module(name)
  require("plenary.reload").reload_module(name)
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)

        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

function M.get_register_value(opts)
  -- this merges the tables, but uses the rightmost table value (if cwd is false, then it will stay as is)
  opts = vim.tbl_deep_extend("force", { sanitize = false }, opts or {})

  -- get copied value from unnamed register
  local search_value = vim.fn.getreg ""

  if opts.sanitize then
    -- if nil, replace with empty string
    search_value = search_value or ""
    -- Replace newline characters with an empty string
    search_value = search_value:gsub("\n", "")
    -- Replace double quotes with \"
    search_value = search_value:gsub('"', '\\"')
    -- Truncate the yanked value to a maximum of 200 characters
    search_value = search_value:sub(1, 200)
  end

  return search_value
end

-- otan kaleitai apo fg, tote sta opts prepei na orizei to search_value na mhn einai yank, alla cword

-- I use the telescope live_grep_args extension so that it is possible to manipulate the live search interactively.
-- I mean, give arguments like -ws , --iglob etc in search string and not in code.
-- Ripgrep is used under the scenes. check available arguments:
-- https://jdhao.github.io/2020/02/16/ripgrep_cheat_sheet/
-- The iglob comes from the live grep args extension:
-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
function M.find_in_files(opts)
  local lga = require("telescope").extensions.live_grep_args
  -- get name of folder selected in nvim tree
  local node = require("nvim-tree.api").tree.get_node_under_cursor()
  -- vim.notify(vim.inspect(node))

  local search_value

  if opts.search_key_source == "yank" or node.type == "directory" then
    search_value = M.get_register_value { sanitize = true }
  elseif opts.search_key_source == "cword" then
    search_value = vim.fn.expand "<cword>"
  else
    search_value = ""
  end

  local search_expression = string.format('"%s" -ws', search_value)

  if node.type == "directory" then
    local dir_name = node.name
    search_expression = search_expression .. string.format(" --iglob=**/%s/**/*", dir_name)
  else
    search_expression = search_expression .. " --iglob=*"
  end

  local on_complete_callback = {}
  -- note: I am also doing this using a <C-r> mapping in live args extension. I leave this code here to show how one can register an action to execute automatically after a search is complete
  if opts.replace == true then
    on_complete_callback = {
      function(picker)
        local prompt_bufnr = picker.prompt_bufnr
        local actions = require "telescope.actions"
        actions.send_to_qflist(prompt_bufnr)
        actions.open_qflist()
        local replace_cmd = ":cdo %s/" .. search_value .. "//gc | update<left><left><left><left><left><left><left><left><left><left><left><left>"
        -- the replace termcodes is used to translate <left> into moving the cursor to the left
        local keys = vim.api.nvim_replace_termcodes(replace_cmd, false, false, true)
        vim.api.nvim_feedkeys(keys, "n", true)
      end,
    }
  end

  lga.live_grep_args {
    default_text = search_expression,
    on_complete = on_complete_callback,
  }
end

function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    -- this merges the tables, but uses the rightmost table value (if cwd is false, then it will stay as is)
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require "telescope.actions.state"
          local line = action_state.get_current_line()
          M.telescope(params.builtin, vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line }))()
        end)
        return true
      end
    end

    -- vim.notify(vim.inspect(opts), nil, { title = plugin })
    -- vim.notify(vim.inspect(builtin), nil, { title = plugin })
    require("telescope.builtin")[builtin](opts)
  end
end

function M.join_paths(...)
  local path_sep = vim.loop.os_uname().version:match "Windows" and "\\" or "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

function M.find_string(table, string)
  local found = false
  for _, v in pairs(table) do
    if v == string then
      found = true
      break
    end
  end
  return found
end

local is_windows = vim.loop.os_uname().version:match "Windows"
local path_separator = is_windows and "\\" or "/"

function M.remove_path_last_separator(path)
  if not path then
    return ""
  end
  if path:sub(#path) == path_separator then
    return path:sub(1, #path - 1)
  end
  return path
end

return M
