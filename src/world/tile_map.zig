const rl = @import("raylib");
const ecs = @import("ecs");
const std = @import("std");
const vtable = @import("vtable.zig");
const f = @import("../core/font.zig");

const Allocator = std.mem.Allocator;

const DrawDelegate = *const fn (map: *TileMap, origin: rl.Vector2) void;

pub const MAP_HEIGHT = 20;
pub const MAP_WIDTH = 20;
pub const TILE_SIZE: f32 = 32.0;

fn drawMap(map: *const TileMap, origin: rl.Vector2) void {
    for (0..map.height) |y| {
        for (0..map.width) |x| {
            const tile = map.data[y][x];
            const tileColor = getTileColor(tile);

            const pos = rl.Vector2{
                .x = origin.x + @as(f32, @floatFromInt(x)) * TILE_SIZE + 8.0,
                .y = origin.y + @as(f32, @floatFromInt(y)) * TILE_SIZE + 6.0,
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
    font: f.Font,

    pub fn create(allocator: Allocator, src: []const []const u8, font: f.Font) !*Self {
        const self = try allocator.create(Self);
        errdefer allocator.destroy(self);
        self.* = try Self.init(allocator, src, font);
        return self;
    }

    pub fn init(allocator: Allocator, src: []const []const u8, font: f.Font) !Self {
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

    pub fn draw(context: *const anyopaque, origin: rl.Vector2) void {
        const self: *const Self = @ptrCast(@alignCast(context));
        drawMap(self, origin);
    }

    pub fn world_to_screen(context: *const anyopaque, screnPos: rl.Vector2) rl.Vector2 {
        const self: *const Self = @ptrCast(@alignCast(context));
        _ = self;
        return .{
            .x = screnPos.x * TILE_SIZE,
            .y = screnPos.y * TILE_SIZE,
        };
    }

    pub fn get_size(context: *const anyopaque) rl.Vector2 {
        const self: *const Self = @ptrCast(@alignCast(context));
        return .{
            .x = @as(f32, @floatFromInt(self.width)) * TILE_SIZE,
            .y = @as(f32, @floatFromInt(self.height)) * TILE_SIZE,
        };
    }

    pub fn map(self: *Self) vtable.Map {
        return .{ .ptr = self, .vtable = .{
            .is_obstacle = isObstacle,
            .destroy = destroy,
            .draw = draw,
            .world_to_screen = world_to_screen,
            .get_size = get_size,
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
