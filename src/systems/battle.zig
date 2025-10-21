const ecs = @import("ecs");
const core = @import("../core.zig");

const Transition = core.Transition;

pub fn BattleSystem(registry: *ecs.Registry) Transition {
    _ = registry;
    return .none;
}
