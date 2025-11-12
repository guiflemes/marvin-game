const rl = @import("raylib");
const core = @import("../core.zig");
const ecs = @import("ecs");
const std = @import("std");
const vtable = @import("vtable.zig");

const Allocator = std.mem.Allocator;

const DrawDelegate = *const fn (map: *TileMap, origin: rl.Vector2) void;

fn drawMap(map: *const TileMap, origin: rl.Vector2) void {
    for (0..map.height) |y| {
        for (0..map.width) |x| {
            const tile = map.data[y][x];
            const tileColor = getTileColor(tile);

            const pos = rl.Vector2{
                .x = origin.x + @as(f32, @floatFromInt(x)) * core.TILE_SIZE + 8.0,
                .y = origin.y + @as(f32, @floatFromInt(y)) * core.TILE_SIZE + 6.0,
            };

            rl.drawTextEx(map.font.raylibFont, rl.textFormat("%c", .{tile}), pos, map.font.size, 0, tileColor);
        }
    }
}

pub const TileMap = struct {
    const Self = @This();

    data: [][]u8,
    allocator: Allocator,
    height: usize,
    width: usize,
    font: core.Font,

    pub fn create(allocator: Allocator, src: []const []const u8, font: core.Font) !*Self {
        const self = try allocator.create(Self);
        errdefer allocator.destroy(self);
        self.* = try Self.init(allocator, src, font);
        return self;
    }

    pub fn init(allocator: Allocator, src: []const []const u8, font: core.Font) !Self {
        const height = src.len;
        const width = src[0].len;

        var data = try allocator.alloc([]u8, height);
        for (src, 0..) |row, i| {
            if (row.len != width) return error.InconsistentRowLength;
            data[i] = try allocator.alloc(u8, width);
            @memcpy(data[i], row);
        }

        return Self{
            .data = data,
            .allocator = allocator,
            .height = height,
            .width = width,
            .font = font,
        };
    }

    pub fn deinit(self: *const Self) void {
        for (self.data) |row| self.allocator.free(row);
        self.allocator.free(self.data);
    }

    pub fn destroy(context: *const anyopaque) void {
        const self: *const Self = @ptrCast(@alignCast(context));
        self.deinit();
        self.allocator.destroy(self);
    }

    pub fn isObstacle(context: *const anyopaque, y: f32, x: f32) bool {
        const self: *const Self = @ptrCast(@alignCast(context));
        return self.checkTile('#', @intFromFloat(y), @intFromFloat(x));
    }

    pub fn checkTile(self: *const Self, tile: u8, y: usize, x: usize) bool {
        return self.data[y][x] == tile;
    }

    pub fn draw(context: *const anyopaque, pos: rl.Vector2) void {
        const self: *const Self = @ptrCast(@alignCast(context));
        drawMap(self, pos);
    }

    pub fn map(self: *Self) vtable.Map {
        return .{ .ptr = self, .vtable = .{
            .is_obstacle = isObstacle,
            .destroy = destroy,
            .draw = draw,
        } };
    }
};

pub fn getTileColor(tile: u8) rl.Color {
    switch (tile) {
        '#' => return rl.Color.gray,
        '.' => return rl.Color.dark_green,
        '^' => return rl.Color.brown,
        '~' => return rl.Color.blue,
        else => return rl.Color.white,
    }
}
