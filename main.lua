function ToString(currencies)
    local result = ''
    for _, row in ipairs(currencies) do
        result =
            table.concat(
            {
                result,
                'Code:' .. (row.Code or '') .. '\n',
                'Name:' .. (row.Name or '') .. '\n',
                'Symbol:' .. (row.Symbol or '') .. '\n',
                'Country:' .. (row.Country or '') .. '\n',
                '\n'
            }
        )
    end
    return Trim(result)
end

function Split(str, sep)
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

function Trim(s)
    return s:gsub('^%s+', ''):gsub('%s+$', '')
end

function ReadFile(fileName)
    local File = io.open(fileName, 'r')
    local Content = File:read('a')
    File:close()
    return Content
end

function WriteOnFile(fileName, content)
    File = io.open(string.gsub(fileName, '.%w+$', '.txt'), 'w')
    File:write(content)
    File:close()
end

local function execute()
    -- currencies.csv
    io.write('Digite o nome do arquivo de entrada: ')
    local fileName = io.read()
    local content = ReadFile(fileName)

    local line = Trim(content)
    line = Split(line, '\n')
    table.remove(line, 1)
    local results = {}

    for _, value in ipairs(line) do
        local currency_table = Split(value, ';')
        local currency = {
            Code = (currency_table[1] and Trim(currency_table[1])),
            Name = (currency_table[2] and Trim(currency_table[2])),
            Symbol = (currency_table[3] and Trim(currency_table[3])),
            Country = (currency_table[5] and Trim(currency_table[5]))
        }
        table.insert(results, currency)
    end

    WriteOnFile(fileName, ToString(results))
    io.write('Parse do arquivo feito com succeso!\n')
end
execute()
