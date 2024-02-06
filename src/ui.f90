module ui
    use iso_c_binding, only: c_int32_t, c_null_char, c_null_ptr
    use raylib
    use game, only: board_size_cl
    implicit none
    
    type(color_type),   parameter :: CELL_COLOR = color_type(187, 173, 160, 255)
    type(color_type),   parameter :: restart_button_color = color_type(238, 238, 238, 255)
    type(color_type),   parameter :: CLR_2 = color_type(238, 228, 218, 255)
    type(color_type),   parameter :: CLR_4 = color_type(237, 224, 200, 255)
    type(color_type),   parameter :: CLR_8 = color_type(242, 177, 121, 255)
    type(color_type),   parameter :: CLR_16 = color_type(245, 149, 99, 255)
    type(color_type),   parameter :: CLR_32 = color_type(246, 124, 95, 255)
    type(color_type),   parameter :: CLR_64 = color_type(246, 94, 59, 255)
    type(color_type),   parameter :: CLR_128 = color_type(237, 207, 114, 255)
    type(color_type),   parameter :: CLR_256 = color_type(237, 204, 97, 255)
    type(color_type),   parameter :: CLR_512 = color_type(237, 200, 80, 255)
    type(color_type),   parameter :: CLR_1024 = color_type(237, 197, 63, 255)
    type(color_type),   parameter :: CLR_2048 = color_type(237, 194, 46, 255)
    type(color_type),   parameter :: CLR_SUPERTILE = color_type(128, 0, 128, 255)
    type(color_type),   parameter :: BG_COLOR = color_type(249, 246, 242, 255)
    type(color_type),   parameter :: SCORE_CONTAINER_CLR = color_type(119, 110, 101, 240)
    type(color_type),   parameter :: GRID_BG_COLOR = color_type(119, 110, 101, 255)


    integer(c_int),     parameter :: screen_factor           = 80
    integer(c_int),     parameter :: screen_width_px         = 16*screen_factor
    integer(c_int),     parameter :: screen_height_px        = 9*screen_factor
    integer(c_int),     parameter :: grid_margin             = 10
    real,               parameter :: board_padding_rl        = 0.03
    real,               parameter :: board_margin_rl         = 0.10
    real,               parameter :: restart_button_width_rl = 0.3
    integer,            parameter :: fontsize_cells          = 50
    integer,            parameter :: fontsize_score          = 50
    integer,            parameter :: restart_button_id       = board_size_cl*board_size_cl + 1
    type(Button_Style), parameter :: restart_button_style = Button_Style( &
                                            color = restart_button_color, &
                                            hover = -0.10, &
                                            hold = -0.15)
    integer :: l
    integer, dimension(11), parameter :: nums = [(2**l, l=1, 11)]
    type(color_type), dimension(11), parameter :: clrs = [CLR_2, CLR_4, CLR_8, CLR_16, CLR_32, CLR_64, CLR_128, &
                                                            CLR_256, CLR_512, CLR_1024, CLR_2048]

    real :: screen_scale = 1, screen_offset_x = 0, screen_offset_y = 0
