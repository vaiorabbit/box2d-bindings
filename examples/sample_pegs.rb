require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'
require_relative 'util/sample_base'
require_relative 'util/sample_debugdraw'

class SamplePegs < SampleBase
  PEG_ROWS = 8
  PEG_COLS = 11
  PEG_SPACING_X = 2.4
  PEG_SPACING_Y = 2.6
  PEG_RADIUS = 0.35
  DISC_RADIUS = 0.6
  DISC_LIMIT = 120
  SPAWN_HEIGHT = 26.0
  FLOOR_Y = -28.0
  AUTO_SPAWN_FRAMES = 30

  def initialize(screenWidth, screenHeight, camera)
    super(screenWidth, screenHeight, camera)
    @board_body = Box2D::NULL_BODYID
    @disc_ids = []
    @auto_spawn_counter = 0
  end

  def setup
    super
    build_board
    build_pegs
    5.times { spawn_disc }
  end

  def cleanup
    @disc_ids.each do |bodyId|
      Box2D::DestroyBody(bodyId) if Box2D.id_non_null(bodyId)
    end
    @disc_ids.clear
    @board_body = Box2D::NULL_BODYID
    super
  end

  def step
    super
    handle_spawning
    prune_discs
  end

  private

  def build_board
    bodyDef = Box2D::DefaultBodyDef()
    @board_body = Box2D::CreateBody(@worldId, bodyDef)

    shapeDef = Box2D::DefaultShapeDef()

    floor = Box2D::MakeOffsetBox(15.0, 0.5, Box2D::Vec2.create_as(0.0, FLOOR_Y), Box2D::ROT_IDENTITY)
    Box2D::CreatePolygonShape(@board_body, shapeDef, floor)

    left_wall = Box2D::MakeOffsetBox(0.5, 18.0, Box2D::Vec2.create_as(-15.5, FLOOR_Y + 18.0), Box2D::ROT_IDENTITY)
    right_wall = Box2D::MakeOffsetBox(0.5, 18.0, Box2D::Vec2.create_as(15.5, FLOOR_Y + 18.0), Box2D::ROT_IDENTITY)
    Box2D::CreatePolygonShape(@board_body, shapeDef, left_wall)
    Box2D::CreatePolygonShape(@board_body, shapeDef, right_wall)

    6.times do |i|
      slot_center = -12.0 + i * 4.8
      divider = Box2D::MakeOffsetBox(0.25, 3.5, Box2D::Vec2.create_as(slot_center, FLOOR_Y + 3.5), Box2D::ROT_IDENTITY)
      Box2D::CreatePolygonShape(@board_body, shapeDef, divider)
    end
  end

  def build_pegs
    shapeDef = Box2D::DefaultShapeDef()
    start_x = -((PEG_COLS - 1) * PEG_SPACING_X) * 0.5
    start_y = 20.0

    PEG_ROWS.times do |row|
      row_y = start_y - row * PEG_SPACING_Y
      offset_x = (row.even? ? 0.0 : PEG_SPACING_X * 0.5)
      PEG_COLS.times do |col|
        peg_x = start_x + col * PEG_SPACING_X + offset_x
        circle = Box2D::Circle.create_as(Box2D::Vec2.create_as(peg_x, row_y), PEG_RADIUS)
        Box2D::CreateCircleShape(@board_body, shapeDef, circle)
      end
    end
  end

  def handle_spawning
    @auto_spawn_counter += 1
    if @auto_spawn_counter >= AUTO_SPAWN_FRAMES
      spawn_disc
      @auto_spawn_counter = 0
    end

    spawn_disc if Raylib.IsKeyPressed(Raylib::KEY_SPACE)

    return unless Raylib.IsMouseButtonPressed(Raylib::MOUSE_BUTTON_LEFT)

    world_pos = screen_to_world(Raylib.GetMousePosition())
    spawn_disc(world_pos.x)
  end

  def spawn_disc(spawn_x = nil)
    return if @disc_ids.length >= DISC_LIMIT

    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_dynamicBody
    bodyDef.position = Box2D::Vec2.create_as(spawn_x || Random.rand(-6.0..6.0), SPAWN_HEIGHT)

    shapeDef = Box2D::DefaultShapeDef()
    shapeDef.density = 1.4
    shapeDef.material.friction = 0.25
    shapeDef.material.restitution = 0.45

    circle = Box2D::Circle.create_as(Box2D::Vec2.create_as(0.0, 0.0), DISC_RADIUS)
    body_id = Box2D::CreateBody(@worldId, bodyDef)
    Box2D::CreateCircleShape(body_id, shapeDef, circle)

    @disc_ids << body_id
  end

  def prune_discs
    @disc_ids.reject! do |bodyId|
      next false unless Box2D.id_non_null(bodyId)

      y_pos = Box2D::Body_GetTransform(bodyId).p.y
      if y_pos < FLOOR_Y * 0.8
        Box2D::DestroyBody(bodyId)
        true
      else
        false
      end
    end
  end

  def screen_to_world(mouse_pos)
    scale = @debugDraw.get_scale
    world_x = (mouse_pos.x - @camera[:offset].x) / scale
    world_y = (@camera[:offset].y - @camera[:target].y - mouse_pos.y) / scale
    Box2D::Vec2.create_as(world_x, world_y)
  end
end

if __FILE__ == $PROGRAM_NAME
  version = Box2D::GetVersion()
  title = "Box2D Version #{version.major}.#{version.minor}.#{version.revision}"

  SetConfigFlags(FLAG_WINDOW_RESIZABLE)
  screenWidth = 1280
  screenHeight = 720
  InitWindow(screenWidth, screenHeight, title)

  target_y = -screenHeight / 4.0
  camera = Camera2D.new
                   .with_target(0, target_y)
                   .with_offset(screenWidth / 2.0, screenHeight / 2.0)
                   .with_rotation(0.0)
                   .with_zoom(1.0)
  SetTargetFPS(60)

  current_sample = SamplePegs.new(screenWidth, screenHeight, camera)
  current_sample.setup

  until WindowShouldClose()
    # rubocop:disable Layout/IndentationConsistency
    screenWidth = GetScreenWidth()
    screenHeight = GetScreenHeight()
    camera[:offset].set(screenWidth / 2.0, screenHeight / 2.0)
    target_y = -screenHeight / 4.0
    camera[:target].set(0, target_y)
    current_sample.set_screen_scale(20.0 * (screenWidth / 1280.0))

    current_sample.step

    BeginDrawing()
      ClearBackground(Raylib::BLACK)
      BeginMode2D(camera)
        current_sample.draw
        DrawFPS(screenWidth / 2 - 100, -screenHeight / 2 + 10 + target_y)
      EndMode2D()
    EndDrawing()
    # rubocop:enable Layout/IndentationConsistency
  end

  current_sample.cleanup
  CloseWindow()
end
