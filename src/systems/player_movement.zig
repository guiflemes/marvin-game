const rl = @import("raylib");
const ecs = @import("ecs");
const std = @import("std");
const core = @import("../core.zig");
const m = @import("../world/map.zig");
const components = @import("../components/components.zig");

const Position = components.Position;
const PlayerTag = components.PlayerTag;
const Transition = core.Transition;

pub fn PlayerMovementWorldSystem(registry: *ecs.Registry) Transition {
    var map: *m.TileMap = registry.singletons().get(m.TileMap);

    var view = registry.view(.{ Position, PlayerTag }, .{});
    var iter = view.entityIterator();
    while (iter.next()) |e| {
        var player = view.get(Position, e);
        if (rl.isKeyPressed(rl.KeyboardKey.right) and !map.isObstacle(player.y, player.x + 1)) {
            player.right(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.left) and !map.isObstacle(player.y, player.x - 1)) {
            player.left(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.down) and !map.isObstacle(player.y + 1, player.x)) {
            player.down(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.up) and !map.isObstacle(player.y - 1, player.x)) {
            player.up(1);
        }

        if (map.isEnemy(player.y, player.x)) {
            return .{ .to = .Battle };
        }
    }

    return .none;
}
