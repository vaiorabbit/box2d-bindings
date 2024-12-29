require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'

class RaylibDebugDraw
  attr_accessor :debug_draw

  def set_scale(s)
    @@scale = s
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
    Raylib::DrawCircleLines(@@scale * p1.x, -@@scale * p1.y, @@scale * radius, Raylib::BLACK)
    Raylib::DrawCircleLines(@@scale * p2.x, -@@scale * p2.y, @@scale * radius, Raylib::BLACK)
    dir = Raylib.Vector2Subtract(Raylib::Vector2.create(p2.x, p2.y), Raylib::Vector2.create(p1.x, p1.y))
    len = Raylib.Vector2LengthSqr(dir)
    return if len <= 1e-6

    dir = Raylib.Vector2Normalize(dir)
    side0dir_x = -dir.y * radius
    side0dir_y = dir.x * radius
    side1dir_x = dir.y * radius
    side1dir_y = -dir.x * radius
    Raylib::DrawLine(@@scale * (p1.x + side0dir_x), -@@scale * (p1.y + side0dir_y), @@scale * (p2.x + side0dir_x), -@@scale * (p2.y + side0dir_y), Raylib::BLACK)
    Raylib::DrawLine(@@scale * (p1.x + side1dir_x), -@@scale * (p1.y + side1dir_y), @@scale * (p2.x + side1dir_x), -@@scale * (p2.y + side1dir_y), Raylib::BLACK)
  end

  @@draw_segment_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, Box2D::Vec2.by_value, :int32, :pointer]) do |p1, p2, color, context|
    Raylib.DrawLine(p1.x * @@scale, -p1.y * @@scale, p2.x * @@scale, -p2.y * @@scale, Raylib::RED)
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

    @debug_draw.useDrawingBounds = false
    @debug_draw.drawShapes = true
    @debug_draw.drawJoints = true
  end
end

class Donut
  attr_reader :is_spawned,  :body_ids, :joint_ids
  SIDES = 7
  def initialize
    @body_ids = Array.new(SIDES) # b2BodyId
    SIDES.times do
      @body_ids << Box2D::BodyId.new
    end

    @joint_ids = Array.new(SIDES) # b2JointId
    SIDES.times do
      @joint_ids << Box2D::JointId.new
    end

    @is_spawned = false
  end

  def spawn(worldId, position, scale)
    return if @is_spawned

    radius = 1.0 * scale
    deltaAngle = 2.0 * Math::PI / SIDES
    length = 2.0 * Math::PI * radius / SIDES

    capsule = Box2D::Capsule.create_as(
      Box2D::Vec2.create_as(0.0, -0.5 * length),
      Box2D::Vec2.create_as(0.0, 0.5 * length),
      0.25 * scale
    )

    center = Box2D::Vec2.create_as(position.x, position.y)

    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_dynamicBody

    shapeDef = Box2D::DefaultShapeDef()
    shapeDef.density = 1.0
    shapeDef.filter.groupIndex = -0
    shapeDef.friction = 0.3

    # Create bodies
    angle = 0.0
    SIDES.times do |i|
      bodyDef.position = Box2D::Vec2.create_as(radius * Math.cos(angle) + center.x, radius * Math.sin(angle) + center.y)
      bodyDef.rotation = Box2D::MakeRot(angle)

      @body_ids[i] = Box2D::CreateBody(worldId, bodyDef)
      Box2D::CreateCapsuleShape(@body_ids[i], shapeDef, capsule)
      angle += deltaAngle
    end

    # Create joints
    weldDef = Box2D::DefaultWeldJointDef()
    weldDef.angularHertz = 5.0
    weldDef.angularDampingRatio = 0.0
    weldDef.localAnchorA = Box2D::Vec2.create_as(0.0, 0.5 * length)
    weldDef.localAnchorB = Box2D::Vec2.create_as(0.0, -0.5 * length)

    prevBodyId = @body_ids[SIDES - 1]
    SIDES.times do |i|
      weldDef.bodyIdA = prevBodyId
      weldDef.bodyIdB = @body_ids[i]
      rotA = Box2D::Body_GetRotation(prevBodyId)
      rotB = Box2D::Body_GetRotation(@body_ids[i])
      weldDef.referenceAngle = Box2D::RelativeAngle(rotB, rotA)
      @joint_ids[i] = Box2D::CreateWeldJoint(worldId, weldDef)
      prevBodyId = weldDef.bodyIdB
    end

    @is_spawned = true
  end

  def despawn()
    return unless @is_spawned

    SIDES.times do |i|
      Box2D::DestroyBody(@body_ids[i])
      @body_ids[i] = nil
      @joint_ids[i] = nil
    end

    SIDES.times do
      @body_ids << Box2D::BodyId.new
    end

    @joint_ids = Array.new(SIDES)
    SIDES.times do
      @joint_ids << Box2D::JointId.new
    end

    @is_spawned = false
  end
end

class SampleSoftbody
  attr_accessor :worldId, :jointId, :motorSpeed, :debugDraw

  def initialize
    @debugDraw = RaylibDebugDraw.new
    @donut = Donut.new
  end

  def setup
    worldDef = Box2D::DefaultWorldDef()
    worldDef.gravity.x = 0.0
    worldDef.gravity.y = -10.0

    @worldId = Box2D::CreateWorld(worldDef)

    bodyDef = Box2D::DefaultBodyDef()
    groundId = Box2D::CreateBody(@worldId, Box2D::DefaultBodyDef())
    shapeDef = Box2D::DefaultShapeDef()
    segment = Box2D::Segment.create_as(Box2D::Vec2.create_as(-30.0, 0.0), Box2D::Vec2.create_as(30.0, 0.0))
    Box2D::CreateSegmentShape(groundId, shapeDef, segment)

    @donut.spawn(@worldId, Box2D::Vec2.create_as(0.0, 20.0), 3.0)
  end

  def cleanup
    @donut.despawn()
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

  target_y = -screenHeight / 3.0
  camera = Camera2D.new
                   .with_target(0, target_y)
                   .with_offset(screenWidth / 2.0, screenHeight / 2.0)
                   .with_rotation(0.0)
                   .with_zoom(1.0)
  SetTargetFPS(60)

  current_sample = SampleSoftbody.new
  current_sample.setup

  until WindowShouldClose()
    run = true if IsKeyPressed(KEY_SPACE)
    current_sample.step if run
    # rubocop:disable Layout/IndentationConsistency
    screenWidth = GetScreenWidth()
    screenHeight = GetScreenHeight()
    camera[:offset].set(screenWidth / 2.0, screenHeight / 2.0)
    current_sample.debugDraw.set_scale(20.0 * (screenWidth / 1280.0))

    BeginDrawing()
      ClearBackground(RAYWHITE)

      BeginMode2D(camera)
        DrawLine(camera.target.x.to_i, -screenHeight * 10, camera.target.x.to_i, screenHeight * 10, GREEN)
        DrawLine(-screenWidth * 10, camera.target.y.to_i, screenWidth * 10, camera.target.y.to_i, GREEN)

        current_sample.draw

        DrawFPS(screenWidth / 2 - 100, -screenHeight / 2 + 10 + target_y)

      EndMode2D()
    EndDrawing()
    # rubocop:enable Layout/IndentationConsistency
  end

  current_sample.cleanup
  CloseWindow()
end