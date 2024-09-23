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
      :start_sec, :ulong_long,
      :start_usec, :ulong_long,
    )
    def start_sec = self[:start_sec]
    def start_sec=(v) self[:start_sec] = v end
    def start_usec = self[:start_usec]
    def start_usec=(v) self[:start_usec] = v end
    def self.create_as(_start_sec_, _start_usec_)
      instance = Timer.new
      instance[:start_sec] = _start_sec_
      instance[:start_usec] = _start_usec_
      instance
    end
  end


  # Function

  def self.setup_base_symbols(output_error = false)
    symbols = [
      :b2SetAllocator,
      :b2GetByteCount,
      :b2SetAssertFcn,
      :b2GetVersion,
      :b2CreateTimer,
      :b2GetTicks,
      :b2GetMilliseconds,
      :b2GetMillisecondsAndReset,
      :b2SleepMilliseconds,
      :b2Yield,
      :b2Hash,
    ]
    apis = {
      :b2SetAllocator => :SetAllocator,
      :b2GetByteCount => :GetByteCount,
      :b2SetAssertFcn => :SetAssertFcn,
      :b2GetVersion => :GetVersion,
      :b2CreateTimer => :CreateTimer,
      :b2GetTicks => :GetTicks,
      :b2GetMilliseconds => :GetMilliseconds,
      :b2GetMillisecondsAndReset => :GetMillisecondsAndReset,
      :b2SleepMilliseconds => :SleepMilliseconds,
      :b2Yield => :Yield,
      :b2Hash => :Hash,
    }
    args = {
      :b2SetAllocator => [:pointer, :pointer],
      :b2GetByteCount => [],
      :b2SetAssertFcn => [:pointer],
      :b2GetVersion => [],
      :b2CreateTimer => [],
      :b2GetTicks => [:pointer],
      :b2GetMilliseconds => [:pointer],
      :b2GetMillisecondsAndReset => [:pointer],
      :b2SleepMilliseconds => [:int],
      :b2Yield => [],
      :b2Hash => [:uint, :pointer, :int],
    }
    retvals = {
      :b2SetAllocator => :void,
      :b2GetByteCount => :int,
      :b2SetAssertFcn => :void,
      :b2GetVersion => Version.by_value,
      :b2CreateTimer => Timer.by_value,
      :b2GetTicks => :long_long,
      :b2GetMilliseconds => :float,
      :b2GetMillisecondsAndReset => :float,
      :b2SleepMilliseconds => :void,
      :b2Yield => :void,
      :b2Hash => :uint,
    }
    symbols.each do |sym|
      begin
        attach_function apis[sym], sym, args[sym], retvals[sym]
      rescue FFI::NotFoundError => error
        $stderr.puts("[Warning] Failed to import #{sym} (#{error}).") if output_error
      end
    end
  end

end

