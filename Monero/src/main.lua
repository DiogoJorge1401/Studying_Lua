require 'libs.dateUtils'
require 'libs.stringUtils'
require 'libs.ioUtils'
require 'libs.centralBank'

local function execute(...)
    local args = {...}
    local inputFileName

    if args[1] == 'search' then
        local countryName = string.upper((args[2] or ''))

        inputFileName = 'quotes/' .. GetCurrenciesFileName(GetDateToday(), 'M')

        local status, content = ReadFile(inputFileName)

        if not (status) then
            DownloadCurreciesTable(GetDateToday())
            print("Baixando moedas atualizadas!")
            execute(...)
            os.exit()
        end

        local tableCurrencies = CreateTableCurrencies(content)

        local currencysExists = GetCurrencyByCountry(tableCurrencies, countryName)

        local validCurrencie = FilterValidCurrencies(currencysExists)

        print(validCurrencie[1].Code)
    end
end

-- execute(...)

DownloadQuotesTable('20220114')
local status, content = ReadFile('quotes/20220114.csv')
local quotesTable = CreateQuoteTable(content)
