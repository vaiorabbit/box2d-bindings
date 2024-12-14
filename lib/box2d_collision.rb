# Ruby-Box2D : Yet another Box2D wrapper for Ruby
#
# * https://github.com/vaiorabbit/box2d-bindings
#
# [NOTICE] Autogenerated. Do not edit.

require 'ffi'

module Box2D
  extend FFI::Library
  # Define/Macro

  MAX_POLYGON_VERTICES = 8

  # Enum

  TOIState_toiStateUnknown = 0
  TOIState_toiStateFailed = 1
  TOIState_toiStateOverlapped = 2
  TOIState_toiStateHit = 3
  TOIState_toiStateSeparated = 4

  # Typedef

  typedef :int, :b2TOIState
  typedef :pointer, :b2TreeQueryCallbackFcn
  typedef :pointer, :b2TreeRayCastCallbackFcn
  typedef :pointer, :b2TreeShapeCastCallbackFcn

  # Struct


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

  class DistanceCache < FFI::Struct
    layout(
      :count, :ushort,
      :indexA, [:uchar, 3],
      :indexB, [:uchar, 3],
    )
    def count = self[:count]
    def count=(v) self[:count] = v end
    def indexA = self[:indexA]
    def indexA=(v) self[:indexA] = v end
    def indexB = self[:indexB]
    def indexB=(v) self[:indexB] = v end
    def self.create_as(_count_, _indexA_, _indexB_)
      instance = DistanceCache.new
      instance[:count] = _count_
      instance[:indexA] = _indexA_
      instance[:indexB] = _indexB_
      instance
    end
  end

  class Hull < FFI::Struct
    layout(
      :points, [Vec2, 8],
      :count, :int,
    )
    def points = self[:points]
    def points=(v) self[:points] = v end
    def count = self[:count]
    def count=(v) self[:count] = v end
    def self.create_as(_points_, _count_)
      instance = Hull.new
      instance[:points] = _points_
      instance[:count] = _count_
      instance
    end
  end

  class RayCastInput < FFI::Struct
    layout(
      :origin, Vec2,
      :translation, Vec2,
      :maxFraction, :float,
    )
    def origin = self[:origin]
    def origin=(v) self[:origin] = v end
    def translation = self[:translation]
    def translation=(v) self[:translation] = v end
    def maxFraction = self[:maxFraction]
    def maxFraction=(v) self[:maxFraction] = v end
    def self.create_as(_origin_, _translation_, _maxFraction_)
      instance = RayCastInput.new
      instance[:origin] = _origin_
      instance[:translation] = _translation_
      instance[:maxFraction] = _maxFraction_
      instance
    end
  end

  class ShapeCastInput < FFI::Struct
    layout(
      :points, [Vec2, 8],
      :count, :int,
      :radius, :float,
      :translation, Vec2,
      :maxFraction, :float,
    )
    def points = self[:points]
    def points=(v) self[:points] = v end
    def count = self[:count]
    def count=(v) self[:count] = v end
    def radius = self[:radius]
    def radius=(v) self[:radius] = v end
    def translation = self[:translation]
    def translation=(v) self[:translation] = v end
    def maxFraction = self[:maxFraction]
    def maxFraction=(v) self[:maxFraction] = v end
    def self.create_as(_points_, _count_, _radius_, _translation_, _maxFraction_)
      instance = ShapeCastInput.new
      instance[:points] = _points_
      instance[:count] = _count_
      instance[:radius] = _radius_
      instance[:translation] = _translation_
      instance[:maxFraction] = _maxFraction_
      instance
    end
  end

  class CastOutput < FFI::Struct
    layout(
      :normal, Vec2,
      :point, Vec2,
      :fraction, :float,
      :iterations, :int,
      :hit, :bool,
    )
    def normal = self[:normal]
    def normal=(v) self[:normal] = v end
    def point = self[:point]
    def point=(v) self[:point] = v end
    def fraction = self[:fraction]
    def fraction=(v) self[:fraction] = v end
    def iterations = self[:iterations]
    def iterations=(v) self[:iterations] = v end
    def hit = self[:hit]
    def hit=(v) self[:hit] = v end
    def self.create_as(_normal_, _point_, _fraction_, _iterations_, _hit_)
      instance = CastOutput.new
      instance[:normal] = _normal_
      instance[:point] = _point_
      instance[:fraction] = _fraction_
      instance[:iterations] = _iterations_
      instance[:hit] = _hit_
      instance
    end
  end

  class MassData < FFI::Struct
    layout(
      :mass, :float,
      :center, Vec2,
      :rotationalInertia, :float,
    )
    def mass = self[:mass]
    def mass=(v) self[:mass] = v end
    def center = self[:center]
    def center=(v) self[:center] = v end
    def rotationalInertia = self[:rotationalInertia]
    def rotationalInertia=(v) self[:rotationalInertia] = v end
    def self.create_as(_mass_, _center_, _rotationalInertia_)
      instance = MassData.new
      instance[:mass] = _mass_
      instance[:center] = _center_
      instance[:rotationalInertia] = _rotationalInertia_
      instance
    end
  end

  class Circle < FFI::Struct
    layout(
      :center, Vec2,
      :radius, :float,
    )
    def center = self[:center]
    def center=(v) self[:center] = v end
    def radius = self[:radius]
    def radius=(v) self[:radius] = v end
    def self.create_as(_center_, _radius_)
      instance = Circle.new
      instance[:center] = _center_
      instance[:radius] = _radius_
      instance
    end
  end

  class Capsule < FFI::Struct
    layout(
      :center1, Vec2,
      :center2, Vec2,
      :radius, :float,
    )
    def center1 = self[:center1]
    def center1=(v) self[:center1] = v end
    def center2 = self[:center2]
    def center2=(v) self[:center2] = v end
    def radius = self[:radius]
    def radius=(v) self[:radius] = v end
    def self.create_as(_center1_, _center2_, _radius_)
      instance = Capsule.new
      instance[:center1] = _center1_
      instance[:center2] = _center2_
      instance[:radius] = _radius_
      instance
    end
  end

  class Polygon < FFI::Struct
    layout(
      :vertices, [Vec2, 8],
      :normals, [Vec2, 8],
      :centroid, Vec2,
      :radius, :float,
      :count, :int,
    )
    def vertices = self[:vertices]
    def vertices=(v) self[:vertices] = v end
    def normals = self[:normals]
    def normals=(v) self[:normals] = v end
    def centroid = self[:centroid]
    def centroid=(v) self[:centroid] = v end
    def radius = self[:radius]
    def radius=(v) self[:radius] = v end
    def count = self[:count]
    def count=(v) self[:count] = v end
    def self.create_as(_vertices_, _normals_, _centroid_, _radius_, _count_)
      instance = Polygon.new
      instance[:vertices] = _vertices_
      instance[:normals] = _normals_
      instance[:centroid] = _centroid_
      instance[:radius] = _radius_
      instance[:count] = _count_
      instance
    end
  end

  class Segment < FFI::Struct
    layout(
      :point1, Vec2,
      :point2, Vec2,
    )
    def point1 = self[:point1]
    def point1=(v) self[:point1] = v end
    def point2 = self[:point2]
    def point2=(v) self[:point2] = v end
    def self.create_as(_point1_, _point2_)
      instance = Segment.new
      instance[:point1] = _point1_
      instance[:point2] = _point2_
      instance
    end
  end

  class ChainSegment < FFI::Struct
    layout(
      :ghost1, Vec2,
      :segment, Segment,
      :ghost2, Vec2,
      :chainId, :int,
    )
    def ghost1 = self[:ghost1]
    def ghost1=(v) self[:ghost1] = v end
    def segment = self[:segment]
    def segment=(v) self[:segment] = v end
    def ghost2 = self[:ghost2]
    def ghost2=(v) self[:ghost2] = v end
    def chainId = self[:chainId]
    def chainId=(v) self[:chainId] = v end
    def self.create_as(_ghost1_, _segment_, _ghost2_, _chainId_)
      instance = ChainSegment.new
      instance[:ghost1] = _ghost1_
      instance[:segment] = _segment_
      instance[:ghost2] = _ghost2_
      instance[:chainId] = _chainId_
      instance
    end
  end

  class SegmentDistanceResult < FFI::Struct
    layout(
      :closest1, Vec2,
      :closest2, Vec2,
      :fraction1, :float,
      :fraction2, :float,
      :distanceSquared, :float,
    )
    def closest1 = self[:closest1]
    def closest1=(v) self[:closest1] = v end
    def closest2 = self[:closest2]
    def closest2=(v) self[:closest2] = v end
    def fraction1 = self[:fraction1]
    def fraction1=(v) self[:fraction1] = v end
    def fraction2 = self[:fraction2]
    def fraction2=(v) self[:fraction2] = v end
    def distanceSquared = self[:distanceSquared]
    def distanceSquared=(v) self[:distanceSquared] = v end
    def self.create_as(_closest1_, _closest2_, _fraction1_, _fraction2_, _distanceSquared_)
      instance = SegmentDistanceResult.new
      instance[:closest1] = _closest1_
      instance[:closest2] = _closest2_
      instance[:fraction1] = _fraction1_
      instance[:fraction2] = _fraction2_
      instance[:distanceSquared] = _distanceSquared_
      instance
    end
  end

  class DistanceProxy < FFI::Struct
    layout(
      :points, [Vec2, 8],
      :count, :int,
      :radius, :float,
    )
    def points = self[:points]
    def points=(v) self[:points] = v end
    def count = self[:count]
    def count=(v) self[:count] = v end
    def radius = self[:radius]
    def radius=(v) self[:radius] = v end
    def self.create_as(_points_, _count_, _radius_)
      instance = DistanceProxy.new
      instance[:points] = _points_
      instance[:count] = _count_
      instance[:radius] = _radius_
      instance
    end
  end

  class DistanceInput < FFI::Struct
    layout(
      :proxyA, DistanceProxy,
      :proxyB, DistanceProxy,
      :transformA, Transform,
      :transformB, Transform,
      :useRadii, :bool,
    )
    def proxyA = self[:proxyA]
    def proxyA=(v) self[:proxyA] = v end
    def proxyB = self[:proxyB]
    def proxyB=(v) self[:proxyB] = v end
    def transformA = self[:transformA]
    def transformA=(v) self[:transformA] = v end
    def transformB = self[:transformB]
    def transformB=(v) self[:transformB] = v end
    def useRadii = self[:useRadii]
    def useRadii=(v) self[:useRadii] = v end
    def self.create_as(_proxyA_, _proxyB_, _transformA_, _transformB_, _useRadii_)
      instance = DistanceInput.new
      instance[:proxyA] = _proxyA_
      instance[:proxyB] = _proxyB_
      instance[:transformA] = _transformA_
      instance[:transformB] = _transformB_
      instance[:useRadii] = _useRadii_
      instance
    end
  end

  class DistanceOutput < FFI::Struct
    layout(
      :pointA, Vec2,
      :pointB, Vec2,
      :distance, :float,
      :iterations, :int,
      :simplexCount, :int,
    )
    def pointA = self[:pointA]
    def pointA=(v) self[:pointA] = v end
    def pointB = self[:pointB]
    def pointB=(v) self[:pointB] = v end
    def distance = self[:distance]
    def distance=(v) self[:distance] = v end
    def iterations = self[:iterations]
    def iterations=(v) self[:iterations] = v end
    def simplexCount = self[:simplexCount]
    def simplexCount=(v) self[:simplexCount] = v end
    def self.create_as(_pointA_, _pointB_, _distance_, _iterations_, _simplexCount_)
      instance = DistanceOutput.new
      instance[:pointA] = _pointA_
      instance[:pointB] = _pointB_
      instance[:distance] = _distance_
      instance[:iterations] = _iterations_
      instance[:simplexCount] = _simplexCount_
      instance
    end
  end

  class SimplexVertex < FFI::Struct
    layout(
      :wA, Vec2,
      :wB, Vec2,
      :w, Vec2,
      :a, :float,
      :indexA, :int,
      :indexB, :int,
    )
    def wA = self[:wA]
    def wA=(v) self[:wA] = v end
    def wB = self[:wB]
    def wB=(v) self[:wB] = v end
    def w = self[:w]
    def w=(v) self[:w] = v end
    def a = self[:a]
    def a=(v) self[:a] = v end
    def indexA = self[:indexA]
    def indexA=(v) self[:indexA] = v end
    def indexB = self[:indexB]
    def indexB=(v) self[:indexB] = v end
    def self.create_as(_wA_, _wB_, _w_, _a_, _indexA_, _indexB_)
      instance = SimplexVertex.new
      instance[:wA] = _wA_
      instance[:wB] = _wB_
      instance[:w] = _w_
      instance[:a] = _a_
      instance[:indexA] = _indexA_
      instance[:indexB] = _indexB_
      instance
    end
  end

  class Simplex < FFI::Struct
    layout(
      :v1, SimplexVertex,
      :v2, SimplexVertex,
      :v3, SimplexVertex,
      :count, :int,
    )
    def v1 = self[:v1]
    def v1=(v) self[:v1] = v end
    def v2 = self[:v2]
    def v2=(v) self[:v2] = v end
    def v3 = self[:v3]
    def v3=(v) self[:v3] = v end
    def count = self[:count]
    def count=(v) self[:count] = v end
    def self.create_as(_v1_, _v2_, _v3_, _count_)
      instance = Simplex.new
      instance[:v1] = _v1_
      instance[:v2] = _v2_
      instance[:v3] = _v3_
      instance[:count] = _count_
      instance
    end
  end

  class ShapeCastPairInput < FFI::Struct
    layout(
      :proxyA, DistanceProxy,
      :proxyB, DistanceProxy,
      :transformA, Transform,
      :transformB, Transform,
      :translationB, Vec2,
      :maxFraction, :float,
    )
    def proxyA = self[:proxyA]
    def proxyA=(v) self[:proxyA] = v end
    def proxyB = self[:proxyB]
    def proxyB=(v) self[:proxyB] = v end
    def transformA = self[:transformA]
    def transformA=(v) self[:transformA] = v end
    def transformB = self[:transformB]
    def transformB=(v) self[:transformB] = v end
    def translationB = self[:translationB]
    def translationB=(v) self[:translationB] = v end
    def maxFraction = self[:maxFraction]
    def maxFraction=(v) self[:maxFraction] = v end
    def self.create_as(_proxyA_, _proxyB_, _transformA_, _transformB_, _translationB_, _maxFraction_)
      instance = ShapeCastPairInput.new
      instance[:proxyA] = _proxyA_
      instance[:proxyB] = _proxyB_
      instance[:transformA] = _transformA_
      instance[:transformB] = _transformB_
      instance[:translationB] = _translationB_
      instance[:maxFraction] = _maxFraction_
      instance
    end
  end

  class Sweep < FFI::Struct
    layout(
      :localCenter, Vec2,
      :c1, Vec2,
      :c2, Vec2,
      :q1, Rot,
      :q2, Rot,
    )
    def localCenter = self[:localCenter]
    def localCenter=(v) self[:localCenter] = v end
    def c1 = self[:c1]
    def c1=(v) self[:c1] = v end
    def c2 = self[:c2]
    def c2=(v) self[:c2] = v end
    def q1 = self[:q1]
    def q1=(v) self[:q1] = v end
    def q2 = self[:q2]
    def q2=(v) self[:q2] = v end
    def self.create_as(_localCenter_, _c1_, _c2_, _q1_, _q2_)
      instance = Sweep.new
      instance[:localCenter] = _localCenter_
      instance[:c1] = _c1_
      instance[:c2] = _c2_
      instance[:q1] = _q1_
      instance[:q2] = _q2_
      instance
    end
  end

  class TOIInput < FFI::Struct
    layout(
      :proxyA, DistanceProxy,
      :proxyB, DistanceProxy,
      :sweepA, Sweep,
      :sweepB, Sweep,
      :tMax, :float,
    )
    def proxyA = self[:proxyA]
    def proxyA=(v) self[:proxyA] = v end
    def proxyB = self[:proxyB]
    def proxyB=(v) self[:proxyB] = v end
    def sweepA = self[:sweepA]
    def sweepA=(v) self[:sweepA] = v end
    def sweepB = self[:sweepB]
    def sweepB=(v) self[:sweepB] = v end
    def tMax = self[:tMax]
    def tMax=(v) self[:tMax] = v end
    def self.create_as(_proxyA_, _proxyB_, _sweepA_, _sweepB_, _tMax_)
      instance = TOIInput.new
      instance[:proxyA] = _proxyA_
      instance[:proxyB] = _proxyB_
      instance[:sweepA] = _sweepA_
      instance[:sweepB] = _sweepB_
      instance[:tMax] = _tMax_
      instance
    end
  end

  class TOIOutput < FFI::Struct
    layout(
      :state, :int,
      :t, :float,
    )
    def state = self[:state]
    def state=(v) self[:state] = v end
    def t = self[:t]
    def t=(v) self[:t] = v end
    def self.create_as(_state_, _t_)
      instance = TOIOutput.new
      instance[:state] = _state_
      instance[:t] = _t_
      instance
    end
  end

  class ManifoldPoint < FFI::Struct
    layout(
      :point, Vec2,
      :anchorA, Vec2,
      :anchorB, Vec2,
      :separation, :float,
      :normalImpulse, :float,
      :tangentImpulse, :float,
      :maxNormalImpulse, :float,
      :normalVelocity, :float,
      :id, :ushort,
      :persisted, :bool,
    )
    def point = self[:point]
    def point=(v) self[:point] = v end
    def anchorA = self[:anchorA]
    def anchorA=(v) self[:anchorA] = v end
    def anchorB = self[:anchorB]
    def anchorB=(v) self[:anchorB] = v end
    def separation = self[:separation]
    def separation=(v) self[:separation] = v end
    def normalImpulse = self[:normalImpulse]
    def normalImpulse=(v) self[:normalImpulse] = v end
    def tangentImpulse = self[:tangentImpulse]
    def tangentImpulse=(v) self[:tangentImpulse] = v end
    def maxNormalImpulse = self[:maxNormalImpulse]
    def maxNormalImpulse=(v) self[:maxNormalImpulse] = v end
    def normalVelocity = self[:normalVelocity]
    def normalVelocity=(v) self[:normalVelocity] = v end
    def id = self[:id]
    def id=(v) self[:id] = v end
    def persisted = self[:persisted]
    def persisted=(v) self[:persisted] = v end
    def self.create_as(_point_, _anchorA_, _anchorB_, _separation_, _normalImpulse_, _tangentImpulse_, _maxNormalImpulse_, _normalVelocity_, _id_, _persisted_)
      instance = ManifoldPoint.new
      instance[:point] = _point_
      instance[:anchorA] = _anchorA_
      instance[:anchorB] = _anchorB_
      instance[:separation] = _separation_
      instance[:normalImpulse] = _normalImpulse_
      instance[:tangentImpulse] = _tangentImpulse_
      instance[:maxNormalImpulse] = _maxNormalImpulse_
      instance[:normalVelocity] = _normalVelocity_
      instance[:id] = _id_
      instance[:persisted] = _persisted_
      instance
    end
  end

  class Manifold < FFI::Struct
    layout(
      :points, [ManifoldPoint, 2],
      :normal, Vec2,
      :pointCount, :int,
    )
    def points = self[:points]
    def points=(v) self[:points] = v end
    def normal = self[:normal]
    def normal=(v) self[:normal] = v end
    def pointCount = self[:pointCount]
    def pointCount=(v) self[:pointCount] = v end
    def self.create_as(_points_, _normal_, _pointCount_)
      instance = Manifold.new
      instance[:points] = _points_
      instance[:normal] = _normal_
      instance[:pointCount] = _pointCount_
      instance
    end
  end

  class DynamicTree < FFI::Struct
    layout(
      :nodes, :pointer,
      :root, :int,
      :nodeCount, :int,
      :nodeCapacity, :int,
      :freeList, :int,
      :proxyCount, :int,
      :leafIndices, :pointer,
      :leafBoxes, :pointer,
      :leafCenters, :pointer,
      :binIndices, :pointer,
      :rebuildCapacity, :int,
    )
    def nodes = self[:nodes]
    def nodes=(v) self[:nodes] = v end
    def root = self[:root]
    def root=(v) self[:root] = v end
    def nodeCount = self[:nodeCount]
    def nodeCount=(v) self[:nodeCount] = v end
    def nodeCapacity = self[:nodeCapacity]
    def nodeCapacity=(v) self[:nodeCapacity] = v end
    def freeList = self[:freeList]
    def freeList=(v) self[:freeList] = v end
    def proxyCount = self[:proxyCount]
    def proxyCount=(v) self[:proxyCount] = v end
    def leafIndices = self[:leafIndices]
    def leafIndices=(v) self[:leafIndices] = v end
    def leafBoxes = self[:leafBoxes]
    def leafBoxes=(v) self[:leafBoxes] = v end
    def leafCenters = self[:leafCenters]
    def leafCenters=(v) self[:leafCenters] = v end
    def binIndices = self[:binIndices]
    def binIndices=(v) self[:binIndices] = v end
    def rebuildCapacity = self[:rebuildCapacity]
    def rebuildCapacity=(v) self[:rebuildCapacity] = v end
    def self.create_as(_nodes_, _root_, _nodeCount_, _nodeCapacity_, _freeList_, _proxyCount_, _leafIndices_, _leafBoxes_, _leafCenters_, _binIndices_, _rebuildCapacity_)
      instance = DynamicTree.new
      instance[:nodes] = _nodes_
      instance[:root] = _root_
      instance[:nodeCount] = _nodeCount_
      instance[:nodeCapacity] = _nodeCapacity_
      instance[:freeList] = _freeList_
      instance[:proxyCount] = _proxyCount_
      instance[:leafIndices] = _leafIndices_
      instance[:leafBoxes] = _leafBoxes_
      instance[:leafCenters] = _leafCenters_
      instance[:binIndices] = _binIndices_
      instance[:rebuildCapacity] = _rebuildCapacity_
      instance
    end
  end

  class TreeStats < FFI::Struct
    layout(
      :nodeVisits, :int,
      :leafVisits, :int,
    )
    def nodeVisits = self[:nodeVisits]
    def nodeVisits=(v) self[:nodeVisits] = v end
    def leafVisits = self[:leafVisits]
    def leafVisits=(v) self[:leafVisits] = v end
    def self.create_as(_nodeVisits_, _leafVisits_)
      instance = TreeStats.new
      instance[:nodeVisits] = _nodeVisits_
      instance[:leafVisits] = _leafVisits_
      instance
    end
  end


  # Function

  def self.setup_collision_symbols(output_error = false)
    symbols = [
      :b2IsValidRay,
      :b2MakePolygon,
      :b2MakeOffsetPolygon,
      :b2MakeOffsetRoundedPolygon,
      :b2MakeSquare,
      :b2MakeBox,
      :b2MakeRoundedBox,
      :b2MakeOffsetBox,
      :b2MakeOffsetRoundedBox,
      :b2TransformPolygon,
      :b2ComputeCircleMass,
      :b2ComputeCapsuleMass,
      :b2ComputePolygonMass,
      :b2ComputeCircleAABB,
      :b2ComputeCapsuleAABB,
      :b2ComputePolygonAABB,
      :b2ComputeSegmentAABB,
      :b2PointInCircle,
      :b2PointInCapsule,
      :b2PointInPolygon,
      :b2RayCastCircle,
      :b2RayCastCapsule,
      :b2RayCastSegment,
      :b2RayCastPolygon,
      :b2ShapeCastCircle,
      :b2ShapeCastCapsule,
      :b2ShapeCastSegment,
      :b2ShapeCastPolygon,
      :b2ComputeHull,
      :b2ValidateHull,
      :b2SegmentDistance,
      :b2ShapeDistance,
      :b2ShapeCast,
      :b2MakeProxy,
      :b2GetSweepTransform,
      :b2TimeOfImpact,
      :b2CollideCircles,
      :b2CollideCapsuleAndCircle,
      :b2CollideSegmentAndCircle,
      :b2CollidePolygonAndCircle,
      :b2CollideCapsules,
      :b2CollideSegmentAndCapsule,
      :b2CollidePolygonAndCapsule,
      :b2CollidePolygons,
      :b2CollideSegmentAndPolygon,
      :b2CollideChainSegmentAndCircle,
      :b2CollideChainSegmentAndCapsule,
      :b2CollideChainSegmentAndPolygon,
      :b2DynamicTree_Create,
      :b2DynamicTree_Destroy,
      :b2DynamicTree_CreateProxy,
      :b2DynamicTree_DestroyProxy,
      :b2DynamicTree_MoveProxy,
      :b2DynamicTree_EnlargeProxy,
      :b2DynamicTree_Query,
      :b2DynamicTree_RayCast,
      :b2DynamicTree_ShapeCast,
      :b2DynamicTree_Validate,
      :b2DynamicTree_GetHeight,
      :b2DynamicTree_GetAreaRatio,
      :b2DynamicTree_GetProxyCount,
      :b2DynamicTree_Rebuild,
      :b2DynamicTree_GetByteCount,
    ]
    apis = {
      :b2IsValidRay => :IsValidRay,
      :b2MakePolygon => :MakePolygon,
      :b2MakeOffsetPolygon => :MakeOffsetPolygon,
      :b2MakeOffsetRoundedPolygon => :MakeOffsetRoundedPolygon,
      :b2MakeSquare => :MakeSquare,
      :b2MakeBox => :MakeBox,
      :b2MakeRoundedBox => :MakeRoundedBox,
      :b2MakeOffsetBox => :MakeOffsetBox,
      :b2MakeOffsetRoundedBox => :MakeOffsetRoundedBox,
      :b2TransformPolygon => :TransformPolygon,
      :b2ComputeCircleMass => :ComputeCircleMass,
      :b2ComputeCapsuleMass => :ComputeCapsuleMass,
      :b2ComputePolygonMass => :ComputePolygonMass,
      :b2ComputeCircleAABB => :ComputeCircleAABB,
      :b2ComputeCapsuleAABB => :ComputeCapsuleAABB,
      :b2ComputePolygonAABB => :ComputePolygonAABB,
      :b2ComputeSegmentAABB => :ComputeSegmentAABB,
      :b2PointInCircle => :PointInCircle,
      :b2PointInCapsule => :PointInCapsule,
      :b2PointInPolygon => :PointInPolygon,
      :b2RayCastCircle => :RayCastCircle,
      :b2RayCastCapsule => :RayCastCapsule,
      :b2RayCastSegment => :RayCastSegment,
      :b2RayCastPolygon => :RayCastPolygon,
      :b2ShapeCastCircle => :ShapeCastCircle,
      :b2ShapeCastCapsule => :ShapeCastCapsule,
      :b2ShapeCastSegment => :ShapeCastSegment,
      :b2ShapeCastPolygon => :ShapeCastPolygon,
      :b2ComputeHull => :ComputeHull,
      :b2ValidateHull => :ValidateHull,
      :b2SegmentDistance => :SegmentDistance,
      :b2ShapeDistance => :ShapeDistance,
      :b2ShapeCast => :ShapeCast,
      :b2MakeProxy => :MakeProxy,
      :b2GetSweepTransform => :GetSweepTransform,
      :b2TimeOfImpact => :TimeOfImpact,
      :b2CollideCircles => :CollideCircles,
      :b2CollideCapsuleAndCircle => :CollideCapsuleAndCircle,
      :b2CollideSegmentAndCircle => :CollideSegmentAndCircle,
      :b2CollidePolygonAndCircle => :CollidePolygonAndCircle,
      :b2CollideCapsules => :CollideCapsules,
      :b2CollideSegmentAndCapsule => :CollideSegmentAndCapsule,
      :b2CollidePolygonAndCapsule => :CollidePolygonAndCapsule,
      :b2CollidePolygons => :CollidePolygons,
      :b2CollideSegmentAndPolygon => :CollideSegmentAndPolygon,
      :b2CollideChainSegmentAndCircle => :CollideChainSegmentAndCircle,
      :b2CollideChainSegmentAndCapsule => :CollideChainSegmentAndCapsule,
      :b2CollideChainSegmentAndPolygon => :CollideChainSegmentAndPolygon,
      :b2DynamicTree_Create => :DynamicTree_Create,
      :b2DynamicTree_Destroy => :DynamicTree_Destroy,
      :b2DynamicTree_CreateProxy => :DynamicTree_CreateProxy,
      :b2DynamicTree_DestroyProxy => :DynamicTree_DestroyProxy,
      :b2DynamicTree_MoveProxy => :DynamicTree_MoveProxy,
      :b2DynamicTree_EnlargeProxy => :DynamicTree_EnlargeProxy,
      :b2DynamicTree_Query => :DynamicTree_Query,
      :b2DynamicTree_RayCast => :DynamicTree_RayCast,
      :b2DynamicTree_ShapeCast => :DynamicTree_ShapeCast,
      :b2DynamicTree_Validate => :DynamicTree_Validate,
      :b2DynamicTree_GetHeight => :DynamicTree_GetHeight,
      :b2DynamicTree_GetAreaRatio => :DynamicTree_GetAreaRatio,
      :b2DynamicTree_GetProxyCount => :DynamicTree_GetProxyCount,
      :b2DynamicTree_Rebuild => :DynamicTree_Rebuild,
      :b2DynamicTree_GetByteCount => :DynamicTree_GetByteCount,
    }
    args = {
      :b2IsValidRay => [:pointer],
      :b2MakePolygon => [:pointer, :float],
      :b2MakeOffsetPolygon => [:pointer, Vec2.by_value, Rot.by_value],
      :b2MakeOffsetRoundedPolygon => [:pointer, Vec2.by_value, Rot.by_value, :float],
      :b2MakeSquare => [:float],
      :b2MakeBox => [:float, :float],
      :b2MakeRoundedBox => [:float, :float, :float],
      :b2MakeOffsetBox => [:float, :float, Vec2.by_value, Rot.by_value],
      :b2MakeOffsetRoundedBox => [:float, :float, Vec2.by_value, Rot.by_value, :float],
      :b2TransformPolygon => [Transform.by_value, :pointer],
      :b2ComputeCircleMass => [:pointer, :float],
      :b2ComputeCapsuleMass => [:pointer, :float],
      :b2ComputePolygonMass => [:pointer, :float],
      :b2ComputeCircleAABB => [:pointer, Transform.by_value],
      :b2ComputeCapsuleAABB => [:pointer, Transform.by_value],
      :b2ComputePolygonAABB => [:pointer, Transform.by_value],
      :b2ComputeSegmentAABB => [:pointer, Transform.by_value],
      :b2PointInCircle => [Vec2.by_value, :pointer],
      :b2PointInCapsule => [Vec2.by_value, :pointer],
      :b2PointInPolygon => [Vec2.by_value, :pointer],
      :b2RayCastCircle => [:pointer, :pointer],
      :b2RayCastCapsule => [:pointer, :pointer],
      :b2RayCastSegment => [:pointer, :pointer, :bool],
      :b2RayCastPolygon => [:pointer, :pointer],
      :b2ShapeCastCircle => [:pointer, :pointer],
      :b2ShapeCastCapsule => [:pointer, :pointer],
      :b2ShapeCastSegment => [:pointer, :pointer],
      :b2ShapeCastPolygon => [:pointer, :pointer],
      :b2ComputeHull => [:pointer, :int],
      :b2ValidateHull => [:pointer],
      :b2SegmentDistance => [Vec2.by_value, Vec2.by_value, Vec2.by_value, Vec2.by_value],
      :b2ShapeDistance => [:pointer, :pointer, :pointer, :int],
      :b2ShapeCast => [:pointer],
      :b2MakeProxy => [:pointer, :int, :float],
      :b2GetSweepTransform => [:pointer, :float],
      :b2TimeOfImpact => [:pointer],
      :b2CollideCircles => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollideCapsuleAndCircle => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollideSegmentAndCircle => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollidePolygonAndCircle => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollideCapsules => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollideSegmentAndCapsule => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollidePolygonAndCapsule => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollidePolygons => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollideSegmentAndPolygon => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollideChainSegmentAndCircle => [:pointer, Transform.by_value, :pointer, Transform.by_value],
      :b2CollideChainSegmentAndCapsule => [:pointer, Transform.by_value, :pointer, Transform.by_value, :pointer],
      :b2CollideChainSegmentAndPolygon => [:pointer, Transform.by_value, :pointer, Transform.by_value, :pointer],
      :b2DynamicTree_Create => [],
      :b2DynamicTree_Destroy => [:pointer],
      :b2DynamicTree_CreateProxy => [:pointer, AABB.by_value, :ulong_long, :int],
      :b2DynamicTree_DestroyProxy => [:pointer, :int],
      :b2DynamicTree_MoveProxy => [:pointer, :int, AABB.by_value],
      :b2DynamicTree_EnlargeProxy => [:pointer, :int, AABB.by_value],
      :b2DynamicTree_Query => [:pointer, AABB.by_value, :ulong_long, :pointer, :pointer],
      :b2DynamicTree_RayCast => [:pointer, :pointer, :ulong_long, :pointer, :pointer],
      :b2DynamicTree_ShapeCast => [:pointer, :pointer, :ulong_long, :pointer, :pointer],
      :b2DynamicTree_Validate => [:pointer],
      :b2DynamicTree_GetHeight => [:pointer],
      :b2DynamicTree_GetAreaRatio => [:pointer],
      :b2DynamicTree_GetProxyCount => [:pointer],
      :b2DynamicTree_Rebuild => [:pointer, :bool],
      :b2DynamicTree_GetByteCount => [:pointer],
    }
    retvals = {
      :b2IsValidRay => :bool,
      :b2MakePolygon => Polygon.by_value,
      :b2MakeOffsetPolygon => Polygon.by_value,
      :b2MakeOffsetRoundedPolygon => Polygon.by_value,
      :b2MakeSquare => Polygon.by_value,
      :b2MakeBox => Polygon.by_value,
      :b2MakeRoundedBox => Polygon.by_value,
      :b2MakeOffsetBox => Polygon.by_value,
      :b2MakeOffsetRoundedBox => Polygon.by_value,
      :b2TransformPolygon => Polygon.by_value,
      :b2ComputeCircleMass => MassData.by_value,
      :b2ComputeCapsuleMass => MassData.by_value,
      :b2ComputePolygonMass => MassData.by_value,
      :b2ComputeCircleAABB => AABB.by_value,
      :b2ComputeCapsuleAABB => AABB.by_value,
      :b2ComputePolygonAABB => AABB.by_value,
      :b2ComputeSegmentAABB => AABB.by_value,
      :b2PointInCircle => :bool,
      :b2PointInCapsule => :bool,
      :b2PointInPolygon => :bool,
      :b2RayCastCircle => CastOutput.by_value,
      :b2RayCastCapsule => CastOutput.by_value,
      :b2RayCastSegment => CastOutput.by_value,
      :b2RayCastPolygon => CastOutput.by_value,
      :b2ShapeCastCircle => CastOutput.by_value,
      :b2ShapeCastCapsule => CastOutput.by_value,
      :b2ShapeCastSegment => CastOutput.by_value,
      :b2ShapeCastPolygon => CastOutput.by_value,
      :b2ComputeHull => Hull.by_value,
      :b2ValidateHull => :bool,
      :b2SegmentDistance => SegmentDistanceResult.by_value,
      :b2ShapeDistance => DistanceOutput.by_value,
      :b2ShapeCast => CastOutput.by_value,
      :b2MakeProxy => DistanceProxy.by_value,
      :b2GetSweepTransform => Transform.by_value,
      :b2TimeOfImpact => TOIOutput.by_value,
      :b2CollideCircles => Manifold.by_value,
      :b2CollideCapsuleAndCircle => Manifold.by_value,
      :b2CollideSegmentAndCircle => Manifold.by_value,
      :b2CollidePolygonAndCircle => Manifold.by_value,
      :b2CollideCapsules => Manifold.by_value,
      :b2CollideSegmentAndCapsule => Manifold.by_value,
      :b2CollidePolygonAndCapsule => Manifold.by_value,
      :b2CollidePolygons => Manifold.by_value,
      :b2CollideSegmentAndPolygon => Manifold.by_value,
      :b2CollideChainSegmentAndCircle => Manifold.by_value,
      :b2CollideChainSegmentAndCapsule => Manifold.by_value,
      :b2CollideChainSegmentAndPolygon => Manifold.by_value,
      :b2DynamicTree_Create => DynamicTree.by_value,
      :b2DynamicTree_Destroy => :void,
      :b2DynamicTree_CreateProxy => :int,
      :b2DynamicTree_DestroyProxy => :void,
      :b2DynamicTree_MoveProxy => :void,
      :b2DynamicTree_EnlargeProxy => :void,
      :b2DynamicTree_Query => TreeStats.by_value,
      :b2DynamicTree_RayCast => TreeStats.by_value,
      :b2DynamicTree_ShapeCast => TreeStats.by_value,
      :b2DynamicTree_Validate => :void,
      :b2DynamicTree_GetHeight => :int,
      :b2DynamicTree_GetAreaRatio => :float,
      :b2DynamicTree_GetProxyCount => :int,
      :b2DynamicTree_Rebuild => :int,
      :b2DynamicTree_GetByteCount => :int,
    }
    symbols.each do |sym|
      begin
        attach_function apis[sym], sym, args[sym], retvals[sym]
      rescue FFI::NotFoundError => error
        $stderr.puts("[Warning] Failed to import #{sym} (#{error}).") if output_error
      end
    end
  end

end

