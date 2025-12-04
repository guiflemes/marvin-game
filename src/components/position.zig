pub const GridPosition = struct {
    const Self = @This();

    x: f32,
    y: f32,
};

pub const IntentMovement = struct {
    const Self = @This();

    x: f32,
    y: f32,

    pub fn up(self: *Self, step: f32) void {
        self.y -= step;
    }

    pub fn down(self: *Self, step: f32) void {
        self.y += step;
    }

    pub fn left(self: *Self, step: f32) void {
        self.x -= step;
    }

    pub fn right(self: *Self, step: f32) void {
        self.x += step;
    }

    pub fn reset(self: *Self) void {
        self.y = 0;
        self.x = 0;
    }
};
