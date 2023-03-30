vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

-- Setup Plugins
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/AppData/Local/nvim')
Plug ('nvim-tree/nvim-web-devicons')
Plug ('nvim-tree/nvim-tree.lua')
Plug('mechatroner/rainbow_csv')
Plug('ryanoasis/vim-devicons')
Plug('prettier/vim-prettier', { ['do'] = 'yarn install --frozen-lockfile --production' })
Plug('neovim/nvim-lspconfig')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('mfussenegger/nvim-dap')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('saadparwaiz1/cmp_luasnip')
Plug('theHamsta/nvim-dap-virtual-text')
Plug('L3MON4D3/LuaSnip')
Plug('David-Kunz/jester')
Plug('rcarriga/nvim-dap-ui')
Plug('BurntSushi/ripgrep')
Plug('nvim-lua/popup.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('f-person/git-blame.nvim')
Plug('kyazdani42/nvim-web-devicons')
Plug ('windwp/nvim-autopairs')
Plug ('glepnir/lspsaga.nvim', { ['branch'] = 'main' })
Plug ('tpope/vim-fugitive')
Plug ('mfussenegger/nvim-jdtls')
Plug ('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug ('feline-nvim/feline.nvim')
Plug ('Hoffs/omnisharp-extended-lsp.nvim')
vim.call('plug#end')

require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = "true"
})

-- Setup Colorscheme
vim.cmd([[
colorscheme catppuccin 
syntax enable
]])

-- Statusline
local ctp_feline = require('catppuccin.groups.integrations.feline')

require("feline").setup({
    components = ctp_feline.get(),
})

-- Treesitter
local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
 highlight = {
 enable = true,
 disable ={},
 },
 indent = {
  enable = true,
  disable = {},
 },
 ensure_installed = {
  "html",
  "css",
  "c_sharp",
  "vim",
  "lua",
  "typescript",
  "tsx",
  "scss",
 },
 autotag = {
  enable = true,
 }
}

-- Autopairs
require("nvim-autopairs").setup()

-- Vim Settings
vim.cmd([[
set splitright
set splitbelow
set relativenumber
set number
set completeopt=menu,menuone,noselect
set signcolumn=yes
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
]])

vim.g.mapleader = " "

-- File Tree
require("nvim-tree").setup({view = {side = "right", width = 50}})
vim.keymap.set('n',"<leader>fb", ':NvimTreeFindFileToggle<cr>', opts)



-- Git Blame
vim.g.gitblame_enabled = 0
vim.keymap.set('n', '<leader>gb', ':GitBlameToggle<CR>')

-- Telescope 
local builtin = require('telescope.builtin')
local telescope = require('telescope')
telescope.setup {
  pickers = {
    find_files = {
      hidden = true,
    }
  },
  defaults = {
    file_ignore_patterns = { "node_modules", ".git" },
  }
}
vim.keymap.set('n', '<leader>ff',  builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- LSP Saga
local saga = require('lspsaga')
saga.setup {
   ui = {
        kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
    }, 
}

-- LSP 
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n',"<leader>sd", '<Cmd>Lspsaga show_line_diagnostics<CR>', opts)
vim.keymap.set('n', '<leader>gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
vim.keymap.set('n',"<leader>rn", '<Cmd>Lspsaga rename<CR>', opts)
vim.keymap.set('n',"<leader>ca", '<Cmd>Lspsaga code_action<CR>', opts)
vim.keymap.set('n', '<leader>od', '<Cmd>Lspsaga hover_doc<CR>', opts)

-- LSP Config
local nvim_lsp = require('lspconfig')

-- Angular
nvim_lsp.angularls.setup{}

-- Typescript
nvim_lsp.tsserver.setup{}

local pid = vim.fn.getpid()
-- Omnisharp Config
nvim_lsp.omnisharp.setup {
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler,
  },
  cmd = {"dotnet", "/Users/patrickelfert/Documents/omnisharp-osx-arm64-net6.0/OmniSharp.dll", "--languageserver" , "--hostPID", tostring(pid) },
}

-- Debugging 

local jester = require("jester")
local dap = require("dap")
local dapui = require("dapui")

vim.keymap.set('n',"<leader>tf", jester.run_file )
vim.keymap.set('n',"<leader>rt", jester.run )
vim.keymap.set('n',"<leader>dt", jester.debug )
vim.keymap.set('n',"<leader>tb", dap.toggle_breakpoint)
vim.keymap.set('n',"<leader>so", dap.step_over)
vim.keymap.set('n',"<leader>si", dap.step_into)
vim.keymap.set('n',"<leader>cd", dap.continue )
vim.keymap.set('n',"<leader>td", dapui.toggle)

dapui.setup({
   icons = { expanded = "↕", collapsed = "↪", current_frame = "" },
})
require("nvim-dap-virtual-text").setup()

-- CMP
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
  cmp.setup({
    snippet = {
      expand = function(args)
	require('luasnip').lsp_expand(args.body) 
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true })}),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, 
    }, {
      { name = 'buffer' },
    })
  })
