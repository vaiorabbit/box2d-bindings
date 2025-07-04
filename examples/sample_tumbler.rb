require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'
require_relative 'util/sample_base'
require_relative 'util/sample_debugdraw'

class SampleTumbler < SampleBase

  def initialize(screenWidth, screenHeight, camera)
    super(screenWidth, screenHeight, camera)
  end

  def setup
    super
    groundId = Box2D::CreateBody(@worldId, Box2D::DefaultBodyDef())

    y_pos = 0.0

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

    shapeDef.material.customColor = Box2D::HexColor_colorBlueViolet
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
    jd.base.bodyIdA = groundId
    jd.base.bodyIdB = bodyId
    jd.base.localFrameA.p = Box2D::Vec2.create_as(0.0, y_pos)
    jd.base.localFrameB.p = Box2D::Vec2.create_as(0.0, 0.0)
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

end

if __FILE__ == $PROGRAM_NAME
  version = Box2D::GetVersion()
  title = "Box2D Version #{version.major}.#{version.minor}.#{version.revision}"

  SetConfigFlags(FLAG_WINDOW_RESIZABLE)
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

    current_sample.step

    BeginDrawing()
      ClearBackground(Raylib::BLACK)

      BeginMode2D(camera)
        current_sample.draw
        DrawFPS(screenWidth / 2 - 100, -screenHeight / 2 + 10)
      EndMode2D()
    EndDrawing()
    # rubocop:enable Layout/IndentationConsistency
  end

  current_sample.cleanup
  CloseWindow()
end
