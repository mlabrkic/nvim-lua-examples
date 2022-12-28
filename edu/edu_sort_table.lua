--[[
Open this script, and run:
:so%

]]
------------------------------------------------------------
--[[
Lua Quick Guide -
https://github.com/medwatt/Notes/blob/main/Lua/Lua_Quick_Guide.ipynb

Lua_Quick_Guide.pdf

2.3 Pattern Matching
string.match(line1, '^.%d')

h luaref-patterns
- `%a`  represents all letters.
- `%d`  represents all digits.
-- %A represents all non-letter characters.

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

]]
------------------------------------------------------------

-- local T = {"John", "Mary", "Thomas"}
local T = {"imsearch, 24 language 1 specific", "paste, 1 important 7", "listchars, 4 displaying 2 text"}
print(vim.inspect(T))

--[[
:lua T = {"John", "Mary", "Thomas"}
:print(vim.inspect(T))
]]

-- create a comparison function to sort according to the second letter
-- h luaref-tonumber
local function comp(s1, s2)
  -- return string.sub(s1,2,2) > string.sub(s2,2,2)
  -- return string.sub(s1,2,2) < string.sub(s2,2,2)
  -- return string.match(s1, ',%s%d+') < string.match(s2, ',%s%d+')
  return tonumber(string.match(s1, '%s%d+')) < tonumber(string.match(s2, '%s%d+'))
end

-- sort the table according to this function
-- h table.sort
table.sort(T, comp) --> T = {John, Thomas, Mary}

print("After sort:")
print(vim.inspect(T))
