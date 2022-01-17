function Split(str, sep)
    local t = {}

    for substr in string.gmatch(str, '[^' .. sep .. ']*') do
        if substr ~= nil and string.len(substr) > 0 then
            table.insert(t, substr)
        end
    end

    return t
end

function Trim(s)
    return s:gsub('^%s+', ''):gsub('%s+$', '')
end
