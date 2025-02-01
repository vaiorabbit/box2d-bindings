require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'
require_relative 'util/sample_base'
require_relative 'util/sample_debugdraw'

CATEGORY_GROUND = 0x00000001
CATEGORY_ATTACHED_TO_MOUSE = 0x00000002
CATEGORY_DETATCHED_FROM_MOUSE = 0x00000004
CATEGORY_ALL = 0xFFFFFFFF

class Shape
  attr_reader :is_spawned, :body_id, :is_attached_to_mouse

  def initialize
    @body_id = nil # Box2D::BodyId.new
    @shape_ids = [] # Box2D::ShapeId.new

    @is_spawned = false
    @is_attached_to_mouse = true
  end

  def get_transform_y
    Box2D.Body_GetTransform(@body_id).p.y
  end

  def get_transform
    return Box2D.Body_GetTransform(@body_id)
  end

  def set_transform(transform)
    Box2D.Body_SetTransform(@body_id, transform.p, transform.q)
  end

  def launch
    @shape_ids.each do |shape_id|
      filter = Box2D.Shape_GetFilter(shape_id)
      filter.categoryBits = CATEGORY_DETATCHED_FROM_MOUSE
      filter.maskBits &= ~CATEGORY_ATTACHED_TO_MOUSE
      filter.maskBits |= CATEGORY_DETATCHED_FROM_MOUSE
      Box2D.Shape_SetFilter(shape_id, filter)
    end

    Box2D.Body_SetType(@body_id, Box2D::BodyType_dynamicBody)
    Box2D.Body_SetAwake(@body_id, true)
    @is_attached_to_mouse = false
  end

  def spawn(worldId, position, scale)
    return if @is_spawned

    radius = 1.0 * scale

    center = Box2D::Vec2.create_as(position.x, position.y)

    bodyDef = Box2D.DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_kinematicBody # Box2D::BodyType_dynamicBody

    shapeDef = Box2D.DefaultShapeDef()
    shapeDef.density = 1.0
    shapeDef.filter.groupIndex = -0
    shapeDef.filter.categoryBits = CATEGORY_ATTACHED_TO_MOUSE
    shapeDef.filter.maskBits = CATEGORY_GROUND | CATEGORY_ATTACHED_TO_MOUSE
    shapeDef.friction = 0.3

    bodyDef.position = Box2D::Vec2.create_as(center.x, center.y)
    bodyDef.rotation = Box2D.MakeRot(0.0)

    @body_id = Box2D.CreateBody(worldId, bodyDef)

    vertices_buf = FFI::MemoryPointer.new(Box2D::Vec2, 3)
    vertices = [Box2D::Vec2.new(vertices_buf[0]), Box2D::Vec2.new(vertices_buf[1]), Box2D::Vec2.new(vertices_buf[2])]

    vertices[0].set(0.0, 0.0)
    vertices[1].set(-2.5, 2.5)
    vertices[2].set(0.0, -2.5)
    polygon_l = Box2D.MakePolygon(Box2D.ComputeHull(vertices_buf, vertices.size), 0.0)
    @shape_ids << Box2D.CreatePolygonShape(@body_id, shapeDef, polygon_l)

    vertices[0].set(0.0, 0.0)
    vertices[1].set(2.5, 2.5)
    vertices[2].set(0.0, -2.5)
    polygon_r = Box2D.MakePolygon(Box2D.ComputeHull(vertices_buf, vertices.size), 0.0)
    @shape_ids << Box2D.CreatePolygonShape(@body_id, shapeDef, polygon_r)

    @is_spawned = true
  end

  def despawn
    return unless @is_spawned

    Box2D.DestroyBody(@body_id)
    @body_id = nil

    @is_spawned = false
  end
end