contains

    subroutine render_board(board_x_px, board_y_px, board_size_px, board)
        ! Note: _px signifie que les dimensions et tailles sont données en pixels 
        real, intent(in) :: board_x_px, board_y_px, board_size_px
        integer, intent(in) :: board(board_size_cl, board_size_cl)
        integer :: i, j
        logical :: button_clicked
        real :: cell_size_px, x_px, y_px, s_px 
        ! type(Font), intent(in) :: game_font
       
        cell_size_px = board_size_px / board_size_cl
        x_px = board_x_px + (cell_size_px*board_padding_rl)/2
        y_px = board_y_px - 0.5 * cell_size_px + (cell_size_px*board_padding_rl)/2
        s_px = cell_size_px - (cell_size_px * board_padding_rl)

        button_clicked = restart_button(x_px, y_px, s_px)
        ! Carré derrière la grille de jeu
        call draw_rectangle_rounded(Rectangle(board_x_px-grid_margin, board_y_px + 0.5*cell_size_px-grid_margin, &
                                    board_size_px+2*grid_margin, board_size_px+2*grid_margin),&
                                    0.05, 10, GRID_BG_COLOR)
        do i = 1, board_size_cl
            do j = 1, board_size_cl
                x_px = board_x_px + (i - 1) * cell_size_px + (cell_size_px*board_padding_rl)/2
                y_px = board_y_px + (j - 0.5) * cell_size_px + (cell_size_px*board_padding_rl)/2
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
        text_size_px = measure_text(disp_number//c_null_char, fontsize_cells)
        ! text_size = measure_text_ex(game_font, disp_number//c_null_char, 100., 0.0)
        ! text_pos = Vector2([x_px, y_px])
        call empty_cell(x_px, y_px, s_px, color)
        call draw_text(disp_number//C_NULL_CHAR, int(x_px +(s_px/2-text_size_px/2), c_int), &
                        int(y_px + s_px/2 - fontsize_cells/2, c_int), fontsize_cells, WHITE)
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

    function restart_button(board_x_px, board_y_px, board_size_px) result(clicked)
        real,       intent(in) :: board_x_px, board_y_px, board_size_px
        logical :: clicked
        type(Rectangle) :: rec
    
        rec%width = board_size_px*restart_button_width_rl
        rec%height = rec%width*0.4
        rec%x = board_x_px + board_size_px/2 - rec%width/2
        rec%y = board_y_px + board_size_px/2 - rec%height/2
    
        clicked = button(restart_button_id, rec, restart_button_style)
    
        call draw_text("Rejouer"//C_NULL_CHAR, int(rec%x), int(rec%y), 10, WHITE)
      end function restart_button

      function button(id,boundary,style) result(clicked)
        integer,            intent(in) :: id
        type(Rectangle),    intent(in) :: boundary
        type(Button_Style), intent(in) :: style
        logical :: clicked
        integer :: state

        ! clicked = button_logic(id, boundary, state)
        state = BUTTON_HOVER
        select case (state)
        case (BUTTON_UNPRESSED)
            call draw_rectangle_rounded(boundary, 0.10, 10, style%color)
        case (BUTTON_HOVER)
            call draw_rectangle_rounded(boundary, 0.10, 10, color_brightness(style%color, style%hover))
        case (BUTTON_HOLD)
            call draw_rectangle_rounded(boundary, 0.10, 10, color_brightness(style%color, style%hold))
        end select
      end function button

    !   function button_logic(id, boundary, state) result(clicked)
    !     integer,         intent(in)  :: id
    !     type(Rectangle), intent(in)  :: boundary
    !     integer,         intent(out) :: state
    !     logical :: clicked
    
    !     clicked = .false.
    !     state = BUTTON_UNPRESSED
    !     if (active_button_id == 0) then
    !         if (check_collision_point_rect(get_mouse_position(), boundary)) then
    !             if (is_mouse_button_down(MOUSE_BUTTON_LEFT)) then
    !             state = BUTTON_HOLD
    !             active_button_id = id
    !             else
    !             state = BUTTON_HOVER
    !             end if
    !         else
    !             state = BUTTON_UNPRESSED
    !         end if
    !     else if (active_button_id == id) then
    !         if (is_mouse_button_released(MOUSE_BUTTON_LEFT)) then
    !             clicked = check_collision_point_rect(get_mouse_position(), boundary)
    !             active_button_id = 0
    !             state = BUTTON_UNPRESSED
    !         else
    !             state = BUTTON_HOLD
    !         end if
    !     else
    !         ! TODO: handle the situation when the active button was not rendered on mouse release
    !         ! If on mouse release the active button was not rendering, it may softlock the whole system
    !         state = BUTTON_UNPRESSED
    !     end if
    ! end function button_logic

    subroutine display_score(score, x_px, y_px, s_px, color, color_text)
        integer, intent(in) :: score
        real, intent(in) :: x_px, y_px, s_px
        type(color_type), intent(in) :: color, color_text
        character(7) :: disp_number
        integer :: text_size_px

        write(disp_number,'(i7)') score
        text_size_px = measure_text(disp_number//c_null_char, fontsize_score)
        call draw_rectangle_rounded(Rectangle(x_px, y_px, 2*s_px, s_px), 0.15, 10, color)
        call draw_text(disp_number//C_NULL_CHAR, int(x_px + s_px/2 - text_size_px/2, c_int), &
                                                 int(y_px + s_px/2 - fontsize_score/2, c_int), fontsize_score, color_text)
    
    end subroutine display_score

    subroutine display_score_boxes(score, record, board_x_px, board_y_px, board_size_px)
        integer, intent(in) :: score, record
        real, intent(in) :: board_x_px, board_y_px, board_size_px
        ! type(color_type), intent(in) :: color, color_text
        integer :: i
        real :: box_size_px, x_px, y_px, s_px 

        box_size_px = board_size_px/board_size_cl * 2/3
        i = 3
        x_px = board_x_px + (i - 1) * box_size_px + (box_size_px*board_padding_rl)/2
        y_px = board_y_px - 0.5 * box_size_px + (box_size_px*board_padding_rl)/2
        s_px = box_size_px - (box_size_px * board_padding_rl)
        call display_score(score, x_px, y_px, s_px, SCORE_CONTAINER_CLR, CELL_COLOR)
        i = 5
        x_px = board_x_px + (i - 1) * box_size_px + (box_size_px*board_padding_rl)/2
        y_px = board_y_px - 0.5 * box_size_px + (box_size_px*board_padding_rl)/2
        s_px = box_size_px - (box_size_px * board_padding_rl)
        call display_score(record, x_px, y_px, s_px, SCORE_CONTAINER_CLR, CELL_COLOR)

    end subroutine display_score_boxes
end module ui