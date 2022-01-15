-- io.write('Digite alguma coisa:')
-- local a = io.read()

local file = io.open('teste.txt', 'r')
local content = file:read('a')
print('|' .. content .. '|')

file = io.open('teste.txt', 'w')
file:write(content)
file:close()
