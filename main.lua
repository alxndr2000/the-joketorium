--- Loads features


local features = { -- we can probably make a config thing for this
    {file = "atlases", enabled = true}, -- TODO "unique atlas for each feature"
    {file = "cigs", enabled =  true},
    {file = "common-jokers", enabled =  true},
    {file = "uncommon-jokers", enabled =  true},
    {file = "rare-jokers", enabled =  true},
    {file = "curry", enabled =  true},
    {file = "ketchup", enabled =  true},
    {file = "traffic", enabled =  true},
}

for i, t in ipairs(features) do
    if t.enabled then
        sendDebugMessage("Loading " .. t.file .. "...", "Joketorium")
        SMODS.load_file('features/' .. t.file .. ".lua")()
    else
        sendDebugMessage("Skipping" .. t.file, "Joketorium")
    end
end



