const events = @import("./events.zig");
const queue = @import("queue.zig");

const Event = events.Event;
const Queue = queue.Queue;

pub const EventQueue = struct {
    data: [256]Event,
    len: usize,
    index: usize,

    const Self = @This();

    pub fn init() Self {
        return Self{
            .data = undefined,
            .len = 0,
            .index = 0,
        };
    }

    pub fn enqueue(context: *anyopaque, event: Event) !void {
        var self: *Self = @ptrCast(@alignCast(context));
        if (self.len >= self.data.len) return error.QueueFull;
        self.data[self.len] = event;
        self.len += 1;
    }

    pub fn dequeue(context: *anyopaque) ?Event {
        var self: *Self = @ptrCast(@alignCast(context));
        if (self.index < self.data.len) {
            const event = self.data[self.index];
            self.index += 1;
            return event;
        }
        self.len = 0;
        self.data = undefined;
        return null;
    }

    pub fn queue(self: *Self) Queue {
        return .{
            .ptr = self,
            .vtbale = &.{ .enqueue = enqueue, .dequeue = dequeue },
        };
    }
};
