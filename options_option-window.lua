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
helpfile	name of the main help file 	set hf=C:\\UTILS\\Neovim\\share\\nvim\\runtime\\doc\\help.txt

 2 moving around, searching and patterns

whichwrap	list of flags specifying which commands wrap to another line	(local to window) 	set ww=b,s
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

