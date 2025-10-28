const rl = @import("raylib");
const core = @import("../core.zig");
const ecs = @import("ecs");
const std = @import("std");
const Allocator = std.mem.Allocator;

pub const PlayerTag = struct {};
pub const EnemyTag = struct {};

pub const Position = struct {
    x: f32,
    y: f32,

    pub fn up(self: *Position, step: f32) void {
        self.y -= step;
    }

    pub fn down(self: *Position, step: f32) void {
        self.y += step;
    }

    pub fn left(self: *Position, step: f32) void {
        self.x -= step;
    }

    pub fn right(self: *Position, step: f32) void {
        self.x += step;
    }
};

pub const Renderable = struct {
    font: core.Font,
    text: []const u8,
    color: rl.Color,
};

pub const Health = struct {
    current: i32,
    max: i32,
};

pub const Attack = struct {
    power: i32,
};

pub const EnemyPool = struct {
    enemies: std.ArrayList(ecs.Entity),

    pub fn init(allocator: Allocator) EnemyPool {
        return .{ .enemies = std.ArrayList(ecs.Entity).init(allocator) };
    }

    pub fn deinit(self: EnemyPool) void {
        self.enemies.deinit();
    }
};
