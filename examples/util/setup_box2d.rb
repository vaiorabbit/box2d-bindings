def box2d_bindings_gem_available?
  Gem::Specification.find_by_name('box2d-bindings')
rescue Gem::LoadError
  false
rescue
  Gem.available?('box2d-bindings')
end

if box2d_bindings_gem_available?
  # puts("Loading from Gem system path.")
  require 'box2d'

  s = Gem::Specification.find_by_name('box2d-bindings')
  shared_lib_path = s.full_gem_path + '/lib/'

  case RUBY_PLATFORM
  when /mswin|msys|mingw|cygwin/
    Box2D.load_lib(shared_lib_path + 'libbox2d.dll')
  when /darwin/
    arch = RUBY_PLATFORM.split('-')[0]
    Box2D.load_lib(shared_lib_path + "libbox2d.#{arch}.dylib")
  when /linux/
    arch = RUBY_PLATFORM.split('-')[0]
    Box2D.load_lib(shared_lib_path + "libbox2d.#{arch}.so")
  else
    raise RuntimeError, "setup_dll.rb : Unknown OS: #{RUBY_PLATFORM}"
  end
else
  # puts("Loaging from local path.")
  require '../lib/box2d'

  case RUBY_PLATFORM
  when /mswin|msys|mingw|cygwin/
    Box2D.load_lib(Dir.pwd + '/../lib/' + 'libbox2d.dll')
  when /darwin/
    arch = RUBY_PLATFORM.split('-')[0]
    Box2D.load_lib(Dir.pwd + '/../lib/' + "libbox2d.#{arch}.dylib")
  when /linux/
    arch = RUBY_PLATFORM.split('-')[0]
    Box2D.load_lib(Dir.pwd + '/../lib/' + "libbox2d.#{arch}.so")
  else
    raise RuntimeError, "setup_dll.rb : Unknown OS: #{RUBY_PLATFORM}"
  end
end

include Box2D
