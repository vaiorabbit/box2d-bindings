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
      points <<  (@@scale * (transform.q.c * vert.x - transform.q.s * vert.y) + @@scale * transform.p.x)
      points <<  (@@scale * (-transform.q.s * vert.x - transform.q.c * vert.y) - @@scale * transform.p.y)
    end
    points << points[0]
    points << points[1]
    # pp 'xf'
    # pp [transform.p.x, transform.p.y, transform.q.c, transform.q.s]
    # #pp points
    # ppoints = []
    # vertexCount.times do |i|
    #   vert = Box2D::Vec2.new(vertices + i * Box2D::Vec2.size)
    #   ppoints << vert.x << vert.y
    # end
    # pp ppoints
    Raylib::DrawLineStrip(points.pack('F*'), vertexCount + 1, Raylib::Color.from_u32(color))
  end

  @@draw_circle_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :float, :int32, :pointer]) do |center, radius, color, context|
    Raylib::DrawCircle(center.p.x * @@scale, -center.p.y * @@scale, radius * @@scale, Raylib::Color.from_u32(color))
  end

  @@draw_solid_circle_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :float, :int32, :pointer]) do |center, radius, color, context|
    Raylib::DrawCircle(center.p.x * @@scale, -center.p.y * @@scale, radius * @@scale, Raylib::Color.from_u32(color))
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

class QueryContext < FFI::Struct
  layout(
    :point, Box2D::Vec2,
    :bodyId, Box2D::BodyId,
  )
  def point = self[:point]
  def point=(v) self[:point] = v end
  def bodyId = self[:bodyId]
  def bodyId=(v) self[:bodyId] = v end
  def self.create_as(_point_, _bodyId_)
    instance = QueryContext.new
    instance[:point] = _point_
    instance[:bodyId] = _bodyId_
    instance
  end
end

$query_callback_fcn = FFI::Function.new(:bool, [Box2D::Vec2.by_value, :pointer]) do |shapeId, context|
  ret = true

  queryContext = QueryContext.new(context)
  bodyId = Box2D::Shape_GetBody(shapeId)
  bodyType = Box2D::Body_GetType(bodyId)
  if bodyType == Box2D::BodyType_dynamicBody && Box2D::Shape_TestPoint(shapeId, queryContext.point)
    queryContext.bodyId = bodyId
    ret = false
  end

  ret
end

class Body
  def initialize(world_id, pos_x, pos_y)
    @world_id = world_id

    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_dynamicBody
    bodyDef.position.x = pos_x
    bodyDef.position.y = pos_y
    @body_id = Box2D::CreateBody(@world_id, bodyDef)

    shapeDef = Box2D::DefaultShapeDef()

    box_side_size = 0.5
    polygon = Box2D::MakeBox(box_side_size, box_side_size)
    Box2D::CreatePolygonShape(@body_id, shapeDef, polygon)

    # p "initializing  #{@body_id}(#{@body_id.index1}, #{@body_id.world0}, #{@body_id.revision})"
    ObjectSpace.define_finalizer(self, Body.finalize(@body_id))
  end

  def self.finalize(body_id)
    # Ref.: ruby-destructor-example.rb https://gist.github.com/iboard/5648299
    proc {
      # p "finalizing #{body_id}(#{body_id.index1}, #{body_id.world0}, #{body_id.revision})"
      Box2D::DestroyBody(body_id)
    }
  end

  def get_transform_y
    Box2D::Body_GetTransform(@body_id).p.y
  end
end

class SampleContact
  attr_accessor :worldId, :jointId, :motorSpeed, :debugDraw

  def initialize(screenWidth, screenHeight, camera)
    @screen_width = screenWidth
    @screen_height = screenHeight
    @camera = camera

    @mouse_joint_id = Box2D::NULL_JOINTID
    @ground_body_id = Box2D::NULL_BODYID

    @debugDraw = RaylibDebugDraw.new

    @bodies = []
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

    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_staticBody
    bodyDef.position.set(0.0, 0.0)
    bodyId = Box2D::CreateBody(@worldId, bodyDef)

    shapeDef = Box2D::DefaultShapeDef()
    shapeDef.density = 50.0

    rot_identity = Box2D::ROT_IDENTITY
    polygon = Box2D::MakeOffsetBox(0.5, 10.0, Box2D::Vec2.create_as(10.0, 0.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(0.5, 10.0, Box2D::Vec2.create_as(-10.0, 0.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(10.0, 0.5, Box2D::Vec2.create_as(0.0, -10.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)

    segment = Box2D::Segment.create_as(Box2D::Vec2.create_as(-30.0, -10.0), Box2D::Vec2.create_as(30.0, -10.0))
    Box2D::CreateSegmentShape(bodyId, shapeDef, segment)
  end

  def cleanup
    @bodies.clear
    GC.start
    Box2D::DestroyWorld(@worldId)
  end

  def step
    if IsKeyPressed(Raylib::KEY_SPACE) || IsMouseButtonPressed(Raylib::MOUSE_BUTTON_LEFT)
      # spawn 10 new rigid bodies
      10.times do
        @bodies << Body.new(@worldId, 0.0 + Random.rand(-9...9), 18.0)
      end
    end
    # remove rigid bodies completely fallen off from platform
    @bodies.reject! {|body| body.get_transform_y < -50.0}

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

  current_sample = SampleContact.new(screenWidth, screenHeight, camera)
  current_sample.setup

  bodies = []

  until WindowShouldClose()
    # rubocop:disable Layout/IndentationConsistency
    screenWidth = GetScreenWidth()
    screenHeight = GetScreenHeight()
    camera[:offset].set(screenWidth / 2.0, screenHeight / 2.0)
    target_y = 0.0
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
