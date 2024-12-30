require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'
require_relative 'util/sample_debugdraw'

class Donut
  attr_reader :is_spawned, :body_ids, :joint_ids

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

  def despawn
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

class SampleSoftbody
  attr_accessor :worldId, :jointId, :motorSpeed, :debugDraw

  def initialize(screenWidth, screenHeight, camera)
    @screen_width = screenWidth
    @screen_height = screenHeight
    @camera = camera

    @mouse_joint_id = Box2D::NULL_JOINTID
    @ground_body_id = Box2D::NULL_BODYID

    @debugDraw = RaylibDebugDraw.new
    @donut = Donut.new
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
    groundId = Box2D::CreateBody(@worldId, Box2D::DefaultBodyDef())
    shapeDef = Box2D::DefaultShapeDef()
    segment = Box2D::Segment.create_as(Box2D::Vec2.create_as(-30.0, 0.0), Box2D::Vec2.create_as(30.0, 0.0))
    Box2D::CreateSegmentShape(groundId, shapeDef, segment)

    @donut.spawn(@worldId, Box2D::Vec2.create_as(0.0, 20.0), 6.0)
  end

  def cleanup
    @donut.despawn
    Box2D::DestroyWorld(@worldId)
  end

  def step
    handle_mouse
    timeStep = 1.0 / 60.0
    Box2D::World_EnableSleeping(@worldId, true)
    Box2D::World_EnableWarmStarting(@worldId, true)
    Box2D::World_EnableContinuous(@worldId, true)
    Box2D::World_Step(@worldId, timeStep, 4)
  end

  def draw
    Box2D::World_Draw(@worldId, @debugDraw.debug_draw)
  end

  private
  def handle_mouse
    if Raylib.IsMouseButtonPressed(Raylib::MOUSE_BUTTON_LEFT)
      mouse_pos = Raylib.GetMousePosition()
      world_pos = Box2D::Vec2.create_as((mouse_pos.x - @camera[:offset].x) / @debugDraw.get_scale,  (@camera[:offset].y - @camera[:target].y - mouse_pos.y) / @debugDraw.get_scale)

      # MouseDown
      # Make a small box.
      d = Box2D::Vec2.create_as(0.001, 0.001)
      box = Box2D::AABB.create_as(Box2D.Sub(world_pos, d), Box2D::Add(world_pos, d))

      # Query the world for overlapping shapes.
      queryContext = QueryContext.create_as(world_pos, Box2D::BodyId.new)
      Box2D::World_OverlapAABB(@worldId, box, Box2D::DefaultQueryFilter(), $query_callback_fcn, queryContext)

      if Box2D.id_non_null(queryContext.bodyId)
        bodyDef = Box2D::DefaultBodyDef()
        @ground_body_id = Box2D::CreateBody(@worldId, bodyDef)

        mouseDef = Box2D::DefaultMouseJointDef()
        mouseDef.bodyIdA = @ground_body_id
        mouseDef.bodyIdB = queryContext.bodyId
        mouseDef.target = world_pos
        mouseDef.hertz = 5.0
        mouseDef.dampingRatio = 0.7
        mouseDef.maxForce = 1000.0 * Box2D::Body_GetMass(queryContext.bodyId)
        @mouse_joint_id = Box2D::CreateMouseJoint(@worldId, mouseDef)

        Box2D::Body_SetAwake(queryContext.bodyId, true)
      end
    elsif Raylib.IsMouseButtonReleased(Raylib::MOUSE_BUTTON_LEFT)
      # MouseUp
      if Box2D.id_non_null(@mouse_joint_id)
        Box2D::DestroyJoint(@mouse_joint_id)
        @mouse_joint_id = Box2D::NULL_JOINTID

        Box2D::DestroyBody(@ground_body_id)
        @ground_body_id = Box2D::NULL_BODYID
      end
    end

    mouse_delta = Raylib.GetMouseDelta
    if (mouse_delta.x != 0 || mouse_delta.y != 0)
      mouse_pos = Raylib.GetMousePosition()
      world_pos = Box2D::Vec2.create_as((mouse_pos.x - @camera[:offset].x) / @debugDraw.get_scale,  (@camera[:offset].y - @camera[:target].y - mouse_pos.y) / @debugDraw.get_scale)

      # MouseMotion
      if Box2D::Joint_IsValid(@mouse_joint_id) == false
        # The world or attached body was destroyed.
        @mouse_joint_id = Box2D::NULL_JOINTID
      end

      if Box2D.id_non_null(@mouse_joint_id)
        Box2D::MouseJoint_SetTarget(@mouse_joint_id, world_pos)
        bodyIdB = Box2D::Joint_GetBodyB(@mouse_joint_id)
        Box2D::Body_SetAwake(bodyIdB, true)
      end
    end
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

  current_sample = SampleSoftbody.new(screenWidth, screenHeight, camera)
  current_sample.setup

  until WindowShouldClose()
    # rubocop:disable Layout/IndentationConsistency
    screenWidth = GetScreenWidth()
    screenHeight = GetScreenHeight()
    camera[:offset].set(screenWidth / 2.0, screenHeight / 2.0)
    target_y = -screenHeight / 3.0
    camera[:target].set(0, target_y)
    current_sample.set_screen_scale(20.0 * (screenWidth / 1280.0))

    run = true if IsKeyPressed(KEY_SPACE)
    current_sample.step if run

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
