def find_next_empty(puzzle):
    # finds the next row, col on the puzzle that's not filled yet ---> rep with -1
    # return row, col tuple (or (None, None) if there is none)
    
    #using 0-8 for our indices
    for r in range(9):
        for c in range(9):   #range(9) is 0, 1, 2, ... 8
            if puzzle[r][c] == -1:
                return r,c
    
    return None, None   #if there are no spaces left in the puzzle

def is_valid(puzzle, guess, row, col):
    # figures out whether the guess at the row/col of the puzzle is valdid guess
    # returns True if is valid, False otherwise

    #validating rows
    row_vals = puzzle[row]
    if guess in row_vals:
        return False
    
    #validating columns
    col_vals = [puzzle[i][col] for i in range(9) ]
    if guess in col_vals:
        return False
    
    #validating the 3x3 matrix
    row_start = (row // 3) * 3 #
    col_start = (col // 3) * 3

    for r in range(row_start, row_start + 3):
        for c in range(col_start, col_start + 3):
            if puzzle[r][c] == guess:
                return False
            
    #if we get here, these checks pass, and we can return True    
    return True

def solve_sudoku(puzzle):
    # solve sudoku using backtracking!
    # our puzzle is a list of lists, where each inner list is a row in our sudoku puzzle
    # return wheter a solution exists or not 
    # mutates puzzle to be the solution (if solution exists)

    # step 1: choose somewhere on the puzzle to make a guess
    row, col = find_next_empty(puzzle)

    # step 1.1: if there's nowhere left, then we're done because we only allowed valid inputs
    if row is None:
        return True
    
    # step 2: if there is a place to put a number, then make a guess beween 1 and 9
    for guess in range(1, 10):
        # step 3: check if this is a valid guess
        if is_valid(puzzle, guess, row, col):
            # step 3.1: if is valid, then place that guess on the puzzle
            puzzle[row][col] = guess
            # now recurse using this puzzle
            # step 4: recursively call our function
            if solve_sudoku(puzzle):
                return True
        
        # step 5: if not valid OR guess doesnt solve the sudoku, then we need to 
        # backtrack and try a new number
        
        puzzle[row][col] = -1 #reset the guess
    
    # step 6: if none of the numbers that we try work, then this puzzle is unsolvable
    return False

if __name__ == '__main__':
    example_board = [
        [-1, -1, -1, 3, -1, 5, -1, -1, 2],
        [3, -1, -1, -1, -1, -1, 8, 1, -1],
        [-1, -1, -1, -1, 9, -1, -1, -1, 7],

        [4, 2, -1, -1, 1, -1, -1, 8, 6],
        [-1, -1, 5, 6, -1, -1, 3, -1, 4],
        [-1, -1, -1, -1, -1, -1, -1, 7, -1],

        [-1, 3, 2, -1, 7, -1, -1, -1, -1],
        [7, 6, -1, -1, -1, -1, -1, -1, -1],
        [5, -1, 8, -1, 6, 2, -1, 4, -1]
    ]
    print(solve_sudoku(example_board))
    print(example_board)