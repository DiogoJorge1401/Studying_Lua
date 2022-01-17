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

function CreateTableCurrencies(currencies, split,trim)
    local currencyFinalTable = {}

    for _, value in ipairs(currencies) do
        local currency_table = split(value, ';')
        local currency = {
            Code = (currency_table[1] and trim(currency_table[1])),
            Name = (currency_table[2] and trim(currency_table[2])),
            Symbol = (currency_table[3] and trim(currency_table[3])),
            Country = (currency_table[5] and trim(currency_table[5]))
        }
        table.insert(currencyFinalTable, currency)
    end

    return currencyFinalTable
end
