module raylib
    use iso_c_binding 
    implicit none
    
    integer, parameter :: c_unsigned_int  = c_int
    integer, parameter :: c_unsigned_char = c_signed_char
    
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


    enum, bind(C)
        enumerator :: BUTTON_UNPRESSED = 0
        enumerator :: BUTTON_HOVER
        enumerator :: BUTTON_HOLD
    end enum

    ! Emprunté à fortran-raylib : https://github.com/interkosmos/fortran-raylib
    type, bind(c), public :: color_type
        integer(kind=c_unsigned_char) :: r = 0_c_unsigned_int
        integer(kind=c_unsigned_char) :: g = 0_c_unsigned_int
        integer(kind=c_unsigned_char) :: b = 0_c_unsigned_int
        integer(kind=c_unsigned_char) :: a = 255_c_unsigned_int
    end type color_type

    type :: Button_Style
        type(color_type) :: color
        real :: hover, hold
     end type Button_Style

    type(color_type), parameter :: BLACK = color_type(0, 0, 0, 255)
    type(color_type), parameter :: WHITE = color_type(255, 255, 255, 255)
    type(color_type), parameter :: BLEU = color_type(0, 121, 241, 255)
    integer(c_int32_t), parameter :: MOUSE_BUTTON_LEFT = 0

    interface
    
    subroutine init_window(width,height,title) bind(C, name="InitWindow")
      import :: c_char, c_int
      integer(c_int),value :: width
      integer(c_int),value :: height
      character(kind=c_char) :: title(*)
    end subroutine init_window

    subroutine close_window() bind(C, name="CloseWindow")
    end subroutine close_window
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
        import :: c_int32_t, color_type
        ! integer(c_int32_t), value :: color
        type(color_type), value :: color
    end subroutine clear_background

    logical(c_bool) function window_should_close() bind(C, name="WindowShouldClose")
        import :: c_bool
    end function window_should_close

    subroutine draw_rectangle_rounded(rec, roundness, segments, color) bind(C, name="DrawRectangleRounded")
        import :: c_float, c_int, c_int32_t, Rectangle, color_type
        type(Rectangle), value :: rec
        real(c_float), value :: roundness
        integer(c_int), value :: segments
        type(color_type), value :: color
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
        import :: c_char, c_float, c_int32_t, c_int, color_type
        character(kind=c_char)   :: text(*)
        integer(c_int), value     :: posX, posY, font_size
        type(color_type), value :: color
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

    type(color_type) function color_brightness(color, factor) bind(C, name="ColorBrightness")
        import :: c_float, color_type
        type(color_type), value :: color
        real(c_float), value :: factor
    end function color_brightness

    type(Vector2) function get_mouse_position() bind(C, name="GetMousePosition")
        import :: Vector2
    end function get_mouse_position

    logical(c_bool) function check_collision_point_rect(point, rec) bind(C, name="CheckCollisionPointRec")
        import :: Vector2, Rectangle, c_bool
        type(Vector2), value :: point
        type(Rectangle), value :: rec
    end function check_collision_point_rect

    logical(c_bool) function is_mouse_button_pressed(button) bind(C, name="IsMouseButtonPressed")
    import :: c_int, c_bool
    integer(c_int),value :: button
  end function is_mouse_button_pressed

  logical(c_bool) function is_mouse_button_down(button) bind(C, name="IsMouseButtonDown")
    import :: c_int, c_bool
    integer(c_int),value :: button
  end function is_mouse_button_down

  logical(c_bool) function is_mouse_button_released(button) bind(C, name="IsMouseButtonReleased")
    import :: c_int, c_bool
    integer(c_int),value :: button
  end function is_mouse_button_released

    end interface
end module raylib