class SampleCompound < SampleBase

  SPAWN_HEIGHT = 25.0

  def initialize(screenWidth, screenHeight, camera)
    super(screenWidth, screenHeight, camera)
    @current_shape = Shape.new
    @shapes = []
  end

  def setup
    super
    bodyDef = Box2D.DefaultBodyDef()
    groundId = Box2D.CreateBody(@worldId, Box2D.DefaultBodyDef())
    shapeDef = Box2D.DefaultShapeDef()

    vertices_buf = FFI::MemoryPointer.new(Box2D::Vec2, 3)
    vertices = [Box2D::Vec2.new(vertices_buf[0]), Box2D::Vec2.new(vertices_buf[1]), Box2D::Vec2.new(vertices_buf[2])]

    vertices[0].set(-30.0, 0.0)
    vertices[1].set(-10.0, 0.0)
    vertices[2].set(-20.0, -5.0)
    polygon_l = Box2D.MakePolygon(Box2D.ComputeHull(vertices_buf, vertices.size), 0.0)
    Box2D.CreatePolygonShape(groundId, shapeDef, polygon_l)

    vertices[0].set(30.0, 0.0)
    vertices[1].set(10.0, 0.0)
    vertices[2].set(20.0, -5.0)
    polygon_r = Box2D.MakePolygon(Box2D.ComputeHull(vertices_buf, vertices.size), 0.0)
    Box2D.CreatePolygonShape(groundId, shapeDef, polygon_r)

    vertices[0].set(-5.0, 0.0)
    vertices[1].set(5.0, 0.0)
    vertices[2].set(0.0, -5.0)
    polygon_c = Box2D.MakePolygon(Box2D.ComputeHull(vertices_buf, vertices.size), 0.0)
    Box2D.CreatePolygonShape(groundId, shapeDef, polygon_c)

    @current_shape.spawn(@worldId, Box2D::Vec2.create_as(0.0, SPAWN_HEIGHT), 2.0)
  end

  def cleanup
    @shapes.each do |shape|
      shape.despawn
    end
    super
  end

  def step
    handle_mouse
    super
    @shapes.reject! do |shape|
      if shape.get_transform_y < -50.0
        shape.despawn
        true
      else
        false
      end
    end
  end

  private
  def handle_mouse
    mouse_pos = Raylib.GetMousePosition()
    world_pos = Box2D::Vec2.create_as((mouse_pos.x - @camera[:offset].x) / @debugDraw.get_scale,  (@camera[:offset].y - @camera[:target].y - mouse_pos.y) / @debugDraw.get_scale)
    mouse_delta = Raylib.GetMouseDelta

    if Raylib.IsMouseButtonReleased(Raylib::MOUSE_BUTTON_LEFT)
      # MouseUp
      @current_shape.launch
      @shapes << @current_shape
      @current_shape = Shape.new
      @current_shape.spawn(@worldId, Box2D::Vec2.create_as(world_pos.x, SPAWN_HEIGHT), 2.0)
    elsif Raylib.IsMouseButtonPressed(Raylib::MOUSE_BUTTON_LEFT)
      # MouseDown
    end

    if @current_shape.is_attached_to_mouse
      current_transform = @current_shape.get_transform
      current_transform.p.set(world_pos.x, current_transform.p.y)
      wheel = Raylib.GetMouseWheelMove
      if wheel.abs >= Raylib::EPSILON
        angle_radian = Box2D.Rot_GetAngle(current_transform.q)
        angle_radian += 10.0 * wheel * Math::PI / 180.0
        current_transform.q = Box2D.MakeRot(angle_radian)
      end
      @current_shape.set_transform(current_transform)
    end

    if (mouse_delta.x != 0 || mouse_delta.y != 0)
      # MouseMotion
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  version = Box2D.GetVersion()
  title = "Box2D Version #{version.major}.#{version.minor}.#{version.revision}"

  SetWindowState(FLAG_WINDOW_RESIZABLE)
  screenWidth = 1280
  screenHeight = 720
  InitWindow(screenWidth, screenHeight, title)

  target_y = -screenHeight / 3.0
  camera = Camera2D.new
                   .with_target(0, target_y)
                   .with_offset(screenWidth / 2.0, screenHeight / 2.0)
                   .with_rotation(0.0)
                   .with_zoom(1.0)
  SetTargetFPS(60)

  current_sample = SampleCompound.new(screenWidth, screenHeight, camera)
  current_sample.setup

  until WindowShouldClose()
    # rubocop:disable Layout/IndentationConsistency
    screenWidth = GetScreenWidth()
    screenHeight = GetScreenHeight()
    camera[:offset].set(screenWidth / 2.0, screenHeight / 2.0)
    target_y = -screenHeight / 3.0
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
