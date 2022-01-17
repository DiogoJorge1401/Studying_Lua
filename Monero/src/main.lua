-- dofile('stringUtils.lua')
local su = require 'stringUtils'
local iou = require 'ioUtils'

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
    return result
end

local function execute()
    io.write('Digite o nome do arquivo de entrada: ')
    local fileName = io.read()
    local status, content = pcall(iou.ReadFile, fileName)

    if not (status) then
        print(content)
        os.exit()
    end

    local line = su.Trim(content)
    line = su.Split(line, '\n')
    table.remove(line, 1)
    local results = {}

    for _, value in ipairs(line) do
        local currency_table = su.Split(value, ';')
        local currency = {
            Code = (currency_table[1] and su.Trim(currency_table[1])),
            Name = (currency_table[2] and su.Trim(currency_table[2])),
            Symbol = (currency_table[3] and su.Trim(currency_table[3])),
            Country = (currency_table[5] and su.Trim(currency_table[5]))
        }
        table.insert(results, currency)
    end

    iou.WriteOnFile(string.gsub(fileName, '.%w+$', '.txt'), su.Trim(ToString(results)))
    io.write('Parse do arquivo feito com succeso!\n')
end
execute()
