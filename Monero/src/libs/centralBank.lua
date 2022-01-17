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
                'CountryCode:' .. (row.CountryCode or '') .. '\n',
                'Country:' .. (row.Country or '') .. '\n',
                'CurrencyType:' .. (row.CurrencyType or '') .. '\n',
                'ExclusionDate:' .. (row.ExclusionDate or '') .. '\n',
                '\n'
            }
        )
    end
    return result
end

function CreateTableCurrencies(currencies, split, trim)
    local currencyFinalTable = {}

    for _, value in ipairs(currencies) do
        local currency_fields = split(value, ';')
        local currency = {
            Code = (currency_fields[1] and trim(currency_fields[1])),
            Name = (currency_fields[2] and trim(currency_fields[2])),
            Symbol = (currency_fields[3] and trim(currency_fields[3])),
            CountryCode = (currency_fields[4] and trim(currency_fields[4])),
            Country = (currency_fields[5] and trim(currency_fields[5])),
            CurrencyType = (currency_fields[6] and trim(currency_fields[6])),
            ExclusionDate = (currency_fields[7] and trim(currency_fields[7]))
        }
        table.insert(currencyFinalTable, currency)
    end

    return currencyFinalTable
end

function GetCurrencyByCountry(currencies, country)
    local currencyExist = {}
    for k, currency in ipairs(currencies) do
        if (currency.Country == country) then
            table.insert(currencyExist, currency)
        end
    end
    return currencyExist
end

function FilterValidCurrencies(currencies)
    local filteredCurrencies = {}
    for k, currency in ipairs(currencies) do
        if not (currency.ExclusionDate) then
            table.insert(filteredCurrencies, currency)
        end
    end
    return filteredCurrencies
end

function DownloadCurreciesTable(day)
    local fileName = GetCurrenciesFileName(day, 'M')
    DownloadFile(fileName)
end
function DownloadQuotesTable(day)
    local fileName = GetCurrenciesFileName(day)
    DownloadFile(fileName)
end

function DownloadFile(fileName)
    local dirPath = 'quotes/' .. fileName
    local BASE_URL = 'https://www4.bcb.gov.br/Download/fechamento/' .. fileName
    os.execute(table.concat({'curl -o ', dirPath, ' ', BASE_URL, ' 2>/dev/null'}))
end

function GetCurrenciesFileName(day, name)
    name = name or ''
    return table.concat(
        {
            name,
            day,
            '.csv'
        }
    )
end
