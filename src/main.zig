const std = @import("std");
const marvin_game = @import("marvin_game");
const rl = @import("raylib");
const g = @import("game.zig");
const core = @import("core.zig");
const events = @import("./events/default_queue.zig");

pub fn main() !void {
    rl.initWindow(core.MAP_WIDTH * core.TILE_SIZE, core.MAP_HEIGHT * core.TILE_SIZE, "marvin game RPG");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var ev = events.EventQueue.init();

    const allocator = gpa.allocator();
    const queue = ev.queue();

    var game = g.GameRunner.init(allocator, queue);

    game.startUp();
    defer {
        game.shutDown();
        const leaked = gpa.detectLeaks();
        std.debug.print("Memory leaked detected: {any}\n", .{leaked});
    }

    while (!rl.windowShouldClose()) {
        game.update();
        game.draw();

        if (game.shouldExit()) {
            break;
        }
    }
}
