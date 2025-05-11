@echo off
set PYTHONPATH=.\clang
python generate_initial_cindex_mapping.py > box2d_cindex_mapping.json
python generate_initial_define_mapping.py > box2d_define_mapping.json
