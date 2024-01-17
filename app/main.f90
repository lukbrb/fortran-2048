program main
  use iso_c_binding, only: c_null_char, c_int, c_int32_t, c_null_ptr, c_float
  use raylib
  use ui
  use game, only: move_numbers, add_number_to_board, game_won, board_moved, get_score, game_over, &
                  get_record, read_file, write_file

  implicit none

  integer(kind=c_int) :: width, height, fps
  real(c_float) :: dt
  integer :: board(4, 4)
  integer(c_int) :: keypressed
  real    :: board_x_px, board_y_px, board_boundary_width, board_boundary_height, board_size_px, cell_size_px
  logical :: can_board_move = .true.
  logical :: clicked
  integer :: score_record, score_actuel
  character(15) :: path = "record.txt"
  
  score_record = read_file(path)
  score_actuel = 0

  board = reshape([0, 0, 0, 0,&
                   0, 0, 0, 0,&
                   0, 0, 0, 0,&
                   0, 0, 0, 0], shape=[4, 4])

  width = 16*80
  height = 9*80
  fps = 60
  

  call init_window(width, height, "FORTRAN 2048"// c_null_char)
  call set_target_fps(fps)

  call add_number_to_board(board)
  ! game_font = load_font_ex("fonts/Alegreya-Regular.ttf"//C_NULL_CHAR, font_size, C_NULL_PTR, 0)
  do while(.not. window_should_close())
    call begin_drawing()
      call begin_screen_fitting()
      call clear_background(BLEU)
      dt = get_frame_time()
      keypressed = get_key_pressed()

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
      score_actuel = get_score(board)
      call render_board(board_x_px, board_y_px, board_size_px, board)
      call display_score(score_actuel, board_boundary_width, 50., 100., WHITE, CELL_COLOR)
      call display_score(get_record(score_record, score_actuel), board_boundary_width + 250., 50., 100., WHITE, CELL_COLOR)


      if (keypressed /= 0) then
        can_board_move = board_moved(board, keypressed)
        if (can_board_move) then
          call move_numbers(board, keypressed)
          call add_number_to_board(board)
        end if

        if (game_over(board)) then
          print *, "Game over"
        end if
        if (game_won(board)) then
          print *, "Gagné, bravo !"
        end if
      end if
      
      call end_screen_fitting()
    call end_drawing()
  end do
  print *, "Fermeture de la fenêtre. Écriture des résultats..."
  call write_file(get_record(score_record, get_score(board)), path)
end program main
