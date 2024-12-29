# Ruby-Box2D : Yet another Box2D wrapper for Ruby
#
# * https://github.com/vaiorabbit/box2d-bindings
#
# [NOTICE] Autogenerated. Do not edit.

require 'ffi'

module Box2D
  extend FFI::Library
  # Define/Macro

  HASH_INIT = 5381

  # Enum


  # Typedef

  typedef :pointer, :b2AllocFcn
  typedef :pointer, :b2FreeFcn
  typedef :pointer, :b2AssertFcn

  # Struct

  class Version < FFI::Struct
    layout(
      :major, :int,
      :minor, :int,
      :revision, :int,
    )
    def major = self[:major]
    def major=(v) self[:major] = v end
    def minor = self[:minor]
    def minor=(v) self[:minor] = v end
    def revision = self[:revision]
    def revision=(v) self[:revision] = v end
    def self.create_as(_major_, _minor_, _revision_)
      instance = Version.new
      instance[:major] = _major_
      instance[:minor] = _minor_
      instance[:revision] = _revision_
      instance
    end
  end

  class Timer < FFI::Struct
    layout(
      :start, :long_long,
    )
    def start = self[:start]
    def start=(v) self[:start] = v end
    def self.create_as(_start_)
      instance = Timer.new
      instance[:start] = _start_
      instance
    end
  end


  # Function

  def self.setup_base_symbols(method_naming: :original)
    entries = [
      [:SetAllocator, :b2SetAllocator, [:pointer, :pointer], :void],
      [:GetByteCount, :b2GetByteCount, [], :int],
      [:SetAssertFcn, :b2SetAssertFcn, [:pointer], :void],
      [:InternalAssertFcn, :b2InternalAssertFcn, [:pointer, :pointer, :int], :int],
      [:GetVersion, :b2GetVersion, [], Version.by_value],
      [:CreateTimer, :b2CreateTimer, [], Timer.by_value],
      [:GetTicks, :b2GetTicks, [:pointer], :long_long],
      [:GetMilliseconds, :b2GetMilliseconds, [:pointer], :float],
      [:GetMillisecondsAndReset, :b2GetMillisecondsAndReset, [:pointer], :float],
      [:SleepMilliseconds, :b2SleepMilliseconds, [:int], :void],
      [:Yield, :b2Yield, [], :void],
      [:Hash, :b2Hash, [:uint, :pointer, :int], :uint],
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

