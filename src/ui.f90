module ui
    use iso_c_binding, only: c_int32_t, c_null_char, c_null_ptr
    use raylib
    use game, only: board_size_cl
    implicit none
    
    ! integer(c_int32_t), parameter :: cell_color = int(z'FF252525', c_int32_t)
    type(color_type),   parameter :: CELL_COLOR = color_type(37, 37, 37, 255)
    ! integer(c_int32_t), parameter :: BLEU = int(z'FFF17900', c_int32_t)
    type(color_type),   parameter :: BLEU = color_type(0, 121, 241, 255)
    ! integer(c_int32_t), parameter :: GREEN = int(z'FF30E400', c_int32_t)
    ! integer(c_int32_t), parameter :: WHITE = int(z'FFFFFFFF', c_int32_t)
    type(color_type),   parameter :: WHITE = color_type(255, 255, 255, 255)
    ! integer(c_int32_t), parameter :: CLR_2 = int(z'FFEEE4DA', c_int32_t)
    type(color_type),   parameter :: CLR_2 = color_type(238, 228, 218, 255)

    ! integer(c_int32_t), parameter :: CLR_4 = int(z'FFEDE0C8', c_int32_t)
    type(color_type),   parameter :: CLR_4 = color_type(237, 224, 200, 255)

    ! integer(c_int32_t), parameter :: CLR_8 = int(z'FFF2B179', c_int32_t)
    type(color_type),   parameter :: CLR_8 = color_type(242, 177, 121, 255)

    ! integer(c_int32_t), parameter :: CLR_16 = int(z'FFF59563', c_int32_t)
    type(color_type),   parameter :: CLR_16 = color_type(245, 149, 99, 255)

    ! integer(c_int32_t), parameter :: CLR_32 = int(z'FFF67C5F', c_int32_t)
    type(color_type),   parameter :: CLR_32 = color_type(246, 124, 95, 255)

    ! integer(c_int32_t), parameter :: CLR_64 = int(z'FFF65E3B', c_int32_t)
    type(color_type),   parameter :: CLR_64 = color_type(246, 94, 59, 255)

    ! integer(c_int32_t), parameter :: CLR_128 = int(z'FFEDCF72', c_int32_t)
    type(color_type),   parameter :: CLR_128 = color_type(237, 207, 114, 255)

    ! integer(c_int32_t), parameter :: CLR_256 = int(z'FFEDCC61', c_int32_t)
    type(color_type),   parameter :: CLR_256 = color_type(237, 204, 97, 255)

    ! integer(c_int32_t), parameter :: CLR_512 = int(z'FFEDC850', c_int32_t)
    type(color_type),   parameter :: CLR_512 = color_type(237, 200, 80, 255)

    ! integer(c_int32_t), parameter :: CLR_1024 = int(z'FFEDC53F', c_int32_t)
    type(color_type),   parameter :: CLR_1024 = color_type(237, 197, 63, 255)

    ! integer(c_int32_t), parameter :: CLR_2048 = int(z'FFEDC22E', c_int32_t)
    type(color_type),   parameter :: CLR_2048 = color_type(237, 194, 46, 255)

    ! integer(c_int32_t), parameter :: CLR_SUPERTILE = int(z'FF3C3A32', c_int32_t)
    type(color_type),   parameter :: CLR_SUPERTILE = color_type(128,0,128, 255)


    integer(c_int),     parameter :: screen_factor           = 120
    integer(c_int),     parameter :: screen_width_px         = 16*screen_factor
    integer(c_int),     parameter :: screen_height_px        = 9*screen_factor
    real,               parameter :: board_padding_rl        = 0.03
    real,               parameter :: board_margin_rl         = 0.10

    integer :: i
    integer, dimension(11), parameter :: nums = [(2**i, i=1, 11)]
    type(color_type), dimension(11), parameter :: clrs = [CLR_2, CLR_4, CLR_8, CLR_16, CLR_32, CLR_64, CLR_128, &
                                                            CLR_256, CLR_512, CLR_1024, CLR_2048]

    real :: screen_scale = 1, screen_offset_x = 0, screen_offset_y = 0
