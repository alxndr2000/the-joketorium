SMODS.Joker {
	key = 'tikka_masala',
	loc_txt = {
		name = 'Tikka Masala',
		text = {
			"Gains {C:mult}+#2#{} Mult if",
			"poker hand is {C:attention}#4#{}",
			"loses a life if not {C:inactive}#3#/3{}",
			"{C:inactive}(Currently {C:mult}#1#{C:inactive} Mult)"
		}
	},
	-- This searches G.GAME.pool_flags to see if Gros Michel went extinct. If so, no longer shows up in the shop.
	no_pool_flag = 'tikka_used',
	config = { extra = { mult = 0, mult_gain = 2, rounds = 3 } },
	rarity = 1,
	atlas = 'joketorium',
	pos = { x = 0, y = 1 },
	cost = 5,
	-- kills itself so no eternal plz
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.mult, 
            card.ability.extra.mult_gain, 
            card.ability.extra.rounds,
     } }
	end,

	calculate = function(self, card, context)
		if context.joker_main then --- just give mult when we're chillin'
			return {
				mult = card.ability.extra.mult,
			}
		end

        if context.end_of_round and not context.blueprint and context.cardarea == G.jokers then -- select hand
            card.ability.extra.rounds = card.ability.extra.rounds-1
            if card.ability.extra.rounds<=0 then
                G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.states.drag.is = true
                            card.children.center.pinch.x = true
                            -- This part destroys the card.
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.3,
                                blockable = false,
                                func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                    return true;
                                end
                            }))
                            return true
                        end
                    }))
                -- set a global, i think they save
                G.GAME.pool_flags.tikka_used = true
                G.GAME.joketorium_curry = math.floor(card.ability.extra.mult/card.ability.extra.mult_gain)
                return {
                    message = "Eaten!"
                }
            else 
                return {
                    message = "Spicy!"
                }
            end
        end
        
		--- when hand played
		if context.selling_card then
            card.ability.extra.mult = card.ability.extra.mult+card.ability.extra.mult_gain
        end
	end
}


SMODS.Joker {
	key = 'vindaloo',
	loc_txt = {
		name = 'Vindaloo',
		text = {
			"Earn {C:money} $#1# {} at end of round",
            "({C:inactive}+1 for each Tikka Masala activation{})"
		}
	},
	-- This also searches G.GAME.pool_flags to see if Gros Michel went extinct. If so, enables the ability to show up in shop.
	yes_pool_flag = 'tikka_used',
	config = { extra = { Xmult = 0 } },
	rarity = 1,
	atlas = 'joketorium',
	pos = { x = 5, y = 0 },
	cost = 4,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
        if not G.GAME.joketorium_curry then
            G.GAME.joketorium_curry = 0
        end
		return { vars = { G.GAME.joketorium_curry } }
	end,
	calc_dollar_bonus = function(self, card)
        return G.GAME.joketorium_curry
	end
}