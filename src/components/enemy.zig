const std = @import("std");
const ecs = @import("ecs");

pub const EnemyPool = struct {
    enemies: std.ArrayList(ecs.Entity),

    pub fn init(allocator: std.mem.Allocator) EnemyPool {
        return .{ .enemies = std.ArrayList(ecs.Entity).init(allocator) };
    }

    pub fn deinit(self: EnemyPool) void {
        self.enemies.deinit();
    }
};
