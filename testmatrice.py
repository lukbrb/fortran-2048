import numpy as np

lenboard = 4
board = np.reshape([0, 0, 0, 2,
                    0, 2, 0, 0,
                    4, 0, 0, 2,
                    0, 2, 0, 0], newshape=[4, 4])

print(board)

# def stack(row):
#     for i in range(lenboard):
#         newindex_i = i + 1
#         if newindex_i == lenboard or newindex_i < 0: continue
#         if row[newindex_i] == 0:
#             row[newindex_i] = row[i]
#             row[i] = 0
#     return row

def compress(board):
    new_board = np.zeros_like(board)
    for i in range(4):
        pos = 0
        for j in range(4):
            if board[i, j] != 0:
                new_board[i, pos] = board[i, j]
                pos += 1
    return new_board

def merge(board):
    for i in range(4):
        for j in range(3):
            if board[i, j] == board[i, j+1] and board[i, j] != 0:
                board[i, j] += board[i, j]
                board[i, j+1] = 0
    return board

# def merge(row):
#     for i in range(lenboard):
#         newindex_i = i + 1
#         if newindex_i == lenboard or newindex_i < 0: continue

#         if row[newindex_i] == row[i]:
#             row[newindex_i] = 2 * row[i]
#             row[i] = 0
#     return row


# def merge_row_backward(row):
#     for i in range(lenboard - 1, -1, -1):
#         newindex_i = i - 1
#         if newindex_i == lenboard or newindex_i < 0: continue
#         if row[newindex_i] == 0:
#             row[newindex_i] = row[i]
#             row[i] = 0
#         elif row[newindex_i] == row[i]:
#             row[newindex_i] = 2 * row[i]
#             row[i] = 0
#     return row
# row = board[:, 1]

def move(board, dir):
    print(dir)
    if dir == "left":
        board = compress(board)
        board = merge(board)
        board = compress(board)

    elif dir == "right":
        board = np.flip(board, axis=1)
        board = compress(board)
        board = merge(board)
        board = np.flip(compress(board), axis=1)

    elif dir == "down":
        board = np.flip(board.T, axis=1)
        board = compress(board)
        board = merge(board)
        board = np.flip(compress(board), axis=1).T

    elif dir == "up":
        board = board.T
        board= compress(board)
        board= merge(board)
        board = compress(board).T
    else:
        print("Should be unreachable")
    return board

sep = 10 * '-'
print(sep)

board = move(board, "up")
print(board)
print(sep)

board = move(board, "left")
print(board)
print(sep)

board = move(board, "down")
print(board)
print(sep)

board = move(board, "right")
print(board)
# i = 0
# for item in row:
#     if i + 1 > lenboard: continue


#     pass
