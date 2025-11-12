const std = @import("std");
const rl = @import("raylib");

pub const Map = struct {
    ptr: *const anyopaque,
    vtable: Vtable,

    pub const Vtable = struct {
        is_obstacle: *const fn (*const anyopaque, f32, f32) bool,
        destroy: *const fn (*const anyopaque) void,
        draw: *const fn (*const anyopaque, rl.Vector2) void,
    };

    pub fn destroy(self: Map) void {
        self.vtable.destroy(self.ptr);
    }

    pub fn is_obstacle(self: Map, y: f32, x: f32) bool {
        return self.vtable.is_obstacle(self.ptr, y, x);
    }

    pub fn draw(self: Map, pos: rl.Vector2) void {
        self.vtable.draw(self.ptr, pos);
    }
};
