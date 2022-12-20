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
:luafile "path to"\options_option-window.lua

Example:
:so C:\Users\<user name>\Documents\options_option-window.lua

------------------------------
I want this:

 1 important

compatible	behave very Vi compatible (not advisable) 	set nocp	cp
cpoptions	list of flags to specify Vi compatibility 	set cpo=aABceFs_
paste	paste mode, insert typed text literally 	set nopaste	paste
pastetoggle	key sequence to toggle paste mode 	set pt=

...

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

------------------------------
h api-buffer
lua print(vim.api.nvim_buf_line_count(0))

Go to the buffer "options.txt"
lua linesNum = vim.api.nvim_buf_line_count(0)
lua print(linesNum)

------------------------------------------------------------
Lua Quick Guide -
https://github.com/medwatt/Notes/blob/main/Lua/Lua_Quick_Guide.ipynb

h luaref-patterns
- `%a`  represents all letters.
- `%d`  represents all digits.

------------------------------------------------------------
]]

------------------------------------------------------------
local A = vim.api

-- local buf = vim.api.nvim_create_buf(true, false)
local buf = A.nvim_create_buf('listed', '')  -- Create a new buffer
A.nvim_buf_set_name(buf, 'Options.txt')  -- Assign a name to the new buffer
A.nvim_buf_set_option(buf, 'buftype', '')  -- set buftype="" (because I want to save the file)

------------------------------
local line = ""
local linesNum = A.nvim_buf_line_count(0)

for row1 = 1, linesNum do  -- The range includes both ends.
  local line1 = A.nvim_buf_get_lines(0, row1 - 1, row1, false)[1] -- only one line
  local line1Len = string.len(line1)

  if row1 == 1 then
    -- print(line1)
    A.nvim_buf_set_lines(buf, 0, 1, true, {line1})  -- First row
    -- print(" ")
    A.nvim_buf_set_lines(buf, -1, -1, true, {''})
  end

  if (line1Len > 0) then
    if (string.match(line1, '^%a')) then  -- %a letters (A-Z, a-z)

      for row2 = 1, 10 do  -- The range includes both ends.
        local line2 = A.nvim_buf_get_lines(0, row1 + row2 - 1, row1 + row2, false)[1]
        local line2Len = string.len(line2)

        if (line2Len > 0) then
          if (string.match(line2, '^%A')) then  -- %A represents all non-letter characters.
            if row2 == 1 then
              line = line1 .. line2
            else
              line = line .. line2
            end
          elseif (string.match(line1, '^%a')) then  -- %a letters (A-Z, a-z)
            row1 = row1 + row2
            -- print(line)
            A.nvim_buf_set_lines(buf, -1, -1, true, {line})
            line = ""
            break
          end

          if (row1 + row2) == linesNum then -- because of the last option
            -- print(line)
            A.nvim_buf_set_lines(buf, -1, -1, true, {line})
            break
          end
        elseif (line2Len == 0) then
          -- print(line)
          A.nvim_buf_set_lines(buf, -1, -1, true, {line})
          -- print(" ")
          A.nvim_buf_set_lines(buf, -1, -1, true, {''})
          line = ""

          line2 = A.nvim_buf_get_lines(0, row1 + row2 - 1 + 1, row1 + row2 + 1, false)[1]
          -- print(line2)
          A.nvim_buf_set_lines(buf, -1, -1, true, {line2})

          row1 = row1 + row2 - 1
          -- print(" ")
          A.nvim_buf_set_lines(buf, -1, -1, true, {''})
          break
        end

      end

    end
  end

end

