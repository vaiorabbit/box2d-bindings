# Ruby-Box2D : Yet another Box2D wrapper for Ruby
#
# * https://github.com/vaiorabbit/box2d-bindings

require 'ffi'
require_relative 'box2d_base.rb'
require_relative 'box2d_math_functions.rb'
require_relative 'box2d_math_inline_functions.rb'
require_relative 'box2d_id.rb'
require_relative 'box2d_id_inline.rb'
require_relative 'box2d_collision.rb'
require_relative 'box2d_types.rb'
require_relative 'box2d_main.rb'
require_relative 'box2d_helper.rb'

module Box2D
  extend FFI::Library

  @@box2d_import_done = false
  def self.load_lib(libpath, method_naming: :original)

    unless @@box2d_import_done
      # Ref.: Using Multiple and Alternate Libraries
      # https://github.com/ffi/ffi/wiki/Using-Multiple-and-Alternate-Libraries
      begin
        lib_paths = [libpath].compact
        ffi_lib_flags :now, :global
        ffi_lib *lib_paths
        setup_symbols(method_naming: method_naming)
      rescue => error
        $stderr.puts("[Warning] Failed to load libraries (#{error}).") if output_error
      end
    end

  end

  def self.setup_symbols(method_naming: :original)
    setup_base_symbols(method_naming: method_naming)
    setup_math_functions_symbols(method_naming: method_naming)
    setup_math_inline_functions_symbols(method_naming: method_naming)
    setup_id_symbols(method_naming: method_naming)
    setup_id_inline_symbols(method_naming: method_naming)
    setup_collision_symbols(method_naming: method_naming)
    setup_types_symbols(method_naming: method_naming)
    setup_main_symbols(method_naming: method_naming)
  end

end
