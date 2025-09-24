const std = @import("std");
const marvin_game = @import("marvin_game");
const rl = @import("raylib");
const g = @import("game.zig");
const consts = @import("const.zig");

pub fn main() !void {
    rl.initWindow(consts.MAP_WIDTH * consts.TILE_SIZE, consts.MAP_HEIGHT * consts.TILE_SIZE, "Raylib 2D ASCII RPG");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var game = try g.Game.init(allocator);

    game.startUp();
    defer game.shutDown();

    while (!rl.windowShouldClose()) {
        game.update();
        game.draw();
    }
}
