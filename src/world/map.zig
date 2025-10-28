const rl = @import("raylib");
const core = @import("../core.zig");
const ecs = @import("ecs");
const std = @import("std");

const Allocator = std.mem.Allocator;

const TILE_SIZE = core.TILE_SIZE;

pub const base = [_][]const u8{
    "####################",
    "#..................#",
    "#..^^^..~~~~~......#",
    "#..^^^..~~~~~......#",
    "#..............#####",
    "#........########..#",
    "#........#.........#",
    "#........#.........#",
    "#.....~~~~~........#",
    "#.....~~~~~........#",
    "#............^^^^^.#",
    "#............^^^^^.#",
    "#..................#",
    "#..................#",
    "#..................#",
    "#..................#",
    "#..................#",
    "#..................#",
    "#..................#",
    "####################",
};

pub const TileMap = struct {
    data: [][]u8,
    allocator: Allocator,
    height: usize,
    width: usize,
    font: core.Font,

    pub fn init(allocator: Allocator, src: []const []const u8, font: core.Font) !TileMap {
        const height = src.len;
        const width = src[0].len;

        var data = try allocator.alloc([]u8, height);
        for (src, 0..) |row, i| {
            if (row.len != width) return error.InconsistentRowLength;
            data[i] = try allocator.alloc(u8, width);
            @memcpy(data[i], row);
        }

        return TileMap{
            .data = data,
            .allocator = allocator,
            .height = height,
            .width = width,
            .font = font,
        };
    }

    pub fn deinit(self: TileMap) void {
        for (self.data) |row| self.allocator.free(row);
        self.allocator.free(self.data);
    }

    pub fn isObstacle(self: *TileMap, y: f32, x: f32) bool {
        return self.checkTile('#', @intFromFloat(y), @intFromFloat(x));
    }

    pub fn isEnemy(self: *TileMap, y: f32, x: f32) bool {
        return self.checkTile('M', @intFromFloat(y), @intFromFloat(x));
    }

    pub fn isWater(self: *TileMap, y: f32, x: f32) bool {
        return self.checkTile("~", y, x);
    }

    pub fn isGround(self: *TileMap, y: f32, x: f32) bool {
        return self.checkTile(".", y, x);
    }

    pub fn checkTile(self: *TileMap, tile: u8, y: usize, x: usize) bool {
        return self.data[y][x] == tile;
    }
};
