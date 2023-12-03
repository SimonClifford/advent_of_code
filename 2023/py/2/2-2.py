from collections import defaultdict
import fileinput
import re

def main():
    '''
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

	In game 1, the game could have been played with as few as 4 red, 2 green,
	and 6 blue cubes. If any color had even one fewer cube, the game would have
	been impossible.  Game 2 could have been played with a minimum of 1 red, 3
	green, and 4 blue cubes.
    Game 3 must have been played with at least 20 red, 13 green, and 6 blue cubes.
    Game 4 required at least 14 red, 3 green, and 15 blue cubes.
    Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.

	The power of a set of cubes is equal to the numbers of red, green, and blue
	cubes multiplied together. The power of the minimum set of cubes in game 1 is
	48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up these
	five powers produces the sum 2286.
    '''
    total = 0
    game_match = re.compile(r'Game (\d+): (.*)\n?')
    for line in fileinput.input():
        cubes = defaultdict(int)
        (game_id_s, the_rest) = game_match.match(line).groups()
        for show in the_rest.split('; '):
            for pair in show.split(', '):
                number, colour = pair.split()
                number = int(number)
                if number > cubes[colour]:
                    cubes[colour] = number
        power = 1
        for min_value in cubes.values():
            power *= min_value
        total += power

    print(total)

if __name__ == '__main__':
    main()
