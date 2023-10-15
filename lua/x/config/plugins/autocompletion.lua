  -- Set up nvim-cmp
local cmp = require'cmp'

local generate_keybindings = require'x.config.plugins.keybindings.autocompletion'

cmp.setup({
  snippet = {
    -- specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  experimental = {
      ghost_text = true,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = generate_keybindings(cmp),
-- more completion sources: https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'cmp-plugins' }
  }, {
    { name = 'buffer' },
  })
})
	-- Set configuration for specific filetype.
      --cmp.setup.filetype('gitcommit', {
      --  sources = cmp.config.sources({
      --    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      --  }, {
      --    { name = 'buffer' },
      --  })
--})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
