const game = @import("game.zig");
const rl = @import("raylib");
const ecs = @import("ecs");
const m = @import("map.zig");
const systems = @import("systems.zig");
const std = @import("std");
const Allocator = std.mem.Allocator;

pub const State = struct {
    ptr: *anyopaque,
    vtable: *const Vtable,

    pub const Vtable = struct {
        name: []const u8,
        update: *const fn (*anyopaque) void,
        exit: *const fn (*anyopaque) void,
        enter: *const fn (*anyopaque) void,
        destroy: *const fn (*anyopaque) void,
    };

    pub fn update(self: State) void {
        self.vtable.update(self.ptr);
    }

    pub fn exit(self: State) void {
        _ = self;
    }

    pub fn enter(self: State) void {
        _ = self;
    }

    pub fn name(self: State) []const u8 {
        return self.vtable.name;
    }

    pub fn destroy(self: State) void {
        self.vtable.destroy(self.ptr);
    }
};

pub const Explore = struct {
    allocator: Allocator,
    registry: *ecs.Registry,

    const Self = @This();

    pub fn init(allocator: Allocator, registry: *ecs.Registry) Self {
        return Explore{ .allocator = allocator, .registry = registry };
    }

    pub fn exit(context: *anyopaque) void {
        _ = context;
    }

    pub fn enter(context: *anyopaque) void {
        _ = context;
    }

    fn update(context: *anyopaque) void {
        const self: *Self = @ptrCast(@alignCast(context));
        systems.PlayerMovementWorldSystem(self.registry);
    }

    pub fn create(registry: *ecs.Registry) !*Self {
        const allocator = registry.allocator;
        const s = try allocator.create(Self);
        s.* = Self.init(allocator, registry);
        return s;
    }

    pub fn destroy(context: *anyopaque) void {
        const self: *Self = @ptrCast(@alignCast(context));
        self.allocator.destroy(self);
    }

    pub fn state(self: *Self) State {
        return .{
            .ptr = self,
            .vtable = &.{ .update = update, .enter = enter, .exit = exit, .name = "Explore", .destroy = destroy },
        };
    }
};

pub fn loadInitialState(registry: *ecs.Registry) void {
    var s = Explore.create(registry) catch @panic("error allocating inital state");
    registry.singletons().add(s.state());
}
