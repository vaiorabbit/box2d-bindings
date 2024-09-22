@echo off
set PYTHONPATH=.\clang
:: Set CLANG_LIBRARY_PATH="c:\Program Files\LLVM\bin"
python generate_base.py > ..\lib\box2d_base.rb
python generate_main.py > ..\lib\box2d_main.rb
python generate_collision.py > ..\lib\box2d_collision.rb
python generate_id.py > ..\lib\box2d_id.rb
python generate_math_functions.py > ..\lib\box2d_math_functions.rb
python generate_types.py > ..\lib\box2d_types.rb
