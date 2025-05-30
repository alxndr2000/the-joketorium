--- TODO Credit Score, Traffic Light, Very Unfortunate Joker

SMODS.Joker {
    key= 'viva',
    loc_txt = {
        name = 'Viva La Revolution',
        text = {
            "Earn {C:money}$#1#{} if a",
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
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.pre_joker or context.remove_playing_cards or context.buying_card or context.playing_card_added and not context.blueprint then
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