const std = @import("std");
const events = @import("events.zig");

// TODO it should receive a global ctx, and change it on game loop
pub fn exitGame(ev: events.Event.Exit) void {
    _ = ev;
    std.debug.print("should exit game", .{});
}
