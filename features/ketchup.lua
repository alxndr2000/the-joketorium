SMODS.Joker { --- Ketchup Bottle
	key = 'ketchup_bottle',
	loc_txt = {
		name = 'Ketchup Bottle',
		text = {
			"Gains {C:mult}+#2#{} Mult if",
			"poker hand is {C:attention}#4#{}",
			"loses a life if not {C:inactive}#3#/3{}",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	-- This searches G.GAME.pool_flags to see if Gros Michel went extinct. If so, no longer shows up in the shop.
	no_pool_flag = 'ketchup_bottle_used',
	config = { extra = { mult = 0, mult_gain = 2, lives = 3, req_hand='High Card' } },
	rarity = 1,
	atlas = 'joketorium',
	pos = { x = 4, y = 0 },
	cost = 5,
	-- kills itself so no eternal plz
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.mult, 
            card.ability.extra.mult_gain, 
            card.ability.extra.lives,
            card.ability.extra.req_hand,
     } }
	end,

	calculate = function(self, card, context)
		if context.joker_main then --- just give mult when we're chillin'
			return {
				mult = card.ability.extra.mult,
			}
		end

        if context.end_of_round and not context.blueprint and context.cardarea == G.jokers then -- select hand
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible and k ~= card.ability.req_hand then _poker_hands[#_poker_hands+1] = k end
            end
            card.ability.extra.req_hand = pseudorandom_element(_poker_hands, pseudoseed('to_do'))
            print(card.ability.extra.req_hand)
            return {
                message = localize('k_reset')
            }
        end
        
		--- when hand played
		if context.before and 
        not context.blueprint and
        not context.repetition and
        context.cardarea == G.jokers
        then
            print(context.scoring_name)
            print(card.ability.extra.req_hand)
			if context.scoring_name == card.ability.extra.req_hand then -- if we played the right hand
                card.ability.extra.mult = card.ability.extra.mult+card.ability.extra.mult_gain
            
                return {
                    message = "+" .. card.ability.extra.mult_gain .. " mult",
                    color = G.C.MULT
                }
            else
                card.ability.extra.lives = card.ability.extra.lives-1
                if card.ability.extra.lives<=0 then 
                    -- Sets the pool flag to true, meaning Gros Michel 2 doesn't spawn, and Cavendish 2 does.
                    G.GAME.pool_flags.ketchup_bottle_used = true
                    -- This part plays the animation.
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
                    G.GAME.joketorium_ketchup = math.floor(card.ability.extra.mult/card.ability.extra.mult_gain)
                    return {
                        message = "Drank!"
                    }
                else
                    return {
                        message = "Thirsty?"
                    }
                end
            end
        end
	end
}



SMODS.Joker { --- Empty Ketchup Bottle
	key = 'empty_ketchup_bottle',
	loc_txt = {
		name = 'Empty Ketchup Bottle',
		text = {
			"{X:mult,C:white} X#1# {} Mult",
            "({C:inactive}+1 for each ketchup activation{})"
		}
	},
	-- This also searches G.GAME.pool_flags to see if Gros Michel went extinct. If so, enables the ability to show up in shop.
	yes_pool_flag = 'ketchup_bottle_used',
	config = { extra = { Xmult = 0 } },
	rarity = 1,
	atlas = 'joketorium',
	pos = { x = 5, y = 0 },
	cost = 4,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
        if not G.GAME.joketorium_ketchup then
            G.GAME.joketorium_ketchup = 0
        end
		return { vars = { G.GAME.joketorium_ketchup } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = G.GAME.joketorium_ketchup
			}
		end
	end
}