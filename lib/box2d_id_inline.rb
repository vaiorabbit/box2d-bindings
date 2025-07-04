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


  # Function

  def self.setup_id_inline_symbols(method_naming: :original)
    entries = [
      [:StoreWorldId, :b2StoreWorldId, [WorldId.by_value], :uint],
      [:LoadWorldId, :b2LoadWorldId, [:uint], WorldId.by_value],
      [:StoreBodyId, :b2StoreBodyId, [BodyId.by_value], :ulong_long],
      [:LoadBodyId, :b2LoadBodyId, [:ulong_long], BodyId.by_value],
      [:StoreShapeId, :b2StoreShapeId, [ShapeId.by_value], :ulong_long],
      [:LoadShapeId, :b2LoadShapeId, [:ulong_long], ShapeId.by_value],
      [:StoreChainId, :b2StoreChainId, [ChainId.by_value], :ulong_long],
      [:LoadChainId, :b2LoadChainId, [:ulong_long], ChainId.by_value],
      [:StoreJointId, :b2StoreJointId, [JointId.by_value], :ulong_long],
      [:LoadJointId, :b2LoadJointId, [:ulong_long], JointId.by_value],
      [:StoreContactId, :b2StoreContactId, [ContactId.by_value, :pointer], :void],
      [:LoadContactId, :b2LoadContactId, [:pointer], ContactId.by_value],
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

