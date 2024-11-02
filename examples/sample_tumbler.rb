require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'

class SampleTumber
  attr_accessor :worldId
  attr_accessor :jointId, :motorSpeed

  def initialize
  end

  def setup
    worldDef = Box2D::DefaultWorldDef()
    @worldId = Box2D::CreateWorld(worldDef)
    groundId = Box2D::CreateBody(@worldId, Box2D::DefaultBodyDef())

    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_dynamicBody
    bodyDef.enableSleep = true
    bodyDef.position.x = 0.0
    bodyDef.position.y = 10.0
    bodyId = Box2D::CreateBody(@worldId, bodyDef)

    shapeDef = Box2D::DefaultShapeDef()
    shapeDef.density = 50.0

    # TODO b2Rot_identity
    rot_identity = Box2D::Rot.create_as(1.0, 0.0)
    polygon = Box2D::MakeOffsetBox(0.5, 10.0, Box2D::Vec2.create_as(10.0, 0.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(0.5, 10.0, Box2D::Vec2.create_as(-10.0, 0.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(10.0, 0.5, Box2D::Vec2.create_as(0.0, 10.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)
    polygon = Box2D::MakeOffsetBox(10.0, 0.5, Box2D::Vec2.create_as(0.0, -10.0), rot_identity)
    Box2D::CreatePolygonShape(bodyId, shapeDef, polygon)

    # TODO b2_colorBlueViolet
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
    jd.localAnchorA = Box2D::Vec2.create_as(0.0, 10.0)
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

    y = -0.2 * gridCount + 10.0
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

  current_sample = SampleTumber.new
  current_sample.setup

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

  current_sample.cleanup
  CloseWindow()
end
