-- Lazy-load guard: setup() must be called by the user
if vim.g.loaded_sixel_preview then
  return
end
vim.g.loaded_sixel_preview = true
