# Box2D wrapper for Ruby
#
# * https://github.com/vaiorabbit/box2d-bindings

require_relative 'box2d_id'

module Box2D
  #
  # ID helper
  #

  NULL_WORLDID = WorldId.new.freeze
  NULL_BODYID = BodyId.new.freeze
  NULL_SHAPEID = ShapeId.new.freeze
  NULL_CHAINID = ChainId.new.freeze
  NULL_JOINTID = JointId.new.freeze

  def self.id_null(id)
    id.index1 == 0
  end

  def self.id_non_null(id)
    id.index1 != 0
  end

  def self.id_equals(id1, id2)
    id1.index1 == id2.index1 && id1.world0 == id2.world0 && id1.revision == id2.revision
  end

  #
  # Math helper
  #

  VEC2_ZERO = Vec2.new.freeze
  ROT_IDENTITY = Rot.create_as(1.0, 0.0).freeze
  TRANSFORM_IDENTITY = Transform.create_as(Vec2.new.freeze, Rot.create_as(1.0, 0.0).freeze).freeze
  MAT22_ZERO = Mat22.create_as(Vec2.new.freeze, Vec2.new.freeze).freeze

  class Vec2
    def self.copy_from(vec)
      Vec2.create_as(vec[:x], vec[:y])
    end

    def set(x, y)
      self[:x] = x
      self[:y] = y
      self
    end

    def add(x, y)
      self[:x] = self[:x] + x
      self[:y] = self[:y] + y
      self
    end

    def add_vector(v)
      self[:x] = self[:x] + v[:x]
      self[:y] = self[:y] + v[:y]
      self
    end

    def to_a
      [x, y]
    end
  end

end
