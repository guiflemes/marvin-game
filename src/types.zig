const rl = @import("raylib");
const consts = @import("const.zig");
const fonts = @import("font.zig");
const ecs = @import("ecs");

pub const PlayerTag = struct {};

pub const Position = struct {
    x: f32,
    y: f32,
};

pub const Renderable = struct {
    font: fonts.Font,
    text: []const u8,
    color: rl.Color,
};
