Error parsing translation unit.
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

  def self.setup_math_function_symbols(output_error = false)
    symbols = [
    ]
    apis = {
    }
    args = {
    }
    retvals = {
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

