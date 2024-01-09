import numpy as np

lenboard = 4
board = np.reshape([0, 0, 0, 0,
           0, 2, 0, 0,
           0, 0, 0, 2,
           0, 2, 0, 0], newshape=[4, 4])

print(board)

def merge_row_forward(row):
    for i in range(lenboard):
        newindex_i = i + 1
        if newindex_i == lenboard or newindex_i < 0: continue
        if row[newindex_i] == 0:
            row[newindex_i] = row[i]
            row[i] = 0
        elif row[newindex_i] == row[i]:
            row[newindex_i] = 2 * row[i]
            row[i] = 0
    return row

def merge_row_backward(row):
    for i in range(lenboard - 1, -1, -1):
        
        newindex_i = i - 1
        if newindex_i == lenboard or newindex_i < 0: continue
        if row[newindex_i] == 0:
            row[newindex_i] = row[i]
            row[i] = 0
        elif row[newindex_i] == row[i]:
            row[newindex_i] = 2 * row[i]
            row[i] = 0
    return row
# row = board[:, 1]
def move(board, dir):
    if dir == "up":
        for j in range(lenboard):
            board[:, j] = merge_row_backward(board[:, j])
    elif dir == "down":
        for j in range(lenboard):
            board[:, j] = merge_row_forward(board[:, j])
    elif dir == "right":
        for j in range(lenboard):
            board[j, :] = merge_row_forward(board[j, :])
    elif dir == "left":
        for j in range(lenboard):
            board[j, :] = merge_row_backward(board[j, :])
    return board

sep = 10 * '-'
board = move(board, "left")
print(sep)

print(board)
print(sep)
board = move(board, "up")
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
