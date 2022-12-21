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

compatible	behave very Vi compatible (not advisable)
 	set nocp	cp
cpoptions	list of flags to specify Vi compatibility
 	set cpo=aABceFs_
paste	paste mode, insert typed text literally
 	set nopaste	paste
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

------------------------------
I want this:

compatible	 1 important
cpoptions	 1 important
paste	 1 important
pastetoggle	 1 important
runtimepath	 1 important
packpath	 1 important
helpfile	 1 important
whichwrap	 2 moving around, searching and patterns
startofline	 2 moving around, searching and patterns
...

-- #########################################################

RESOURCES (Neovim Lua API):

https://www.davekuhlman.org/nvim-lua-info-notes.html
Published
Fri 29 April 2022

https://jacobsimpson.github.io/nvim-lua-manual/docs/buffers-and-windows/

https://github.com/nanotee/nvim-lua-guide

------------------------------------------------------------
NOTE:

------------------------------
-- 02:
h luaref-Lib

5  STANDARD LIBRARIES

5.4 - String Manipulation
h luaref-libString

h string.sub
h string.len
h string.match

h luaref-patterns
- `%a`  represents all letters.
- `%d`  represents all digits.

------------------------------
-- 03:
h lua.txt

---------------
Lua module: vim
h lua-vim

h vim.split
h vim.trim

------------------------------
-- 04:
Nvim API
h api.txt

Options Functions
h api-options
h nvim_buf_set_option

Buffer Functions
h api-buffer
-->
h nvim_buf_set_name
h nvim_buf_line_count
h nvim_buf_get_lines
h nvim_buf_set_lines

Global Functions
h api-global
-->
h nvim_create_buf
h nvim_get_current_line
h nvim_get_current_buf
h nvim_list_bufs
h nvim_notify

------------------------------------------------------------
h buffers

------------------------------------------------------------
Lua Quick Guide -
https://github.com/medwatt/Notes/blob/main/Lua/Lua_Quick_Guide.ipynb

h luaref-patterns
- `%a`  represents all letters.
- `%d`  represents all digits.
-- %A represents all non-letter characters.

------------------------------------------------------------
]]

------------------------------------------------------------
local A = vim.api

-- nvim_create_buf({listed}, {scratch})
-- local buf = vim.api.nvim_create_buf(true, false)
local buf = A.nvim_create_buf('listed', '')  -- Create a new buffer

A.nvim_buf_set_name(buf, 'Options_groups.txt')  -- Assign a name to the new buffer
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
      if (string.match(line2, '^%a')) then
        local words = vim.split(line2, "\t")
        local firstWord = words[1]
        -- print(firstWord .. ", " .. line1)
        A.nvim_buf_set_lines(buf, -1, -1, true, {firstWord .. ', ' .. vim.trim(line1)})
      end

      if (string.match(line2, '^.%d')) then  -- `%d`  represents all digits.
        row1 = row1 + row2 - 1
        break
      end

      if (row1 + row2 == linesNum -1) then
        break
      end
    end

  end


end

