class TicTacToe:
    def __init__(self): 
        self.board = [' ' for _ in range (9)] #using a single list to rep 3x3 board
        self.current_winner = None #Keep track of winner!

    def print_board(self):
        for row in [self.board[i*3:(i+1)*3] for i in range(3)]:
            print('|  ' + ' | '.join(row)+ '  |')

    @staticmethod
    def print_board_nums():
        pass