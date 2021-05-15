import Bowling

main :: IO ()
main = putStrLn ("Example score: " ++ (show (score [Strike, Strike, Full 5 2])))
