function CurrenciesTableToString(currencies)
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

function CreateTableCurrencies(content)
    local currencies = Trim(content)

    currencies = Split(currencies, '\n')

    table.remove(currencies, 1)

    local currencyFinalTable = {}

    for _, line in ipairs(currencies) do
        table.insert(currencyFinalTable, ReadTable(line))
    end

    return currencyFinalTable
end

function ReadTable(currencyLine)
    local currency_fields = Split(currencyLine, ';')
    local currency = {
        Code = (currency_fields[1] and Trim(currency_fields[1])),
        Name = (currency_fields[2] and Trim(currency_fields[2])),
        Symbol = (currency_fields[3] and Trim(currency_fields[3])),
        CountryCode = (currency_fields[4] and Trim(currency_fields[4])),
        Country = (currency_fields[5] and Trim(currency_fields[5])),
        CurrencyType = (currency_fields[6] and Trim(currency_fields[6])),
        ExclusionDate = (currency_fields[7] and Trim(currency_fields[7]))
    }
    return currency
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
-------------------------------------------------------------------
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
    local result = os.execute(table.concat({'curl -o ', dirPath, ' ', BASE_URL, ' 2>/dev/null'}))
    if not(result) then
        print("Unable to download currencies file. Try later")
        os.exit()
    end
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
-------------------------------------------------------------------
function CreateQuoteTable(content)
    local quotesTable = Trim(content)

    quotesTable = Split(quotesTable, '\n')

    local quotesFinalTable = {}

    for _, line in ipairs(quotesTable) do
        local quote = ReadQuote(line)
        quotesFinalTable[quote.Symbol] = quote
    end

    return quotesFinalTable
end

function ReadQuote(quoteLine)
    local quote_fields = Split(quoteLine, ';')

    local quote = {
        Code = (quote_fields[2] and quote_fields[2]),
        Type = (quote_fields[3] and quote_fields[3]),
        Symbol = (quote_fields[4] and quote_fields[4]),
        PurchaseFee = (quote_fields[5] and CBPriceToNumber(quote_fields[5])),
        SaleFee = (quote_fields[6] and CBPriceToNumber(quote_fields[6])),
        PurchaseParity = (quote_fields[7] and CBPriceToNumber(quote_fields[7])),
        ParitySale = (quote_fields[8] and CBPriceToNumber(quote_fields[8]))
    }

    return quote
end

function CBPriceToNumber(cbPrice)
    return tonumber((string.gsub(cbPrice, ',', '.')))
end

function ShowQuote(quote)
    print(
        table.concat(
            {
                'Currency: ',
                quote.Symbol,
                ' (',
                quote.Type,
                ')',
                '\n',
                'Tax\t=> ',
                'Purchase: ',
                quote.PurchaseFee,
                ' Sale: ',
                quote.SaleFee,
                '\n',
                'Parity\t=> ',
                'Purchase: ',
                quote.PurchaseParity,
                ' Sale: ',
                quote.ParitySale,
                '\n'
            }
        )
    )
end

REAL_SYMBOL = 'BRL'

function ToDollar(quoteTable, amount, currencySymbol)
    if currencySymbol == REAL_SYMBOL then
        return amount / quoteTable.USD.SaleFee
    end

    local currency = quoteTable[currencySymbol]
    if currency.Type == 'A' then
        return amount / currency.ParitySale
    end
    return amount * currency.ParitySale
end

function FromDollar(quoteTable, amount, currencySymbol)
    if currencySymbol == REAL_SYMBOL then
        return amount * quoteTable.USD.SaleFee
    end
    local currency = quoteTable[currencySymbol]
    if currency.Type == 'A' then
        return amount * currency.ParitySale
    end
    return amount / currency.ParitySale
end

function Convert(quoteTable, amount, srcQuoteSymbol, destQuoteSymbol)
    return FromDollar(quoteTable, ToDollar(quoteTable, amount, srcQuoteSymbol), destQuoteSymbol)
end
