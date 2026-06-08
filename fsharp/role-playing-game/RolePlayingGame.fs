module RolePlayingGame

type Player = { 
    Name: string option
    Level: int
    Health: int
    Mana: int option
}

let introduce (player: Player): string = 
    match player.Name with
    | Some s -> s
    | None -> "Mighty Magician"

let revive (player: Player): Player option =
    match player.Health with
    | 0 ->
        let revivedPlayer: Player =
            match player.Level with
            | lvl when lvl >= 10 ->
                { player with Health = 100; Mana = Some 100 }
            | _ ->
                { player with Health = 100; Mana = None }
        Some revivedPlayer
    | _ ->
        None

let castSpell (manaCost: int) (player: Player): Player * int =
    match player.Mana with
    | Some pool when pool >= manaCost ->
        { player with Mana = Some (pool - manaCost) }, manaCost * 2
    | Some pool ->
        player, 0
    | None ->
        let reducedHealth = player.Health - manaCost
        match reducedHealth with
        | h when h < 0 ->
            { player with Health = 0 }, 0
        | _ ->
        { player with Health = reducedHealth }, 0
