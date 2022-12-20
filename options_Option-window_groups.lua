-- date: 2022-12M-06 16:16:00
--[[
------------------------------------------------------------
No 0)
:options

--> Neovim\share\nvim\runtime\optwin.vim
--> "option-window" :

Copy all text (from  " 1 important" to end) to new buffer:
options_option-window.txt

---------------
 1 important

- 'compatible' is always disabled
nocompatible
compatible	behave very Vi compatible (not advisable)
	set nocp	cp

'cpoptions'	  'cpo'     flags for Vi-compatible behavior
cpoptions=aABceFs_

...

------------------------------------------------------------
No 1)
Open options_option-window.txt

------------------------------
No 2)
Run this script!

https://github.com/nanotee/nvim-lua-guide#sourcing-lua-files
:luafile "path to"\options_option-window_groups.lua

Example:
:so C:\Users\<user name>\Documents\options_option-window_groups.lua


------------------------------------------------------------
My notes (NeoVim):
------------------------------
-- 01:
:h
:h helphelp

The Nvim help (text) files are in (OS Windows):
C:\UTILS\Neovim\share\nvim\runtime\doc\

------------------------------
-- 02:
h luaref-Lib
5  STANDARD LIBRARIES
-->

h string.sub()

h string.match

h luaref-patterns
- `%a`  represents all letters.
- `%d`  represents all digits.

h table.concat
h luaref-ipairs()

------------------------------
-- 03:
h lua.txt
Lua engine
-->

h vim.regex()
Vim regexes can be used directly from lua. Currently they only allow
matching within a single line.

------------------------------
-- 04:
h api.txt
Nvim API
Nvim exposes a powerful API that can be used by plugins and external processes
via |RPC|, |Lua| and VimL (|eval-api|).
-->

NOTE:

Global Functions
h api-global
-->
h nvim_get_current_line()

Options Functions
h api-options

Buffer Functions
h api-buffer

------------------------------
https://github.com/nanotee/nvim-lua-guide#the-vim-namespace

Neovim exposes a global "vim" variable which serves as an entry point to interact with its APIs from Lua.
It provides users with an extended "standard library" of functions as well as various sub-modules.

Some notable functions and modules include:
vim.inspect: transform Lua objects into human-readable strings (useful for inspecting tables)
vim.regex: use Vim regexes from Lua
vim.api: module that exposes API functions (the same API used by remote plugins)

------------------------------------------------------------
RESOURCES (Neovim Lua API):

https://www.davekuhlman.org/nvim-lua-info-notes.html
Published
Fri 29 April 2022

https://jacobsimpson.github.io/nvim-lua-manual/docs/buffers-and-windows/

https://github.com/nanotee/nvim-lua-guide

------------------------------------------------------------
1   Some examples

# print the current line (line with the cursor)
h nvim_get_current_line()
:lua print(vim.api.nvim_get_current_line())

# print a range of lines (concatenated and separated by "::".
lua print(table.concat(vim.api.nvim_buf_get_lines(0, 6, 9, true), '::'))

# replace the second and third lines of the current buffer with lines in table.
lua vim.api.nvim_buf_set_lines(0, 1, 3, true, table01)

# to delete a range of lines, give an empty table as replacement parameter
lua vim.api.nvim_buf_set_lines(0, 1, 3, true, {})

---------------
# print each of a range of lines from the current buffer.
lua for i, v in ipairs(vim.api.nvim_buf_get_lines(4, 6, 9, true)) do print(i, v) end

# get a range of lines from a different buffer (buf 4), then display them.
# use `:ls` or `:buffers` to learn the buffer numbers.
:ls --> 4
lua table02 = vim.api.nvim_buf_get_lines(4, 6, 9, true)
lua for i, v in ipairs(table02) do print(i, v) end

------------------------------------------------------------
2   Buffers

h nvim_get_current_buf()
lua print(vim.api.nvim_get_current_buf())

h nvim_list_bufs()

h buffers
:ls!
:ls

1.
lua bufs = vim.api.nvim_list_bufs()

2.
https://github.com/nanotee/nvim-lua-guide#the-vim-namespace
lua print(vim.inspect(bufs))

or
/ in Neovim 0.7.0+, this function is built-in, see :help vim.pretty_print() /
lua vim.pretty_print(bufs)

or
lua =bufs

------------------------------------------------------------
NOTE:

h nvim_create_buf
nvim_create_buf({listed}, {scratch})

Creates a new, empty, unnamed buffer.
• {listed}   Sets 'buflisted'

Return: ~
Buffer handle, or 0 on error

