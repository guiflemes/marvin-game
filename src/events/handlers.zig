const std = @import("std");
const events = @import("events_types.zig");

pub fn onExit(ctx: *events.Context, ev: events.Event) void {
    _ = ev;
    _ = ctx;
    std.debug.print("should exit game", .{});
}
