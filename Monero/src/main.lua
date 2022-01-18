require 'libs.dateUtils'
require 'libs.stringUtils'
require 'libs.ioUtils'
require 'libs.centralBank'

local function execute(...)
    local args = {...}
    local inputFileName

    local commandName = args[1]

    if commandName == 'search' then
        local countryName = string.upper((args[2] or ''))
        inputFileName = 'quotes/' .. GetCurrenciesFileName(GetDateToday(), 'M')
        local status, content = ReadFile(inputFileName)
        if not (status) then
            DownloadCurreciesTable(GetDateToday())
            print('Baixando moedas atualizadas!')
            execute(...)
        end
        local tableCurrencies = CreateTableCurrencies(content)
        local currencysExists = GetCurrencyByCountry(tableCurrencies, countryName)
        local validCurrencie = FilterValidCurrencies(currencysExists)
        print('Symbol: ' .. validCurrencie[1].Symbol)
    elseif commandName == 'convert' then
        local value = tonumber(args[2])
        local sourceCurrenncySymbol = string.upper(args[3])
        local destineCurrencySymbol = string.upper(args[4])
        local date = args[5] or GetDateToday()

        local status, content = ReadFile('quotes/' .. date .. '.csv')
        if not (status) then
            DownloadQuotesTable(date)
            execute(...)
            return
        end
        local quotesTable = CreateQuoteTable(content)
        local sourceCurrenncy = quotesTable[sourceCurrenncySymbol]
        local destineCurrency = quotesTable[destineCurrencySymbol]
        if not (sourceCurrenncy) then
            print('Quote symbol not found: "' .. sourceCurrenncySymbol .. '"')
            os.exit()
        elseif not (destineCurrency) then
            print('Quote symbol not found: "' .. destineCurrencySymbol .. '"')
            os.exit()
        end
        local conversionAmount = Convert(value, sourceCurrenncy, destineCurrency)
        print(string.format('%s %s = %s %s', value, sourceCurrenncySymbol, conversionAmount, destineCurrencySymbol))
    end
end

execute(...)
