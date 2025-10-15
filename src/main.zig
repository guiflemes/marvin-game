const std = @import("std");
const marvin_game = @import("marvin_game");
const rl = @import("raylib");
const g = @import("game.zig");
const consts = @import("const.zig");

pub fn main() !void {
    rl.initWindow(consts.MAP_WIDTH * consts.TILE_SIZE, consts.MAP_HEIGHT * consts.TILE_SIZE, "marvin game RPG");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();
    var game = g.GameRunner.init(allocator);

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

pub fn logLeak(leaked: bool) !void {
    const leak_file = try std.fs.cwd().createFile("leak.log", .{ .truncate = true });
    defer leak_file.close();

    var buffer: [1024]u8 = undefined;
    var writer = leak_file.writer(&buffer);

    try writer.interface.print("Game ended\n", .{});
    try writer.interface.print("Memory leak detected: {}\n", .{leaked});
    try writer.interface.flush();
}
