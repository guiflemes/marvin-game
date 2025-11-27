const std = @import("std");
const types = @import("events_types.zig");
const bus = @import("bus.zig");
pub const handlers = @import("handlers.zig");

pub const Context = types.Context;
pub const EventBus = bus.Bus(100);

pub fn CreateEventBus(allocator: std.mem.Allocator) *EventBus {
    var disp = EventBus.init(allocator);
    return &disp;
}
