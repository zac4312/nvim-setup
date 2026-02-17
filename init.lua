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
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- ==========================
-- BOOTSTRAP LAZY.NVIM
-- ==========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
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

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "javascript", "typescript",
          "html", "css", "python", "sql"
        },
        highlight = { enable = true },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSP bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ts_ls", 
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Config
 
{
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      "lua_ls",
      "pyright",
      "ts_ls",
      "sqls",
    }

    for _, server in ipairs(servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
      vim.lsp.enable(server)
    end

    -- Keymaps
    vim.keymap.set("n", "K", vim.lsp.buf.hover)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "gr", vim.lsp.buf.references)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)

    -- Autocomplete
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
      },
    })

  end,
},


})

-- ==========================
-- COLORSCHEME (AFTER PLUGINS)
-- ==========================
vim.schedule(function()
  vim.cmd.colorscheme("retrobox")
end)
