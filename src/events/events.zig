const std = @import("std");
const types = @import("events_types.zig");
pub const dispatcher = @import("dispatcher.zig");
pub const handlers = @import("handlers.zig");

pub const Context = types.Context;

pub fn EventDispatcher(allocator: std.mem.Allocator) dispatcher.Dispatcher(100) {
    var disp = dispatcher.Dispatcher(100).init(allocator);
    disp.registerHandler(types.Exit, types.Exit);
    return disp;
}
