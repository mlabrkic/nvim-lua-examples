-- date: 2022-12M-28 17:01:26
--[[
------------------------------------------------------------
No 0)
opt03_sort_nvim-opt-surv_gr.lua
(--> 03sortNeovim-options-survey_groups.txt)

------------------------------------------------------------
No 1)
Neovim, open "03sortNeovim-options-survey_groups.txt"
Goto buffer "03sortNeovim-options-survey_groups.txt"

No 2)
Run this script!
:so C:\Users\<user name>\Documents\opt04_sortSort_nvim-opt-surv_gr.lua

No 3)
write buffer
:w

------------------------------
I want this:
04sort_Sort_nvim-opt-surv_gr.txt :

...
paste,false, 1 important
pastetoggle,"", 1 important

autochdir,false, 2 moving around
casemap,"internal,keepascii", 2 moving around
cdhome,false, 2 moving around
cdpath,",,", 2 moving around
define,"^\\s*#\\s*define", 2 moving around
include,"^\\s*#\\s*include", 2 moving around
includeexpr,"", 2 moving around
incsearch,true, 2 moving around
magic,true, 2 moving around
maxmempattern,1000, 2 moving around
paragraphs,"IPLPPPQPP TPHPLIPpLpItpplpipbp", 2 moving around
path,".,/usr/include,,", 2 moving around
regexpengine,0, 2 moving around
startofline,false, 2 moving around
wrapscan,true, 2 moving around

cscopepathcomp,0, 3 tags
cscopeprg,"cscope", 3 tags
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
h table.maxn

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

Lua_Quick_Guide.pdf

------------------------------
2.3 Pattern Matching
string.match(line1, '^.%d')

h luaref-patterns
- `%a`  represents all letters.
- `%d`  represents all digits.
-- %A represents all non-letter characters.

------------------------------
Tables
-->
4.2 Basic Table Operations

local T = {"b", "c", "d"} --> {[1]="b", [2]="c", [3]="d"}

-- update an entry
T[1] = "a" --> {[1]="a", [2]="c", [3]="d"}

-- add a new item at a specific unoccupied index
T[10] = "j" --> {[1]="a", [2]="c", [3]="d", [10]="j"}

-- add a new item to the end of the last consecutive integer key
table.insert(T, "e") --> {[1]="a", [2]="c", [3]="d", [4],"e", [10]="j"}

-- insert a new item at a specific occupied index
table.insert(T, 2, "b") --> {[1]="a", [2]="b", [3]="c", [4]="d", [5],"e", [10]="j"}

-- T[6] = nil, so the loop stops at T[5]
for index, value in ipairs(T) do
  print(index, value)
end

------------------------------
Tables
-->
4.3 Other Table Methods

Sort list elements in a given order, in-place.
If "comp" is given, then it must be a function that receives two list elements and
returns "true" when the first element must come before the second in the final order.
If "comp" is not given, then the standard Lua operator < is used instead.

local T = {"John", "Mary", "Thomas"}

-- create a comparison function to sort according to the second letter
local function comp(s1, s2)
    return string.sub(s1,2,2) > string.sub(s2,2,2)
end

-- sort the table according to this function
table.sort(T, comp) --> T = {John, Thomas, Mary}

------------------------------
5.5 Variable Number of Arguements

-- `_` is a placeholder for a variable whose value we don't care about

for _, value in ipairs(arg) do
  sum = sum + value
end

---------------
h luaref-pairs
h luaref-ipairs

for k,v in pairs(t) do
`body`
end

------------------------------------------------------------
:h :language
:language de_DE.ISO_8859-1

:h :sort

]]
------------------------------------------------------------

local A = vim.api

-- nvim_create_buf({listed}, {scratch})
local bufnr = A.nvim_create_buf(true, false)

A.nvim_buf_set_name(bufnr, '04sort_Sort_nvim-opt-surv_gr.txt')  -- Assign a name to the new buffer
A.nvim_buf_set_option(bufnr, 'buftype', '')  -- set buftype="" (because I want to save the file)

------------------------------
-- local lines = { '---Start---' }
local lines = { }
local linesSort = { }

local lastWordOLD

-- The entire buffer is loaded into the table.
-- 03sortNeovim-options-survey_groups.txt
local myTable = A.nvim_buf_get_lines(0, 0, -1, false)

for k,line in pairs(myTable) do
  local words = vim.split(line, ", ")

  -- h table.maxn
  local iMax = table.maxn(words)
  -- local firstWord = words[1]
  local lastWord = words[iMax]

  -- first line
  if k == 1 then
    lastWordOLD = lastWord
  end

  if (lastWord == lastWordOLD) then
    table.insert(linesSort, line)
  else
    table.sort(linesSort)
    vim.list_extend(lines, linesSort)
    linesSort = { }
  end
  lastWordOLD = lastWord

end

------------------------------
-- TEST table.sort :

-- local linesSort = A.nvim_buf_get_lines(0, 0, 4, false)
-- table.sort(linesSort)

-- print("After sort:")
-- print(vim.inspect(linesSort))

-- A.nvim_buf_set_lines(bufnr, 0, -1, true, linesSort)

------------------------------
--[[
h nvim_buf_set_lines
]]
A.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
A.nvim_set_current_buf(bufnr)

