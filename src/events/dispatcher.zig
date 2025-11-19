const std = @import("std");
const events = @import("./events_types.zig");

const callbackFn = *const fn (*events.Context, events.Event) void;

// TODO use a ring buffer :)
pub fn Dispatcher(max_events_size: usize) type {
    return struct {
        allocator: std.mem.Allocator,
        events: [max_events_size]?events.Event,
        handlers: []Handler,
        events_count: usize,

        pub const Handler = struct {
            event_type: events.Event,
            callback: callbackFn,
        };

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .allocator = allocator,
                .events = [_]?events.Event{null} ** max_events_size,
                .handlers = &[_]Handler{},
                .events_count = 0,
            };
        }

        pub fn registerHandler(self: *@This(), event_type: events.Event, callback: callbackFn) void {
            const handler = Handler{ .event_type = event_type, .callback = callback };
            const new_handlers = self.allocator.alloc(Handler, self.handlers.len + 1) catch unreachable;
            @memcpy(new_handlers, self.handlers);
            new_handlers[new_handlers.len + 1] = handler;
        }

        pub fn emit(self: *@This(), event: events.Event) void {
            if (self.events_count < max_events_size) {
                self.events[self.events_count] = event;
                self.events_count += 1;
            }
        }

        pub fn dispatchAll(self: *@This(), ctx: *events.Context) void {
            for (self.events[0..self.events_count]) |maybe_ev| {
                if (maybe_ev) |ev| {
                    if (self.getHandler(ev)) |handler| {
                        self.dispatch(ctx, ev, handler.callback);
                    }
                }
            }
            self.events_count = 0;
        }

        pub fn dispatch(self: @This(), ctx: *events.Context, ev: events.Event, callback: callbackFn) void {
            _ = self;
            switch (ev) {
                .Exit => callback(ctx, ev.Exit),
                .Attack => callback(ctx, ev.Attack),
                .Collisition => callback(ctx, ev.Collisition),
            }
        }

        fn getHandler(self: @This(), event: events.Event) ?*Handler {
            for (self.handlers) |*h| {
                if (h.event_type == event) {
                    return h;
                }
            }
            return null;
        }
    };
}
