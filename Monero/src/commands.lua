require 'libs.dateUtils'
require 'libs.stringUtils'
require 'libs.ioUtils'
require 'libs.centralBank'

local Commands = {}

Commands.search = function(args)
    local countryName = string.upper((args[1] or ''))
    local inputFileName = 'quotes/' .. GetCurrenciesFileName(GetDateToday(), 'M')
    local status, content = ReadFile(inputFileName)
    if not (status) then
        DownloadCurreciesTable(GetDateToday())
        Commands.search(args)
        return
    end
    local tableCurrencies = CreateTableCurrencies(content)
    local currencysExists = GetCurrencyByCountry(tableCurrencies, countryName)
    local validCurrencie = FilterValidCurrencies(currencysExists)
    print('Symbol: ' .. validCurrencie[1].Symbol)
end

Commands.convert = function(args)
    local value = tonumber(args[1])
    local sourceCurrenncySymbol = string.upper(args[2])
    local destineCurrencySymbol = string.upper(args[3])
    local date = args[4] or GetDateToday()

    local status, content = ReadFile('quotes/' .. date .. '.csv')
    if not (status) then
        DownloadQuotesTable(date)
        Commands.convert(args)
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

return Commands