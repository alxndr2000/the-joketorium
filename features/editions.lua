SMODS.Enhancement {
    key = "ancient",
    atlas = 'joketorium',
    pos = {
        x = 2,
        y = 1
    },
    loc_txt = {
        name = "Ancient Card",
        text = {
            "{C:green}#1# in #2#{} chance",
            "for a random {C:tarot}Tarot{} card",
            "{C:green}#1# in #3#{} chance",
            "for a random {C:spectral}Spectral{} card",
            "Cannot create both",
        }
    },
    loc_vars = function(self, info, card)
        return {vars = {
            (G.GAME.probabilities.normal or 1),
            card.ability.extra.tarot_chance,
            card.ability.extra.spectral_chance,
     } }
    end,
    config = {
        extra = {
            tarot_chance = 5,
            spectral_chance = 20
        }
    },
    weight = 0,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            print(G.GAME.probabilities.normal/card.ability.extra.tarot_chance)
            print(pseudorandom('ancient_tarot'))
            if not (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) then
                return -- no card spawn
            end
            
            if (pseudorandom('ancient_tarot') < G.GAME.probabilities.normal/card.ability.extra.tarot_chance) then
                -- spawn tarot and return so we can't double spawn
                
                return {
                    message = '+Tarot',
                    colour = G.C.TAROT,
                    func = function()
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'before',
                                    delay = 0.0,
                                    func = (function()
                                            SMODS.add_card({set = 'Tarot'})
                                        return true
                                    end)}))
                                end,
                }
                
            end
            if (pseudorandom('ancient_spectral') < G.GAME.probabilities.normal/card.ability.extra.spectral_chance) then
                -- spawn spectral and return
                SMODS.add_card({set = 'Spectral'})
                return {
                    message = '+Spectral',
                    colour = G.C.SPECTRAL,
                    func = function()
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'before',
                                    delay = 0.0,
                                    func = (function()
                                            SMODS.add_card({set = 'Spectral'})
                                        return true
                                    end)}))
                                end,
                }
            end
        end
    end,
}