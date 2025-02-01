@echo off
set PYTHONPATH=.\clang
python generate_base.py > ..\lib\box2d_base.rb
python generate_main.py > ..\lib\box2d_main.rb
python generate_collision.py > ..\lib\box2d_collision.rb
:: python generate_collision_inline.py > ../lib/box2d_collision_inline.rb
python generate_id.py > ..\lib\box2d_id.rb
python generate_id_inline.py > ..\lib\box2d_id_inline.rb
python generate_math_functions.py > ..\lib\box2d_math_functions.rb
python generate_math_inline_functions.py > ../lib/box2d_math_inline_functions.rb
python generate_types.py > ..\lib\box2d_types.rb
