-- treesitter
-- treesitter playground - visualize AST
-- undotree - use treesitter to visualize old edit-tree branches
return {
    {
    "nvim-treesitter/nvim-treesitter",
      config = function ()
              vim.cmd(":TSUpdate")
      end
    },
--    "nvim-treesitter/playground",
    "mbbill/undotree",
}
