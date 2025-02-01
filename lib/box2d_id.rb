# Ruby-Box2D : Yet another Box2D wrapper for Ruby
#
# * https://github.com/vaiorabbit/box2d-bindings
#
# [NOTICE] Autogenerated. Do not edit.

require 'ffi'

module Box2D
  extend FFI::Library
  # Define/Macro


  # Enum


  # Typedef


  # Struct

  class WorldId < FFI::Struct
    layout(
      :index1, :ushort,
      :generation, :ushort,
    )
    def index1 = self[:index1]
    def index1=(v) self[:index1] = v end
    def generation = self[:generation]
    def generation=(v) self[:generation] = v end
    def self.create_as(_index1_, _generation_)
      instance = WorldId.new
      instance[:index1] = _index1_
      instance[:generation] = _generation_
      instance
    end
  end

  class BodyId < FFI::Struct
    layout(
      :index1, :int,
      :world0, :ushort,
      :generation, :ushort,
    )
    def index1 = self[:index1]
    def index1=(v) self[:index1] = v end
    def world0 = self[:world0]
    def world0=(v) self[:world0] = v end
    def generation = self[:generation]
    def generation=(v) self[:generation] = v end
    def self.create_as(_index1_, _world0_, _generation_)
      instance = BodyId.new
      instance[:index1] = _index1_
      instance[:world0] = _world0_
      instance[:generation] = _generation_
      instance
    end
  end

  class ShapeId < FFI::Struct
    layout(
      :index1, :int,
      :world0, :ushort,
      :generation, :ushort,
    )
    def index1 = self[:index1]
    def index1=(v) self[:index1] = v end
    def world0 = self[:world0]
    def world0=(v) self[:world0] = v end
    def generation = self[:generation]
    def generation=(v) self[:generation] = v end
    def self.create_as(_index1_, _world0_, _generation_)
      instance = ShapeId.new
      instance[:index1] = _index1_
      instance[:world0] = _world0_
      instance[:generation] = _generation_
      instance
    end
  end

  class ChainId < FFI::Struct
    layout(
      :index1, :int,
      :world0, :ushort,
      :generation, :ushort,
    )
    def index1 = self[:index1]
    def index1=(v) self[:index1] = v end
    def world0 = self[:world0]
    def world0=(v) self[:world0] = v end
    def generation = self[:generation]
    def generation=(v) self[:generation] = v end
    def self.create_as(_index1_, _world0_, _generation_)
      instance = ChainId.new
      instance[:index1] = _index1_
      instance[:world0] = _world0_
      instance[:generation] = _generation_
      instance
    end
  end

  class JointId < FFI::Struct
    layout(
      :index1, :int,
      :world0, :ushort,
      :generation, :ushort,
    )
    def index1 = self[:index1]
    def index1=(v) self[:index1] = v end
    def world0 = self[:world0]
    def world0=(v) self[:world0] = v end
    def generation = self[:generation]
    def generation=(v) self[:generation] = v end
    def self.create_as(_index1_, _world0_, _generation_)
      instance = JointId.new
      instance[:index1] = _index1_
      instance[:world0] = _world0_
      instance[:generation] = _generation_
      instance
    end
  end


  # Function

  def self.setup_id_symbols(method_naming: :original)
    entries = [
    ]
    entries.each do |entry|
      api_name = if method_naming == :snake_case
                   snake_case_name = entry[0].to_s.gsub(/([A-Z]+)([A-Z0-9][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z0-9])/, '\1_\2').downcase
                   snake_case_name.gsub!('vector_3', 'vector3_') if snake_case_name.include?('vector_3')
                   snake_case_name.gsub!('vector_2', 'vector2_') if snake_case_name.include?('vector_2')
                   snake_case_name.chop! if snake_case_name.end_with?('_')
                   snake_case_name.to_sym
                 else
                   entry[0]
                 end
      attach_function api_name, entry[1], entry[2], entry[3]
    rescue FFI::NotFoundError => e
      warn "[Warning] Failed to import #{entry[0]} (#{e})."
    end
  end

end

