local keymap = vim.keymap.set

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "g,", "g,zvzz")
keymap("n", "g;", "g;zvzz")

-- Scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Paste
-- keymap("n", "]p", "o<Esc>p", { desc = "Paste below" })
-- keymap("n", "]P", "O<Esc>p", { desc = "Paste above" })

-- Better escape using jk in insert and terminal mode
-- keymap("i", "jk", "<ESC>")
keymap("t", "<C-[>", "<C-\\><C-n>")
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h")
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j")
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k")
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dp')

-- Move Lines
-- keymap("n", "<A-j>", ":m .+1<CR>==")
-- keymap("v", "<A-j>", ":m '>+1<CR>gv=gv")
-- keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
-- keymap("n", "<A-k>", ":m .-2<CR>==")
-- keymap("v", "<A-k>", ":m '<-2<CR>gv=gv")
-- keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Resize window using <shift> arrow keys
keymap("n", "<S-Up>", "<cmd>resize +2<CR>")
keymap("n", "<S-Down>", "<cmd>resize -2<CR>")
keymap("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
keymap("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

-- Insert blank line
keymap("n", "]<Space>", "o<Esc>")
keymap("n", "[<Space>", "O<Esc>")

-- Map vi window-split key to <alt+w>, then map horizontal and vertical window split keys
keymap("n", "<M-w>", "<C-w>")
keymap("n", "<M-w>[", "<C-w>s")
keymap("n", "<M-w>]", "<C-w>v")
keymap("n", "<M-w>k", "<C-w><Up>")
keymap("n", "<M-w>h", "<C-w><Left>")
keymap("n", "<M-w>j", "<C-w><Down>")
keymap("n", "<M-w>l", "<C-w><Right>")

keymap("n", "J", "<cmd>:res +5<CR>")
keymap("n", "K", "<cmd>:res -5<CR>")
keymap("n", "L", "<cmd>:vertical resize +5<CR>")
keymap("n", "H", "<cmd>:vertical resize -5<CR>")

keymap("n", "_", "<C-w>K")
keymap("n", "+", "<C-w>J")

-- Auto indent
keymap("n", "i", function()
  if #vim.fn.getline "." == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

-- previous / next buffer keymap alias
keymap("n", "<M-left>", "<C-o>")
keymap("n", "<M-right>", "<C-i>")

keymap("n", "<M-7>", "<cmd>:SymbolsOutline<CR>")

-- https://www.visidata.org/docs/man/
keymap("n", "vd", ":lua vim.fn.system('tmux split-window -v vd ' .. require('nvim-tree.api').tree.get_node_under_cursor().absolute_path)<CR>")
-- if you want to do this with vsplit it would be something like the following. I leave it here just in case..
-- keymap("n", "vd", "<cmd>vsplit term://vd <cfile><CR>")
-- keymap("n", "vd", ":lua vsplit term://vd ' .. require('nvim-tree.api').tree.get_node_under_cursor().absolute_path)<CR>")

function get_yanked_value()
  return require("utils").get_register_value { sanitize = true }
end

keymap("n", "<leader>sr", function() 
 return ":cdo s/" .. get_yanked_value() .. "//gc | update<left><left><left><left><left><left><left><left><left><left><left><left>"
end, {expr = true})


function get_word_under_cursor()
    return vim.fn.expand('<cword>')
end

keymap("n", "<leader>re", function() 
 return ":%s /" .. get_word_under_cursor() .. "//gc | update<left><left><left><left><left><left><left><left><left><left><left><left>"
end, {expr = true})

-- this does not seem to work.. what are the <, >? I switched to get_word_under_cursor. much easier to implement using cword
-- I leave it here in case I need this in the future.. don't know.
local function get_visual_selection()
  -- local s_start = vim.fn.getpos("'<")
  -- local s_end = vim.fn.getpos("'>")
  -- local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  -- local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  -- lines[1] = string.sub(lines[1], s_start[3], -1)
  -- if n_lines == 1 then
  --   lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  -- else
  --   lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  -- end
  -- return table.concat(lines, '\n')
end

