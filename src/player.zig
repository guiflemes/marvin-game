const rl = @import("raylib");
const consts = @import("const.zig");
const fonts = @import("font.zig");

const TILE_SIZE = consts.TILE_SIZE;

pub const Player = struct {
    x: f32,
    y: f32,
    font: fonts.Font,
    color: rl.Color,

    pub fn init(font: fonts.Font) Player {
        return Player{ .x = 2, .y = 2, .font = font, .color = rl.Color.yellow };
    }

    pub fn draw(self: *Player, origin: rl.Vector2) void {
        const pos = rl.Vector2{ .x = origin.x + self.x * TILE_SIZE, .y = origin.y + self.y * TILE_SIZE };
        rl.drawTextEx(self.font.raylibFont, "@", pos, self.font.size, 0, self.color);
    }
};
