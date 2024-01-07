module ui
    use iso_c_binding, only: c_int32_t, c_null_char, c_null_ptr
    use raylib
    use game, only: board_len
    implicit none
    
    private 
    public :: render_board
    real, parameter :: board_padding_rl = 0.03
    integer(c_int32_t), parameter :: cell_color = int(z'FF252525', c_int32_t)
    integer(c_int32_t), parameter :: GREEN = int(z'FF30E400', c_int32_t)
contains
    subroutine render_board(board_x_px, board_y_px, board_size_px, board, game_font)
        ! Note: _px signifie que les dimensions et tailles sont données en pixels 
        real, intent(in) :: board_x_px, board_y_px, board_size_px
        integer, intent(in) :: board(board_len, board_len)
        integer :: i, j, number
        real :: cell_size_px, x_px, y_px, s_px 
        type(Font), intent(in) :: game_font
       
        cell_size_px = board_size_px / board_len

        do i = 1, board_len
            do j = 1, board_len
                x_px = board_x_px + (i - 1) * cell_size_px + (cell_size_px*board_padding_rl)/2
                y_px = board_y_px + (j - 1) * cell_size_px + (cell_size_px*board_padding_rl)/2
                s_px = cell_size_px - (cell_size_px * board_padding_rl)

                if (board(i, j) == 0) then
                    call empty_cell(x_px, y_px, s_px, cell_color)
                else
                    ! number = board(i, j) * 2
                    call draw_number(x_px, y_px, s_px, number, game_font)
                end if
            end do
        end do
    end subroutine render_board

    subroutine empty_cell(x_px, y_px, s_px, color)
        real, intent(in) :: x_px, y_px, s_px
        integer(c_int32_t), intent(in) :: color

        call draw_rectangle_rounded(Rectangle(x_px, y_px, s_px, s_px), 0.1, 10, color)
    end subroutine empty_cell

    subroutine draw_number(x_px, y_px, s_px, number, game_font)
        real, intent(in) :: x_px, y_px, s_px
        integer, intent(in) :: number
        type(Font), intent(in) :: game_font
        type(Vector2) :: text_size, text_pos
        
        character(4) :: disp_number ! number displayed on screen, from integer 'number'

        write(disp_number,'(i4)') number
        text_size = measure_text_ex(game_font, disp_number//c_null_char, 0.0, 0.0)
        text_pos = Vector2([x_px, y_px])
        call draw_text_ex(game_font, disp_number//C_NULL_CHAR, text_pos, 0.0, 0.0, GREEN)
    end subroutine draw_number

end module ui