--- Main Lua File

--------------------------------------------------------------------------------
---                                 ATLASES                                  ---
--------------------------------------------------------------------------------
SMODS.Atlas { -- Jokers
    key = "joketorium",
    path = "joketorium.png",
    px = 71,
    py = 95
}

--------------------------------------------------------------------------------
---                                 JOKERS                                   ---
--------------------------------------------------------------------------------
SMODS.Joker {
    key= 'vivalarevolution',
    loc_txt = {
        name = 'Viva La Revolution',
        text = {
            "Earn {C:money}#1#{} if a",
            "King or Queen is destroyed"
        }
    },
    config = {
        extra = {
            money = 5
        }
    },
    rarity = 2,
    atlas = 'joketorium',
    blueprint_compat = true,
    pos = {
        x = 2,
        y = 0
    },
    cost = 7,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.money} 
        }
    end,
    
    calculate = function(self, card, context)
        if context.remove_playing_cards then
            local count = 0
            for i, removed_card in ipairs(context.removed) do
                if removed_card.base.value == "King" or removed_card.base.value == "Queen" then
                    count = count + 1
                    --     G.E_MANAGER:add_event(Event({
                --     trigger = "after",
                --     delay = 0.4,
                --     func = function()
                --         play_sound("crumple5")
                --         card:juice_up(0.3, 0.5)
                --         add_tag(Tag(card.ability.extra.tag_type))
                --         return true
                --     end,
                -- }))
                end
            end
            return {
                dollars=card.ability.extra.money * count,
                message_card = removed_card
            }
        end
    end
}

-- Needs calc update scoring
SMODS.Joker {
    key = 'gigabrain',
    loc_txt = {
        name = "Gigabrain",
        text = {
            "Gains {X:mult,C:white}X#2#{} Mult",
            "for each face card in deck",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)"
        }
    },
    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.1
        }
    },
    rarity = 2,
    atlas = 'joketorium',
    blueprint_compat = true,
    pos = {
        x = 3,
        y = 0
    },
    cost = 8,
    loc_vars = function(self, info_queue, card)
        -- if not G.deck then
            return {
            vars = {
                card.ability.extra.xmult,
                card.ability.extra.xmult_gain           
            } }
        -- }
        -- end
        -- local count = 0
        -- for _, deck_card in ipairs(G.hand.cards) do
        --     if deck_card.base.value == "King" or deck_card.base.value == "Queen" or deck_card.base.value == "Jack" then
        --         count = count + 1
        --     end
        -- end
        -- for _, deck_card in ipairs(G.play.cards) do
        --     if deck_card.base.value == "King" or deck_card.base.value == "Queen" or deck_card.base.value == "Jack" then
        --         count = count + 1
        --     end
        -- end
        -- for _, deck_card in ipairs(G.discard.cards) do
        --     if deck_card.base.value == "King" or deck_card.base.value == "Queen" or deck_card.base.value == "Jack" then
        --         count = count + 1
        --     end
        -- end
        -- for _, deck_card in ipairs(G.deck.cards) do
        --     if deck_card.base.value == "King" or deck_card.base.value == "Queen" or deck_card.base.value == "Jack" then
        --         count = count + 1
        --     end
        -- end

        -- local current_mult = card.ability.extra.xmult + (card.ability.extra.xmult_gain * count)
        -- vars = {
        --         card.ability.extra.xmult,
        --         card.ability.extra.xmult_gain           
        --     }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.remove_playing_cards  or context.buying_card or context.playing_card_added then
            local count = 0
            for _, deck_card in ipairs(G.hand.cards) do
                if deck_card.base.value == "King" or deck_card.base.value == "Queen" or deck_card.base.value == "Jack" then
                    count = count + 1
                end
            end
            for _, deck_card in ipairs(G.play.cards) do
                if deck_card.base.value == "King" or deck_card.base.value == "Queen" or deck_card.base.value == "Jack" then
                    count = count + 1
                end
            end
            for _, deck_card in ipairs(G.discard.cards) do
                if deck_card.base.value == "King" or deck_card.base.value == "Queen" or deck_card.base.value == "Jack" then
                    count = count + 1
                end
            end
            for _, deck_card in ipairs(G.deck.cards) do
                if deck_card.base.value == "King" or deck_card.base.value == "Queen" or deck_card.base.value == "Jack" then
                    count = count + 1
                end
            end
            card.ability.extra.xmult = 1+(card.ability.extra.xmult_gain * count)
        end
    end            
}

SMODS.Joker { -- Jackpot
    key = 'jackpot',
    loc_txt = {
        name = 'Jackpot',
        text = {
			"Gains {X:mult,C:white}X#2#{} Mult",
			"if played hand", 
			"contains 3 or more {C:attention}7s{}",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)"
		}
    },
    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.25
        }
    },
    rarity = 2,
    atlas = 'joketorium',
    blueprint_compat = true,
    pos = {
        x = 1,
        y = 0
    },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.xmult_gain}
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.before and not context.blueprint then
            local seven_count = 0

            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].base.value == "7" then
                    seven_count = seven_count + 1
                end
            end
            if seven_count >= 3 then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = 'Upgraded!',
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker { -- Evil Trading Card
    key = 'eviltradingcard',
    loc_txt = {
        name = 'Evil Trading Card',
        text = {
			"If {C:attention}first hand{} of round has",
			"only {C:attention}1{} card, destroy every other",
            "card and earn {C:money}$#1#{} for", "each card destroyed"
		}
    },
    config = {
        extra = {
            money = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.money}
        }
    end,
    rarity = 3,
    atlas = 'joketorium',
    blueprint_compat = false,
    pos = {
        x = 0,
        y = 0
    },
    cost = 7,
    calculate = function(self, card, context)
        if context.destroy_card and not context.blueprint then
            if context.cardarea == G.hand
            and context.destroy_card ~= context.full_hand[1]
            and #context.full_hand == 1
            and G.GAME.current_round.hands_played == 0
            then
                return {
                    remove = true,
                    dollars = card.ability.extra.money,
                    message_card = context.destroy_card
                }
            end
        end
    end
}



--------------------------------------------------------------------------------
---                                  CIGS                                    ---
--------------------------------------------------------------------------------

SMODS.Atlas { 
    key = "cigs",
    path = "cigs.png",
    px = 71,
    py = 95
}

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
            x = i,
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

