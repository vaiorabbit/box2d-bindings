import box2d_parser, box2d_generator

STRUCT_PREFIX_TREENODE = """
  class TreeNode_Union < FFI::Union
    layout(
      :parent, :int,
      :next, :int,
    )
  end

  class TreeNode < FFI::Struct
    layout(
      :aabb, AABB,
      :categoryBits, :uint,
      :union, TreeNode_Union,
      :child1, :int,
      :child2, :int,
      :userData, :int,
      :height, :short,
      :enlarged, :int,
      :pad, [:char, 9],
    )
    def aabb = self[:aabb]
    def aabb=(v) self[:aabb] = v end
    def categoryBits = self[:categoryBits]
    def categoryBits=(v) self[:categoryBits] = v end
    def union = self[:union]
    def union=(v) self[:union] = v end
    def child1 = self[:child1]
    def child1=(v) self[:child1] = v end
    def child2 = self[:child2]
    def child2=(v) self[:child2] = v end
    def userData = self[:userData]
    def userData=(v) self[:userData] = v end
    def height = self[:height]
    def height=(v) self[:height] = v end
    def enlarged = self[:enlarged]
    def enlarged=(v) self[:enlarged] = v end
    def pad = self[:pad]
    def pad=(v) self[:pad] = v end
    def self.create_as(_aabb_, _categoryBits_, _union_, _child1_, _child2_, _userData_, _height_, _enlarged_, _pad_)
      instance = b2TreeNode.new
      instance[:aabb] = _aabb_
      instance[:categoryBits] = _categoryBits_
      instance[:union] = _union_
      instance[:child1] = _child1_
      instance[:child2] = _child2_
      instance[:userData] = _userData_
      instance[:height] = _height_
      instance[:enlarged] = _enlarged_
      instance[:pad] = _pad_
      instance
    end
  end
"""

if __name__ == "__main__":

    ctx = box2d_parser.ParseContext('collision.h')
    box2d_parser.execute(ctx)

    ctx.decl_structs['b2TreeNode'] = None

    box2d_generator.sanitize(ctx)
    box2d_generator.generate(ctx,
                             struct_prefix = STRUCT_PREFIX_TREENODE,
                             setup_method_name = 'collision')
