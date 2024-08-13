#!/usr/local/bin/zsh
export PYTHONPATH=/opt/homebrew/opt/llvm/lib/python3.12/site-packages
/opt/homebrew/bin/python3 generate_base.py > ../lib/box2d_base.rb
/opt/homebrew/bin/python3 generate_box2d.py > ../lib/box2d_box2d.rb
/opt/homebrew/bin/python3 generate_collision.py > ../lib/box2d_collision.rb
/opt/homebrew/bin/python3 generate_id.py > ../lib/box2d_id.rb
/opt/homebrew/bin/python3 generate_math_function.py > ../lib/box2d_math_function.rb
/opt/homebrew/bin/python3 generate_types.py > ../lib/box2d_types.rb
