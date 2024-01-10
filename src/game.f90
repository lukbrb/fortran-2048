module game
    use raylib
    implicit none
    
    private

    public :: board_size_cl, move_numbers
    integer, parameter :: board_size_cl = 4 ! On prend un carré 4x4 pour la grille
contains

    function compress(board) result(new_board)
        integer, intent(in) :: board(board_size_cl, board_size_cl)
        integer :: new_board(board_size_cl, board_size_cl)
        integer :: i, j, pos

        new_board = reshape([0, 0, 0, 0, &
                            0, 0, 0, 0, &
                            0, 0, 0, 0, &
                            0, 0, 0, 0], shape=[board_size_cl, board_size_cl])
        
        do j = 1, board_size_cl
            pos = 1
            do i = 1, board_size_cl
                if (board(i, j) /= 0) then
                    new_board(pos, j) = board(i, j)
                    pos = pos + 1
                end if
            end do
        end do
    end function compress

    subroutine merge(board)
        integer, intent(inout) :: board(board_size_cl, board_size_cl)
        integer :: i, j
    
        do j = 1, board_size_cl
            do i = 1, board_size_cl - 1
                if (board(i, j) == board(i+1, j) .and. board(i, j) /= 0) then
                    board(i, j) = board(i, j) + board(i, j)
                    board(i+1, j) = 0
                end if
            end do
        end do
    end subroutine merge

    function flip(array) result(farray)
        integer, intent(in) :: array(board_size_cl, board_size_cl)
        integer :: farray(4, 4)  ! tableau renversé selon un axe de symétrie vertical

        farray = array(board_size_cl:1:-1, :)
    end function flip

    subroutine move_numbers(board, keypressed)
        integer, intent(inout) :: board(board_size_cl, board_size_cl)
        integer, intent(in) :: keypressed

        select case (keypressed)
        case (KEY_LEFT)
            print *, "Gauche"
            board = compress(board)
            call merge(board)
            board = compress(board)
        case (KEY_RIGHT)
            print *, "Droit"
            board = flip(board)
            board = compress(board)
            call merge(board)
            board = compress(board)
            board = flip(board)
        case (KEY_DOWN)
            print *, "Bas"
            board = transpose(board)
            board = flip(board)
            board = compress(board)
            call merge(board)
            board = compress(board)
            board = flip(board)
            board = transpose(board)
        case (KEY_UP)
            print *, "Haut"
            board = transpose(board)
            board = compress(board)
            call merge(board)
            board = compress(board)
            board = transpose(board)
        end select
    end subroutine move_numbers

end module game