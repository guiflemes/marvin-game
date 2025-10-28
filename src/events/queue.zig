const events = @import("./events.zig");

const Event = events.Event;

pub const Queue = struct {
    ptr: *anyopaque,
    vtbale: *const Vtable,

    const Vtable = struct { enqueue: *const fn (*anyopaque, Event) anyerror!void, dequeue: *const fn (*anyopaque) ?Event };

    const Self = @This();

    pub fn enqueue(self: *Self, event: Event) !void {
        return self.vtbale.enqueue(self.ptr, event);
    }

    pub fn dequeue(self: *Self) ?Event {
        return self.vtbale.dequeue(self.ptr);
    }
};
