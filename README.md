# Neovim Configuration

## Structure - Plugins

Configure `lazy.nvim` to manage all plugins under the `lua/plugins` folder.

`lazy.nvim` makes it very easy and flexible to configure plugins. For our configuration:

- For common plugins (e.g., plenary.nvim, nui.nvim, nvim-web-devicons, dressing.nvim, etc), we use the plugins/init.lua file.
- For plugins that do not need many configurations (e.g., dial.nvim, numb.nvim, neogit, diffview.nvim, etc), we use the plugins/init.lua file.
- Plugins that require more configurations will have their own configuration files, e.g. WhichKey, Telescope, and Tree-sitter.
- For similar plugins that require more configurations, e.g. LSP, and color schemes, they will have their own folders.

Every `*.lua` file in `lua/plugins/` is automatically sourced!
Actually it appears that everything is sourced, all `init.lua` files even if they are contained in separate folders. that's lazy :-)

There is a plugin management section here: <https://alpha2phi.medium.com/modern-neovim-init-lua-ab1220e3ecc1>

### Plugin Management

In file `config/lazy.lua`:

    vim.keymap.set("n", "<leader>zz", "<cmd>:Lazy<cr>", { desc = "Manage Plugins" })

## Autocommands

### Intro

Lua functions that are executed as a response to an event.

List of events:

    :h events

To check current autocommand settings for an event (e.g. BufEnter):

    :au BufEnter

Examples:

    local group = vim.api.nvim_create_augroup("Smash", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", { command = "echo 'Hello'", group = group })
    local mystr = "Hello"
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            print

###

I have created autocommands for processing VimEnter event and

1. opening nvim tree
2. add folding arrows (using ufo module)

### Formatting

A plugin used for formatting is `null-ls`.

Documentation: <https://github.com/nvimtools/none-ls.nvim/blob/main/doc/MAIN.md>

In `lsp/init.lua` where the plugin is defined we set the `shfmt` for formatting bash files by default.
In `pde/../init.lua` we extend the source formatters with more , e.g. `stylua, prettierd, black` etc. 

Type `:NullLsInfo` to get active buffer formatters. 
You also get this information in the horizontal bar below. , e.g. bashls (lsp), shfmt (formatting)
now I see marksman / prettierd for md files. interesting

null-ls supports a number of built-in sources. They are categorized in:

* Formatting sources
* Code Action sources
* Diagnostic sources

<https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md>

For shfmt in above link you get the following defaults:

Filetypes: { "sh" }
Method: formatting
Command: shfmt
Args: { "-filename", "$FILENAME" }

You see, it is a formatting type of source. It is operated on sh filetypes. the command is shfmt, and it takes arguments. 
Then I chatgpted arguments for shfmt and found out I can do:

    null_ls.setup {
        sources = {
            null_ls.builtins.formatting.shfmt.with {
            -- Set the indentation level to 4 spaces
            args = { "-i", "4" },
            },
        },
    }

It turns out shfmt is also used by JetBrains, VScode etc..

### Auto-format

In `plugins/lsp/format.lua`, there is this autocmd:

    vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
    buffer = bufnr,
    callback = function()
    if M.autoformat then
    M.format()
    end
    end,
    })

I changed M.autoformat to false in the beginning of the file so that it does not set up the autocommand to execute formatting on every buffer write.

### Treesitter

Treesitter provides many features, such as highlighting, indentation, folding, etc. They are called modules

