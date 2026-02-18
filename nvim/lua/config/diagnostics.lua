-- Diagnostic configuration

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    severity = { min = vim.diagnostic.severity.WARN },
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})
