class SampleBase
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

