program main
  use iso_c_binding, only: c_null_char, c_int, c_int32_t, c_null_ptr, c_float
  use raylib
  use ui
  use game
  use iofiles

  implicit none

  integer(kind=c_int) :: width, height, fps
  real(c_float) :: dt
  integer :: board(board_size_cl, board_size_cl)
  integer(c_int) :: keypressed
  real    :: board_x_px, board_y_px, board_boundary_width, board_boundary_height, board_size_px, cell_size_px
  logical :: can_board_move = .true.
  logical :: restart_the_game = .false.
  integer :: score_record, score_actuel
  character(15) :: path = "record.txt"
  
  score_record = read_file(path)
  score_actuel = 0

  width = screen_width_px
  height = screen_height_px
  fps = 60
  
  board = init_board()
  call init_window(width, height, "FORTRAN 2048"// c_null_char)
  call set_target_fps(fps)

  do while(.not. window_should_close())
    call begin_drawing()
      call begin_screen_fitting()
      call clear_background(BG_COLOR)
      dt = get_frame_time()
      keypressed = get_key_pressed()

      board_boundary_width  = screen_width_px 
      board_boundary_height = screen_height_px * 0.95

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
      score_record = get_record(score_actuel, score_record)
      call render_board(board_x_px, board_y_px, board_size_px, board, restart_the_game)
      call display_score_boxes(score_actuel, score_record, board_x_px, board_y_px, &
                               board_size_px)

      if (keypressed /= 0) then
        can_board_move = board_moved(board, keypressed)
        if (can_board_move) then
          call move_numbers(board, keypressed)
          call add_number_to_board(board)
        end if
 
        if (game_won(board)) then
          call display_game_win()
        end if
      end if

      if (game_over(board)) then
        call display_game_over(restart_the_game)
      end if
     
      if (restart_the_game) then
        board = init_board()
        restart_the_game = .false.
        call write_file(get_record(score_record, get_score(board)), path) ! Le score doit être écrit aussi si la partie est recommencée
      end if
      call end_screen_fitting()
    call end_drawing()
  end do
  print *, "Fermeture de la fenêtre. Écriture des résultats..."
  call close_window()
  call write_file(get_record(score_record, get_score(board)), path)
end program main
