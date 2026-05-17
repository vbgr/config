local tabsize = 4

-- File safety

-- Deprecated: no. Keeps temporary backups while writing files.
vim.o.writebackup = true
-- Deprecated: no. Keeps swap files for unsaved crash recovery.
vim.o.swapfile = true
-- Deprecated: no. Persists undo history across sessions.
vim.o.undofile = true
-- Deprecated: no. Removes backup files after successful writes.
vim.o.backup = false

-- Buffers and files

-- Deprecated: no. Allows leaving modified buffers hidden.
vim.o.hidden = true
-- Deprecated: no. Sets current-buffer file encoding.
vim.o.fileencoding = "utf-8"

-- UI and terminal

-- Deprecated: no. Asks colorschemes to prefer dark variants.
vim.o.background = "dark"
-- Deprecated: no. Enables 24-bit terminal colors.
vim.o.termguicolors = true
-- Deprecated: no. Enables mouse support in all modes.
vim.o.mouse = "a"
-- Deprecated: no. Hides the mode text, for example "-- INSERT --".
vim.o.showmode = false
-- Deprecated: no. Hides partial normal-mode command display.
vim.o.showcmd = false
-- Deprecated: no. Hides the tabline.
vim.o.showtabline = 0
-- Deprecated: no. Shows concealed text normally.
vim.o.conceallevel = 0
-- Deprecated: no. Customizes split separators and end-of-buffer markers.
vim.o.fillchars = vim.o.fillchars .. "vert:│" .. ",eob: "
-- Deprecated: no. Shows a guide at column 80.
vim.o.colorcolumn = "80"

-- Command line and completion

-- Deprecated: no. Shortens or suppresses selected messages.
vim.o.shortmess = "atIW"
-- Deprecated: no. Keeps command line height at one row.
vim.o.cmdheight = 1
-- Deprecated: no. Enables automatic insert-mode completion.
vim.o.autocomplete = true
-- Deprecated: no. Chooses insert-mode completion sources and per-source limits.
vim.o.complete = ".^10,w^10,b^10,u^10"
-- Deprecated: no. Configures insert-mode popup completion behavior.
vim.o.completeopt = "menuone,noselect,popup,fuzzy"
-- Deprecated: no. Limits popup menu height.
vim.o.pumheight = 16
-- Deprecated: no. Enables command-line completion menu.
vim.o.wildmenu = true
-- Deprecated: no. Shows command-line matches without selecting the first item.
vim.o.wildmode = "noselect:lastused,full"
-- Deprecated: no. Uses popup and fuzzy matching for command-line completion.
vim.o.wildoptions = "pum,fuzzy"
-- Deprecated: no. Ignores case during command-line completion.
vim.o.wildignorecase = true
-- Deprecated: no. Uses fd-backed fuzzy matching for :find.
vim.o.findfunc = "v:lua.ConfigFindFunc"
-- Deprecated: no. Skips noisy paths during command-line completion.
vim.opt.wildignore = {
  "*/.git/*",
  "*/.venv/*",
  "*/node_modules/*",
  "*/dist/*",
}

-- Windows and splits

-- Deprecated: no. Opens horizontal splits below the current window.
vim.o.splitbelow = true
-- Deprecated: no. Opens vertical splits to the right.
vim.o.splitright = true
-- Deprecated: no. Wraps long lines visually in each window.
vim.wo.wrap = true
-- Deprecated: no. Shows absolute line numbers.
vim.wo.number = true
-- Deprecated: no. Highlights the current cursor line.
vim.wo.cursorline = true
-- Deprecated: no. Always shows sign column to avoid layout shifts.
vim.wo.signcolumn = "yes"

-- Navigation and scrolling

-- Deprecated: no. Allows cursor movement across line boundaries.
vim.o.whichwrap = "b,s,<,>,[,],h,l"
-- Deprecated: no. Keeps screen lines above and below the cursor.
vim.o.scrolloff = 4
-- Deprecated: no. Keeps screen columns left and right of the cursor.
vim.o.sidescrolloff = 4

-- Search

-- Deprecated: no. Highlights all search matches.
vim.o.hlsearch = true
-- Deprecated: no. Makes searches case-insensitive.
vim.o.ignorecase = true
-- Deprecated: no. Shows search matches while typing.
vim.o.incsearch = true

