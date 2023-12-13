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

-- keymap("n", "vd", "<cmd>vsplit term://vd <cfile><CR>")
-- keymap("n", "vd", ":lua vsplit term://vd ' .. require('nvim-tree.api').tree.get_node_under_cursor().absolute_path)<CR>")

