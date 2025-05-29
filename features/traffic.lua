SMODS.Joker {
	key = 'traffic_light',
	loc_txt = {
		name = 'Traffic Light',
		text = {
			"Not Implimented",
		}
	},
	-- This also searches G.GAME.pool_flags to see if Gros Michel went extinct. If so, enables the ability to show up in shop.
	config = { extra = { count = 0.0, stage = 0 } },
	rarity = 1,
	atlas = 'trafficlight',
	pos = { x = 0, y = 0 },
	cost = 4,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.count, card.ability.extra.stage } }
	end,
	update = function(self, card, dt)
        card.ability.extra.count = card.ability.extra.count+dt
        if card.ability.extra.count > 10 then
            card.ability.extra.stage = card.ability.extra.stage+1
            card.ability.extra.count = 0
            
        end
        if card.ability.extra.stage >= 3 then
            card.ability.extra.stage = 0
        end
        card.children.center:set_sprite_pos({x= card.ability.extra.stage, y= 0})
	end
}