-- ==========================
-- BASIC SETTINGS
-- ==========================
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- Leader key
vim.g.mapleader = ' '
vim.keymap.set('n', '<Space>', '', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

-- ==========================
-- BOOTSTRAP LAZY.NVIM
-- ==========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================
-- PLUGINS
-- ==========================

require("lazy").setup({

  -- ==========================
  -- TREE-SITTER (Syntax Highlighting)
  -- ==========================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "javascript", "typescript", "html", "css", "python"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },

  -- ==========================
  -- COLORSHEME
  -- ==========================
  {
    priority = 1000,
    config = function()
      vim.cmd("colorscheme retrobox")
    end, 
  },

  -- ==========================
  -- TELESCOPE
  -- ==========================
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- ==========================
  -- FILE EXPLORER
  -- ==========================
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        sort = { sorter = "case_sensitive" },
        view = { width = 30, side = "left" },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        update_focused_file = { enable = true, update_root = false },
        sync_root_with_cwd = true,
      })
    end,
  },

  -- ==========================
  -- STATUSLINE
  -- ==========================
  { "nvim-lualine/lualine.nvim" },

  -- ==========================
  -- LSP + MASON
  -- ==========================
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      -- MASON SETUP
      require("mason").setup()
      local mlsp = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      local servers = { "lua_ls", "pyright", "tsserver" }
      mlsp.setup({ ensure_installed = servers })
      mlsp.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
      })

      -- KEYMAPS
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })

      -- CMP + SNIPPETS
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
    end,
  },

})