-- Whitespace display

-- Deprecated: no. Shows whitespace configured by listchars.
vim.o.list = true
-- Deprecated: no. Defines symbols for tabs and spaces.
vim.o.listchars = "tab:▸ ,trail:·,space:·"

-- Editing and formatting

-- Deprecated: no. Sets automatic hard-wrap width.
vim.o.textwidth = 120
-- Deprecated: no. Sets indentation width.
vim.o.shiftwidth = tabsize
-- Deprecated: no. Sets displayed tab width.
vim.o.tabstop = tabsize
-- Deprecated: no. Sets insert-mode tab and backspace width.
vim.o.softtabstop = tabsize
-- Deprecated: no. Copies current indent on a new line.
vim.o.autoindent = true
-- Deprecated: no. Inserts spaces instead of literal tab characters.
vim.o.expandtab = true

-- Folding

-- Deprecated: no. Opens folds up to this level by default.
vim.o.foldlevel = 10
-- Deprecated: no. Treesitter folds are enabled buffer-locally after a parser starts.
-- See lua/plugin/treesitter.lua for the FileType autocmd.

-- Performance

-- Deprecated: no. Lowers idle delay for CursorHold and plugins.
vim.o.updatetime = 300
-- Deprecated: no. Reduces redraws during macros and commands.
vim.o.lazyredraw = true
-- Deprecated: no. Selects regexp engine behavior.
vim.o.re = 1
-- Deprecated: no. Stops syntax highlighting after this column.
-- vim.o.synmaxcol = 180

-- Bells

-- Deprecated: no. Disables error beeps.
vim.o.errorbells = false
-- Deprecated: no. Disables all bells.
vim.o.belloff = "all"

-- Built-in plugin tuning

-- Deprecated: no. Reduces matchparen timeout.
vim.g.matchparen_timeout = 1
-- Deprecated: no. Reduces matchparen timeout in insert mode.
vim.g.matchparen_insert_timeout = 1
-- Deprecated: no. Would disable matchparen if uncommented.
-- vim.g.loaded_matchparen = 0
-- Deprecated: no. Disables extended % matching.
vim.g.loaded_matchit = 1
-- Deprecated: no. Disables the logiPat runtime plugin.
vim.g.loaded_logiPat = 1
-- Deprecated: no. Disables the rrhelper runtime plugin.
vim.g.loaded_rrhelper = 1
-- Deprecated: no. Disables tar archive browsing and editing.
vim.g.loaded_tarPlugin = 1
-- Deprecated: no. Disables gzip file auto-read and auto-write.
vim.g.loaded_gzip = 1
-- Deprecated: no. Disables zip archive browsing and editing.
vim.g.loaded_zipPlugin = 1
-- Deprecated: no. Disables the :TOhtml plugin.
vim.g.loaded_2html_plugin = 1
-- Deprecated: no. Disables ShaDa runtime autocmd support.
vim.g.loaded_shada_plugin = 1
-- Deprecated: no. Disables spellfile download helper.
vim.g.loaded_spellfile_plugin = 1
-- Deprecated: no. Disables netrw core.
vim.g.loaded_netrw = 1
-- Deprecated: no. Disables netrw plugin loading.
vim.g.loaded_netrwPlugin = 1
-- Deprecated: no. Disables tutor mode plugin.
vim.g.loaded_tutor_mode_plugin = 1
-- Deprecated: no. Disables remote plugin manifest loading.
vim.g.loaded_remote_plugins = 1
-- Deprecated: no. Disables Python 3 provider checks.
vim.g.loaded_python3_provider = 1
-- Deprecated: unknown. Old cursorline performance knob.
-- vim.g.cursorline_timeout = 500

-- Neovide

if vim.fn.exists("g:neovide") == 1 then
  -- Deprecated: no. Sets GUI font.
  vim.o.guifont = "SF Mono"
  -- Deprecated: no. Uses Command as logo/meta input.
  vim.g.neovide_input_use_logo = true
  -- Deprecated: no. Disables scroll animation.
  vim.g.neovide_scroll_animation_length = 0
  -- Deprecated: no. Disables cursor trail.
  vim.g.neovide_cursor_trail_size = 0
  -- Deprecated: no. Disables cursor visual effects.
  vim.g.neovide_cursor_vfx_mode = ""
end
