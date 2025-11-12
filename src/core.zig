const rl = @import("raylib");

pub const MAP_HEIGHT = 20;
pub const MAP_WIDTH = 20;
pub const TILE_SIZE: f32 = 32.0;

pub const Transition = union(enum) {
    none,
    to: StateType,

    pub const StateType = enum {
        Explore,
    };
};

pub const Font = struct {
    raylibFont: rl.Font,
    size: f32,

    pub fn init() Font {
        const font = rl.getFontDefault() catch {
            @panic("impossible to load raylib default font");
        };
        return Font{ .raylibFont = font, .size = 24 };
    }
};
