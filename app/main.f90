program main
  use iso_c_binding, only: c_null_char, c_int, c_int32_t, c_null_ptr, c_float
  use raylib
  use ui
  implicit none

  integer(kind=c_int) :: width, height, fps
  integer(c_int32_t) :: bleu
  real(c_float) :: dt
  integer :: board(4, 4)

  integer :: font_size = 128
  real    :: board_x_px, board_y_px, board_boundary_width, board_boundary_height, board_size_px, cell_size_px
  
  board = reshape([0, 0, 0, 0, &
           0, 2048, 0, 0, &
           0, 0, 0, 0, &
           0, 0, 0, 0], shape=[4, 4])

  width = 16*80
  height = 9*80
  fps = 60
  bleu = int(z'FFF17900', c_int32_t)

  call init_window(width, height, "FORTRAN 2048"// c_null_char)
  call set_target_fps(fps)

  ! game_font = load_font_ex("fonts/Alegreya-Regular.ttf"//C_NULL_CHAR, font_size, C_NULL_PTR, 0)
  do while(.not. window_should_close())
    call begin_drawing()
      call begin_screen_fitting()
      call clear_background(bleu)
      dt = get_frame_time()
      board_boundary_width  = screen_width_px * 2/3
      board_boundary_height = screen_height_px

      if (board_boundary_width > board_boundary_height) then
         board_size_px = board_boundary_height
         board_x_px = real(board_boundary_width)/2 - board_size_px/2
         board_y_px = 0
      else
         board_size_px = board_boundary_width
         board_x_px = 0
         board_y_px = real(board_boundary_height)/2 - board_size_px/2
      end if

      board_x_px = board_x_px + board_size_px*board_margin_rl
      board_y_px = board_y_px + board_size_px*board_margin_rl
      board_size_px = board_size_px - board_size_px*board_margin_rl*2

      cell_size_px = board_size_px/board_size_cl

      call render_board(board_x_px, board_y_px, board_size_px, board)

      call end_screen_fitting()
    call end_drawing()
  end do
end program main
