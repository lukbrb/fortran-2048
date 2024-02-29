module iofiles
    implicit none
    
contains
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
end module iofiles