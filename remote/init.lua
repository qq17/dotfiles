vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'gruvbox-material'
    end,
  },

  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'kanagawa'
    end,
  },

  {
    'junegunn/seoul256.vim',
    priority = 1000,
    config = function()
      vim.g.seoul256_background = 235
      vim.cmd.colorscheme 'seoul256'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons",
                    { "junegunn/fzf", build = "./install --bin" } },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async'
  },

  {
    'machakann/vim-sandwich',
  },

  {
    'SmiteshP/nvim-navic',
  }
}, {})

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.keymap.set({'n', 'v', 'i', 'o', 'l', 't'}, '<M-c>', '<C-[>')

vim.opt.fillchars = { fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.g.markdown_folding = 1 -- enable markdown folding

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
-- vim.opt.smartindent = true

--vim.keymap.set('i', '<Tab>', '<C-n>')
--vim.keymap.set('i', '<S-Tab>', '<C-p>')

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.opt.list = true
-- vim.opt.listchars = { leadmultispace = "│   ", multispace = "│ ", tab = "│ ", }
vim.opt.listchars = { tab = "│ ", leadmultispace = "┊   ", trail = "␣", nbsp = "⍽" }

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- vim.keymap.set('n', '<M-.>', ":vertical resize +1<CR>", { silent = true })
-- vim.keymap.set('n', '<M-,>', ":vertical resize -1<CR>", { silent = true })
vim.keymap.set('n', '<M-.>', '<C-w>>', { silent = true })
vim.keymap.set('n', '<M-,>', '<C-w><', { silent = true })

vim.keymap.set('n', '<M-w>', ':set iskeyword+=^A-Z,^_<CR>w:set iskeyword-=^A-Z,^_<CR>', { expr = true })
--   function()
--   vim.cmd.set("iskeyword+=^A-Z,^_")
--   vim.cmd.normal("w")
--   vim.cmd.set("iskeyword-=^A-Z,^_")
--   -- vim.o.iskeyword:remove{'65-90'}
--   -- vim.o.iskeyword:append{'^A-Z,^_'}
--   -- vim.cmd("normal w")
--   -- vim.o.iskeyword:remove{'^A-Z,^_'}
--   -- vim.o.iskeyword:append{'65-90'}
-- end, { expr = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local function get_visual_selection()
  local vstart = vim.fn.getpos("'<")
  local vend = vim.fn.getpos("'>")

  local ls, cs = vstart[2], vstart[3]
  local le, ce = vend[2], vend[3]
  vim.print('ls = '..ls..'cs = '..cs..'le = '..le..'ce = '..ce)

  local lines = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
  local vlines = table.concat(lines)

  vim.print(vlines)
end

---- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('fzf-lua').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('fzf-lua').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('fzf-lua').grep_curbuf()
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sc', function()
  local curfiledir = vim.fn.expand('%:p:h')
  require('fzf-lua').live_grep({cwd = curfiledir})
end, { desc = '[S]earch in [C]urrent file dir' })

vim.keymap.set('n', '<leader>st', function()
  local current_git_dir = vim.cmd('!git rev-parse --show-toplevel')
  require('fzf-lua').live_grep({cwd = current_git_dir})
end, { desc = '[S]earch in current gi[T] dir' })

vim.keymap.set('n', '<leader>gf', require('fzf-lua').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('fzf-lua').files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('fzf-lua').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('fzf-lua').grep_cword, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('fzf-lua').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sr', require('fzf-lua').resume, { desc = '[S]earch [R]esume' })

vim.keymap.set('v', '<leader>sc', function()
  local curfiledir = vim.fn.expand('%:p:h')
  require('fzf-lua').grep_visual({cwd = curfiledir})
end, { desc = '[S]earch in [C]urrent file dir' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

local navic = require("nvim-navic")
navic.setup {
    icons = {
        File          = "F ",
        Module        = "% ",
        Namespace     = "@ ",
        Package       = "# ",
        Class         = "C ",
        Method        = "m ",
        Property      = "p ",
        Field         = ". ",
        Constructor   = "c ",
        Enum          = "E",
        Interface     = "I",
        Function      = "f ",
        Variable      = "V ",
        Constant      = "g ",
        String        = "s ",
        Number        = "n ",
        Boolean       = "b ",
        Array         = "a ",
        Object        = "O ",
        Key           = "k ",
        Null          = "0 ",
        EnumMember    = "e ",
        Struct        = "S ",
        Event         = "w ",
        Operator      = "o ",
        TypeParameter = "P ",
    },
    lsp = {
        auto_attach = false,
        preference = nil,
    },
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
    safe_output = true,
    lazy_update_context = false,
    click = false,
    format_text = function(text)
        return text
    end,
}
-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = '[W]orkspace [L]ist Folders' })

  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]oto [D]efinition' })
  vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, { desc = '[G]oto [D]efinition' })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
  vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { desc = '[G]oto [R]eferences' })
  vim.keymap.set('n', 'gI', require('fzf-lua').lsp_implementations, { desc = '[G]oto [I]mplementation' })
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type [D]efinition' })
  vim.keymap.set('n', '<leader>ds', require('fzf-lua').lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
  vim.keymap.set('n', '<leader>ws', require('fzf-lua').lsp_live_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })
  --nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  --nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  --nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  --nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  --nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  --nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  --nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  --nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  ---- See `:help K` for why this keymap
  --nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  --nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  ---- Lesser used LSP functionality
  --nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  --nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  --nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  --nmap('<leader>wl', function()
  --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --end, '[W]orkspace [L]ist Folders')

  ---- Create a command `:Format` local to the LSP buffer
  --vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --  vim.lsp.buf.format()
  --end, { desc = 'Format current buffer with LSP' })
