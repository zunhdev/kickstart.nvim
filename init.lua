--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
-- Stamp startup begin so the dashboard can report load time without lazy.nvim.
-- (Snacks' built-in `startup` section reads `lazy.stats`, which we don't have.)
_G.NVIM_START_TIME = vim.uv.hrtime()

do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '


  -- New UI opt-in
  require('vim._core.ui2').enable({})

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  --  See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.o.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10
  -- Horizontal counterpart to scrolloff (matters when wrap is off)
  vim.o.sidescrolloff = 8

  -- Cursor shape per mode + blink (a non-blinking cursor is easy to lose)
  vim.o.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20,'
    .. 'a:blinkwait700-blinkoff400-blinkon250'

  -- Highlight only the line number, less noisy than the whole line
  vim.o.cursorlineopt = 'number'

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true

  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config & Keymaps
  --  See `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  -- Restore last cursor position when reopening a file
  vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Return to last edit position',
    group = vim.api.nvim_create_augroup('kickstart-last-pos', { clear = true }),
    callback = function(args)
      local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
      local lcount = vim.api.nvim_buf_line_count(args.buf)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })
end

-- ============================================================
-- SECTION 2: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  -- `vim.pack` is a new plugin manager built into Neovim,
  --  which provides a Lua interface for installing and managing plugins.
  --
  --  See `:help vim.pack`, `:help vim.pack-examples` or the
  --  excellent blog post from the creator of vim.pack and mini.nvim:
  --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
  --
  --  To inspect plugin state and pending updates, run
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  To update plugins, run
  --    :lua vim.pack.update()
  --
  --
  --  Throughout the rest of the config there will be examples
  --  of how to install and configure plugins using `vim.pack`.
  --
  --  In this section we set up some autocommands to run build
  --  steps for certain plugins after they are installed or updated.

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 3: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  -- [[ Installing and Configuring Plugins ]]
  --
  -- To install a plugin simply call `vim.pack.add` with its git url.
  -- This will download the default branch of the plugin, which will usually be `main` or `master`
  -- You can also have more advanced specs, which we will talk about later.
  --
  -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
  --
  -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
  -- automatically detecting and setting the indentation.
  --
  -- We first install it from https://github.com/NMAC427/guess-indent.nvim
  -- and then call its `setup()` function to start it with default settings.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- Because lua is a real programming language, you can also have some logic to your installation -
  -- like only installing a plugin if a condition is met.
  --
  -- Here we only install `nvim-web-devicons` (which adds pretty icons) if we have a Nerd Font,
  -- since otherwise the icons won't display properly.
  if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

  -- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
  --
  -- See `:help gitsigns` to understand what each configuration key does.
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
  }

  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'x' } },
      { '<leader>f', group = '[F]ind' }, -- Snacks file/buffer pickers
      { '<leader>u', group = '[U]I / Toggle' }, -- e.g. <leader>uC colorschemes
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
      { 'ga', group = 'LSP C[a]lls', mode = { 'n' } }, -- gai / gao incoming/outgoing calls
    },
  }

  -- [[ Colorscheme ]]
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command under that to load whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:lua Snacks.picker.colorschemes()`.
  vim.pack.add { gh 'savq/melange-nvim' }

  -- Load the colorscheme here.
  -- Melange has no `setup()`; it follows `vim.o.background`, so flip this to
  -- 'light' for the light variant.
  vim.o.background = 'dark'
  vim.cmd.colorscheme 'melange'

  -- Highlight todo, notes, etc in comments
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  -- Smooth animated cursor trail
  vim.pack.add { gh 'sphamba/smear-cursor.nvim' }
  require('smear_cursor').setup {}

  -- [[ mini.nvim ]]
  --  A collection of various small independent plugins/modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  -- Automatically insert matching brackets, quotes, etc. as you type.
  -- (Ships inside mini.nvim, just not enabled by default.) Pairs nicely with nvim-ts-autotag.
  require('mini.pairs').setup()

  -- Simple and easy statusline.
  --  You could remove this setup call if you don't like it,
  --  and try some other statusline plugin
  local statusline = require 'mini.statusline'
  -- Set `use_icons` to true if you have a Nerd Font
  statusline.setup { use_icons = vim.g.have_nerd_font }

  -- You can configure sections in the statusline by overriding their
  -- default behavior. For example, here we set the section for
  -- cursor location to LINE:COLUMN
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end

  -- ... and there is more!
  --  Check out: https://github.com/nvim-mini/mini.nvim
