module Raylib
  # Color helper
  class Color
    def self.from_u32(rgba = 255)
      r = (rgba >> 24) & 0xFF
      g = (rgba >> 16) & 0xFF
      b = (rgba >>  8) & 0xFF
      a = (rgba >>  0) & 0xFF
      Color.new.set(r, g, b, a)
    end

    def self.set(rgba)
      self[:r] = (rgba >> 24) & 0xFF
      self[:g] = (rgba >> 16) & 0xFF
      self[:b] = (rgba >>  8) & 0xFF
      self[:a] = (rgba >>  0) & 0xFF
      self
    end
  end
end

class RaylibDebugDraw
  attr_accessor :debug_draw

  def set_scale(s)
    @@scale = s
  end

  def get_scale
    @@scale
  end

  @@scale = 1.0

  @@draw_polygon_fcn = FFI::Function.new(:void, %i[pointer int32 int32 pointer]) do |vertices, vertexCount, radius, color, context|
    p 'polygon'
  end

  @@draw_solid_polygon_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :pointer, :int32, :float, :int32, :pointer]) do |transform, vertices, vertexCount, radius, color, context|
    points = []
    vertexCount.times do |i|
      vert = Box2D::Vec2.new(vertices + i * Box2D::Vec2.size)
      points <<  (@@scale * (transform.q.c * vert.x - transform.q.s * vert.y) + @@scale * transform.p.x)
      points <<  (@@scale * (-transform.q.s * vert.x - transform.q.c * vert.y) - @@scale * transform.p.y)
    end
    points << points[0]
    points << points[1]
    Raylib::DrawLineStrip(points.pack('F*'), vertexCount + 1, Raylib::Color.from_u32(color))
  end

  @@draw_circle_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :float, :int32, :pointer]) do |center, radius, color, context|
    Raylib::DrawCircle(center.p.x * @@scale, -center.p.y * @@scale, radius * @@scale, Raylib::Color.from_u32(color))
  end

  @@draw_solid_circle_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :float, :int32, :pointer]) do |center, radius, color, context|
    Raylib::DrawCircle(center.p.x * @@scale, -center.p.y * @@scale, radius * @@scale, Raylib::Color.from_u32(color))
  end

  @@draw_solid_capsule_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, Box2D::Vec2.by_value, :float, :int32, :pointer]) do |p1, p2, radius, color, context|
    raylib_color = Raylib::Color.from_u32(color)
    Raylib::DrawCircleLines(@@scale * p1.x, -@@scale * p1.y, @@scale * radius, raylib_color)
    Raylib::DrawCircleLines(@@scale * p2.x, -@@scale * p2.y, @@scale * radius, raylib_color)
    dir = Raylib.Vector2Subtract(Raylib::Vector2.create(p2.x, p2.y), Raylib::Vector2.create(p1.x, p1.y))
    len = Raylib.Vector2LengthSqr(dir)
    return if len <= 1e-6

    dir = Raylib.Vector2Normalize(dir)
    side0dir_x = -dir.y * radius
    side0dir_y = dir.x * radius
    side1dir_x = dir.y * radius
    side1dir_y = -dir.x * radius
    Raylib::DrawLine(@@scale * (p1.x + side0dir_x), -@@scale * (p1.y + side0dir_y), @@scale * (p2.x + side0dir_x), -@@scale * (p2.y + side0dir_y), raylib_color)
    Raylib::DrawLine(@@scale * (p1.x + side1dir_x), -@@scale * (p1.y + side1dir_y), @@scale * (p2.x + side1dir_x), -@@scale * (p2.y + side1dir_y), raylib_color)
  end

  @@draw_segment_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, Box2D::Vec2.by_value, :int32, :pointer]) do |p1, p2, color, context|
    Raylib.DrawLine(p1.x * @@scale, -p1.y * @@scale, p2.x * @@scale, -p2.y * @@scale, Raylib::Color.from_u32(color))
  end

  @@draw_transform_fcn = FFI::Function.new(:void, [Box2D::Transform.by_value, :pointer]) do |transform, context|
    p 'transform'
  end

  @@draw_point_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :float, :int32, :pointer]) do |p, size, color, context|
    Raylib.DrawCircle(p.x * @@scale, -p.y * @@scale, 5.0, Raylib::Color.from_u32(color))
  end

  @@draw_string_fcn = FFI::Function.new(:void, [Box2D::Vec2.by_value, :pointer, :pointer]) do |p, s, context|
    p 'string'
  end

  def initialize
    @debug_draw = Box2D::DebugDraw.new

    @debug_draw.DrawPolygon = @@draw_polygon_fcn
    @debug_draw.DrawSolidPolygon = @@draw_solid_polygon_fcn
    @debug_draw.DrawCircle = @@draw_circle_fcn
    @debug_draw.DrawSolidCircle = @@draw_solid_circle_fcn
    @debug_draw.DrawSolidCapsule = @@draw_solid_capsule_fcn
    @debug_draw.DrawSegment = @@draw_segment_fcn
    @debug_draw.DrawTransform = @@draw_transform_fcn
    @debug_draw.DrawPoint = @@draw_point_fcn
    @debug_draw.DrawString = @@draw_string_fcn

    @debug_draw.useDrawingBounds = false
    @debug_draw.drawShapes = true
    @debug_draw.drawJoints = true
  end
end

