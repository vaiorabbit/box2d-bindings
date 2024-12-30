#!/bin/sh

echo "add_compile_definitions(box2d_EXPORTS)" >> ./box2d/CMakeLists.txt

ruby split_inline_collision.rb
ruby split_inline_id.rb
ruby split_inline_math_functions.rb