end

-- ============================================================
-- SECTION 4: SEARCH & NAVIGATION
-- Snacks picker setup, keymaps, LSP picker mappings
-- ============================================================
do
  -- [[ Fuzzy Finder (files, lsp, etc) ]]
  --
  -- `snacks.nvim` is a collection of small QoL plugins by folke. Here we use only
  -- its `picker` module: a fast, built-in fuzzy finder that can search files, live
  -- grep, buffers, your workspace, LSP symbols, diagnostics, and much more.
  --
  -- Why Snacks picker (vs. Telescope, which this config used previously)?
  --  - It ships its own fzf-syntax fuzzy matcher, so there is NO native build step
  --    (no `telescope-fzf-native` / `make` required).
  --  - `picker.ui_select = true` replaces `vim.ui.select` natively, so we don't need
  --    a separate `telescope-ui-select` extension for code-action menus, etc.
  --
  -- The easiest way to open a picker is to call one of its sources directly:
  --  :lua Snacks.picker.help()
  --
  -- A window opens with a prompt; type to fuzzy-filter, and the matching entry is
  -- previewed alongside the list. While a picker is open, press `?` to see all of
  -- its keymaps and actions — a great way to discover what each picker can do.
  --
  -- For a list of every available picker source, run `:lua Snacks.picker.pickers()`,
  -- and to confirm the picker is healthy run `:checkhealth snacks`.
  --
  -- See `:help snacks-picker` for the full reference.

  vim.pack.add { gh 'folke/snacks.nvim' }

  require('snacks').setup {
    -- We enable the picker and dashboard modules here. Snacks ships many other
    -- modules (explorer, notifier, git pickers, ...) — add more to this table later.
    picker = {
      -- Route `vim.ui.select` through the Snacks picker (this is the default, set
      -- explicitly here for clarity). This is what gives `vim.lsp.buf.code_action`
      -- and other selection prompts the nice fuzzy UI — replacing telescope-ui-select.
      ui_select = true,
    },
    -- Start screen shown when running `nvim` with no file. A two-pane layout:
    -- left = header + a menu of actions, right = recent files + recent projects.
    -- All menu actions route through the Snacks pickers configured above.
    --
    -- NOTE: we deliberately do NOT use the built-in `startup` section — it reads
    -- startup time from `lazy.stats`, which doesn't exist here (we use the native
    -- `vim.pack`, not lazy.nvim). Instead the custom footer below derives load time
    -- from `_G.NVIM_START_TIME` (stamped at the top of this file) and counts plugins
    -- via `vim.pack.get()`.
    dashboard = {
      enabled = true,
      preset = {
        -- stylua: ignore
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File',      action = ':lua Snacks.dashboard.pick("files")' },
          { icon = ' ', key = 'n', desc = 'New File',       action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text',      action = ':lua Snacks.dashboard.pick("live_grep")' },
          { icon = ' ', key = 'r', desc = 'Recent Files',   action = ':lua Snacks.dashboard.pick("oldfiles")' },
          { icon = ' ', key = 'c', desc = 'Config',         action = ':lua Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") })' },
          { icon = ' ', key = 'C', desc = 'Colorschemes',   action = ':lua Snacks.picker.colorschemes()' },
          { icon = '󰚰 ', key = 'u', desc = 'Update Plugins', action = ':lua vim.pack.update()' },
          { icon = ' ', key = 'q', desc = 'Quit',           action = ':qa' },
        },
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        -- Custom footer: startup time + plugin count, with no lazy.nvim dependency.
        function()
          local now = vim.uv.hrtime()
          local ms = math.floor((now - (_G.NVIM_START_TIME or now)) / 1e6 + 0.5)
          local count = #vim.pack.get()
          return {
            align = 'center',
            padding = 1,
            text = {
              { '⚡ Loaded ', hl = 'footer' },
              { tostring(count) .. ' plugins', hl = 'special' },
              { ' in ', hl = 'footer' },
              { ms .. 'ms', hl = 'special' },
            },
          }
        end,
      },
    },
  }

  -- [[ Picker keymaps ]]
  -- These use Snacks' own recommended default bindings (see `:help snacks-picker`).
  -- Each is wrapped in a function so the picker is only created when the key is
  -- pressed (`Snacks` becomes a global after `setup()` above).

  -- Files / buffers
  vim.keymap.set('n', '<leader><space>', function() Snacks.picker.smart() end, { desc = 'Smart Find Files' })
  vim.keymap.set('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = '[,] Find existing buffers' })
  vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = '[F]ind [B]uffers' })
  vim.keymap.set('n', '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[F]ind [C]onfig File' })
  vim.keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = '[F]ind [F]iles' })
  vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = '[F]ind [R]ecent files' })

  -- Search (`<leader>s*`)
  vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = '[/] Grep' })
  vim.keymap.set('n', '<leader>:', function() Snacks.picker.command_history() end, { desc = 'Command History' })
  vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = '[S]earch [B]uffer lines' })
  vim.keymap.set('n', '<leader>sB', function() Snacks.picker.grep_buffers() end, { desc = '[S]earch open [B]uffers (grep)' })
  vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
  -- `grep_word` greps the word under the cursor (normal) or the selection (visual).
  vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>s"', function() Snacks.picker.registers() end, { desc = '[S]earch ["]registers' })
  vim.keymap.set('n', '<leader>s/', function() Snacks.picker.search_history() end, { desc = '[S]earch [/] history' })
  vim.keymap.set('n', '<leader>sa', function() Snacks.picker.autocmds() end, { desc = '[S]earch [A]utocmds' })
  vim.keymap.set('n', '<leader>sc', function() Snacks.picker.command_history() end, { desc = '[S]earch [C]ommand history' })
  vim.keymap.set('n', '<leader>sC', function() Snacks.picker.commands() end, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = '[S]earch buffer [D]iagnostics' })
  vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sH', function() Snacks.picker.highlights() end, { desc = '[S]earch [H]ighlights' })
  vim.keymap.set('n', '<leader>si', function() Snacks.picker.icons() end, { desc = '[S]earch [I]cons' })
  vim.keymap.set('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = '[S]earch [J]umps' })
  vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sl', function() Snacks.picker.loclist() end, { desc = '[S]earch [L]ocation list' })
  vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = '[S]earch [M]arks' })
  vim.keymap.set('n', '<leader>sM', function() Snacks.picker.man() end, { desc = '[S]earch [M]an pages' })
  vim.keymap.set('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = '[S]earch [Q]uickfix list' })
  vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>su', function() Snacks.picker.undo() end, { desc = '[S]earch [U]ndo history' })
  vim.keymap.set('n', '<leader>uC', function() Snacks.picker.colorschemes() end, { desc = '[U]I [C]olorschemes' })

  -- Add Snacks LSP pickers when an LSP attaches to a buffer.
  -- These follow Snacks' default LSP bindings. If you later switch picker plugins,
  -- this is the single place to update them.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('snacks-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      -- Jump to the definition of the word under your cursor.
      -- This is where a variable was first declared, or where a function is defined, etc.
      -- To jump back, press <C-t>.
      vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { buffer = buf, desc = 'LSP: [G]oto [D]efinition' })

      -- WARN: This is Goto Declaration, NOT Goto Definition.
      --  For example, in C this would take you to the header.
      vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { buffer = buf, desc = 'LSP: [G]oto [D]eclaration' })

      -- Find references for the word under your cursor.
      -- NOTE: We deliberately do NOT pass `nowait` here (Snacks' default does). Without
      -- `nowait`, pressing `gr` waits `timeoutlen` for a follow-up key, so the `gr`-prefixed
      -- LSP buf actions defined in Section 5 (`grn` rename, `gra` code action, `grD` ...)
      -- stay reachable.
      vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { buffer = buf, desc = 'LSP: [G]oto [R]eferences' })

      -- Jump to the implementation of the word under your cursor.
      -- Useful when your language has ways of declaring types without an actual implementation.
      vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { buffer = buf, desc = 'LSP: [G]oto [I]mplementation' })

      -- Jump to the type of the word under your cursor.
      -- Useful when you're not sure what type a variable is and you want to see
      -- the definition of its *type*, not where it was *defined*.
      vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { buffer = buf, desc = 'LSP: Goto T[y]pe Definition' })

      -- Browse the call hierarchy: who calls this symbol (incoming) and what it calls (outgoing).
      vim.keymap.set('n', 'gai', function() Snacks.picker.lsp_incoming_calls() end, { buffer = buf, desc = 'LSP: C[a]lls [I]ncoming' })
      vim.keymap.set('n', 'gao', function() Snacks.picker.lsp_outgoing_calls() end, { buffer = buf, desc = 'LSP: C[a]lls [O]utgoing' })

      -- Fuzzy find all the symbols in your current document.
      -- Symbols are things like variables, functions, types, etc.
      vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { buffer = buf, desc = 'LSP: [S]earch document [S]ymbols' })

      -- Fuzzy find all the symbols in your current workspace.
      -- Similar to document symbols, except searches over your entire project.
      vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { buffer = buf, desc = 'LSP: [S]earch workspace [S]ymbols' })
    end,
  })
