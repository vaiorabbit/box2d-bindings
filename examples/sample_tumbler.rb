require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'

class RaylibDebugDraw
  attr_accessor :debug_draw

  @scale = 20.0

  @@draw_polygon_fcn = FFI::Function.new(:void, %i[pointer int32 int32 pointer]) do |vertices, vertexCount, radius, color, context|
    p 'polygon'
  end

  @@draw_solid_polygon_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :pointer, :int32, :float, :int32, :pointer]) do |transform, vertices, vertexCount, radius, color, context|
    radius = radius <= 0.0 ? 3.0 : radius
    Raylib::DrawCircle(transform.p.x * @scale, -transform.p.y * @scale, radius, BLUE)
  end

  @@draw_circle_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :float, :int32, :pointer]) do |center, radius, color, context|
    # p 'circle'
    Raylib::DrawCircle(center.p.x * @scale, -center.p.y * @scale, radius * @scale, BLUE)
  end

  @@draw_solid_circle_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :float, :int32, :pointer]) do |center, radius, color, context|
    # p 'solid_circle'
    Raylib::DrawCircle(center.p.x * @scale, -center.p.y * @scale, radius * @scale, BLACK)
  end

  @@draw_solid_capsule_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, Box2D::Vec2.by_value, :float, :int32, :pointer]) do |p1, p2, radius, color, context|
    p 'capsule'
  end

  @@draw_segment_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, Box2D::Vec2.by_value, :int32, :pointer]) do |p1, p2, color, context|
    # TODO
    # DrawLine(p1.x * @scale, -p1.y * @scale, p2.x * @scale, -p2.y * @scale, GREEN)
    # p 'segment'
  end

  @@draw_transform_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :pointer]) do |transform, context|
    p 'transform'
  end

  @@draw_point_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :float, :int32, :pointer]) do |p, size, color, context|
    p 'point'
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

    # @debug_draw.drawingBounds.lowerBound.x = -100.0
    # @debug_draw.drawingBounds.lowerBound.y = -100.0
    # @debug_draw.drawingBounds.upperBound.x = 100.0
    # @debug_draw.drawingBounds.upperBound.y = 100.0
    # @debug_draw.useDrawingBounds = true
    @debug_draw.useDrawingBounds = false
    @debug_draw.drawShapes = true
    @debug_draw.drawJoints = true
  end
end

class SampleTumber
  attr_accessor :worldId, :jointId, :motorSpeed, :debugDraw

  def initialize
    @debugDraw = RaylibDebugDraw.new
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

    # TODO: b2Rot_identity
    rot_identity = Box2D::Rot.create_as(1.0, 0.0)
    polygon = Box2D::MakeOffsetBox(0.5, 10.0, Box2D::Vec2.create_as(10.0, 0.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(0.5, 10.0, Box2D::Vec2.create_as(-10.0, 0.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(10.0, 0.5, Box2D::Vec2.create_as(0.0, 10.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(10.0, 0.5, Box2D::Vec2.create_as(0.0, -10.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)

    # TODO: b2_colorBlueViolet
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

    gridCount = 45
    polygon = Box2D::MakeBox(0.125, 0.125)
    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_dynamicBody
    shapeDef = Box2D::DefaultShapeDef()

    y = -0.2 * gridCount + y_pos
    gridCount.times do |i|
      x = -0.2 * gridCount
      gridCount.times do |j|
        bodyDef.position.x = x
        bodyDef.position.y = y
        bodyId = Box2D::CreateBody(@worldId, bodyDef)
        Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
        x += 0.4
      end
      y += 0.4
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

  screenWidth = 1280
  screenHeight = 720
  InitWindow(screenWidth, screenHeight, title)

  camera = Camera2D.new
                   .with_target(0, 0)
                   .with_offset(screenWidth / 2.0, screenHeight / 2.0)
                   .with_rotation(0.0)
                   .with_zoom(1.0)
  SetTargetFPS(60)

  current_sample = SampleTumber.new
  current_sample.setup

  until WindowShouldClose()
    run = true if IsKeyPressed(KEY_SPACE)
    current_sample.step if run
    # rubocop:disable Layout/IndentationConsistency
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
