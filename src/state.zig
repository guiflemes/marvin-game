const game = @import("game.zig");
const rl = @import("raylib");
const ecs = @import("ecs");
const m = @import("map.zig");
const p = @import("player.zig");

const Map = m.Map;
const Player = p.Player;

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

    fn update(context: *anyopaque) void {
        const self: *Self = @ptrCast(@alignCast(context));

        var player: *Player = self.registry.singletons().get(Player);
        var map: *Map = self.registry.singletons().get(Map);

        if (rl.isKeyPressed(rl.KeyboardKey.right) and !map.isObstacle(player.y, player.x + 1)) {
            player.x += 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.left) and !map.isObstacle(player.y, player.x - 1)) {
            player.x -= 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.down) and !map.isObstacle(player.y + 1, player.x)) {
            player.y += 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.up) and !map.isObstacle(player.y - 1, player.x)) {
            player.y -= 1;
        }
    }

    pub fn state(self: *Self) State {
        return .{
            .ptr = self,
            .vtable = &.{ .update = update },
        };
    }
};
