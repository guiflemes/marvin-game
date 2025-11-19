const std = @import("std");
const game = @import("game.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    defer {
        const leaked = gpa.detectLeaks();
        std.debug.print("Memory leaked detected: {any}\n", .{leaked});
    }

    game.run(allocator);
}
