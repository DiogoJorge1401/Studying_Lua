require 'libs.stringUtils'
require 'libs.ioUtils'
require 'libs.centralBank'

local function execute(...)
    local args = {...}
    local inputFileName

    if args[1] == 'search' then
        local countryName = args[2]

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

    end

    local status, content = ReadFile(inputFileName)

    if not (status) then
        print(content)
        os.exit()
    end

    local currenciesTable = Trim(content)
    currenciesTable = Split(currenciesTable, '\n')
    table.remove(currenciesTable, 1)

    local results = CreateTableCurrencies(currenciesTable, Split, Trim)

    WriteOnFile(string.gsub(inputFileName, '.%w+$', '.txt'), Trim(ToString(results)))

    io.write('Parse do arquivo feito com succeso!\n')
end

execute(...)
