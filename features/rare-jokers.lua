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

SMODS.Joker {
    key = 'muse',
    loc_txt = {
        name = "Muse",
        text = {
            "After {C:attention}2{} rounds {C:attention}sell this card to",
            "Create {C:blue}Blueprint{} or {C:money}Brainstorm{}",
            "{C:inactive}(Currently {C:attention}#1#{}/2){C:inactive}"
        }
    },
    config = {
        extra = {
            count = 0
        }
    },
    rarity = 3,
    atlas = 'joketorium',
    blueprint_compat = false,
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { 
            vars = {card.ability.extra.count}
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round then
            if G.jokers then
                if context.cardarea == G.jokers then
                    card.ability.extra.count = card.ability.extra.count + 1
                end 
            end
        end
        if context.selling_card then 
            if context.card == card then 
                if card.ability.extra.count >= 2 then
                    local choice = math.random(1, 2)
                    local joker_to_spawn = (choice == 1) and "j_blueprint" or "j_brainstorm"
                    local new_joker = create_card('j_blueprint', G.jokers, nil, nil)
                    G.jokers:emplace(new_joker)
                end
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