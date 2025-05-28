SMODS.ConsumableType {
	object_type = "ConsumableType",
	key = "Ciggys",
	primary_colour = HEX("e28743"),
	secondary_colour = HEX("eab676"),
	collection_rows = { 6, 5 },
	shop_rate = 0.0,
	loc_txt = {
 		name = 'Cigarette', -- used on card type badges
 		collection = 'Cigarettes', -- label for the button to access the collection
 		undiscovered = { -- description for undiscovered cards in the collection
 			name = 'Unsmoked',
 			text = { 'You\'ve not lit one of these yet' },
 		},
 	},
	default = "c_joketorium_cig_base",
}

SMODS.Booster { -- Program Pack, 1/2
	object_type = "Booster",
	key = "cig_pack_1",
	kind = "Ciggys",
    loc_txt = { name = 'Cig Pack', text = { 'Ciggy Time' } },
	atlas = "cigs",
	pos = { x = 0, y = 0 }, --TODO actual sprite
	config = { extra = 5, choose = 1 },
	cost = 4,
	weight = 1,
	create_card = function(self, card)
		return create_card("Ciggys", G.pack_cards, nil, nil, true, false)
	end,

	group_key = "k_joketorium_cig_pack",
}

--- Generates all the cigs, order matters for the sprites

local types = {
    {key = 'cig_uncommon', name = 'Uncommon Cigarette', tag_type = 'tag_uncommon', tag_fname = 'Uncommon Tag'},
    {key = 'cig_rare', name = 'Rare Cigarette', tag_type = 'tag_rare', tag_fname = 'Rare Tag'},
    {key = 'cig_negative', name = 'Negative Cigarette', tag_type = 'tag_negative', tag_fname = 'Negative Tag'},
    {key = 'cig_polychrome', name = 'Polychrome Cigarette', tag_type = 'tag_polychrome', tag_fname = 'Polychrome Tag'},
    {key = 'cig_investment', name = 'Investment Cigarette', tag_type = 'tag_investment', tag_fname = 'Investment Tag'},
    {key = 'cig_voucher', name = 'Voucher Cigarette', tag_type = 'tag_voucher', tag_fname = 'Voucher Tag'},
    {key = 'cig_reroll', name = 'Boss Reroll Cigarette', tag_type = 'tag_boss', tag_fname = 'Boss Reroll Tag'},
    {key = 'cig_ethereal', name = 'Ethereal Cigarette', tag_type = 'tag_ethereal', tag_fname = 'Ethereal Tag'},
    {key = 'cig_handy', name = 'Handy Cigarette', tag_type = 'tag_handy', tag_fname = 'Handy Tag'},
    {key = 'cig_garbage', name = 'Garbage Cigarette', tag_type = 'tag_garbage', tag_fname = 'Garbage Tag'},
    {key = 'cig_double', name = 'Double Cigarette', tag_type = 'tag_double', tag_fname = 'Double Tag'},
}

for i, t in ipairs(types) do
    SMODS.Consumable {
        key = t.key,
        set = 'Ciggys',
        loc_txt = {
            name = t.name,
            text = {
                "Creates A",
                "{C:attention}#2#{}",
            }
        },
        pools = {
            ["Ciggys"] = true
        },
        atlas = 'cigs',
        pos = {
            x = i, -- spritesheet effected here
            y = 0,
        },
        config = {
            extra = {
                tag_type = t.tag_type,
                tag_fname = t.tag_fname
            }
        },
        loc_vars = function(self, info_queue, card)
            return {
                vars = {card.ability.extra.tag_type, card.ability.extra.tag_fname}
            }
        end,
        cost = 3,
        can_use = function(self, card)
            return true
        end,
        use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.4,
                func = function()
                    play_sound("crumple5")
                    card:juice_up(0.3, 0.5)
                    add_tag(Tag(card.ability.extra.tag_type))
                    return true
                end,
            }))
        end,
    }
end

