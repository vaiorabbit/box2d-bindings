require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'

module Raylib
  # Color helper
  class Color
    def self.from_u32(rgba = 255)
      r = (rgba >> 24) & 0xFF
      g = (rgba >> 16) & 0xFF
      b = (rgba >>  8) & 0xFF
      a = (rgba >>  0) & 0xFF
      Color.new.set(r, g, b, a)
    end

    def self.set(rgba)
      self[:r] = (rgba >> 24) & 0xFF
      self[:g] = (rgba >> 16) & 0xFF
      self[:b] = (rgba >>  8) & 0xFF
      self[:a] = (rgba >>  0) & 0xFF
      self
    end
  end
end

class RaylibDebugDraw
  attr_accessor :debug_draw

  def set_scale(s)
    @@scale = s
  end

  def get_scale
   @@scale
  end

  @@scale = 1.0

  @@draw_polygon_fcn = FFI::Function.new(:void, %i[pointer int32 int32 pointer]) do |vertices, vertexCount, radius, color, context|
    p 'polygon'
  end

  @@draw_solid_polygon_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :pointer, :int32, :float, :int32, :pointer]) do |transform, vertices, vertexCount, radius, color, context|
    points = []
    vertexCount.times do |i|
      vert = Box2D::Vec2.new(vertices + i * Box2D::Vec2.size)
      points <<  (@@scale * (transform.q.c * vert.x + transform.q.s * vert.y) + @@scale * transform.p.x)
      points <<  (@@scale * (-transform.q.s * vert.x + transform.q.c * vert.y) - @@scale * transform.p.y)
    end
    points << points[0]
    points << points[1]
    Raylib::DrawLineStrip(points.pack('F*'), vertexCount + 1, BLUE)
  end

  @@draw_circle_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :float, :int32, :pointer]) do |center, radius, color, context|
    Raylib::DrawCircle(center.p.x * @@scale, -center.p.y * @@scale, radius * @@scale, BLUE)
  end

  @@draw_solid_circle_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :float, :int32, :pointer]) do |center, radius, color, context|
    Raylib::DrawCircle(center.p.x * @@scale, -center.p.y * @@scale, radius * @@scale, BLACK)
  end

  @@draw_solid_capsule_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, Box2D::Vec2.by_value, :float, :int32, :pointer]) do |p1, p2, radius, color, context|
    raylib_color = Raylib::Color.from_u32(color)
    Raylib::DrawCircleLines(@@scale * p1.x, -@@scale * p1.y, @@scale * radius, raylib_color)
    Raylib::DrawCircleLines(@@scale * p2.x, -@@scale * p2.y, @@scale * radius, raylib_color)
    dir = Raylib.Vector2Subtract(Raylib::Vector2.create(p2.x, p2.y), Raylib::Vector2.create(p1.x, p1.y))
    len = Raylib.Vector2LengthSqr(dir)
    return if len <= 1e-6

    dir = Raylib.Vector2Normalize(dir)
    side0dir_x = -dir.y * radius
    side0dir_y = dir.x * radius
    side1dir_x = dir.y * radius
    side1dir_y = -dir.x * radius
    Raylib::DrawLine(@@scale * (p1.x + side0dir_x), -@@scale * (p1.y + side0dir_y), @@scale * (p2.x + side0dir_x), -@@scale * (p2.y + side0dir_y), raylib_color)
    Raylib::DrawLine(@@scale * (p1.x + side1dir_x), -@@scale * (p1.y + side1dir_y), @@scale * (p2.x + side1dir_x), -@@scale * (p2.y + side1dir_y), raylib_color)
  end

  @@draw_segment_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, Box2D::Vec2.by_value, :int32, :pointer]) do |p1, p2, color, context|
    Raylib.DrawLine(p1.x * @@scale, -p1.y * @@scale, p2.x * @@scale, -p2.y * @@scale, Raylib::Color.from_u32(color))
  end

  @@draw_transform_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :pointer]) do |transform, context|
    p 'transform'
  end

  @@draw_point_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :float, :int32, :pointer]) do |p, size, color, context|
    Raylib.DrawCircle(p.x * @@scale, -p.y * @@scale, 5.0, Raylib::Color.from_u32(color))
  end

  @@draw_string_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :pointer, :pointer]) do |p, s, context|
    p 'string'
  end

  def initialize
    @debug_draw = Box2D::DebugDraw.new

    @debug_draw.DrawPolygon = @@draw_polygon_fcn
    @debug_draw.DrawSolidPolygon = @@draw_solid_polygon_fcn
    @debug_draw.DrawCircle = @@draw_circle_fcn
    @debug_draw.DrawSolidCircle = @@draw_solid_circle_fcn
    @debug_draw.DrawSolidCapsule = @@draw_solid_capsule_fcn
    @debug_draw.DrawSegment = @@draw_segment_fcn
    @debug_draw.DrawTransform = @@draw_transform_fcn
    @debug_draw.DrawPoint = @@draw_point_fcn
    @debug_draw.DrawString = @@draw_string_fcn

    @debug_draw.useDrawingBounds = false
    @debug_draw.drawShapes = true
    @debug_draw.drawJoints = true
  end
end

