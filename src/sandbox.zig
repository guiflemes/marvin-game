const std = @import("std");
const events = @import("./events/events.zig");
const assert = std.debug.assert;
const context = @import("./core/ctx.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var game_state: context.State = .none;
    var ctx = events.Context{ .state = &game_state };

    var disp = EventDispatcher(allocator);

    var coco = Coco{ .xixi = false };
    disp.emit(&coco);
    disp.dispatchAll(&ctx);
}

pub fn EventDispatcher(allocator: std.mem.Allocator) Dispatcher(100) {
    var disp = Dispatcher(100).init(allocator);
    disp.registerHandler(Coco, onCoco);
    return disp;
}

pub const Coco = struct { xixi: bool };

pub fn onCoco(ctx: *events.Context, coco: *Coco) void {
    _ = ctx;
    std.debug.print("executing coco={}\n", .{coco.xixi});
}

pub const Event = struct {
    id: usize,
    type_id: std.builtin.TypeId,
    data: *anyopaque,

    pub fn init(data: anytype) Event {
        const T = @TypeOf(data.*);
        return .{
            .id = 1,
            .type_id = @typeInfo(T),
            .data = data,
        };
    }
};

const callbackFn = *const fn (*events.Context, *anyopaque) void;

pub fn Dispatcher(max_events_size: usize) type {
    return struct {
        allocator: std.mem.Allocator,
        events: [max_events_size]?Event,
        handlers: []Handler,
        events_count: usize,

        pub const Handler = struct {
            event_type: std.builtin.TypeId,
            callback: callbackFn,
        };

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .allocator = allocator,
                .events = [_]?Event{null} ** max_events_size,
                .handlers = &[_]Handler{},
                .events_count = 0,
            };
        }

        pub fn registerHandler(self: *@This(), comptime T: type, callback: fn (*events.Context, *T) void) void {
            const thunk = struct {
                fn erased(ctx: *events.Context, data: *anyopaque) void {
                    const typed = @as(*T, @ptrCast(data));
                    callback(ctx, typed);
                }
            }.erased;

            const handler = Handler{ .event_type = @typeInfo(T), .callback = thunk };
            const new_handlers = self.allocator.alloc(Handler, self.handlers.len + 1) catch unreachable;
            @memcpy(new_handlers[0..self.handlers.len], self.handlers);
            new_handlers[new_handlers.len - 1] = handler;
            self.handlers = new_handlers;
        }

        pub fn emit(self: *@This(), data: anytype) void {
            const event = Event.init(data);
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

        pub fn dispatch(self: @This(), ctx: *events.Context, ev: Event, callback: callbackFn) void {
            _ = self;
            callback(ctx, @ptrCast(ev.data));
        }

        fn getHandler(self: @This(), event: Event) ?*Handler {
            for (self.handlers) |*h| {
                if (h.event_type == event.type_id) {
                    return h;
                }
            }
            return null;
        }
    };
}
