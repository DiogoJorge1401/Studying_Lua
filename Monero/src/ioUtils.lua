local ioUtils = {}

ioUtils.ReadFile = function(fileName)
    local file = io.open(fileName, 'r')
    if not (file) then
        error(table.concat({'File "', fileName, '" not found!'}), 2)
    end
    local content = file:read('a')
    file:close()
    return content
end

ioUtils.WriteOnFile = function(fileName, content)
    io.open(fileName, 'w'):write(content):close()
end

return ioUtils