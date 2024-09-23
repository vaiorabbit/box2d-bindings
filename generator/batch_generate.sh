#!/usr/local/bin/zsh
export PYTHONPATH=/opt/homebrew/opt/llvm/lib/python3.12/site-packages
/opt/homebrew/bin/python3 generate_base.py > ../lib/box2d_base.rb
/opt/homebrew/bin/python3 generate_main.py > ../lib/box2d_main.rb
/opt/homebrew/bin/python3 generate_collision.py > ../lib/box2d_collision.rb
/opt/homebrew/bin/python3 generate_id.py > ../lib/box2d_id.rb
/opt/homebrew/bin/python3 generate_math_functions.py > ../lib/box2d_math_functions.rb
/opt/homebrew/bin/python3 generate_math_inline_functions.py > ../lib/box2d_math_inline_functions.rb
/opt/homebrew/bin/python3 generate_types.py > ../lib/box2d_types.rb
