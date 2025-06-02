SMODS.Joker {
	key = 'traffic_light',
	loc_txt = {
		name = 'Traffic Light',
		text = {
			"Earn {C:money}$#3#{} at end of round ", 
			"if last hand was played",
			"while the light is {C:green}green{}",
			"Earn {E:2,C:red}$#2#{} if the light was {C:red}red{}"
		}
	},
	-- This also searches G.GAME.pool_flags to see if Gros Michel went extinct. If so, enables the ability to show up in shop.
	config = { extra = { stage = 0, r_money = -5, g_money = 10 } },
	rarity = 1,
	atlas = 'trafficlight',
	pos = { x = 0, y = 0 },
	cost = 4,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.stage, card.ability.extra.r_money, card.ability.extra.g_money,  } }
	end,

	calculate = function(self, card, context)
		if context.after 
		and context.cardarea == G.jokers 
		and not context.blueprint
		and not context.repetition then
			card.ability.extra.stage = card.ability.extra.stage + 1
			if card.ability.extra.stage >= 3 then
            	card.ability.extra.stage = 0
        	end
        	card.children.center:set_sprite_pos({x= card.ability.extra.stage, y= 0})
		end
	end,

	calc_dollar_bonus = function(self, card)
		if card.ability.extra.stage == 0 then -- just went to red from green
			return card.ability.extra.g_money
		end
		if card.ability.extra.stage == 1 then -- just went from red to yellow
			return card.ability.extra.r_money
		end
	end
}