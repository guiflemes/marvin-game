const std = @import("std");
const events = @import("events_types.zig");

pub fn onExit(ctx: *events.Context, ev: *events.Exit) void {
    _ = ev;
    ctx.state.* = .Exit;
}
