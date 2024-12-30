require_relative 'util/setup_box2d'
require_relative 'util/setup_raylib'
require_relative 'util/sample_base'
require_relative 'util/sample_debugdraw'

class Body
  def initialize(world_id, pos_x, pos_y)
    @world_id = world_id

    bodyDef = Box2D::DefaultBodyDef()
    bodyDef.type = Box2D::BodyType_dynamicBody
    bodyDef.position.x = pos_x
    bodyDef.position.y = pos_y
    @body_id = Box2D::CreateBody(@world_id, bodyDef)

    shapeDef = Box2D::DefaultShapeDef()
    shapeDef.enableContactEvents = true

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

class SampleContact < SampleBase
  # attr_accessor :worldId, :jointId, :motorSpeed, :debugDraw

  def initialize(screenWidth, screenHeight, camera)
    super(screenWidth, screenHeight, camera)

    @bodies = []
    @contacts = []
  end

  def setup
    super

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
    super
  end

  def collect_contacts
    @contacts.clear

    contactEvents = Box2D::World_GetContactEvents(@worldId)
    contactEvents.beginCount.times do |i|
      beginTouchEvent = Box2D::ContactBeginTouchEvent.new(contactEvents.beginEvents + i * Box2D::ContactBeginTouchEvent.size)
      bodyIdA = Box2D::Shape_GetBody(beginTouchEvent.shapeIdA)
      bodyIdB = Box2D::Shape_GetBody(beginTouchEvent.shapeIdB)

      # We can get the final contact data from the shapes. The manifold is shared by the two shapes, so we just need the
      # contact data from one of the shapes. Choose the one with the smallest number of contacts.
      capacityA = Box2D::Shape_GetContactCapacity(beginTouchEvent.shapeIdA)
      capacityB = Box2D::Shape_GetContactCapacity(beginTouchEvent.shapeIdB)

      if capacityA < capacityB
        contactDataBuf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * capacityA)
        # pp [beginTouchEvent.shapeIdA, contactDataBuf, capacityA]
        countA = Box2D::Shape_GetContactData(beginTouchEvent.shapeIdA, contactDataBuf, capacityA)
        countA.times do |j|
          contact = Box2D::ContactData.new(contactDataBuf + j * Box2D::ContactData.size)
          idA = contact.shapeIdA
          idB = contact.shapeIdB
          if Box2D::id_equals(idA, beginTouchEvent.shapeIdB) || Box2D::id_equals(idB, beginTouchEvent.shapeIdB)
            manifold = contact.manifold
            manifold.pointCount.times do |k|
              manifoldPoint = manifold.points[k]
              @contacts << manifoldPoint.point
            end
          end
        end
      else
        contactDataBuf = FFI::MemoryPointer.new(:uint8, Box2D::ContactData.size * capacityB)
        # pp [beginTouchEvent.shapeIdB, contactDataBuf, capacityB]
        countB = Box2D::Shape_GetContactData(beginTouchEvent.shapeIdB, contactDataBuf, capacityB)
        countB.times do |j|
          contact = Box2D::ContactData.new(contactDataBuf + j * Box2D::ContactData.size)
          idA = contact.shapeIdA
          idB = contact.shapeIdB
          if Box2D::id_equals(idA, beginTouchEvent.shapeIdA) || Box2D::id_equals(idB, beginTouchEvent.shapeIdA)
            manifold = contact.manifold
            manifold.pointCount.times do |k|
              manifoldPoint = manifold.points[k]
              @contacts << manifoldPoint.point
            end
          end
        end
      end
    end
  end

  def step
    super

    if IsKeyPressed(Raylib::KEY_SPACE) || IsMouseButtonPressed(Raylib::MOUSE_BUTTON_LEFT)
      # spawn 10 new rigid bodies
      10.times do
        @bodies << Body.new(@worldId, 0.0 + Random.rand(-9...9), 18.0)
      end
    end
    # remove rigid bodies completely fallen off from platform
    @bodies.reject! {|body| body.get_transform_y < -50.0}

    collect_contacts()
  end

  def draw
    super
    scale = @debugDraw.get_scale
    @contacts.each do |contact|
      Raylib.DrawCircle(contact.x * scale, -contact.y * scale, 5.0, Raylib::ORANGE)
    end
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
