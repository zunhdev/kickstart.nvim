-- grug-far.nvim — project-wide find & replace.
-- https://github.com/MagicDuck/grug-far.nvim
--
-- Opens a dedicated buffer where you type a Search term, a Replace term, and
-- optionally a Files-glob / flags. It runs ripgrep live for a preview, and the
-- "replace" action (`<localleader>r` inside the buffer) applies the change
-- across every matching file on disk.
--
-- Pure Lua, ripgrep-backed, no build step — a clean fit for `vim.pack`.
-- Project-wide *text search* itself is already covered by the Snacks picker
-- (`<leader>sg` / `<leader>sw`); this plugin adds the missing *replace*.
vim.pack.add {
  'https://github.com/MagicDuck/grug-far.nvim',
}

require('grug-far').setup {
  -- Defaults are excellent (engine = ripgrep). Left empty intentionally.
}

-- [[ Keymaps ]]
-- Placed under the `<leader>s` (search) prefix to sit alongside the existing
-- Snacks search group. `desc` is picked up automatically by which-key.
local grug = function()
  return require 'grug-far'
end

-- Project-wide search & replace.
vim.keymap.set('n', '<leader>sr', function() grug().open() end, { desc = '[S]earch & [R]eplace (project)' })

-- Replace, prefilling the visual selection as the search term.
vim.keymap.set('x', '<leader>sr', function() grug().with_visual_selection() end, { desc = '[S]earch & [R]eplace (selection)' })

-- Search & replace scoped to the current file only.
vim.keymap.set('n', '<leader>sf', function() grug().open { prefills = { paths = vim.fn.expand '%' } } end, { desc = '[S]earch & replace in current [F]ile' })
