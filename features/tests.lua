--- run with 
--- eval Balatest.run_tests()
--- in the debugplus console

Balatest.TestPlay {
    name = 'viva_test_destroy',
    category = 'uncommon_test',

    jokers = { 'j_joketorium_viva' }, -- Start with a Joker
    consumeables = { 'c_hanged_man', 'c_hanged_man' }, -- two hung men
    
    execute = function()
        Balatest.highlight {'KH', 'QD'} -- should add money
        Balatest.use(G.consumeables.cards[1])
        Balatest.highlight {'JH', '3D'} -- shouldn't add money
        Balatest.use(G.consumeables.cards[1])
    end,
    assert = function()
        Balatest.assert_eq(G.GAME.dollars, 10) -- we should have 10 bucks
    end
}

Balatest.TestPlay {
    name = 'gigabrain_xmult_base',
    category = 'uncommon_test',

    jokers = { 'j_joketorium_gigabrain' }, -- Start with a Joker
    
    execute = function()
        Balatest.play_hand {'2S'} -- scores 15?
    end,
    assert = function()
        Balatest.assert_chips(15) -- we should have 10 bucks
    end
}

Balatest.TestPlay {
    name = 'gigabrain_remove',
    category = 'uncommon_test',
    consumeables = { 'c_hanged_man'},
    jokers = { 'j_joketorium_gigabrain' }, -- Start with a Joker
    
    execute = function()
        Balatest.highlight {'KH', 'QH'}
        Balatest.use(G.consumeables.cards[1])
        Balatest.play_hand {'2S'}
    end,
    assert = function()
        Balatest.assert_chips(14)
    end
}
Balatest.TestPlay {
    name = 'gigabrain_add',
    category = 'uncommon_test',
    consumeables = { 'c_cryptid'},
    jokers = { 'j_joketorium_gigabrain' }, -- Start with a Joker
    
    execute = function()
        Balatest.highlight {'KH'}
        Balatest.use(G.consumeables.cards[1])
        Balatest.unhighlight_all() -- cryptid leaves selected
        Balatest.play_hand {'2S'}
    end,
    assert = function()
        Balatest.assert_chips(16) -- we should have 10 bucks
    end
}