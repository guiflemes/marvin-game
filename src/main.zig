const std = @import("std");
const marvin_game = @import("marvin_game");
const rl = @import("raylib");
const g = @import("game.zig");
const core = @import("core.zig");
const Dispatcher = @import("./events/dispatcher.zig").Dispatcher;

pub fn main() !void {
    rl.initWindow(core.MAP_WIDTH * core.TILE_SIZE, core.MAP_HEIGHT * core.TILE_SIZE, "marvin game RPG");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();

    var disp = Dispatcher(100).init(allocator);
    var game = g.GameRunner.init(allocator, &disp);

    game.startUp();
    defer {
        game.shutDown();
        const leaked = gpa.detectLeaks();
        std.debug.print("Memory leaked detected: {any}\n", .{leaked});
    }

    while (!rl.windowShouldClose()) {
        game.update();

        if (game.shouldExit()) {
            break;
        }
    }
}
