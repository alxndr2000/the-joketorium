--- run with 
--- eval Balatest.run_tests()
--- in the debugplus console
Balatest.TestPlay {
    name = 'base_test_case',
    requires = {},
    category = 'base_test',

    jokers = { 'j_joker' }, -- Start with a Joker
    
    execute = function()
        Balatest.play_hand { '2S' } -- Play a High Card
    end,
    assert = function()
        Balatest.assert_chips(35) -- Total round score, *not* the last hand
    end
}