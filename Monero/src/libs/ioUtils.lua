function ReadFile(fileName)
    local file = io.open(fileName, 'r')
    if not (file) then
        return nil, table.concat({'File "', fileName, '" not found!'})
    end
    local content = file:read('a')
    file:close()
    return true, content
end

function WriteOnFile(fileName, content)
    io.open(fileName, 'w'):write(content):close()
end
