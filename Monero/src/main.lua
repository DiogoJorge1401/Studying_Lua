require 'libs.dateUtils'
require 'libs.stringUtils'
require 'libs.ioUtils'
require 'libs.centralBank'

local function execute(...)
    local args = {...}
    local inputFileName

    if args[1] == 'search' then
        local countryName = string.upper((args[2] or ''))

        inputFileName = 'quotes/' .. GetCurrenciesFileName(GetDateToday())

        local status, content = ReadFile(inputFileName)

        if not (status) then
            DownloadCurreciesTable(GetDateToday())
            execute(...)
            os.exit()
        end

        local currenciesTable = Trim(content)

        currenciesTable = Split(currenciesTable, '\n')

        table.remove(currenciesTable, 1)

        local tableCurrencies = CreateTableCurrencies(currenciesTable, Split, Trim)

        local currencysExists = GetCurrencyByCountry(tableCurrencies, countryName)

        local validCurrencie = FilterValidCurrencies(currencysExists)

        if (validCurrencie[1]) then
            print(validCurrencie[1].Code)
        end
    end
end

-- execute(...)
DownloadCurreciesTable('20220117')
DownloadQuotesTable('20220114')
