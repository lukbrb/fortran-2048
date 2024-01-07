module raylib
    use iso_c_binding, only: c_char, c_int, c_bool, c_int32_t, c_float, c_ptr
    implicit none
    
    type, bind(C) :: Rectangle
        real(c_float) :: x, y, width, height
    end type Rectangle

    type, bind(C) :: Vector2
        real(c_float) :: array(2)
    end type Vector2

    type, bind(C) :: Texture
        integer(c_int) :: id, width, height, mipmap, format
    end type Texture

    type, bind(C) :: Font
        integer(c_int) :: baseSize, glyphCount, glyphPadding
        type(c_ptr) :: recs, glyps
        type(Texture) :: texture
    end type Font

    interface

    subroutine init_window(width,height,title) bind(C, name="InitWindow")
      import :: c_char, c_int
      integer(c_int),value :: width
      integer(c_int),value :: height
      character(kind=c_char) :: title(*)
    end subroutine init_window

    subroutine set_target_fps(fps) bind(C, name="SetTargetFPS")
      import :: c_int
      integer(c_int),value :: fps
    end subroutine set_target_fps

    subroutine begin_drawing() bind(C, name="BeginDrawing")
    end subroutine begin_drawing

    subroutine end_drawing() bind(C, name="EndDrawing")
    end subroutine end_drawing

    subroutine clear_background(color) bind(C, name="ClearBackground")
        import :: c_int32_t
        integer(c_int32_t), value :: color
    end subroutine clear_background

    logical(c_bool) function window_should_close() bind(C, name="WindowShouldClose")
        import :: c_bool
    end function window_should_close

    subroutine draw_rectangle_rounded(rec, roundness, segments, color) bind(C, name="DrawRectangleRounded")
        import :: c_float, c_int, c_int32_t, Rectangle
        type(Rectangle), value :: rec
        real(c_float), value :: roundness
        integer(c_int), value :: segments
        integer(c_int32_t), value :: color
      end subroutine draw_rectangle_rounded

    ! RLAPI Vector2 MeasureTextEx(Font font, const char *text, float fontSize, float spacing);    // Measure string size for Font
    type(Vector2) function measure_text_ex(text_font, text, fontSize, spacing) bind(C, name="MeasureTextEx")
        import :: Vector2, Font, c_char, c_float
        type(Font), value :: text_font
        character(kind=c_char) :: text(*)
        real(c_float), value :: fontSize, spacing
    end function measure_text_ex

    subroutine draw_text_ex(text_font, text, position, fontSize, spacing, tint) bind(C, name="DrawTextEx")
        import :: Font, Vector2, c_char, c_float, c_int32_t
        type(Font), value         :: text_font
        character(kind=c_char)   :: text(*)
        type(Vector2), value      :: position
        real(c_float), value      :: fontSize, spacing
        integer(c_int32_t), value :: tint
      end subroutine draw_text_ex

    type(Font) function load_font_ex(fileName, fontSize, fontChars, glyphCount) bind(C, name="LoadFontEx")
      import :: Font, c_char, c_int, c_ptr
      character(kind=c_char) :: fileName
      integer(c_int), value  :: fontSize
      type(c_ptr), value     :: fontChars
      integer(c_int), value  :: glyphCount
    end function load_font_ex

    end interface
end module raylib