end

-- ============================================================
-- SECTION 5: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
  -- [[ LSP Configuration ]]
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  -- Useful status updates for LSP.
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end

      -- When the ESLint language server attaches, fix + format this buffer on every save.
      -- `LspEslintFixAll` is a command the ESLint server itself provides; it applies your
      -- project's ESLint autofixes (formatting rules included) in one pass — so ESLint, not
      -- prettier/conform, is what formats JS/TS/Vue files here.
      if client and client.name == 'eslint' then
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = event.buf,
          command = 'LspEslintFixAll',
        })

        -- Also route the manual `<leader>f` format key through ESLint for this buffer. Without
        -- this, `<leader>f` would fall through to the TypeScript server's (vtsls) own formatter
        -- (because conform.nvim has no JS/TS/Vue formatter and falls back to the LSP), which
        -- would fight your ESLint formatting rules. The buffer-local map shadows the global one.
        vim.keymap.set({ 'n', 'x' }, '<leader>f', '<cmd>LspEslintFixAll<cr>', { buffer = event.buf, desc = '[F]ormat buffer (ESLint)' })
      end
    end,
  })

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --  See `:help lsp-config` for information about keys and how to configure
  -- Vue 3 works in "hybrid mode": the Vue server (`vue_ls`) only handles the template/CSS,
  -- while the TypeScript server (`vtsls`) handles the `<script>` TypeScript — but ONLY if it
  -- loads Vue's `@vue/typescript-plugin`. That plugin ships *inside* the Mason-installed
  -- `vue-language-server` package. The subfolder it lives in has historically been either
  -- `@vue/language-server` or `@vue/typescript-plugin`, so we probe for whichever exists.
  --
  -- NOTE: On the very first launch the package isn't installed yet, so this returns the default
  -- path; it resolves correctly once Mason finishes installing and you restart Neovim.
  local function vue_typescript_plugin_location()
    local base = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue'
    for _, sub in ipairs { '/language-server', '/typescript-plugin' } do
      if vim.uv.fs_stat(base .. sub) then return base .. sub end
    end
    return base .. '/language-server'
  end

  ---@type table<string, vim.lsp.Config>
  local servers = {
    -- [[ Go ]]
    -- `gopls` is the official Go language server. These settings enable the most useful extras.
    -- We deliberately do NOT set `gofumpt = true` here, because formatting is done by conform.nvim
    -- (Section 6) — enabling it in both places would format the file twice.
    gopls = {
      settings = {
        gopls = {
          staticcheck = true, -- run the extra `staticcheck` analyzers for richer diagnostics
          usePlaceholders = true, -- on completion, fill function arguments as editable snippets
          completeUnimported = true, -- suggest symbols from packages you haven't imported yet
          analyses = {
            unusedparams = true, -- flag unused function parameters
            unusedwrite = true, -- flag writes to variables that are never read
            nilness = true, -- flag redundant nil checks / guaranteed nil dereferences
          },
          -- Inlay hints stay hidden until you toggle them with `<leader>th` (see LspAttach above);
          -- these just decide WHICH hints appear once enabled.
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },

    -- [[ TypeScript / JavaScript — and TypeScript inside .vue files ]]
    -- `vtsls` is a fast wrapper around the official TypeScript server. We load Vue's TypeScript
    -- plugin into it so the SAME server also understands `.vue` files. Two required bits:
    --   * `filetypes` is extended to include `vue` (its default omits it).
    --   * the plugin's `languages` list must include `vue`.
    -- Formatting is left to ESLint (see `eslint` below), not vtsls.
    vtsls = {
      filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = '@vue/typescript-plugin',
                location = vue_typescript_plugin_location(),
                languages = { 'vue' },
                configNamespace = 'typescript',
              },
            },
          },
        },
        -- Which inlay hints to show once toggled on with `<leader>th`.
        typescript = {
          inlayHints = {
            parameterNames = { enabled = 'literals' },
            variableTypes = { enabled = false },
            functionLikeReturnTypes = { enabled = true },
          },
        },
      },
    },

    -- [[ Vue — template + CSS half of hybrid mode ]]
    -- `vue_ls` only handles `<template>` and `<style>`; the `<script>` TypeScript is answered by
    -- `vtsls` above. nvim-lspconfig's default `vue_ls` config already wires the two servers
    -- together (via an `on_init` handler that forwards TS requests to vtsls), so an empty table
    -- is all we need.
    vue_ls = {},

    -- [[ ESLint — linter AND formatter for JS/TS/Vue ]]
    -- The ESLint language server surfaces your project's lint rules as diagnostics. Because your
    -- projects also use ESLint for formatting, we run its `LspEslintFixAll` command on save
    -- (wired up in the LspAttach autocmd above) instead of pulling in prettier.
    eslint = {},

    stylua = {}, -- Used to format Lua code

    -- Special Lua Config, as recommended by neovim help docs
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          format = { enable = false }, -- Disable formatting (formatting is done by stylua)
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  -- Automatically install LSPs and related tools to stdpath for Neovim
  require('mason').setup {}

  -- Ensure the servers and tools above are installed
  --
  -- To check the current status of installed tools and/or manually install
  -- other tools, you can run
  --    :Mason
  --
  -- You can press `g?` for help in this menu.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- Extra tools (and a couple of explicit LSP package names) for Mason to install.
    -- We spell out the exact Mason package names here because mason-tool-installer's automatic
    -- "lspconfig name -> Mason package name" translation can miss recently renamed servers
    -- (notably the `volar` -> `vue_ls` rename), which would make a server silently fail to install.
    'vue-language-server', -- the Vue server + bundled @vue/typescript-plugin
    'eslint-lsp', -- vscode-eslint-language-server
    'goimports', -- Go: organize imports + format
    'gofumpt', -- Go: stricter gofmt
  })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- SECTION 6: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- You can specify filetypes to autoformat on save here:
      local enabled_filetypes = {
        go = true, -- format Go with goimports + gofumpt on save
        -- lua = true,
        -- python = true,
        -- NOTE: JS/TS/Vue are intentionally NOT here — they are formatted by ESLint on save
        -- (see the eslint LspAttach autocmd in Section 5), not by conform.
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
      -- Go: run goimports FIRST (adds/removes/sorts imports), THEN gofumpt (stricter gofmt).
      -- Conform runs a filetype's formatters in listed order.
      go = { 'goimports', 'gofumpt' },
      -- NOTE: no entries for javascript/typescript/vue on purpose — those are handled by the
      -- ESLint language server (Section 5), per your "ESLint is the formatter" setup.
      --
      -- rust = { 'rustfmt' },
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SECTION 7: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
  -- [[ Snippet Engine ]]

  -- NOTE: You can also specify plugin using a version range for its git tag.
  --  See `:help vim.version.range()` for more info
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  --
  -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  -- require('luasnip.loaders.from_vscode').lazy_load()

  -- [[ Autocomplete Engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See `:help blink-cmp-config-keymap` for defining your own keymap
      preset = 'default',

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See `:help blink-cmp-config-fuzzy` for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 8: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
  -- [[ Configure Treesitter ]]
  --  Used to highlight, edit, and navigate code
  --
  --  See `:help nvim-treesitter-intro`

  -- NOTE: You can also specify a branch or a specific commit
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Ensure basic parsers are installed
  -- (Parsers power highlighting/indentation/folds — this is separate from the LSP servers.)
  local parsers = {
    'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
    -- Go
    'go', 'gomod', 'gowork', 'gosum',
    -- TypeScript / JavaScript / Vue (note: JSX lives inside the `javascript`/`tsx` parsers)
    'typescript', 'tsx', 'javascript', 'vue', 'css',
    -- Common companions for web/Go projects
    'json', 'yaml',
  }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })

  -- [[ Auto close / rename tags ]]
  -- `nvim-ts-autotag` uses treesitter to automatically close tags (type `<div>` and it inserts
  -- `</div>`) and to rename the closing tag when you edit the opening one. Hugely useful in Vue
  -- templates, HTML, and JSX/TSX. It is treesitter-based, hence configured here in Section 8.
  vim.pack.add { gh 'windwp/nvim-ts-autotag' }
  require('nvim-ts-autotag').setup {}
end

-- ============================================================
-- SECTION 9: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  -- require 'kickstart.plugins.autopairs'
  require 'kickstart.plugins.neo-tree'
  -- require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

  -- NOTE: You can add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  require 'custom.plugins'
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
