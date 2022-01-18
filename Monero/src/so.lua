local os = {
    DIR_SEP = string.sub(package.config, 1, 1),
    PATH_SEP = string.sub(package.config, 3, 3)
}
local SYSTEM_MAP = {
    ['\\'] = 'WINDOWS',
    ['/'] = 'UNIX'
}

local SYSTEM_PARAMS = {
    NULL_DEV = {
        WINDOWS = 'null',
        UNIX = '/dev/null'
    }
}

function os.getSystem()
    return SYSTEM_MAP[os.DIR_SEP]
end

function os.getParam(name)
  return SYSTEM_PARAMS[name][os.getSystem()]
end

return os