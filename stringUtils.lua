local stringUtils = {}

stringUtils.Split = function(str, sep)
    local parts = {}
    local iniPart = 1
    local posPartBreak, endPartBreak
    repeat
        posPartBreak, endPartBreak = string.find(str, sep, iniPart)
        local endPart
        if posPartBreak then
            endPart = posPartBreak - 1
        end
        local part = string.sub(str, iniPart, endPart)
        if posPartBreak then
            iniPart = endPartBreak + 1
        end
        table.insert(parts, part)
    until posPartBreak == nil
    return parts
end

stringUtils.Trim = function(s)
    return s:gsub('^%s+', ''):gsub('%s+$', '')
end

return stringUtils