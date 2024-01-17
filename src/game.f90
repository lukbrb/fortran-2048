module game
    use raylib
    implicit none
    
    private

    public :: board_size_cl, move_numbers, add_number_to_board, game_over, game_won, &
              get_score, board_moved, get_record, read_file, write_file
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

    logical function board_moved(board, direction) result(moved)
        integer, intent(in) :: board(board_size_cl, board_size_cl)
        integer, intent(in) :: direction
        integer :: test_board(board_size_cl, board_size_cl)

        test_board = board
        ! essayer de bouger la matrice dans chaqure direction, et voir si elle change ou non
        ! Si ne change pas, alors aucun mouv possible et c'est perdu

        call move_numbers(test_board, direction)

        if (all(test_board == board)) then
            moved = .false.
        else
            moved = .true.
        end if
    end function board_moved

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
            board = compress(board)
            call merge(board)
            board = compress(board)
        case (KEY_RIGHT)
            board = flip(board)
            board = compress(board)
            call merge(board)
            board = compress(board)
            board = flip(board)
        case (KEY_DOWN)
            board = transpose(board)
            board = flip(board)
            board = compress(board)
            call merge(board)
            board = compress(board)
            board = flip(board)
            board = transpose(board)
        case (KEY_UP)
            board = transpose(board)
            board = compress(board)
            call merge(board)
            board = compress(board)
            board = transpose(board)
        end select
    end subroutine move_numbers

    integer function rand_int(a, b) result (j)
        integer, intent(in) :: a, b
        real :: u

        call random_number(u)
        j = a + floor((b+1 - a) * u)
    end function rand_int

    subroutine add_number_to_board(board)
        integer, intent(inout) :: board(board_size_cl, board_size_cl)
        integer :: rand_i, rand_j, rand_k, counter
        logical :: placed
        integer, dimension(10) :: new_num

        new_num = [2, 2, 2, 4, 2, 2, 2, 2, 2, 2] ! on veut des 2 90% du temps
        counter = 1
        placed = .false.
        if (.not. any(board == 0)) then
            print *, "Impossible d'ajouter un nombre"
            return
        end if
        do while (.not. placed .and. counter < board_size_cl**2)
            print *, "While loop"
            rand_i = rand_int(1, board_size_cl)
            rand_j = rand_int(1, board_size_cl)
            rand_k = rand_int(1, 10)

            if (board(rand_i, rand_j) == 0) then
                board(rand_i, rand_j) = new_num(rand_k)
                ! print *, "New number", new_num(rand_k),  "added at", "(i=", rand_i, ",", rand_j, ")"
                ! write(*, '(4(I4))') board
                placed = .true.
                counter = counter + 1
            end if
        end do

        if (counter == board_size_cl**2) then
            print *, "La partie est perdu ?"
        end if
    end subroutine add_number_to_board

    logical function game_won(board)
        integer, intent(in) :: board(board_size_cl, board_size_cl)

        game_won = any(board == 2048)
    end function game_won

    logical function game_over(board)
        integer, intent(in) :: board(board_size_cl, board_size_cl)
        integer :: test_board(board_size_cl, board_size_cl)

        test_board = board
        ! essayer de bouger la matrice dans chaque direction, et voir si elle change ou non
        ! Si ne change pas, alors aucun mouv possible et c'est perdu

        call move_numbers(test_board, KEY_LEFT)
        call move_numbers(test_board, KEY_UP)
        call move_numbers(test_board, KEY_RIGHT)
        call move_numbers(test_board, KEY_DOWN)

        if (all(test_board == board)) then
            game_over = .true.
        else
            game_over = .false.
        end if
    end function game_over

    pure function get_score(board) result(score)
        integer, intent(in) :: board(board_size_cl, board_size_cl)
        integer :: score

        score = sum(board)
    end function get_score

    pure function get_record(current_score, record_score) result(record)
        integer, intent(in) :: current_score, record_score
        integer :: record

        if (current_score < record_score) then
            record = record_score
        else 
            record = current_score
        end if
    end function get_record

    integer function read_file(path) result(score)
        character(*), intent(in) :: path
        character(514) :: errmsg
        integer :: stat, io
        logical :: exists

        
        inquire(file=path, exist=exists)

        if (exists) then
            open(newunit=io, file=path, status="old", action="read", iostat=stat, iomsg=errmsg)

            if (stat /= 0) then
                score = 0
                print *, errmsg
            else
                read(io, *) score
                close(io)
            end if
        else
            score = 0
        end if
    end function read_file

    subroutine write_file(score, path)
        character(*), intent(in) :: path
        integer, intent(in) :: score
        character(514) :: errmsg
        integer :: stat, io

        open(newunit=io, file=path, status="replace", action="write", iostat=stat, iomsg=errmsg)

        if (stat /= 0) then
            print *, errmsg
        else
            write(io, *) score
            close(io)
        end if
    end subroutine write_file
end module game