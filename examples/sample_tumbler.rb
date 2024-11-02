require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'

class SampleTumber
  def initialize
  end

  def setup
  end

  def cleanup
  end

  def step
  end

  def draw
  end
end

if __FILE__ == $PROGRAM_NAME
  version = Box2D::GetVersion()
  title = "Box2D Version #{version.major}.#{version.minor}.#{version.revision}"

  screenWidth = 800
  screenHeight = 450
  InitWindow(screenWidth, screenHeight, title)

  camera = Camera2D.new
             .with_target(0, 0)
             .with_offset(screenWidth / 2.0, screenHeight / 2.0)
             .with_rotation(0.0)
             .with_zoom(1.0)
  SetTargetFPS(60)

  until WindowShouldClose()

    # sample step

    BeginDrawing()
      ClearBackground(RAYWHITE)

      BeginMode2D(camera)
        DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY)
        DrawLine(camera.target.x.to_i, -screenHeight*10, camera.target.x.to_i, screenHeight*10, GREEN)
        DrawLine(-screenWidth*10, camera.target.y.to_i, screenWidth*10, camera.target.y.to_i, GREEN)
      EndMode2D()
    EndDrawing()
  end

  CloseWindow()
end
