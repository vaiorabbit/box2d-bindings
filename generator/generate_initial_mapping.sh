#!/usr/local/bin/zsh
export PYTHONPATH=/opt/homebrew/opt/llvm/lib/python3.12/site-packages
/opt/homebrew/bin/python3 generate_initial_cindex_mapping.py > box2d_cindex_mapping.json
/opt/homebrew/bin/python3 generate_initial_define_mapping.py > box2d_define_mapping.json