buf = 0 (current buffer)

---------------
1. Create a new buffer
-- local buf = vim.api.nvim_create_buf(true, false)
:lua buf = vim.api.nvim_create_buf('listed', '')  -- Create a new buffer
:lua =buf

2. Assign a name to the new buffer
lua vim.api.nvim_buf_set_name(buf, 'Options.txt')  -- Assign a name to the new buffer

3. Setting Options on a Buffer
:set buftype?
lua vim.api.nvim_buf_set_option(buf, 'buftype', '')  -- set buftype="" (because I want to save the file)

4. Appending to a Buffer
h nvim_buf_set_lines
lua vim.api.nvim_buf_set_lines(buf, -1, -1, true, {"abc", "def"})

------------------------------------------------------------
NOTE:

h luaref-libString
h string.sub()

lua line1 = vim.api.nvim_get_current_line()
lua lineStart1 = string.sub(line1, 1, 1)
lua print('"' .. lineStart1 .. '"')

lua print(type(lineStart1))
lua print(string.len(lineStart1))

------------------------------
lua firstWord = vim.split(line1, "\t")
lua print(firstWord)
lua =firstWord

------------------------------------------------------------
h api-buffer
lua print(vim.api.nvim_buf_line_count(0))

Go to the buffer "options.txt"
lua linesNum = vim.api.nvim_buf_line_count(0)
lua print(linesNum)

------------------------------------------------------------
h nvim_buf_get_lines

Indexing is zero-based, end-exclusive. Negative indices are interpreted as
length+1+index: -1 refers to the index past the end. So to get the last
element use start=-2 and end=-1.

local lines = vim.api.nvim_buf_get_lines(0, row1 - 1, row1, false)
local line1 = vim.api.nvim_buf_get_lines(0, row1 - 1, row1, false)[1]

---------------
NOTE:

lua line1 = vim.api.nvim_buf_get_lines(0, 24 - 1, 24, false)[1]

Last line:
lua line1 = vim.api.nvim_buf_get_lines(0, - 2, -1, false)[1]
lua print(line1)

------------------------------------------------------------
Most of the API uses 0-based indices, and ranges are end-exclusive.
For the end of a range, -1 denotes the last line/column.

------------------------------------------------------------
Iterating over tables:

for v in pairs(mytable) do
  print(mytable[v])
end

-- k,v
for index,value in ipairs(mytable) do
  print(index,value)
end

---------------
The entire buffer:
lua myTable1 = vim.api.nvim_buf_get_lines(0, 0, -1, false)

for i, line in ipairs(myTable1) do
  local lineLen = string.len(line)

  if i == 1 then
    -- print(line)
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, {line})  -- First row
  end

end

------------------------------------------------------------
Lua Quick Guide -
https://github.com/medwatt/Notes/blob/main/Lua/Lua_Quick_Guide.ipynb
-->
https://github.com/medwatt/Notes/blob/main/Lua/Lua_Quick_Guide.pdf

2.3 Pattern Matching
-- h luaref-patterns
Lua’s string library doesn’t support regular expressions (regex), but
it supports something similar, albeit more limited in functionality.

]]

------------------------------------------------------------
local A = vim.api

-- local buf = vim.api.nvim_create_buf(true, false)

local buf = A.nvim_create_buf('listed', '')  -- Create a new buffer
A.nvim_buf_set_name(buf, 'Options.txt')  -- Assign a name to the new buffer
A.nvim_buf_set_option(buf, 'buftype', '')  -- set buftype="" (because I want to save the file)

------------------------------
local linesNum = A.nvim_buf_line_count(0)

for row1 = 1, linesNum do  -- The range includes both ends.
  local line1 = A.nvim_buf_get_lines(0, row1 - 1, row1, false)[1] -- only one line

  -- h luaref-patterns
  -- 1 important
  if (string.match(line1, '^.%d')) then  -- `%d`  represents all digits.

    for row2 = 1, 100 do  -- The range includes both ends.
      local line2 = A.nvim_buf_get_lines(0, row1 - 1 + row2, row1 + row2, false)[1] -- only one line
      if (line2 ~= "") and not(string.match(line2, '^.%d')) then
        local words = vim.split(line2, "\t")
        local firstWord = words[1]
        -- print(firstWord .. " mySep " .. line1)
        A.nvim_buf_set_lines(buf, -1, -1, true, {firstWord .. '\t' .. line1})
      end

      if (string.match(line2, '^.%d')) then  -- `%d`  represents all digits.
        row1 = row1 + row2 - 1
        break
      end
    end

  end


end

