module Bandwagoner

type Coach = { Name: string; FormerPlayer: bool }
type Stats = { Wins: int; Losses: int }
type Team = { Name: string; Coach: Coach; Stats: Stats }

let createCoach (name: string) (formerPlayer: bool): Coach =
    { Name = name; FormerPlayer = formerPlayer }

let createStats(wins: int) (losses: int): Stats =
    { Wins = wins; Losses = losses }

let createTeam(name: string) (coach: Coach)(stats: Stats): Team =
    { Name = name; Coach = coach; Stats = stats }

let replaceCoach(team: Team) (coach: Coach): Team =
    { team with Coach = coach }

let isSameTeam(homeTeam: Team) (awayTeam: Team): bool =
    homeTeam.Name = awayTeam.Name &&
        homeTeam.Coach.Name = awayTeam.Coach.Name &&
        homeTeam.Stats.Losses = awayTeam.Stats.Losses &&
        homeTeam.Stats.Wins = awayTeam.Stats.Wins

let rootForTeam(team: Team): bool =
    team.Coach.Name = "Gregg Popovich" ||
        team.Coach.FormerPlayer = true ||
        team.Name = "Chicago Bulls" ||
        team.Stats.Wins >= 60 ||
        team.Stats.Wins < team.Stats.Losses
