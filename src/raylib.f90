module raylib
    use iso_c_binding, only: c_char, c_int, c_bool, c_int32_t, c_float, c_ptr
    implicit none
    
    ! Raylib cheatsheet: https://www.raylib.com/cheatsheet/cheatsheet.html
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

    type, bind(C) :: Camera2D
        type(Vector2) :: offset, target
        real(c_float) :: rotation, zoom
    end type Camera2D

    enum, bind(C)
        enumerator :: KEY_RIGHT = 262
        enumerator :: KEY_LEFT
        enumerator :: KEY_DOWN
        enumerator :: KEY_UP
    end enum
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

    real(c_float) function get_frame_time() bind(C, name="GetFrameTime")
        import :: c_float
    end function get_frame_time
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

    subroutine draw_text(text, posX, posY, font_size, color) bind(C, name="DrawText")
        import :: c_char, c_float, c_int32_t, c_int
        character(kind=c_char)   :: text(*)
        integer(c_int), value     :: posX, posY, font_size
        integer(c_int32_t), value :: color
      end subroutine draw_text
      
    integer(c_int) function get_render_width() bind(C, name="GetRenderWidth")
        import :: c_int
    end function get_render_width

    integer(c_int) function get_render_height() bind(C, name="GetRenderHeight")
        import :: c_int
    end function get_render_height

    subroutine begin_mode_2d(camera) bind(C, name="BeginMode2D")
        import :: Camera2D
        type(Camera2D),value :: camera
    end subroutine begin_mode_2d
      ! RLAPI void EndMode2D(void);                                       // Ends 2D mode with custom camera
    subroutine end_mode_2d() bind(C, name="EndMode2D")
    end subroutine end_mode_2d

    integer(c_int) function measure_text(text, font_size) bind(C, name="MeasureText")
        import :: c_int, c_char
        character(kind=c_char) :: text(*)
        integer(c_int), value  :: font_size
    end function measure_text

    ! bool IsKeyDown(int key);
    logical(c_bool) function is_key_down(key) bind(C, name="IsKeyDown")
    import :: c_int, c_bool
        integer(c_int), value :: key
    end function is_key_down

    ! int GetKeyPressed(void);   
    integer(c_int) function get_key_pressed() bind(C, name="GetKeyPressed")
        import :: c_int
    end function get_key_pressed

    end interface
end module raylib