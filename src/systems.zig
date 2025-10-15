const rl = @import("raylib");
const consts = @import("const.zig");
const fonts = @import("font.zig");
const ecs = @import("ecs");
const types = @import("types.zig");
const m = @import("map.zig");
const state = @import("state.zig");
const std = @import("std");

const MAP_HEIGHT = consts.MAP_HEIGHT;
const MAP_WIDTH = consts.MAP_HEIGHT;
const TILE_SIZE = consts.TILE_SIZE;

const Position = types.Position;
const Renderable = types.Renderable;
const PlayerTag = types.PlayerTag;

pub fn PlayerRenderSystem(registry: *ecs.Registry, origin: rl.Vector2) void {
    var view = registry.view(.{ Position, Renderable, PlayerTag }, .{});
    var iter = view.entityIterator();
    while (iter.next()) |e| {
        const pos: Position = view.getConst(Position, e);
        const rend: Renderable = view.getConst(Renderable, e);

        const screenPos = rl.Vector2{ .x = origin.x + pos.x * TILE_SIZE, .y = origin.y + pos.y * TILE_SIZE };
        rl.drawTextEx(rend.font.raylibFont, "@", screenPos, rend.font.size, 0, rend.color);
    }
}

pub fn MapRenderSystem(registry: *ecs.Registry, origin: rl.Vector2) void {
    const world = registry.singletons().get(m.TileMap);

    for (0..MAP_HEIGHT) |y| {
        for (0..MAP_WIDTH) |x| {
            const tile = world.data[y][x];
            const tileColor = getTileColor(tile);

            const pos = rl.Vector2{
                .x = origin.x + @as(f32, @floatFromInt(x)) * TILE_SIZE + 8.0,
                .y = origin.y + @as(f32, @floatFromInt(y)) * TILE_SIZE + 6.0,
            };

            rl.drawTextEx(world.font.raylibFont, rl.textFormat("%c", .{tile}), pos, world.font.size, 0, tileColor);
        }
    }
}

pub fn PlayerMovementWorldSystem(registry: *ecs.Registry) void {
    var map: *m.TileMap = registry.singletons().get(m.TileMap);
    // const currentState = registry.singletons().get(state.State);
    // std.debug.print("currentState: {s}\n", .{currentState.name()});

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
    }
}

pub fn getTileColor(tile: u8) rl.Color {
    switch (tile) {
        '#' => return rl.Color.gray,
        '.' => return rl.Color.dark_green,
        '^' => return rl.Color.brown,
        '~' => return rl.Color.blue,
        else => return rl.Color.white,
    }
}
