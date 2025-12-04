const std = @import("std");
const types = @import("events_types.zig");
const bus = @import("bus.zig");
pub const handlers = @import("handlers.zig");

pub const Context = types.Context;
pub const EventBus = bus.Bus(100);
pub const Exit = types.Exit;

pub fn CreateEventBus(allocator: std.mem.Allocator) EventBus {
    var event_bus = EventBus.init(allocator);
    event_bus.registerHandler(Exit, handlers.onExit);
    return event_bus;
}
