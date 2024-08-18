# Ruby-Box2D : Yet another Box2D wrapper for Ruby
#
# * https://github.com/vaiorabbit/box2d-bindings

module Box2D

  def self.Rot_GetAngle(q)
    return Math.atan2(q.s, q.c)
  end

end

