const game = @import("game.zig");
const rl = @import("raylib");

pub const Vtable = struct {
    update: *const fn (*anyopaque, g: *game.Game) void,
};

pub const State = struct {
    ptr: *anyopaque,
    vtable: *Vtable,

    pub fn update(self: *State, g: *game.Game) void {
        self.vtable.update(self, g);
    }
};

pub const Explore = struct {
    game: *game.Game,

    const Self = @This();

    fn init(g: *game) Explore {
        return Explore{ .game = g };
    }

    fn update(context: *anyopaque) void {
        const self: *Self = @ptrCast(@alignCast(context));

        if (rl.isKeyPressed(rl.KeyboardKey.right) and !self.game.map.isObstacle(self.game.player.y, self.game.player.x + 1)) {
            self.game.player.x += 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.left) and !self.game.map.isObstacle(self.game.player.y, self.game.player.x - 1)) {
            self.game.player.x -= 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.down) and !self.game.map.isObstacle(self.game.player.y + 1, self.game.player.x)) {
            self.game.player.y += 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.up) and !self.game.map.isObstacle(self.game.player.y - 1, self.game.player.x)) {
            self.game.player.y -= 1;
        }
    }

    pub fn state(self: *Self) State {
        return .{
            .ptr = self,
            .vtable = &.{ .update = update },
        };
    }
};
