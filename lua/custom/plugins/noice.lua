-- noice.nvim — replaces the bottom `:` command line with a floating popup
-- in the center of the screen (the LazyVim-style command UI).
-- https://github.com/folke/noice.nvim
--
-- Command/path/option autocomplete inside the popup is provided by your
-- existing blink.cmp (its cmdline source is on by default) — noice only
-- supplies the popup UI.
--
-- `nui.nvim` is required and is already installed (neo-tree pulls it in);
-- it is listed again here only to be explicit — duplicates are harmless.
vim.pack.add {
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('noice').setup {
  cmdline = {
    enabled = true,
    view = 'cmdline_popup', -- the centered floating box
  },
  -- Keep this focused on the command line: do NOT take over messages or
  -- notifications, so we avoid pulling in nvim-notify and changing how
  -- `:messages` / `vim.notify` behave.
  messages = { enabled = false },
  notify = { enabled = false },
  popupmenu = { enabled = true }, -- render the completion menu in the popup
  presets = {
    command_palette = true, -- position cmdline + popupmenu together, centered
    long_message_to_split = true, -- send long messages to a split
  },
}
