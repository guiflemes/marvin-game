const game = @import("game.zig");
const rl = @import("raylib");
const ecs = @import("ecs");
const m = @import("map.zig");
const systems = @import("systems.zig");

pub const Vtable = struct {
    update: *const fn (*anyopaque) void,
    exit: *const fn (*anyopaque) void,
    enter: *const fn (*anyopaque) void,
};

pub const State = struct {
    ptr: *anyopaque,
    vtable: *const Vtable,

    pub fn update(self: State) void {
        self.vtable.update(self.ptr);
    }

    pub fn exit(self: State) void {
        _ = self;
    }

    pub fn enter(self: State) void {
        _ = self;
    }
};

pub const Explore = struct {
    registry: *ecs.Registry,

    const Self = @This();

    pub fn init(registry: *ecs.Registry) Explore {
        return Explore{ .registry = registry };
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

    pub fn state(self: *Self) State {
        return .{
            .ptr = self,
            .vtable = &.{ .update = update, .enter = enter, .exit = exit },
        };
    }
};
