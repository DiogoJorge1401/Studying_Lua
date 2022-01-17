require 'libs.stringUtils'
require 'libs.ioUtils'
require 'libs.centralBank'

local function execute(...)
    local args = {...}
    local inputFileName

    if args[1] == 'search' then
        local countryName = string.upper((args[2] or ''))

        inputFileName =
            table.concat(
            {
                'quotes/',
                'M',
                os.date('%Y%m%d'),
                '.csv'
            }
        )

        local status, content = ReadFile(inputFileName)

        if not (status) then
            print(content, countryName)
            os.exit(0)
        end
        status, content = ReadFile(inputFileName)

        if not (status) then
            print(content)
            os.exit()
        end

        local currenciesTable = Trim(content)

        currenciesTable = Split(currenciesTable, '\n')

        table.remove(currenciesTable, 1)

        local tableCurrencies = CreateTableCurrencies(currenciesTable, Split, Trim)

        local currencysExists = GetCurrencyByCountry(tableCurrencies, countryName)

        local validCurrencie = FilterValidCurrencies(currencysExists)

        if(validCurrencie[1]) then
            print(validCurrencie[1].Code)
        end

        -- local textCurrencies = Trim(ToString(tableCurrencies))
    
        -- WriteOnFile(string.gsub(inputFileName, '.%w+$', '.txt'), textCurrencies)
    
        -- io.write('Parse do arquivo feito com succeso!\n')
    end

end

execute(...)
