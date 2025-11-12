const std = @import("std");
const ecs = @import("ecs");
const rl = @import("raylib");
const components = @import("./components/components.zig");
const core = @import("./core.zig");
const map_resource = @import("./resources/map_layouts.zig");

pub fn get_map_entity(registry: *ecs.Registry) ?*components.Map {
    var view = registry.view(.{ components.ActiveMapTag, components.Map }, .{});
    var iter = view.entityIterator();
    if (iter.next()) |entt| {
        return view.get(components.Map, entt);
    }
    return null;
}
