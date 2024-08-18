require_relative 'util/setup_dll'

# Ref.: box2d/test/test_world.c

# TODO
def b2Rot_GetAngle(q)
  return Math.atan2(q.s, q.c)
end

if __FILE__ == $PROGRAM_NAME
  # Construct a world object, which will hold and simulate the rigid bodies.
  worldDef = Box2D::DefaultWorldDef()
  worldDef.gravity.x = 0.0
  worldDef.gravity.y = -10.0

  worldId = Box2D::CreateWorld(worldDef)

  # Define the ground body.
  groundBodyDef = Box2D::DefaultBodyDef()
  groundBodyDef.position.x = 0.0
  groundBodyDef.position.y = -10.0

  # Call the body factory which allocates memory for the ground body
  # from a pool and creates the ground box shape (also from a pool).
  # The body is also added to the world.
  groundId = Box2D::CreateBody(worldId, groundBodyDef)

  # Define the ground box shape. The extents are the half-widths of the box.
  groundBox = Box2D::MakeBox(50.0, 10.0)

  # Add the box shape to the ground body.
  groundShapeDef = Box2D::DefaultShapeDef()
  Box2D::CreatePolygonShape(groundId, groundShapeDef, groundBox)

  # Define the dynamic body. We set its position and call the body factory.
  bodyDef = Box2D::DefaultBodyDef()
  bodyDef.type = Box2D::BodyType_dynamicBody;
  bodyDef.position.x = 0.0
  bodyDef.position.y = 4.0

  bodyId = Box2D::CreateBody(worldId, bodyDef)

  # Define another box shape for our dynamic body.
  dynamicBox = Box2D::MakeBox(1.0, 1.0)

  # Define the dynamic body shape
  shapeDef = Box2D::DefaultShapeDef()

  # Set the box density to be non-zero, so it will be dynamic.
  shapeDef.density = 1.0

  # Override the default friction.
  shapeDef.friction = 0.3

  # Add the shape to the body.
  Box2D::CreatePolygonShape(bodyId, shapeDef, dynamicBox)

  # Prepare for simulation. Typically we use a time step of 1/60 of a
  # second (60Hz) and 4 sub-steps. This provides a high quality simulation
  # in most game scenarios.
  timeStep = 1.0 / 60.0
  subStepCount = 4

  position = Box2D::Body_GetPosition(bodyId)
  rotation = Box2D::Body_GetRotation(bodyId)

  # This is our little game loop.
  90.times do |i|
    # Instruct the world to perform a single step of simulation.
    # It is generally best to keep the time step and iterations fixed.
    Box2D::World_Step(worldId, timeStep, subStepCount)

    # Now print the position and angle of the body.
    position = Box2D::Body_GetPosition(bodyId)
    rotation = Box2D::Body_GetRotation(bodyId)

    printf("%4.2f %4.2f %4.2f\n", position.x, position.y, b2Rot_GetAngle(rotation))
  end

  # When the world destructor is called, all bodies and joints are freed. This can
  # create orphaned ids, so be careful about your world management.
  Box2D::DestroyWorld(worldId)
end
