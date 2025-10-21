const rl = @import("raylib");
const ecs = @import("ecs");
const std = @import("std");
const state = @import("state.zig");
const core = @import("../core.zig");
const systems = @import("../systems/player_movement.zig");

const Transition = core.Transition;
const State = state.State;
const Allocator = std.mem.Allocator;

pub const Explore = struct {
    allocator: Allocator,
    registry: *ecs.Registry,

    const Self = @This();

    pub fn init(allocator: Allocator, registry: *ecs.Registry) Self {
        return Explore{ .allocator = allocator, .registry = registry };
    }

    fn update(context: *anyopaque) Transition {
        const self: *Self = @ptrCast(@alignCast(context));
        return systems.PlayerMovementWorldSystem(self.registry);
    }

    pub fn destroy(context: *anyopaque) void {
        const self: *Self = @ptrCast(@alignCast(context));
        self.allocator.destroy(self);
    }

    pub fn createState(registry: *ecs.Registry) !State {
        const allocator = registry.allocator;
        const s = try allocator.create(Self);
        s.* = Self.init(allocator, registry);
        return s.state();
    }

    pub fn state(self: *Self) State {
        return .{
            .ptr = self,
            .vtable = &.{ .update = update, .destroy = destroy },
        };
    }
};
