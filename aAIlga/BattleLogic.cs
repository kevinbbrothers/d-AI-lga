using dAIlga;
using EmulatorBot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace aAIlga
{
    public class Move
    {
        public string Name;
        public string Type;
        public int Power;
    }

    public class Pokemon
    {
        public string Name;
        public string Type1;
        public string Type2;
        public int HP;
        public List<Move> Moves = new();

        public Pokemon() { }

        public Pokemon(ActiveBattler battler)
        {
            Name = battler.Species;
            HP = battler.CurrentHp;

            Console.WriteLine(Name);
            // Lookup typing using your PokemonTypes class
            PokemonTypeInfo? typeInfo = PokemonTypes.GetTypes(battler.Species);

            if (typeInfo != null)
            {
                Type1 = typeInfo.Value.Type1.ToString();
                Type2 = typeInfo.Value.Type2?.ToString() ?? "";
            }
            else
            {
                Type1 = "Normal";
                Type2 = "";
            }

            // Convert moves from snapshot → Move objects
            foreach (string moveName in battler.Moves)
            {
                if (moveName == "--")
                    continue;

                MoveData.MoveInfo? moveInfo = MoveData.GetMove(moveName);

                if (moveInfo != null)
                {
                    Moves.Add(new Move
                    {
                        Name = moveInfo.Value.Name,
                        Type = moveInfo.Value.Type.ToString(),
                        Power = moveInfo.Value.Power
                    });
                }
                else
                {
                    Moves.Add(new Move
                    {
                        Name = moveName,
                        Type = "Normal",
                        Power = 0
                    });
                }
            }
        }
    }




    public class BattleLogic
    {
        // -----------------------------
        // TYPE CHART
        // -----------------------------
        private static readonly Dictionary<string, Dictionary<string, double>> TypeChart =
            new()
            {
                ["Normal"] = new() { ["Rock"] = 0.5, ["Ghost"] = 0, ["Steel"] = 0.5 },
                ["Fire"] = new() { ["Grass"] = 2, ["Ice"] = 2, ["Bug"] = 2, ["Steel"] = 2 },
                ["Water"] = new() { ["Fire"] = 2, ["Ground"] = 2, ["Rock"] = 2 },
                ["Grass"] = new() { ["Water"] = 2, ["Ground"] = 2, ["Rock"] = 2 },
                ["Electric"] = new() { ["Water"] = 2, ["Flying"] = 2 },
                ["Ice"] = new() { ["Grass"] = 2, ["Ground"] = 2, ["Flying"] = 2, ["Dragon"] = 2 },
                ["Fighting"] = new() { ["Normal"] = 2, ["Ice"] = 2, ["Rock"] = 2, ["Dark"] = 2, ["Steel"] = 2 },
                ["Poison"] = new() { ["Grass"] = 2 },
                ["Ground"] = new() { ["Fire"] = 2, ["Electric"] = 2, ["Poison"] = 2, ["Rock"] = 2, ["Steel"] = 2 },
                ["Flying"] = new() { ["Grass"] = 2, ["Fighting"] = 2, ["Bug"] = 2 },
                ["Psychic"] = new() { ["Fighting"] = 2, ["Poison"] = 2 },
                ["Bug"] = new() { ["Grass"] = 2, ["Psychic"] = 2, ["Dark"] = 2 },
                ["Rock"] = new() { ["Fire"] = 2, ["Ice"] = 2, ["Flying"] = 2, ["Bug"] = 2 },
                ["Ghost"] = new() { ["Psychic"] = 2, ["Ghost"] = 2 },
                ["Dragon"] = new() { ["Dragon"] = 2 },
                ["Dark"] = new() { ["Psychic"] = 2, ["Ghost"] = 2 },
                ["Steel"] = new() { ["Ice"] = 2, ["Rock"] = 2, ["Fairy"] = 2 },
                ["Fairy"] = new() { ["Fighting"] = 2, ["Dragon"] = 2, ["Dark"] = 2 }
            };

        // -----------------------------
        // TYPE EFFECTIVENESS
        // -----------------------------
        private static double Effectiveness(string moveType, string t1, string t2)
        {
            double mult = 1.0;

            if (TypeChart.TryGetValue(moveType, out var chart))
            {
                if (chart.TryGetValue(t1, out var m1)) mult *= m1;
                if (chart.TryGetValue(t2, out var m2)) mult *= m2;
            }

            return mult;
        }

        // -----------------------------
        // CHECK IF OPPONENT HAS SUPER-EFFECTIVE MOVE
        // -----------------------------
        private static bool OpponentHasSuperEffectiveMove(Pokemon me, Pokemon opp)
        {
            foreach (var move in opp.Moves)
            {
                if (TypeChart.TryGetValue(move.Type, out var chart))
                {
                    if (chart.TryGetValue(me.Type1, out var eff1) && eff1 > 1.0)
                        return true;

                    if (chart.TryGetValue(me.Type2, out var eff2) && eff2 > 1.0)
                        return true;
                }
            }

            return false;
        }

        // -----------------------------
        // FINAL DECISION
        // -----------------------------
        public static int ChooseAction(Pokemon me, Pokemon opp)
        {
            // Rule: Switch if HP is 5 or lower
            if (me.HP <= 5)
                return 5;

            // Rule: Switch if opponent has a super-effective move
            if (OpponentHasSuperEffectiveMove(me, opp))
                return 5;

            // Choose best move using type chart + STAB + power
            int bestIndex = 1;
            double bestScore = -1;

            for (int i = 0; i < me.Moves.Count; i++)
            {
                var move = me.Moves[i];

                double stab = (move.Type == me.Type1 || move.Type == me.Type2) ? 1.5 : 1.0;
                double eff = Effectiveness(move.Type, opp.Type1, opp.Type2);

                double score = move.Power * stab * eff;

                if (score > bestScore)
                {
                    bestScore = score;
                    bestIndex = i + 1; // convert 0-based to 1-based
                }
            }

            return bestIndex;
        }
    }
}
