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

end