contains
    subroutine render_board(board_x_px, board_y_px, board_size_px, board)
        ! Note: _px signifie que les dimensions et tailles sont données en pixels 
        real, intent(in) :: board_x_px, board_y_px, board_size_px
        integer, intent(in) :: board(board_size_cl, board_size_cl)
        integer :: i, j
        real :: cell_size_px, x_px, y_px, s_px 
        ! type(Font), intent(in) :: game_font
       
        cell_size_px = board_size_px / board_size_cl

        do i = 1, board_size_cl
            do j = 1, board_size_cl
                x_px = board_x_px + (i - 1) * cell_size_px + (cell_size_px*board_padding_rl)/2
                y_px = board_y_px + (j - 1) * cell_size_px + (cell_size_px*board_padding_rl)/2
                s_px = cell_size_px - (cell_size_px * board_padding_rl)

                if (board(i, j) == 0) then
                    call empty_cell(x_px, y_px, s_px, CELL_COLOR)
                else
                    call draw_number(x_px, y_px, s_px, board(i, j))
                end if
            end do
        end do
    end subroutine render_board

    subroutine empty_cell(x_px, y_px, s_px, color)
        real, intent(in) :: x_px, y_px, s_px
        type(color_type) :: color

        call draw_rectangle_rounded(Rectangle(x_px, y_px, s_px, s_px), 0.15, 10, color)
    end subroutine empty_cell

    subroutine draw_number(x_px, y_px, s_px, number)
        real, intent(in) :: x_px, y_px, s_px
        integer, intent(in) :: number
        integer :: text_size_px
        type(color_type) :: color
        ! type(Font), intent(in) :: game_font
        ! type(Vector2) :: text_size, text_pos
        character(4) :: disp_number ! number displayed on screen, from integer 'number'

        color = get_color(number)

        ! x_px = x_px + 0.5 * s_px
        ! y_px = y_px + 0.5 * s_px
        write(disp_number,'(i4)') number
        text_size_px = measure_text(disp_number//c_null_char, 50)
        ! text_size = measure_text_ex(game_font, disp_number//c_null_char, 100., 0.0)
        ! text_pos = Vector2([x_px, y_px])
        call empty_cell(x_px, y_px, s_px, color)
        call draw_text(disp_number//C_NULL_CHAR, int(x_px + 0.5 * (s_px-text_size_px), c_int), &
                        int(y_px + 0.5 * s_px, c_int), 50, WHITE)
    end subroutine draw_number

    subroutine begin_screen_fitting()
        type(Camera2D) :: camera
        real :: rw, rh

        rw = real(get_render_width())
        rh = real(get_render_height())
        screen_scale = rw / real(screen_width_px)
        if (rh < screen_height_px * screen_scale) then
            screen_scale = rh / real(screen_height_px)
        end if

        screen_offset_x = 0.5 * rw - screen_width_px * screen_scale * 0.5
        screen_offset_y = 0.5 * rh - screen_height_px * screen_scale * 0.5

        camera%target = Vector2([0, 0])
        camera%rotation = 0
        camera%offset = Vector2([screen_offset_x, screen_offset_y])
        camera%zoom = screen_scale
        call begin_mode_2d(camera)
    end subroutine begin_screen_fitting

    subroutine end_screen_fitting()
        call end_mode_2d()
    end subroutine end_screen_fitting


    pure function get_color(num) result(color)
        integer, intent(in) :: num
        type(color_type) :: color
        integer :: num_idx ! où la couleur est dans le tableau

        num_idx = findloc(nums, num, dim=1)
        if (num_idx == 0) then
        color = CLR_SUPERTILE
        else
        color = clrs(num_idx)
        end if
    end function get_color
end module ui