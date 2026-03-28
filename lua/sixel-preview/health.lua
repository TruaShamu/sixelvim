local M = {}

function M.check()
  vim.health.start("sixel-preview.nvim")

  -- Check Neovim version
  if vim.fn.has("nvim-0.9") == 1 then
    vim.health.ok("Neovim >= 0.9")
  else
    vim.health.error("Neovim >= 0.9 required")
  end

  -- Check terminal sixel support
  local term = vim.env.TERM_PROGRAM or vim.env.TERM or "unknown"
  local wt = vim.env.WT_SESSION
  if wt then
    vim.health.ok("Running inside Windows Terminal (WT_SESSION detected)")
  else
    vim.health.info("Terminal: " .. term .. " (sixel support not verified)")
  end

  -- Check ImageMagick
  local magick = vim.fn.executable("magick")
  if magick == 1 then
    local handle = io.popen("magick --version 2>&1")
    local version = handle and handle:read("*l") or "unknown"
    if handle then handle:close() end
    vim.health.ok("ImageMagick found: " .. (version or ""))

    -- Check if ImageMagick has sixel delegate
    local dhandle = io.popen("magick identify -list format 2>&1")
    local formats = dhandle and dhandle:read("*a") or ""
    if dhandle then dhandle:close() end
    if formats:lower():find("sixel") or formats:lower():find("six") then
      vim.health.ok("ImageMagick has sixel support")
    else
      vim.health.warn("ImageMagick may lack sixel delegate — try: magick identify -list format | findstr /i sixel")
    end
  else
    vim.health.error("ImageMagick not found — install from https://imagemagick.org")
  end

  -- Check pdftoppm (poppler)
  if vim.fn.executable("pdftoppm") == 1 then
    vim.health.ok("pdftoppm found (poppler-utils)")
  else
    vim.health.warn("pdftoppm not found — PDF preview will fall back to ImageMagick (needs Ghostscript)")
  end

  -- Check chafa (optional)
  if vim.fn.executable("chafa") == 1 then
    vim.health.ok("chafa found (alternative sixel backend)")
  else
    vim.health.info("chafa not found (optional alternative backend)")
  end
end

return M
