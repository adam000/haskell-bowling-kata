import Test.Tasty (defaultMain, testGroup)
import Test.Tasty.HUnit (assertEqual, testCase)
import Bowling

main = defaultMain tests

tests = testGroup "Tests" [scoreTests, validateTests]

scoreTests =
    testGroup
        "Score Tests"
        [singleStrikeTest, doubleStrikeTest, turkeyTest,
        doubleSpareTest,
        tenthFrameNothingTest, tenthFrameJustTest,
        tenthFrameSpareNinthTest,
        allStrikesTest]

singleStrikeTest =
    testCase "One strike and a spare" $ assertEqual [] 30 (score [Strike, Spare 2])

doubleStrikeTest =
    testCase "A strike followed by a strike" $ assertEqual [] 49 (score [Strike, Strike, Full 5 2])

turkeyTest =
    testCase "A turkey" $ assertEqual [] 60 (score [Strike, Strike, Strike])

doubleSpareTest =
    testCase "Back-to-back spares" $ assertEqual [] 27 (score [Spare 1, Spare 7])

tenthFrameNothingTest =
    testCase "Tenth frame scores correctly when you whiff on the 10th" $ assertEqual [] 67 (score [Full 5 2, Full 8 1, Full 7 1, Full 8 1, Full 4 5, Full 1 1, Full 1 7, Full 2 5, Full 1 1, Tenth 1 5 Nothing])

tenthFrameJustTest =
    testCase "Tenth frame scores correctly when there's a spare in the 10th" $ assertEqual [] 74 (score [Full 5 2, Full 8 1, Full 7 1, Full 8 1, Full 4 5, Full 1 1, Full 1 7, Full 2 5, Full 1 1, Tenth 5 5 (Just 3)])

tenthFrameSpareNinthTest =
    testCase "Tenth frame scores correctly when there's a spare in the 9th" $ assertEqual [] 82 (score [Full 5 2, Full 8 1, Full 7 1, Full 8 1, Full 4 5, Full 1 1, Full 1 7, Full 2 5, Spare 7, Tenth 5 3 Nothing])

allStrikesTest =
    testCase "All strikes is a score of 300" $ assertEqual [] 300 (score [Strike, Strike, Strike, Strike, Strike, Strike, Strike, Strike, Strike, Tenth 10 10 (Just 10)])


validateTests =
    testGroup
        "Validate Tests"
        [validatePerfectGameTest, validateTooManyFramesTest]

validatePerfectGameTest =
    testCase "A perfect game" $ assertEqual [] Nothing (validate [Strike, Strike, Strike, Strike, Strike, Strike, Strike, Strike, Strike, Tenth 10 10 (Just 10)])

validateTooManyFramesTest =
    testCase "Too many frames" $ assertEqual [] (Just "Too many frames") (validate [Strike, Strike, Strike, Strike, Strike, Strike, Strike, Strike, Strike, Strike, Strike, Tenth 10 10 (Just 10)])
