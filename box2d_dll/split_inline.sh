#!/bin/sh

echo "target_compile_definitions(box2d PUBLIC box2d_EXPORTS)" >> ./box2d/CMakeLists.txt

ruby split_inline_collision.rb
ruby split_inline_id.rb
ruby split_inline_math_functions.rb
