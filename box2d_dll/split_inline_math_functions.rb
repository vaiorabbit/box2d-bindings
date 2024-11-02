# Usage : $ ruby split_inline_math_functions.rb ../box2d_dll/box2d/include/box2d/math_functions.h
require 'fileutils'

original_lines = nil
inline_functions = {}
current_key = nil
current_body = nil

filename = '../box2d_dll/box2d/include/box2d/math_functions.h'
if ARGV[0] != nil
  filename = ARGV[0]
end

# Copy original math_functions.h
if File.exist?("#{filename}.default")
  FileUtils.copy("#{filename}.default", filename)
end
if File.exist?("#{File.dirname(filename)}/../../src/math_functions.c.default")
  FileUtils.copy("#{File.dirname(filename)}/../../src/math_functions.c.default", "#{File.dirname(filename)}/../../src/math_functions.c")
end

# Extract inline functions
File.open(filename, 'r') do |math_functions_h|
  original_lines = math_functions_h.readlines
  parsing = false
  original_lines.each do |original_line|
    if original_line.start_with? 'B2_INLINE'
      current_key = original_line.split(/\W()/).reject(&:empty?)[2] # key : "B2_INLINE float b2LengthSquared( b2Vec2 v )" -> "b2LengthSquared"
      first_line = original_line.gsub('B2_INLINE ', '') # first_line : "float b2LengthSquared( b2Vec2 v )"
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

# Copy original math_functions.h and c
FileUtils.copy(filename, "#{filename}.default")
FileUtils.copy("#{File.dirname(filename)}/../../src/math_functions.c", "#{File.dirname(filename)}/../../src/math_functions.c.default")

# Write modified version of math_functions.h
File.open(filename, 'w') do |math_functions_h|
  modified_lines.each do |modified_line|
    math_functions_h.puts modified_line
  end
  math_functions_h.puts '#include "math_inline_functions.h"'
end

# Modify math_functions.c to include split code
File.open("#{File.dirname(filename)}/../../src/math_functions.c", 'a') do |math_functions_c|
  math_functions_c.puts '#include "math_inline_functions.c"'
end

# Write math_inline_functions.h and math_inline_functions.c

File.open("#{File.dirname(filename)}/math_inline_functions.h", 'w') do |math_inline_functions_h|
  header = <<-HEADER
// [NOTE] Autogenerated. Do NOT edit.
#pragma once

#include "math_functions.h"

HEADER
  math_inline_functions_h << header
  inline_functions.each do |key, body|
    math_inline_functions_h.puts "#{body[0].chop};"
  end
end

File.open("#{File.dirname(filename)}/../../src/math_inline_functions.c", 'w') do |math_inline_functions_c|
  header = <<-HEADER
// [NOTE] Autogenerated. Do NOT edit.
#include "box2d/math_inline_functions.h"

#include "core.h"

#include <float.h>

HEADER
  math_inline_functions_c << header
  inline_functions.each do |key, body|
    math_inline_functions_c.puts body
    math_inline_functions_c.puts
  end
end