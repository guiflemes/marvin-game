const ecs = @import("ecs");
const rl = @import("raylib");

pub const Event = union(enum) {
    Collisition: struct {
        entity_a: ecs.Entity,
        entity_b: ?ecs.Entity,
        pos: rl.Vector2,
    },

    Attack: struct {
        entity_a: ecs.Entity,
        entity_b: ?ecs.Entity,
    },

    Exit,
};
