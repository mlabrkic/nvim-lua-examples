--[[
https://gist.github.com/echasnovski/
https://gist.github.com/echasnovski/493329c67050e9dcc5546815f31179d0
neovim-options-survey.lua

------------------------------
-->
opt00_nvim-opt-survey.lua

How to use this script?
Open this script, and type:
:so%

Write buffer to file
:w 00optionsDefault.txt
]]
------------------------------------------------------------
-- Get Neovim version
local version = vim.version()
--[[
:h cmdline.txt
Command-line mode

:h lua.txt
:h vim.version

:lua ver = vim.version()
:lua =ver
]]

if version.major == 0 and version.minor < 7 then error('This script needs at least Neovim 0.7.') end

-- Create scratch buffer to better track options and paste output lines
--[[
:h api.txt

:h nvim_create_buf
nvim_create_buf({listed}, {scratch})

:h buffers
:ls!
:ls

]]

-- local bufnr = vim.api.nvim_create_buf(true, false)
local bufnr = vim.api.nvim_create_buf(true, true)
vim.api.nvim_set_current_buf(bufnr)

-- Define "bad" (non-transferable) options
--stylua: ignore
local bad_options = {
  -- Current GUI options
  'columns', 'lines', 'scroll', 'window',

  -- mlabrkic:
  -- Related to paths (not safe to transfer)
  -- 'cdpath', 'packpath', 'path', 'runtimepath',
  -- 'backupdir', 'directory', 'viewdir', 'undodir',
  -- 'helpfile', 'spellfile',
  -- 'backupskip',
  -- 'dictionary',

  'operatorfunc',  -- mlabrkic:

  -- Only buffer-local which are fixed for current scratch buffer
  'buftype', 'swapfile', 'modeline',
}

-- Start creating output lines
local lines = { '---Please copy all lines---' }

-- Add Neovim version
--[[
h luaref.txt

h table.insert
h string.format
]]
table.insert(lines, string.format('neovim_version,%d.%d.%d', version.major, version.minor, version.patch))

-- Add leader key
--[[
h lua.txt
h vim.inspect

lua mapl = vim.g.mapleader
lua =mapl
]]
table.insert(lines, 'leader,' .. vim.inspect(vim.g.mapleader))

-- Add non-default options
local option_lines = {}

--[[
h api.txt
h nvim_get_all_options_info

------------------------------
h nvim_get_option_info()

lua number = vim.api.nvim_get_option_info('number')
lua =number

------------------------------
Command-line mode

lua number = vim.api.nvim_get_option_info('number')
redir @a
lua =number
redir END

Now, register 'a' will have the output of the "lua =number" ex command.
You can paste this into a Vim buffer, using
"ap

{
  allows_duplicates = true,
  commalist = false,
  default = false,
  flaglist = false,
  global_local = false,
  last_set_chan = -9.2233720368548e+18,
  last_set_linenr = 53,
  last_set_sid = -9,
  name = "number",
  scope = "win",
  shortname = "nu",
  type = "boolean",
  was_set = true
}

]]
local all_options_info = vim.api.nvim_get_all_options_info()  -- Lua table

--[[
h luaref-pairs

h luaref-ipairs
`for i,v in ipairs(t) do`  `body`  `end`
will iterate over the pairs (`1,t[1]`), (`2,t[2]`), ..., up to the

h luaref-pcall
]]
-- for name, info in pairs(vim.api.nvim_get_all_options_info()) do
for name, info in pairs(all_options_info) do
  local has_value, value = pcall(vim.api.nvim_get_option_value, name, {})

  -- 4. Options (without "bad_options", without "unknown", without "default"):
  local is_ok_option = has_value and value ~= info.default and not vim.tbl_contains(bad_options, name)

  -- 3. Options default (without "bad_options", without "unknown", "default"):
  -- local is_ok_option = has_value and value == info.default and not vim.tbl_contains(bad_options, name)

  -- 2. ALL options (without "bad_options", without "unknown"):
  -- local is_ok_option = has_value and not vim.tbl_contains(bad_options, name)

  -- 1. ALL options (without "bad_options", with "unknown"):
  -- local is_ok_option = not vim.tbl_contains(bad_options, name) -- browsedir,"unknown option 'browsedir'"

  if is_ok_option then table.insert(option_lines, string.format('%s,%s', name, vim.inspect(value))) end

end

table.sort(option_lines)

--[[
h vim.list_extend
]]
vim.list_extend(lines, option_lines)

-- Set lines
table.insert(lines, '---Please copy all lines---')

--[[
h nvim_buf_set_lines
]]
vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)

