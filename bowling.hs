module Bowling(Frame (..), score, validate) where

data Frame = Strike | Spare Int | Full Int Int | Partial Int (Maybe Int) | Tenth Int Int (Maybe Int)

-- Get the pins knocked down by the next bowl
nextBowlPins :: [Frame] -> Int
nextBowlPins [] = 0
nextBowlPins (Strike:_) = 10
nextBowlPins ((Spare x):_) = x
nextBowlPins ((Full x _):_) = x
nextBowlPins ((Partial x _):_) = x
nextBowlPins ((Tenth x _ _):_) = x

-- Get the pins knocked down by the next two bowls
nextTwoBowlPins :: [Frame] -> Int
nextTwoBowlPins [] = 0
nextTwoBowlPins (Strike:xs) = 10 + (nextBowlPins xs)
nextTwoBowlPins ((Spare _):_) = 10
nextTwoBowlPins ((Full x y):_) = x + y
nextTwoBowlPins ((Partial x Nothing):_) = x
nextTwoBowlPins ((Partial x (Just y)):_) = x + y
nextTwoBowlPins ((Tenth x y _):_) = x + y

-- Score a set of frames.
score :: [Frame] -> Int
score [] = 0
score (Strike:xs) = 10 + nextTwoBowlPins xs + score xs
score ((Spare _):xs) = 10 + nextBowlPins xs + score xs
score ((Full x y):xs) = x + y + score xs
score ((Partial x Nothing):xs) = x + score xs
score ((Partial x (Just y)):xs) = x + y + score xs
score ((Tenth x y Nothing):xs) = x + y + score xs
score ((Tenth x y (Just z)):xs) = x + y + z + score xs

-- Validate that a set of frames is valid in bowling.
validate :: [Frame] -> Maybe String
validate frames = validateInner frames 1

validateInner :: [Frame] -> Int -> Maybe String
validateInner [] _ = Nothing
validateInner _ 11 = Just "Too many frames"
validateInner (Strike:xs) frameNum =
    validateInner xs (frameNum + 1)
validateInner ((Spare x):xs) frameNum =
    if x > 9 then
        Just ("Spare in frame " ++ show frameNum ++ " must be less than 9, saw " ++ show x)
    else if x < 0 then
        Just ("Spare in frame " ++ show frameNum ++ " must be greater than 0, saw " ++ show x)
    else
        validateInner xs (frameNum + 1)
validateInner ((Full x y):xs) frameNum =
    if x < 0 || y < 0 then
        Just ("Full frame " ++ show frameNum ++ " must have non-negative values, saw " ++ show x ++ " and "  ++ show y)
    else if x + y > 9 then
        Just ("Full frame " ++ show frameNum ++ " must have fewer than 10 points, saw " ++ show x ++ " and "  ++ show y)
    else
        validateInner xs (frameNum + 1)
validateInner ((Partial x Nothing):xs) frameNum =
    if x > 9 then
        Just ("Partial in frame " ++ show frameNum ++ " must be less than 9, saw " ++ show x)
    else if x < 0 then
        Just ("Partial in frame " ++ show frameNum ++ " must be non-negative, saw " ++ show x)
    else
        validateInner xs (frameNum + 1)
validateInner ((Partial x (Just y)):xs) frameNum =
    if frameNum /= 10 then
        Just "Partial frame with 2 values can only be 10th frame"
    else if x < 0 || y < 0 then
        Just ("Partial 10th frame " ++ show frameNum ++ " must have non-negative values, saw " ++ show x ++ " and "  ++ show y)
    else if x + y > 10 then
        Just ("Partial 10th frame " ++ show frameNum ++ " must have fewer than 11 points, saw " ++ show x ++ " and "  ++ show y)
    else if length xs > 0 then
        Just "Partial frame must be the last frame of an in-progress game"
    else
        validateInner xs (frameNum + 1)
validateInner ((Tenth x y Nothing):xs) frameNum =
    if frameNum /= 10 then
        Just "Tenth frame must actually be the 10th frame in the set"
    else if x < 0 || y < 0 then
        Just ("Tenth frame " ++ show frameNum ++ " must have non-negative values, saw " ++ show x ++ " and "  ++ show y)
    else if x + y > 9 then
        Just ("Tenth frame " ++ show frameNum ++ " with no extra bowl must have fewer than 10 points, saw " ++ show x ++ " and "  ++ show y)
    else
        validateInner xs (frameNum + 1)
validateInner ((Tenth x y (Just z)):xs) frameNum =
    if frameNum /= 10 then
        Just "Tenth frame must actually be the 10th frame in the set"
    else if x /= 10 && x + y /= 10 then
        Just ("If there's a 3rd bowl in the 10th frame, there must be a strike or a spare earlier in the 10th, saw " ++ show x ++ " and " ++ show y)
    else if x > 10 || y > 10 || z > 10 then
        Just ("In the 10th frame, no bowl can be greater than 10, saw " ++ show x ++ " and " ++ show y ++ " and " ++ show z)
    else if x == 10 && y /= 10 && y + z > 10 then
        Just ("In the 10th frame, if the first bowl is a strike and the second bowl is not, then the second and third cannot be greater than 10, saw " ++ show x ++ " and " ++ show y ++ " and " ++ show z)
    else
        validateInner xs (frameNum + 1)