- [https://github.com/nvim-treesitter/nvim-treesitter#modules](https://github.com/nvim-treesitter/nvim-treesitter#modules)

execute this to get information:

    :TSModuleInfo

#### Changes

Removed this line of code (from file treesitter/init.lua )

    context_commentstring = { enable = true, enable_autocmd = false },

since I was getting errors. This is no longer required in newer versions of treesitter.

#### Comments

Treesitter can be used to add comments to any file.
Actually, for this purpose [https://github.com/numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)
is being used.

in `plugins/init.lua`
I changed the key mappings so ctrl+/ is used to do line comments.

Notes on keymappings:

The default key mapping for comment toggling was gcc. I got this by executing
:map

It showed the comment.nvim plugin is used for this key mapping. Then I went to [https://github.com/numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)

and found out the settings to use to change the key mapping. just configure these in opts, and will be passed to the startup function of the module.

### nvim-tree

migration guide (this is how I found out that all g:... variables are now provided as setup options - because on the internet I was reading configuration that I could not find in docs..)

[https://github.com/nvim-tree/nvim-tree.lua/issues/674](https://github.com/nvim-tree/nvim-tree.lua/issues/674)

and the docs:

[https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt](https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt)

execute this for keymappings

    : g?

nvim-tree mappings exit: q
sort by description: s
<2-LeftMouse> Open  
 <2-RightMouse> CD  
 <C-]> CD  
 <C-E> Open: In Place  
 <C-K> Info  
 <C-R> Rename: Omit Filename  
 <C-T> Open: New Tab  
 <C-V> Open: Vertical Split  
 <C-X> Open: Horizontal Split  
 <BS> Close Directory  
 <CR> Open  
 <Tab> Open Preview

-              Up
  . Run Command
  >              Next Sibling
  >
  > < Previous Sibling  
  > B Toggle Filter: No Buffer
  > C Toggle Filter: Git Clean
  > D Trash  
  > E Expand All  
  > F Clean Filter  
  > H Toggle Filter: Dotfiles  
  > I Toggle Filter: Git Ignore
  > J Last Sibling  
  > K First Sibling  
  > O Open: No Window Picker  
  > P Parent Directory  
  > R Refresh  
  > S Search  
  > U Toggle Filter: Hidden  
  > W Collapse  
  > Y Copy Relative Path  
  > a Create File Or Directory
  > bd Delete Bookmarked  
  > bmv Move Bookmarked  
  > bt Trash Bookmarked  
  > ]c Next Git  
  > [c Prev Git  
  > c Copy  
  > d Delete  
  > e Rename: Basename  
  > [e Prev Diagnostic
  >
  > > ]e Next Diagnostic  
  > > f Filter  
  > > g? Help  
  > > gy Copy Absolute Path  
  > > m Toggle Bookmark  
  > > o Open  
  > > p Paste  
  > > q Close  
  > > r Rename  
  > > s Run System  
  > > u Rename: Full Path  
  > > x Cut  
  > > y Copy Name

### ColorSchemes

Plugins configured in file `lua/plugins/colorscheme/init.lua`

You can enable the plugins by setting
`lazy = false` (so that it is not lazy-loaded - when referenced by a required, but at startup)
`enabled = true` (to enable this)

I decided to use <https://github.com/sainnhe/gruvbox-material/blob/master/README.module>

Useful commands:

    Type :color to view current color-scheme.
    Type :hi to list all color groups.
    Type :hi Statement to view color definations for Statement. (change Statement to what you want)

Semantic highlighting:

<https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316>

### LSP

In the configuration of lazy vim (`lazy.lua`), we import all plugin specs contained in folders `plugins` and `pde`. The `pde` folder contains many LSP configurations for different languages. They will be fetched by using the `config.pde` Lua table, contained in the `config/init.lua` file. Check this:

    if not require("config").pde.docker then
    	return {}
    end

    return {
    	{
    		-- load docker lsp settings
    		-- actually, this contains docker specific configurations for many plugins. somehow they are all merged together
    	}
    }

If you execute `:LspInfo`, you see the installed language servers. These come from servers defined in the `pde` plugin folder, as well as in `lsp.opts.servers` (`plugins/lsp/init.lua` file).

I added `bashls` in `lsp/init.lua`, `opt.servers` and it appears to work. Don't swear.

#### Plugins

so many plugins involved..

    "neovim/nvim-lspconfig", important
    "williamboman/mason.nvim", important
    "utilyre/barbecue.nvim", not used - lspsaga instead
    "folke/trouble.nvim",
    "nvimdev/lspsaga.nvim",
    "Bekaboo/dropbar.nvim",
    "nvimtools/none-ls.nvim", important
    "jay-babu/mason-null-ls.nvim"
    "stevearc/conform.nvim", not used
    "mfussenegger/nvim-lint", not used
    "dnlhc/glance.nvim", not used
    "luckasRanarison/clear-action.nvim", not used

`nvim-lspconfig` plugin is lazy-loaded on events BufReadPre, BufNewFile.
events fired on edit of new or existing file.

I guess this is how it attaches the language server on file open.

most important line:

      require("plugins.lsp.servers").setup(plugin, opts)

this calls the `setup()` function of `servers.lua` file. (more on that below)

Mason:

it is lazy loaded when the command Mason is executed. (cmd plugin option)
-> this opens a graphical status window

From there, you can see installed packages and update them too!

it executes MasonUpdate when the plugin is updated
-> this updates all managed registries

    build = ":MasonUpdate", - not sure what it does.
    cmd = "Mason",

on load, it isntalls the shfmt only - some formatting package in ensure_installed lua table.

LSP features:

- Code actions

- Diagnostics (file- and project-level)

- Formatting (including range formatting)

- Hover

- Completion

The none-ls (aka null-ls) provides a way for non-LSP sources to hook into its LSP client.
It is unique because it doesn't come with its own language server. Instead, it acts as a connector between Neovim and various external programs or scripts that perform language-specific tasks. These external programs are referred to as "sources" in the context of Null-ls.

Null-ls aims to provide language server capabilities without the need to run a separate language server for each supported language. It allows you to use existing tools or scripts that fulfill specific language server functionalities.

You can use Null-ls with different sources, which means you can integrate it with various tools or scripts that suit your workflow. This makes it highly customizable and adaptable to different programming languages or projects.

ok, but in sources I see only

nls.builtins.formatting.shfmt,

and this is also provided by Mason (in ensure_installed). good, but what about all other programming languages?

well. there is mason-lspconfig declared as a dependency in lspconfig.
and this is used in servers.lua file right in the setup() function.

#### servers.setup function

this function registers a callback to LspAttach event that is triggered when an LspClient attaches to a buffer.

So, you open a file, the lsp client gets attached and then an on_attach function is executed to do the
required processing:

- set formatters
- configure keymaps

foreach server, (configued in lspconfig, contained in pde plugin folder too, that during loading of the pluginsextend the servers table of the lspconfig plugin).

the code checks all registrered mason lsp servers and if it does not find an entry for the one being iterated,
it installs this and calls setup. i think. more after debugging this. how to debug lua ?

### init.lua

Used by neovim, as opposed to `init.vim`.

A folder containing an `init.lua` file can be required directly, without having to specify the name of the file.

    require('other_modules') -- loads other_modules/init.lua

### lazy.lua

The `require("lazy").setup` is where the magic happens. This starts up lazy nvim.

Now, the `setup()` function can be either:

    require("lazy").setup(plugins, opts)

or

    require("lazy").setup opts

We use the second version, where the plugin specs (see [lazy.nvim](https://github.com/folke/lazy.nvim#-plugin-spec)) are passed to lazy vim via the `config.spec` parameter, which is actually a Lua table.

The doc says that the default is:

    -- leave nil when passing the spec as the first argument to setup()
    spec = nil, ---@type LazySpec

But we instead use:

    spec = {
    	{ import = "plugins" },
    	{ import = "plugins.ui" },
    	{ import = "plugins.notes" },
    	{ import = "plugins.ai" },
    	{ import = "pde" },
    },

Check: [lazy.nvim Configuration](https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration)

### Lua Tables

#### Example 1: Creating and Accessing Tables

    -- Creating a simple table
    local fruits = {"Apple", "Banana", "Orange"}

    -- Accessing elements in the table
    print(fruits[1]) -- Output: Apple
    print(fruits[2]) -- Output: Banana
    print(fruits[3]) -- Output: Orange

    -- Adding a new element
    fruits[4] = "Grapes"

    -- Iterating through the table
    for i, fruit in ipairs(fruits) do
    print(i, fruit)
    end

#### Example 2: Table with Mixed Types

    -- Creating a table with mixed types
    local person = {
    name = "John",
    age = 30,
    isStudent = true,
    grades = {90, 85, 92},
    }

    -- Accessing elements
    print(person.name) -- Output: John
    print(person.age) -- Output: 30
    print(person.isStudent) -- Output: true
    print(person.grades[1]) -- Output: 90

    -- Modifying a value
    person.age = 31

    -- Adding a new key-value pair
    person.gender = "Male"

#### Example 3: Table as a Dictionary

    -- Creating a table as a dictionary
    local car = {
    model = "Toyota",
    year = 2020,
    color = "Blue",
    }

    -- Accessing elements
    print(car.model) -- Output: Toyota
    print(car.year) -- Output: 2020
    print(car.color) -- Output: Blue

    -- Modifying a value
    car.year = 2022

    -- Removing a key-value pair
    car.color = nil

#### Example 4: Nested Tables

    -- Creating nested tables
    local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9},
    }

    -- Accessing elements in a nested table
    print(matrix[2][3]) -- Output: 6

    -- Modifying a value
    matrix[1][1] = 0

These examples demonstrate some of the basic ways Lua tables can be used, including simple arrays, dictionaries, mixed-type tables, and nested tables. Lua tables are quite flexible and can be adapted to various data structures and use cases.

### Completion

This is achieved using the following two plugins:

- "hrsh7th/nvim-cmp",
- "L3MON4D3/LuaSnip",

These include a `config` function. According to the plugin spec this is executed when the plugin loads and if not specified, it defaults to `require("plugin_name").setup()`.

usually, each plugin has an

- opts function (that retrieves a table with all options when evaluated.)
- a config function that gets the opts as input.

The completion plugin is provided with sources, e.g.

          { name = "nvim_lsp", group_index = 1, max_item_count = 15 },
          { name = "codeium", group_index = 1 },
          { name = "luasnip", group_index = 1, max_item_count = 8 },
          { name = "buffer", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "git", group_index = 2 },
          { name = "orgmode", group_index = 2 },

there are ssoo many completion sources : https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources

### Telescope

<https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes>

i see:

this is imlementated in `utils/init.lua`
require("utils").telescope(...))

implements recipees like:
Falling back to find_files if git_files can't find a .git directory

these two are telescope specific:
require("function() require("telescope").extensions.live_grep_args.live_grep_args() end
require("telescope.builtin").live_grep(

### Logging 

~/.local/state/modern-neovim
~/.local/share/modern-neovim
~/.cache/modern-neovim

say you want to debug/log something. Use vim notify to print the message (e.g. lua table).
Then use nvim-notify telescope extension to view notification history (with <leader> fn).

    -- vim.notify(vim.inspect(require("nvim-tree.api").tree.get_node_under_cursor()), nil)
