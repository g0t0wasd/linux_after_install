vim.opt.incsearch = true
vim.opt.smartcase = true          -- smart case
vim.opt.splitbelow = true         -- force all horizontal splits to go below current window
vim.opt.splitright = true         -- force all vertical splits to go to the right of current window
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.backup = false            -- creates a backup file
vim.opt.showmode = false          -- we don't need to see things like -- INSERT -- anymore
vim.opt.hlsearch = true           -- highlight all matches on previous search pattern
vim.opt.termguicolors = true      -- set term gui colors (most terminals support this)
vim.opt.background = "light"
-- background = "dark",
vim.opt.cmdheight = 2                                       -- more space in the neovim command line for displaying messages
vim.opt.updatetime = 300                                    -- faster completion (4000ms default)
vim.opt.mouse = "a"                                         -- allow the mouse to be used in neovim
vim.opt.completeopt = { "menuone", "noselect", "noinsert" } -- mostly just for cmp
vim.opt.hls = false                                         -- turn off highlight

-- Buffer scope
vim.opt.tabstop = 4        -- insert 4 spaces for a tab
vim.opt.shiftwidth = 4     -- the number of spaces inserted for each indentation
vim.opt.expandtab = true   -- convert tabs to spaces
vim.opt.softtabstop = 4
vim.opt.smartindent = true -- make indenting smarter again

-- Window scope
vim.opt.number = true         -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.wrap = false          -- display lines as one long line
vim.opt.cursorline = true     -- highlight the current line
vim.opt.colorcolumn = "80"    -- highlight the 80th column
vim.opt.signcolumn = "yes"    -- always show the sign column, otherwise it would shift the text each time

-- Other things
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.showtabline = 0        -- always show tabs

vim.opt.ignorecase = true      -- ignore case in search patterns
vim.opt.scrolloff = 5          -- number of lines before the end of the screen to start scrolling the text
vim.opt.sidescrolloff = 5


-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.shortmess:append "c"

-- for k, v in pairs(options) do
--     vim.opt[k] = v
-- end

-- Disables automatic commenting on newline:
vim.cmd [[set formatoptions-=cro]]

-- Automatically deletes all trailing whitespace and newlines at end of file on save.
vim.api.nvim_command [[ autocmd BufWritePre * %s/\s\+$//e ]]
vim.api.nvim_command [[ autocmd BufWritePre * %s/\n\+\%$//e ]]

-- vim.api.nvim_command [[ autocmd BufWritePre *.py :lua vim.lsp.buf.formatting_sync() ]]

-- disable diagnostic as virtual text
vim.diagnostic.config({
    virtual_text = false
})


-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- show diagnostic on hold
vim.cmd [[ autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false}) ]]
