vim.filetype.add({
  extension = {
    als = "alloy",
  },
})

-- Add the plugin's bundled parser to Neovim's search path
local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.runtimepath:append(plugin_dir)

vim.treesitter.language.register("alloy", "alloy")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "alloy",
  callback = function(args)
    vim.treesitter.start(args.buf, "alloy")
  end,
})
