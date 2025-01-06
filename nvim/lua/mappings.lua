vim.g.mapleader = ' '
-- local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


function InsertDebugMessage()
  -- get the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)

  -- insert the lines below the current line
  vim.api.nvim_put({'import code; code.interact(local=locals())'}, 'l', true, true)

  -- move the cursor back to the original position
  vim.api.nvim_win_set_cursor(0, current_pos)
end

local function register_mappings(mappings, default_options)
  for mode, mode_mappings in pairs(mappings) do
    for _, mapping in pairs(mode_mappings) do
      local options = #mapping == 3 and table.remove(mapping) or default_options
      local prefix, cmd = unpack(mapping)
      pcall(vim.api.nvim_set_keymap, mode, prefix, cmd, options)
    end
  end
end

local mappings = {
  i = { -- Insert mode
  },
  n = { -- Normal mode
    { 'j', 'gj'},
    { 'k', 'gk'},

    -- Better window movement
    {'<leader>j', '<C-w><C-j>'},
    {'<leader>k', '<C-w><C-k>'},
    {'<leader>h', '<C-w><C-h>'},
    {'<leader>l', '<C-w><C-l>'},

    {'<leader>w', ':w<CR>'}, -- save
    {'<leader>q', ':q<CR>'}, -- quiz
    {'<leader>Q', ':qa!<CR>'},

    -- show next matched string at the center of screen
    {'n', 'nzz'},
    {'N', 'Nzz'},

    -- insert python debug
    {'<leader>pd', ":lua vim.api.nvim_put({'import code; code.interact(local=locals())'}, 'l', true, true)<CR>"},

    -- working with buffers
    -- close buffer without closing split
    {'<leader>bk', ':b#|bd#<CR>'},

    -- vertical split
    {'<leader>v', ':vsplit<CR>'},

    -- format the code according to Lsp rules
    {'<leader>f', ':lua vim.lsp.buf.format()<CR>'},

    -- Telescope binds
    {'<leader>pf', ':Telescope find_files hidden=true<CR>', opts},
    {'<leader>ps', ':Telescope live_grep glob_pattern=*.*', {noremap = true, silent=false}},
    {'<leader>pb', ':Telescope buffers<CR>', opts},
    -- {'<leader>/', ':Telescope current_buffer_fuzzy_find<CR>', opts},

    -- NeoTree
    {'<leader>pv', ':Neotree toggle reveal_force_cwd<CR>', opts},

    -- Substitute the word under the cursor.
    {'<leader>s', ':%s/<C-r><C-w>//gI<c-f>$F/i'},

    {'<leader>m', ':MaximizerToggle!<CR>'},

    -- Git usage
    {'<leader>gs', ':G<CR>'},
   {'<leader>gd', ':Gdiffsplit!<CR>'},
   {'<leader>gw', ':Gwrite<CR>'},
   {'<leader>gj', ':diffget //3<CR>'},
   {'<leader>gf', ':diffget //2<CR>'},
   {'<leader>gb', ':Git blame<CR>'},
   {'<leader>gc', ':Git commit<CR>'},
   {'<leader>gp', ':Git push<CR>'},

   -- Hop movement
   {'<leader><leader>s', ':HopChar1<CR>', opts},

   -- Toggle terminal
   {'<leader>tt', ':ToggleTerm<CR>', opts},
  },
  t = { -- Terminal mode
  },
  v = { -- Visual/Select mode
    -- Get the sum of the selected numbers
    -- Expects comma as a decimal sign for some reason
    -- (Probably locale related)
    {'S', ":!awk '{print; total+=$0}END{print total}'", {silent=false}}
  },
  x = { -- Visual mode
    -- Move selected line / block of text in visual mode
    {'J', ":move '>+1<CR>gv=gv"},
    {'K', ":move '<-2<CR>gv=gv"},
  },
  [""] = {
    {'<leader>cc', ':Commentary<CR>'},
    -- Make splits vertical
    {'<leader>th', '<C-w>t<C-w>H'},
    -- Make splits horizontal
    {'<leader>tk', '<C-w>t<C-w>K'},
  },
}

register_mappings(mappings, {silent = true, noremap = true})
