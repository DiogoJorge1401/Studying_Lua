File = io.open('currencies.csv', 'r')
Content = File:read('*a')

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

function ToString(currencies)
    local result = ''
    for index, row in ipairs(currencies) do
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

Lines = Trim(Content)
Lines = Split(Lines, '\n')
table.remove(Lines, 1)
Results = {}

for index, value in ipairs(Lines) do
    local currency_table = Split(value, ';')
    local currency = {
        Code = (currency_table[1] and Trim(currency_table[1])),
        Name = (currency_table[2] and Trim(currency_table[2])),
        Symbol = (currency_table[3] and Trim(currency_table[3])),
        Country = (currency_table[5] and Trim(currency_table[5]))
    }
    table.insert(Results, currency)
end

File = io.open('currencies.txt', 'w')
File:write(ToString(Results))
