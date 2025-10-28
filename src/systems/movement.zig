const rl = @import("raylib");
const ecs = @import("ecs");
const std = @import("std");
const core = @import("../core.zig");
const m = @import("../world/map.zig");
const components = @import("../components/components.zig");

const Position = components.Position;
const PlayerTag = components.PlayerTag;
const Transition = core.Transition;

pub fn PlayerMovementWorldSystem(registry: *ecs.Registry) Transition {
    var map: *m.TileMap = registry.singletons().get(m.TileMap);

    var view = registry.view(.{ Position, PlayerTag }, .{});
    var iter = view.entityIterator();
    while (iter.next()) |e| {
        var player = view.get(Position, e);
        if (rl.isKeyPressed(rl.KeyboardKey.right) and !map.isObstacle(player.y, player.x + 1)) {
            player.right(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.left) and !map.isObstacle(player.y, player.x - 1)) {
            player.left(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.down) and !map.isObstacle(player.y + 1, player.x)) {
            player.down(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.up) and !map.isObstacle(player.y - 1, player.x)) {
            player.up(1);
        }

        if (map.isEnemy(player.y, player.x)) {
            return .{ .to = .Battle };
        }
    }

    return .none;
}

// pub fn EnemyMovementWorldSystem(registry: *ecs.Registry) Transition {
//     var map: *m.TileMap = registry.singletons().get(m.TileMap);

//     var view_enemies = registry.view(.{ components.Position, components.EnemyTag }, .{});
//     var view_player = registry.view(.{ components.Position, components.PlayerTag }, .{});

//     const player_entity = view_player.entityIterator().next() orelse return .none;
//     const player_pos = view_player.getConst(components.Position, player_entity);

//     var enemy_entities = view_enemies.entityIterator();

//     while (enemy_entities.next()) |ent| {
//         const enemy_pos = view_enemies.getConst(components.Position, ent);

//     }
// }

// . . # P . . .
// # A . . . # .
// # A # . . . A
//

// * each flame as posições das entidades são atualizadas
// * quem é atualizado primeiro npcs ou player????
// * quando o nps vai se mover alem do player e dos obstculos ele tbm precisar saber se tem outro nps la, nao seria melhor ver se tem
//   outra entidade no proximo moviemento?? mas para saber disso eu teria que carregar todas as enitidades e vem que ta proximo para pode mover?
//   pq como o loop roda entre entidadesm ele vai um a um checkando e movendo, mas ... se eu nao carreguei tudo a volta nao tem como checkar
// * cada flame tem que checkar a colisão, mas para o nps NPC1 que vai mover de posição mas nao tem posição disponivel, ele fica parado?
// * nao preciso carregar o mapa todo, só o que ta na visao do player
// * na hora de checar a colisao devo retorna algum status dizendo que esse colisao representa um ação tipo batte?? nao vai acoplar? mas isso tbm é eficiente ...

// TODO when isObstacle move randomly on axies but also check for isObstacle again and player