end

require("lualine").setup({
  winbar = {
    lualine_c = {
      {
        function()
          return navic.get_location()
        end,
        cond = function()
          return navic.is_available()
        end
      },
    }
  }
})

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- require 'lspconfig'.clangd.setup({
--   cmd = { "clangd", "-x", "c++-header" }
-- })

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

local function get_keys(t)
  local keys={}
  for key,_ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

function TableConcat(t1,t2)
  for i=1,#t2 do
    t1[#t1+1] = t2[i]
  end
  return t1
end

local function iterate(obj, str)
  local result = {}

  for k, v in pairs(obj) do

    local prev = ''

    if type(v) == "table" then
      local s
      if obj[1] ~= nil then
        s = prev..str..'['..(k-1)..']'
        -- vim.print('#'..s..'#')
      else
        s = prev..str..'["'..k..'"]'
        -- vim.print('#'..s..'#')
      end

      TableConcat(result, iterate(obj[k], s))

    else
      prev = str
      local surs
      local sure
      local key = k
      if obj[1] ~= nil then
        surs = '['
        sure = '] = '
        key = k - 1
      else
        surs = '["'
        sure = '"] = '
      end
      if type(obj[k]) == "string" then
        table.insert(result, prev..surs..key..sure..'"'..tostring(obj[k])..'";')
        vim.print(prev..surs..key..sure..'"'..tostring(obj[k])..'";')
      else
        table.insert(result, prev..surs..key..sure..tostring(obj[k])..';')
        vim.print(prev..surs..key..sure..tostring(obj[k])..';')
      end
    end

  end

  return result
end

-- -- local myt = vim.fn.json_decode('{"all_rows": 0, "cnt_rows": 1, "data": [ { "COUNT(*)": 0 } ], "error": { "msg": "No find records by selection request", "status": 2 }, "request": "SELECT * FROM sw_integrity_user WHERE reference=\'recalculate\' LIMIT 500 OFFSET 0;" }')
-- local myt = vim.fn.json_decode('{"cmd":{"admin-id":20000,"file":"/tmp/file_not_exist.test","is-szi":false},"rpc":"cs-file-unlock","unit":"file-integrity"}')
-- -- local myt = {5, "string", {x1 = "tuturu", x = 10}, {y = 20}}
-- -- local myt = {x = 10, y = 20}
-- vim.print(myt)
-- vim.print(get_keys(myt))
-- vim.print('------------------')
--
-- local ans = iterate(myt, 'out')
-- vim.print(ans)
--
-- vim.print('------------------')
--
-- local myj = vim.fn.json_encode(myt)
--
-- vim.print(myj)

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

vim.api.nvim_create_user_command('Jsoncodegen',
  function(opts)
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")

    local ls, cs = vstart[2], vstart[3]
    local le, ce = vend[2], vend[3]
    vim.print('ls = '..ls..'cs = '..cs..'le = '..le..'ce = '..ce)

    local lines = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
    local vlines = table.concat(lines)

    vim.print(vlines)

    local vtab = vim.fn.json_decode(vlines)
    vim.print(vtab)
    local code = iterate(vtab, 'out')

    vim.api.nvim_buf_set_text(0, ls - 1, cs - 1, le - 1, ce - 1, { ' ' })
    vim.api.nvim_buf_set_lines(0, ls, ls, true, code)

  end, { range=2 })


vim.keymap.set('n', '<leader>j', function()
  local vstart = vim.fn.getpos("'<")
  local vend = vim.fn.getpos("'>")

  local ls, cs = vstart[2], vstart[3]
  local le, ce = vend[2], vend[3]
  vim.print('ls = '..ls..'cs = '..cs..'le = '..le..'ce = '..ce)

  local lines = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
  local vlines = table.concat(lines)

  vim.print(vlines)

  local vtab = vim.fn.json_decode(vlines)
  vim.print(vtab)
  local code = iterate(vtab, 'out')

  vim.api.nvim_buf_set_text(0, ls - 1, cs - 1, le - 1, ce - 1, { ' ' })
  vim.api.nvim_buf_set_lines(0, ls, ls, true, code)
end, { desc = '[j] json' })

vim.cmd([[
" Use one of the following to define the camel characters.
" Stop on capital letters.
let g:camelchar = "A-Z"
" Also stop on numbers.
let g:camelchar = "A-Z0-9"
" Include '.' for class member, ',' for separator, ';' end-statement,
" and <[< bracket starts and "'` quotes.
let g:camelchar = "A-Z0-9.,;:{([`'\""
nnoremap <silent><C-Left> :<C-u>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
nnoremap <silent><C-Right> :<C-u>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
inoremap <silent><C-Left> <C-o>:call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
inoremap <silent><C-Right> <C-o>:call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
vnoremap <silent><C-Left> :<C-U>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>v`>o
vnoremap <silent><C-Right> <Esc>`>:<C-U>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>v`<o
]])

vim.cmd([[
   " tell which cinoption take effect for current line
  function s:which_cinoption() abort

    " test if cindent take effect
    if !empty(&indentexpr)
      echo "'indentexpr' exists, it overrides 'cindent'."
      return
    endif

    if !&cindent
      echo "'cindent' is currently disabled."
      return
    endif

    " test cinoption one by one

    " copied from :h cino- <ctrl-a> in vim8.2 1-677
    let opts = ['#','(',')','+','/',':','=','>','^','{','}','C','E','J','L','M',
          \ 'N','U','W','b','c','e','f','g','h','i','j','k','l','m','n','p','t',
          \ 'u','w','*']

    let indent = cindent(line('.'))
    let results = []
    let cinopt = &l:cinoptions

    for opt in opts
      try

        " test it with 8s, it should be big enough to make difference
        exe printf('setlocal cinoptions+=%s8s', opt)
        if indent != cindent(line('.'))
          let results += [opt]
        endif

      catch /.*/
        echom 'failed to test ' . opt
        echom 'internal error : ' . v:exception
      finally
        let &l:cinoptions = cinopt
      endtry
    endfor

    echohl Macro
    echom join(results)
    echohl None
  endfunction

  com! WhichCinoption call s:which_cinoption()

]])

vim.cmd([[ 
  let @r = "o\<ESC>iinsert\<CR>\<ESC>\"wp"
]])

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