class SampleTumbler
  attr_accessor :worldId, :jointId, :motorSpeed, :debugDraw

  def initialize(screenWidth, screenHeight, camera)
    @screen_width = screenWidth
    @screen_height = screenHeight
    @camera = camera
    @debugDraw = RaylibDebugDraw.new
  end

  def get_screen_scale
    @debugDraw.get_scale
  end

  def set_screen_scale(scale)
    @debugDraw.set_scale(scale)
  end

  def setup
    worldDef = Box2D::DefaultWorldDef()
    worldDef.gravity.x = 0.0
    worldDef.gravity.y = -10.0

    @worldId = Box2D::CreateWorld(worldDef)
    groundId = Box2D::CreateBody(@worldId, Box2D::DefaultBodyDef())

    y_pos = 0.0 # 10.0

    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_dynamicBody
    bodyDef.enableSleep = true
    bodyDef.position.x = 0.0
    bodyDef.position.y = y_pos
    bodyId = Box2D::CreateBody(@worldId, bodyDef)

    shapeDef = Box2D::DefaultShapeDef()
    shapeDef.density = 50.0

    rot_identity = Box2D::ROT_IDENTITY
    polygon = Box2D::MakeOffsetBox(0.5, 10.0, Box2D::Vec2.create_as(10.0, 0.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(0.5, 10.0, Box2D::Vec2.create_as(-10.0, 0.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(10.0, 0.5, Box2D::Vec2.create_as(0.0, 10.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(10.0, 0.5, Box2D::Vec2.create_as(0.0, -10.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)

    shapeDef.customColor = Box2D::HexColor_colorBlueViolet
    circle = Box2D::Circle.create_as(Box2D::Vec2.create_as(5.0, 5.0), 1.0)
    Box2D::CreateCircleShape(bodyId, shapeDef, circle)
    circle = Box2D::Circle.create_as(Box2D::Vec2.create_as(5.0, -5.0), 1.0)
    Box2D::CreateCircleShape(bodyId, shapeDef, circle)
    circle = Box2D::Circle.create_as(Box2D::Vec2.create_as(-5.0, -5.0), 1.0)
    Box2D::CreateCircleShape(bodyId, shapeDef, circle)
    circle = Box2D::Circle.create_as(Box2D::Vec2.create_as(-5.0, 5.0), 1.0)
    Box2D::CreateCircleShape(bodyId, shapeDef, circle)

    @motorSpeed = 25.0

    jd = Box2D::DefaultRevoluteJointDef()
    jd.bodyIdA = groundId
    jd.bodyIdB = bodyId
    jd.localAnchorA = Box2D::Vec2.create_as(0.0, y_pos)
    jd.localAnchorB = Box2D::Vec2.create_as(0.0, 0.0)
    jd.referenceAngle = 0.0
    jd.motorSpeed = (Math::PI / 180.0) * @motorSpeed
    jd.maxMotorTorque = 1e8
    jd.enableMotor = true

    @jointId = Box2D::CreateRevoluteJoint(@worldId, jd)

    box_side_size = 0.25
    gridCount = 24
    polygon = Box2D::MakeBox(box_side_size, box_side_size)
    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_dynamicBody
    shapeDef = Box2D::DefaultShapeDef()

    y = -(box_side_size * 1.5) * gridCount + y_pos
    gridCount.times do |i|
      x = -(box_side_size * 1.5) * gridCount
      gridCount.times do |j|
        bodyDef.position.x = x
        bodyDef.position.y = y
        bodyId = Box2D::CreateBody(@worldId, bodyDef)
        Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
        x += (box_side_size * 3)
      end
      y += (box_side_size * 3)
    end

  end

  def cleanup
    Box2D::DestroyWorld(@worldId)
  end

  def step
    timeStep = 1.0 / 60.0
    Box2D::World_EnableSleeping(@worldId, true)
    Box2D::World_EnableWarmStarting(@worldId, true)
    Box2D::World_EnableContinuous(@worldId, true)
    Box2D::World_Step(@worldId, timeStep, 4)
  end

  def draw
    Box2D::World_Draw(@worldId, @debugDraw.debug_draw)
  end
end

if __FILE__ == $PROGRAM_NAME

  run = false

  version = Box2D::GetVersion()
  title = "Box2D Version #{version.major}.#{version.minor}.#{version.revision}"

  SetWindowState(FLAG_WINDOW_RESIZABLE)
  screenWidth = 1280
  screenHeight = 720
  InitWindow(screenWidth, screenHeight, title)

  target_y = 0.0
  camera = Camera2D.new
                   .with_target(0, target_y)
                   .with_offset(screenWidth / 2.0, screenHeight / 2.0)
                   .with_rotation(0.0)
                   .with_zoom(1.0)
  SetTargetFPS(60)

  current_sample = SampleTumbler.new(screenWidth, screenHeight, camera)
  current_sample.setup

  until WindowShouldClose()
    # rubocop:disable Layout/IndentationConsistency
    screenWidth = GetScreenWidth()
    screenHeight = GetScreenHeight()
    camera[:offset].set(screenWidth / 2.0, screenHeight / 2.0)
    target_y = 0.0
    camera[:target].set(0, target_y)
    current_sample.set_screen_scale(20.0 * (screenWidth / 1280.0))

    run = true if IsKeyPressed(KEY_SPACE)
    current_sample.step if run

    BeginDrawing()
      ClearBackground(RAYWHITE)

      BeginMode2D(camera)
        DrawLine(camera.target.x.to_i, -screenHeight * 10, camera.target.x.to_i, screenHeight * 10, GREEN)
        DrawLine(-screenWidth * 10, camera.target.y.to_i, screenWidth * 10, camera.target.y.to_i, GREEN)

        current_sample.draw

        DrawFPS(screenWidth / 2 - 100, -screenHeight / 2 + 10)

      EndMode2D()
    EndDrawing()
    # rubocop:enable Layout/IndentationConsistency
  end

  current_sample.cleanup
  CloseWindow()
end
