module game
    use raylib
    implicit none
    
    private

    public :: board_size_cl
    integer, parameter :: board_size_cl = 4 ! On prend un carré 4x4 pour la grille
contains

    subroutine move_numbers(board, keypressed)
        integer, intent(inout) :: board(board_size_cl, board_size_cl)
        integer, intent(in) :: keypressed

        select case (keypressed)
        case (KEY_RIGHT)
            call update_board(board, 1, 0)
        case (KEY_LEFT)
            call update_board(board, -1, 0)
        case (KEY_DOWN)
            call update_board(board, 0, -1)
        case (KEY_UP)
            call update_board(board, 0, 1)
        end select
    end subroutine move_numbers

    subroutine update_board(board, x_shift, y_shift)
        integer, intent(inout) :: board(board_size_cl, board_size_cl)
        integer, intent(in) :: x_shift, y_shift
    end subroutine update_board
end module game