-- date: 2022-12M-23 14:58:52
--[[
------------------------------------------------------------
No 0)
neovim-options-survey_groups.lua
(-->  neovim-options-survey_groups.txt)

------------------------------------------------------------
No 1)
Neovim, open "neovim-options-survey_groups.txt"
Goto buffer "neovim-options-survey_groups.txt"

No 2)
Run this script!
:so C:\Users\<user name>\Documents\sort_neovim-options-survey_groups.lua

No 3)
write buffer
:w

------------------------------
I want this:

pastetoggle,"", 1 important
compatible,false, 1 important
sections,"SHNHH HUnhsh", 2 moving around
casemap,"internal,keepascii", 2 moving around
cdhome,false, 2 moving around
...
exrc,false, 26 various

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

----------
5.1  Basic Functions
h luaref-libBasic

h luaref-tonumber

----------
5.4 - String Manipulation
h luaref-libString

h string.sub
h string.len
h string.match

h luaref-patterns
- `%a`  represents all letters.
- `%d`  represents all digits.

----------
5.5  Table Manipulation
h luaref-libTable

h table.concat
h table.sort

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

--[[
Lua Quick Guide -
https://github.com/medwatt/Notes/blob/main/Lua/Lua_Quick_Guide.ipynb

Lua_Quick_Guide.pdf

2.3 Pattern Matching
string.match(line1, '^.%d')

-->
4.3 Other Table Methods
]]
------------------------------------------------------------

local A = vim.api

-- nvim_create_buf({listed}, {scratch})
local buf_id = A.nvim_create_buf(true, false)

A.nvim_buf_set_name(buf_id, 'sort_neovim-options-survey_groups.txt')  -- Assign a name to the new buffer
A.nvim_buf_set_option(buf_id, 'buftype', '')  -- set buftype="" (because I want to save the file)

------------------------------
-- local T = {"John", "Mary", "Thomas"}
-- local T = {"imsearch, 24 language 1 specific", "paste, 1 important 7", "listchars, 4 displaying 2 text"}
-- print(vim.inspect(T))

-- The entire buffer is loaded into the table.
-- neovim-options-survey_groups.txt (:ls  --> buf_id=1)
local myTable = A.nvim_buf_get_lines(0, 0, -1, false)

------------------------------
-- create a comparison function to sort according to the second letter
-- h luaref-tonumber
local function comp(s1, s2)
  -- return string.sub(s1,2,2) > string.sub(s2,2,2)
  -- return string.sub(s1,2,2) < string.sub(s2,2,2)
  -- return string.match(s1, ',%s%d+') < string.match(s2, ',%s%d+')
  return tonumber(string.match(s1, '%s%d+%s')) < tonumber(string.match(s2, '%s%d+%s'))
end

-- sort the table according to this function
-- h table.sort
table.sort(myTable, comp) --> T = {John, Thomas, Mary}

------------------------------
-- print("After sort:")
-- print(vim.inspect(myTable))

--[[
h nvim_buf_set_lines
]]
A.nvim_buf_set_lines(buf_id, 0, -1, true, myTable)
vim.api.nvim_set_current_buf(buf_id)

