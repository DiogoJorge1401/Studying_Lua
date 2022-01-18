local Commands = require 'commands'

local function execute(...)
    local args = {...}
    local commandName = args[1]
    local command = Commands[commandName]
    if not (command) then
        print('Command not found: '..commandName)
        os.exit()
    end
    command({select(2, ...)})
end

execute(...)
