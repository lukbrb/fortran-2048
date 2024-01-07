program main
  use iso_c_binding, only: c_null_char, c_int, c_int32_t, c_null_ptr
  use raylib
  use ui, only: render_board
  implicit none

  integer(kind=c_int) :: width, height, fps
  integer(c_int32_t) :: bleu
  integer :: board(4, 4)
  type(Font) :: game_font
  integer :: font_size = 128

  

  board = reshape([0, 0, 0, 0, &
           0, 2048, 0, 0, &
           0, 0, 0, 0, &
           0, 0, 0, 0], shape=[4, 4])

  width = 800
  height = 600
  fps = 60
  bleu = int(z'FFF17900', c_int32_t)

  call init_window(width, height, "FORTRAN 2048"// c_null_char)
  call set_target_fps(fps)

  game_font = load_font_ex("fonts/Alegreya-Regular.ttf"//C_NULL_CHAR, font_size, C_NULL_PTR, 0)
  do while(.not. window_should_close())
    call begin_drawing()
    call clear_background(bleu)
    call render_board(100., 150., 500., board, game_font)
    call end_drawing()
  end do
end program main
