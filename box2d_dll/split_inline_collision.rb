# Usage : $ ruby split_inline_collision.rb ../box2d_dll/box2d/include/box2d/collision.h
require 'fileutils'

original_lines = nil
inline_functions = {}
current_key = nil
current_body = nil

filename = '../box2d_dll/box2d/include/box2d/collision.h'
if ARGV[0] != nil
  filename = ARGV[0]
end

# Copy original collision.h
if File.exist?("#{filename}.default")
  FileUtils.copy("#{filename}.default", filename)
end
if File.exist?("#{File.dirname(filename)}/../../src/dynamic_tree.c.default")
  FileUtils.copy("#{File.dirname(filename)}/../../src/dynamic_tree.c.default", "#{File.dirname(filename)}/../../src/dynamic_tree.c")
end

# Extract inline functions
File.open(filename, 'r') do |collision_h|
  original_lines = collision_h.readlines
  parsing = false
  original_lines.each do |original_line|
    if original_line.start_with? 'B2_INLINE'
      current_key = original_line.split(/\W()/).reject(&:empty?)[2] # key : "B2_INLINE float b2LengthSquared( b2Vec2 v )" -> "b2LengthSquared"
      first_line = original_line.gsub('B2_INLINE ', 'B2_API ') # first_line : "float b2LengthSquared( b2Vec2 v )"
      current_body = [first_line]
      parsing = true
      next
    end
    if parsing
      current_body << original_line
      if original_line.start_with? '}'
        inline_functions[current_key] = current_body
        parsing = false
        next
      end
    end
  end
end

# Comment out inline functions in original content
modified_lines = []
parsing = false
original_lines.each do |original_line|
  modified_line = nil
  if original_line.start_with? 'B2_INLINE'
    parsing = true
  end
  if parsing
    modified_line = "// #{original_line}"
    if original_line.start_with? '}'
      parsing = false
    end
  end
  modified_lines << (modified_line.nil? ? original_line : modified_line)
end

# Copy original collision.h
FileUtils.copy(filename, "#{filename}.default")
FileUtils.copy("#{File.dirname(filename)}/../../src/dynamic_tree.c", "#{File.dirname(filename)}/../../src/dynamic_tree.c.default")

# Write modified version of collision.h
File.open(filename, 'w') do |collision_h|
  modified_lines.each do |modified_line|
    collision_h.puts modified_line
  end
  collision_h.puts '#include "collision_inline.h"'
end

# Modify dynamic_tree.c to include split code
File.open("#{File.dirname(filename)}/../../src/dynamic_tree.c", 'a') do |dynamic_tree_c|
  dynamic_tree_c.puts '#include "collision_inline.c"'
end

# Write collision_inline.h and collision_inline.c

File.open("#{File.dirname(filename)}/collision_inline.h", 'w') do |collision_inline_h|
  header = <<-HEADER
// [NOTE] Autogenerated. Do NOT edit.
#pragma once

#include "collision.h"

HEADER
  collision_inline_h << header
  inline_functions.each do |key, body|
    collision_inline_h.puts "#{body[0].chop};"
  end
end

File.open("#{File.dirname(filename)}/../../src/collision_inline.c", 'w') do |collision_inline_c|
  header = <<-HEADER
// [NOTE] Autogenerated. Do NOT edit.
#include "box2d/collision_inline.h"

HEADER
  collision_inline_c << header
  inline_functions.each do |key, body|
    collision_inline_c.puts body
    collision_inline_c.puts
  end
end
