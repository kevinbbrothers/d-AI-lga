using System;
using System.Collections.Generic;
using dAIlga;

namespace dAIlga
{
    /// <summary>
    /// Move name, type, and base power for National move #1-467 (Gen 1-4), matching
    /// Plat_Qol.lua's moveNamesList numbering exactly, so a move ID read from BattleMon
    /// maps directly here without any offset math.
    /// Power = 0 for status moves and for moves whose power varies by formula rather than
    /// a fixed base (e.g. Low Kick, Flail, Hidden Power, Gyro Ball, Eruption, Present,
    /// Magnitude, Trump Card, Return/Frustration, Fling, Natural Gift) — those are flagged
    /// with a trailing "// variable" comment. Treat those specially in battle logic rather
    /// than reading Power directly.
    /// Given the size of this table (467 entries), spot-check anything mission-critical
    /// against Bulbapedia/PokeAPI — a transcription slip here and there is possible.
    /// </summary>
    public static class MoveData
    {
        public readonly record struct MoveInfo(string Name, PokemonType Type, int Power);

        private static readonly MoveInfo?[] ById = new MoveInfo?[468];
        private static readonly Dictionary<string, MoveInfo> ByName =
            new(StringComparer.OrdinalIgnoreCase);

        private static void Add(int id, string name, PokemonType type, int power)
        {
            var info = new MoveInfo(name, type, power);
            ById[id] = info;
            ByName[name] = info;
        }

        /// <summary>Look up by move name (case-insensitive). Returns null if not found.</summary>
        public static MoveInfo? GetMove(string moveName) =>
            ByName.TryGetValue(moveName, out var info) ? info : null;

        /// <summary>Look up by move ID (0-467; 0 is "--"/no move). Returns null if out of range.</summary>
        public static MoveInfo? GetMove(int moveId) =>
            (moveId >= 0 && moveId < ById.Length) ? ById[moveId] : null;

        static MoveData()
        {
            Add(0, "--", PokemonType.Normal, 0);

            // ---- Gen 1 (1-165) ----
            Add(1, "Pound", PokemonType.Normal, 40);
            Add(2, "Karate Chop", PokemonType.Fighting, 50);
            Add(3, "Double Slap", PokemonType.Normal, 15);
            Add(4, "Comet Punch", PokemonType.Normal, 18);
            Add(5, "Mega Punch", PokemonType.Normal, 80);
            Add(6, "Pay Day", PokemonType.Normal, 40);
            Add(7, "Fire Punch", PokemonType.Fire, 75);
            Add(8, "Ice Punch", PokemonType.Ice, 75);
            Add(9, "Thunder Punch", PokemonType.Electric, 75);
            Add(10, "Scratch", PokemonType.Normal, 40);
            Add(11, "Vice Grip", PokemonType.Normal, 55);
            Add(12, "Guillotine", PokemonType.Normal, 0); // variable (OHKO)
            Add(13, "Razor Wind", PokemonType.Normal, 80);
            Add(14, "Swords Dance", PokemonType.Normal, 0);
            Add(15, "Cut", PokemonType.Normal, 50);
            Add(16, "Gust", PokemonType.Flying, 40);
            Add(17, "Wing Attack", PokemonType.Flying, 60);
            Add(18, "Whirlwind", PokemonType.Normal, 0);
            Add(19, "Fly", PokemonType.Flying, 70);
            Add(20, "Bind", PokemonType.Normal, 15);
            Add(21, "Slam", PokemonType.Normal, 80);
            Add(22, "Vine Whip", PokemonType.Grass, 35);
            Add(23, "Stomp", PokemonType.Normal, 65);
            Add(24, "Double Kick", PokemonType.Fighting, 30);
            Add(25, "Mega Kick", PokemonType.Normal, 120);
            Add(26, "Jump Kick", PokemonType.Fighting, 100);
            Add(27, "Rolling Kick", PokemonType.Fighting, 60);
            Add(28, "Sand Attack", PokemonType.Ground, 0);
            Add(29, "Headbutt", PokemonType.Normal, 70);
            Add(30, "Horn Attack", PokemonType.Normal, 65);
            Add(31, "Fury Attack", PokemonType.Normal, 15);
            Add(32, "Horn Drill", PokemonType.Normal, 0); // variable (OHKO)
            Add(33, "Tackle", PokemonType.Normal, 35);
            Add(34, "Body Slam", PokemonType.Normal, 85);
            Add(35, "Wrap", PokemonType.Normal, 15);
            Add(36, "Take Down", PokemonType.Normal, 90);
            Add(37, "Thrash", PokemonType.Normal, 90);
            Add(38, "Double-Edge", PokemonType.Normal, 120);
            Add(39, "Tail Whip", PokemonType.Normal, 0);
            Add(40, "Poison Sting", PokemonType.Poison, 15);
            Add(41, "Twineedle", PokemonType.Bug, 25);
            Add(42, "Pin Missile", PokemonType.Bug, 14);
            Add(43, "Leer", PokemonType.Normal, 0);
            Add(44, "Bite", PokemonType.Dark, 60);
            Add(45, "Growl", PokemonType.Normal, 0);
            Add(46, "Roar", PokemonType.Normal, 0);
            Add(47, "Sing", PokemonType.Normal, 0);
            Add(48, "Supersonic", PokemonType.Normal, 0);
            Add(49, "Sonic Boom", PokemonType.Normal, 0); // fixed 20 damage
            Add(50, "Disable", PokemonType.Normal, 0);
            Add(51, "Acid", PokemonType.Poison, 40);
            Add(52, "Ember", PokemonType.Fire, 40);
            Add(53, "Flamethrower", PokemonType.Fire, 95);
            Add(54, "Mist", PokemonType.Ice, 0);
            Add(55, "Water Gun", PokemonType.Water, 40);
            Add(56, "Hydro Pump", PokemonType.Water, 120);
            Add(57, "Surf", PokemonType.Water, 95);
            Add(58, "Ice Beam", PokemonType.Ice, 95);
            Add(59, "Blizzard", PokemonType.Ice, 120);
            Add(60, "Psybeam", PokemonType.Psychic, 65);
            Add(61, "Bubble Beam", PokemonType.Water, 65);
            Add(62, "Aurora Beam", PokemonType.Ice, 65);
            Add(63, "Hyper Beam", PokemonType.Normal, 150);
            Add(64, "Peck", PokemonType.Flying, 35);
            Add(65, "Drill Peck", PokemonType.Flying, 80);
            Add(66, "Submission", PokemonType.Fighting, 80);
            Add(67, "Low Kick", PokemonType.Fighting, 0); // variable (weight-based)
            Add(68, "Counter", PokemonType.Fighting, 0); // variable
            Add(69, "Seismic Toss", PokemonType.Fighting, 0); // fixed = user level
            Add(70, "Strength", PokemonType.Normal, 80);
            Add(71, "Absorb", PokemonType.Grass, 20);
            Add(72, "Mega Drain", PokemonType.Grass, 40);
            Add(73, "Leech Seed", PokemonType.Grass, 0);
            Add(74, "Growth", PokemonType.Normal, 0);
            Add(75, "Razor Leaf", PokemonType.Grass, 55);
            Add(76, "Solar Beam", PokemonType.Grass, 120);
            Add(77, "Poison Powder", PokemonType.Poison, 0);
            Add(78, "Stun Spore", PokemonType.Grass, 0);
            Add(79, "Sleep Powder", PokemonType.Grass, 0);
            Add(80, "Petal Dance", PokemonType.Grass, 90);
            Add(81, "String Shot", PokemonType.Bug, 0);
            Add(82, "Dragon Rage", PokemonType.Dragon, 0); // fixed 40 damage
            Add(83, "Fire Spin", PokemonType.Fire, 35);
            Add(84, "Thunder Shock", PokemonType.Electric, 40);
            Add(85, "Thunderbolt", PokemonType.Electric, 95);
            Add(86, "Thunder Wave", PokemonType.Electric, 0);
            Add(87, "Thunder", PokemonType.Electric, 120);
            Add(88, "Rock Throw", PokemonType.Rock, 50);
            Add(89, "Earthquake", PokemonType.Ground, 100);
            Add(90, "Fissure", PokemonType.Ground, 0); // variable (OHKO)
            Add(91, "Dig", PokemonType.Ground, 60);
            Add(92, "Toxic", PokemonType.Poison, 0);
            Add(93, "Confusion", PokemonType.Psychic, 50);
            Add(94, "Psychic", PokemonType.Psychic, 90);
            Add(95, "Hypnosis", PokemonType.Psychic, 0);
            Add(96, "Meditate", PokemonType.Psychic, 0);
            Add(97, "Agility", PokemonType.Psychic, 0);
            Add(98, "Quick Attack", PokemonType.Normal, 40);
            Add(99, "Rage", PokemonType.Normal, 20);
            Add(100, "Teleport", PokemonType.Psychic, 0);
            Add(101, "Night Shade", PokemonType.Ghost, 0); // fixed = user level
            Add(102, "Mimic", PokemonType.Normal, 0);
            Add(103, "Screech", PokemonType.Normal, 0);
            Add(104, "Double Team", PokemonType.Normal, 0);
            Add(105, "Recover", PokemonType.Normal, 0);
            Add(106, "Harden", PokemonType.Normal, 0);
            Add(107, "Minimize", PokemonType.Normal, 0);
            Add(108, "Smokescreen", PokemonType.Normal, 0);
            Add(109, "Confuse Ray", PokemonType.Ghost, 0);
            Add(110, "Withdraw", PokemonType.Water, 0);
            Add(111, "Defense Curl", PokemonType.Normal, 0);
            Add(112, "Barrier", PokemonType.Psychic, 0);
            Add(113, "Light Screen", PokemonType.Psychic, 0);
            Add(114, "Haze", PokemonType.Ice, 0);
            Add(115, "Reflect", PokemonType.Psychic, 0);
            Add(116, "Focus Energy", PokemonType.Normal, 0);
            Add(117, "Bide", PokemonType.Normal, 0); // variable
            Add(118, "Metronome", PokemonType.Normal, 0);
            Add(119, "Mirror Move", PokemonType.Flying, 0);
            Add(120, "Self-Destruct", PokemonType.Normal, 200);
            Add(121, "Egg Bomb", PokemonType.Normal, 100);
            Add(122, "Lick", PokemonType.Ghost, 20);
            Add(123, "Smog", PokemonType.Poison, 20);
            Add(124, "Sludge", PokemonType.Poison, 65);
            Add(125, "Bone Club", PokemonType.Ground, 65);
            Add(126, "Fire Blast", PokemonType.Fire, 120);
            Add(127, "Waterfall", PokemonType.Water, 80);
            Add(128, "Clamp", PokemonType.Water, 35);
            Add(129, "Swift", PokemonType.Normal, 60);
            Add(130, "Skull Bash", PokemonType.Normal, 100);
            Add(131, "Spike Cannon", PokemonType.Normal, 20);
            Add(132, "Constrict", PokemonType.Normal, 10);
            Add(133, "Amnesia", PokemonType.Psychic, 0);
            Add(134, "Kinesis", PokemonType.Psychic, 0);
            Add(135, "Soft-Boiled", PokemonType.Normal, 0);
            Add(136, "High Jump Kick", PokemonType.Fighting, 100);
            Add(137, "Glare", PokemonType.Normal, 0);
            Add(138, "Dream Eater", PokemonType.Psychic, 100);
            Add(139, "Poison Gas", PokemonType.Poison, 0);
            Add(140, "Barrage", PokemonType.Normal, 15);
            Add(141, "Leech Life", PokemonType.Bug, 20);
            Add(142, "Lovely Kiss", PokemonType.Normal, 0);
            Add(143, "Sky Attack", PokemonType.Flying, 140);
            Add(144, "Transform", PokemonType.Normal, 0);
            Add(145, "Bubble", PokemonType.Water, 20);
            Add(146, "Dizzy Punch", PokemonType.Normal, 70);
            Add(147, "Spore", PokemonType.Grass, 0);
            Add(148, "Flash", PokemonType.Normal, 0);
            Add(149, "Psywave", PokemonType.Psychic, 0); // variable
            Add(150, "Splash", PokemonType.Normal, 0);
            Add(151, "Acid Armor", PokemonType.Poison, 0);
            Add(152, "Crabhammer", PokemonType.Water, 90);
            Add(153, "Explosion", PokemonType.Normal, 250);
            Add(154, "Fury Swipes", PokemonType.Normal, 18);
            Add(155, "Bonemerang", PokemonType.Ground, 50);
            Add(156, "Rest", PokemonType.Psychic, 0);
            Add(157, "Rock Slide", PokemonType.Rock, 75);
            Add(158, "Hyper Fang", PokemonType.Normal, 80);
            Add(159, "Sharpen", PokemonType.Normal, 0);
            Add(160, "Conversion", PokemonType.Normal, 0);
            Add(161, "Tri Attack", PokemonType.Normal, 80);
            Add(162, "Super Fang", PokemonType.Normal, 0); // fixed 50% HP
            Add(163, "Slash", PokemonType.Normal, 70);
            Add(164, "Substitute", PokemonType.Normal, 0);
            Add(165, "Struggle", PokemonType.Normal, 50);

            // ---- Gen 2 (166-251) ----
            Add(166, "Sketch", PokemonType.Normal, 0);
            Add(167, "Triple Kick", PokemonType.Fighting, 10);
            Add(168, "Thief", PokemonType.Dark, 40);
            Add(169, "Spider Web", PokemonType.Bug, 0);
            Add(170, "Mind Reader", PokemonType.Normal, 0);
            Add(171, "Nightmare", PokemonType.Ghost, 0);
            Add(172, "Flame Wheel", PokemonType.Fire, 60);
            Add(173, "Snore", PokemonType.Normal, 40);
            Add(174, "Curse", PokemonType.Ghost, 0);
            Add(175, "Flail", PokemonType.Normal, 0); // variable (HP-based)
            Add(176, "Conversion 2", PokemonType.Normal, 0);
            Add(177, "Aeroblast", PokemonType.Flying, 100);
            Add(178, "Cotton Spore", PokemonType.Grass, 0);
            Add(179, "Reversal", PokemonType.Fighting, 0); // variable (HP-based)
            Add(180, "Spite", PokemonType.Ghost, 0);
            Add(181, "Powder Snow", PokemonType.Ice, 40);
            Add(182, "Protect", PokemonType.Normal, 0);
            Add(183, "Mach Punch", PokemonType.Fighting, 40);
            Add(184, "Scary Face", PokemonType.Normal, 0);
            Add(185, "Feint Attack", PokemonType.Dark, 60);
            Add(186, "Sweet Kiss", PokemonType.Normal, 0);
            Add(187, "Belly Drum", PokemonType.Normal, 0);
            Add(188, "Sludge Bomb", PokemonType.Poison, 90);
            Add(189, "Mud-Slap", PokemonType.Ground, 20);
            Add(190, "Octazooka", PokemonType.Water, 65);
            Add(191, "Spikes", PokemonType.Ground, 0);
            Add(192, "Zap Cannon", PokemonType.Electric, 100);
            Add(193, "Foresight", PokemonType.Normal, 0);
            Add(194, "Destiny Bond", PokemonType.Ghost, 0);
            Add(195, "Perish Song", PokemonType.Normal, 0);
            Add(196, "Icy Wind", PokemonType.Ice, 55);
            Add(197, "Detect", PokemonType.Fighting, 0);
            Add(198, "Bone Rush", PokemonType.Ground, 25);
            Add(199, "Lock-On", PokemonType.Normal, 0);
            Add(200, "Outrage", PokemonType.Dragon, 90);
            Add(201, "Sandstorm", PokemonType.Rock, 0);
            Add(202, "Giga Drain", PokemonType.Grass, 60);
            Add(203, "Endure", PokemonType.Normal, 0);
            Add(204, "Charm", PokemonType.Normal, 0);
            Add(205, "Rollout", PokemonType.Rock, 30);
            Add(206, "False Swipe", PokemonType.Normal, 40);
            Add(207, "Swagger", PokemonType.Normal, 0);
            Add(208, "Milk Drink", PokemonType.Normal, 0);
            Add(209, "Spark", PokemonType.Electric, 65);
            Add(210, "Fury Cutter", PokemonType.Bug, 10);
            Add(211, "Steel Wing", PokemonType.Steel, 70);
            Add(212, "Mean Look", PokemonType.Normal, 0);
            Add(213, "Attract", PokemonType.Normal, 0);
            Add(214, "Sleep Talk", PokemonType.Normal, 0);
            Add(215, "Heal Bell", PokemonType.Normal, 0);
            Add(216, "Return", PokemonType.Normal, 0); // variable (happiness-based)
            Add(217, "Present", PokemonType.Normal, 0); // variable
            Add(218, "Frustration", PokemonType.Normal, 0); // variable (happiness-based)
            Add(219, "Safeguard", PokemonType.Normal, 0);
            Add(220, "Pain Split", PokemonType.Normal, 0);
            Add(221, "Sacred Fire", PokemonType.Fire, 100);
            Add(222, "Magnitude", PokemonType.Ground, 0); // variable
            Add(223, "Dynamic Punch", PokemonType.Fighting, 100);
            Add(224, "Megahorn", PokemonType.Bug, 120);
            Add(225, "Dragon Breath", PokemonType.Dragon, 60);
            Add(226, "Baton Pass", PokemonType.Normal, 0);
            Add(227, "Encore", PokemonType.Normal, 0);
            Add(228, "Pursuit", PokemonType.Dark, 40);
            Add(229, "Rapid Spin", PokemonType.Normal, 20);
            Add(230, "Sweet Scent", PokemonType.Normal, 0);
            Add(231, "Iron Tail", PokemonType.Steel, 100);
            Add(232, "Metal Claw", PokemonType.Steel, 50);
            Add(233, "Vital Throw", PokemonType.Fighting, 70);
            Add(234, "Morning Sun", PokemonType.Normal, 0);
            Add(235, "Synthesis", PokemonType.Grass, 0);
            Add(236, "Moonlight", PokemonType.Dark, 0);
            Add(237, "Hidden Power", PokemonType.Normal, 0); // variable (type/power from IVs)
            Add(238, "Cross Chop", PokemonType.Fighting, 100);
            Add(239, "Twister", PokemonType.Dragon, 40);
            Add(240, "Rain Dance", PokemonType.Water, 0);
            Add(241, "Sunny Day", PokemonType.Fire, 0);
            Add(242, "Crunch", PokemonType.Dark, 80);
            Add(243, "Mirror Coat", PokemonType.Psychic, 0); // variable
            Add(244, "Psych Up", PokemonType.Normal, 0);
            Add(245, "Extreme Speed", PokemonType.Normal, 80);
            Add(246, "Ancient Power", PokemonType.Rock, 60);
            Add(247, "Shadow Ball", PokemonType.Ghost, 80);
            Add(248, "Future Sight", PokemonType.Psychic, 100);
            Add(249, "Rock Smash", PokemonType.Fighting, 40);
            Add(250, "Whirlpool", PokemonType.Water, 35);
            Add(251, "Beat Up", PokemonType.Dark, 0); // variable

            // ---- Gen 3 (252-354) ----
            Add(252, "Fake Out", PokemonType.Normal, 40);
            Add(253, "Uproar", PokemonType.Normal, 50);
            Add(254, "Stockpile", PokemonType.Normal, 0);
            Add(255, "Spit Up", PokemonType.Normal, 0); // variable (stockpile-based)
            Add(256, "Swallow", PokemonType.Normal, 0);
            Add(257, "Heat Wave", PokemonType.Fire, 100);
            Add(258, "Hail", PokemonType.Ice, 0);
            Add(259, "Torment", PokemonType.Dark, 0);
            Add(260, "Flatter", PokemonType.Dark, 0);
            Add(261, "Will-O-Wisp", PokemonType.Fire, 0);
            Add(262, "Memento", PokemonType.Dark, 0);
            Add(263, "Facade", PokemonType.Normal, 70);
            Add(264, "Focus Punch", PokemonType.Fighting, 150);
            Add(265, "Smelling Salts", PokemonType.Normal, 60);
            Add(266, "Follow Me", PokemonType.Normal, 0);
            Add(267, "Nature Power", PokemonType.Normal, 0);
            Add(268, "Charge", PokemonType.Electric, 0);
            Add(269, "Taunt", PokemonType.Dark, 0);
            Add(270, "Helping Hand", PokemonType.Normal, 0);
            Add(271, "Trick", PokemonType.Psychic, 0);
            Add(272, "Role Play", PokemonType.Psychic, 0);
            Add(273, "Wish", PokemonType.Normal, 0);
            Add(274, "Assist", PokemonType.Normal, 0);
            Add(275, "Ingrain", PokemonType.Grass, 0);
            Add(276, "Superpower", PokemonType.Fighting, 120);
            Add(277, "Magic Coat", PokemonType.Psychic, 0);
            Add(278, "Recycle", PokemonType.Normal, 0);
            Add(279, "Revenge", PokemonType.Fighting, 60);
            Add(280, "Brick Break", PokemonType.Fighting, 75);
            Add(281, "Yawn", PokemonType.Normal, 0);
            Add(282, "Knock Off", PokemonType.Dark, 20);
            Add(283, "Endeavor", PokemonType.Normal, 0); // variable
            Add(284, "Eruption", PokemonType.Fire, 150); // variable (HP-based, max 150)
            Add(285, "Skill Swap", PokemonType.Psychic, 0);
            Add(286, "Imprison", PokemonType.Psychic, 0);
            Add(287, "Refresh", PokemonType.Normal, 0);
            Add(288, "Grudge", PokemonType.Ghost, 0);
            Add(289, "Snatch", PokemonType.Dark, 0);
            Add(290, "Secret Power", PokemonType.Normal, 70);
            Add(291, "Dive", PokemonType.Water, 60);
            Add(292, "Arm Thrust", PokemonType.Fighting, 15);
            Add(293, "Camouflage", PokemonType.Normal, 0);
            Add(294, "Tail Glow", PokemonType.Bug, 0);
            Add(295, "Luster Purge", PokemonType.Psychic, 70);
            Add(296, "Mist Ball", PokemonType.Psychic, 70);
            Add(297, "Feather Dance", PokemonType.Flying, 0);
            Add(298, "Teeter Dance", PokemonType.Normal, 0);
            Add(299, "Blaze Kick", PokemonType.Fire, 85);
            Add(300, "Mud Sport", PokemonType.Ground, 0);
            Add(301, "Ice Ball", PokemonType.Ice, 30);
            Add(302, "Needle Arm", PokemonType.Grass, 60);
            Add(303, "Slack Off", PokemonType.Normal, 0);
            Add(304, "Hyper Voice", PokemonType.Normal, 90);
            Add(305, "Poison Fang", PokemonType.Poison, 50);
            Add(306, "Crush Claw", PokemonType.Normal, 75);
            Add(307, "Blast Burn", PokemonType.Fire, 150);
            Add(308, "Hydro Cannon", PokemonType.Water, 150);
            Add(309, "Meteor Mash", PokemonType.Steel, 100);
            Add(310, "Astonish", PokemonType.Ghost, 30);
            Add(311, "Weather Ball", PokemonType.Normal, 50); // variable (type/power by weather)
            Add(312, "Aromatherapy", PokemonType.Grass, 0);
            Add(313, "Fake Tears", PokemonType.Dark, 0);
            Add(314, "Air Cutter", PokemonType.Flying, 55);
            Add(315, "Overheat", PokemonType.Fire, 140);
            Add(316, "Odor Sleuth", PokemonType.Normal, 0);
            Add(317, "Rock Tomb", PokemonType.Rock, 50);
            Add(318, "Silver Wind", PokemonType.Bug, 60);
            Add(319, "Metal Sound", PokemonType.Steel, 0);
            Add(320, "Grass Whistle", PokemonType.Grass, 0);
            Add(321, "Tickle", PokemonType.Normal, 0);
            Add(322, "Cosmic Power", PokemonType.Psychic, 0);
            Add(323, "Water Spout", PokemonType.Water, 150); // variable (HP-based, max 150)
            Add(324, "Signal Beam", PokemonType.Bug, 75);
            Add(325, "Shadow Punch", PokemonType.Ghost, 60);
            Add(326, "Extrasensory", PokemonType.Psychic, 80);
            Add(327, "Sky Uppercut", PokemonType.Fighting, 85);
            Add(328, "Sand Tomb", PokemonType.Ground, 35);
            Add(329, "Sheer Cold", PokemonType.Ice, 0); // variable (OHKO)
            Add(330, "Muddy Water", PokemonType.Water, 95);
            Add(331, "Bullet Seed", PokemonType.Grass, 10);
            Add(332, "Aerial Ace", PokemonType.Flying, 60);
            Add(333, "Icicle Spear", PokemonType.Ice, 10);
            Add(334, "Iron Defense", PokemonType.Steel, 0);
            Add(335, "Block", PokemonType.Normal, 0);
            Add(336, "Howl", PokemonType.Normal, 0);
            Add(337, "Dragon Claw", PokemonType.Dragon, 80);
            Add(338, "Frenzy Plant", PokemonType.Grass, 150);
            Add(339, "Bulk Up", PokemonType.Fighting, 0);
            Add(340, "Bounce", PokemonType.Flying, 85);
            Add(341, "Mud Shot", PokemonType.Ground, 55);
            Add(342, "Poison Tail", PokemonType.Poison, 50);
            Add(343, "Covet", PokemonType.Normal, 40);
            Add(344, "Volt Tackle", PokemonType.Electric, 120);
            Add(345, "Magical Leaf", PokemonType.Grass, 60);
            Add(346, "Water Sport", PokemonType.Water, 0);
            Add(347, "Calm Mind", PokemonType.Psychic, 0);
            Add(348, "Leaf Blade", PokemonType.Grass, 90);
            Add(349, "Dragon Dance", PokemonType.Dragon, 0);
            Add(350, "Rock Blast", PokemonType.Rock, 25);
            Add(351, "Shock Wave", PokemonType.Electric, 60);
            Add(352, "Water Pulse", PokemonType.Water, 60);
            Add(353, "Doom Desire", PokemonType.Steel, 120);
            Add(354, "Psycho Boost", PokemonType.Psychic, 140);

            // ---- Gen 4 (355-467) ----
            Add(355, "Roost", PokemonType.Flying, 0);
            Add(356, "Gravity", PokemonType.Psychic, 0);
            Add(357, "Miracle Eye", PokemonType.Psychic, 0);
            Add(358, "Wake-Up Slap", PokemonType.Fighting, 60);
            Add(359, "Hammer Arm", PokemonType.Fighting, 100);
            Add(360, "Gyro Ball", PokemonType.Steel, 0); // variable (speed-based)
            Add(361, "Healing Wish", PokemonType.Psychic, 0);
            Add(362, "Brine", PokemonType.Water, 65);
            Add(363, "Natural Gift", PokemonType.Normal, 0); // variable (berry-based)
            Add(364, "Feint", PokemonType.Normal, 30);
            Add(365, "Pluck", PokemonType.Flying, 60);
            Add(366, "Tailwind", PokemonType.Flying, 0);
            Add(367, "Acupressure", PokemonType.Normal, 0);
            Add(368, "Metal Burst", PokemonType.Steel, 0); // variable
            Add(369, "U-turn", PokemonType.Bug, 70);
            Add(370, "Close Combat", PokemonType.Fighting, 120);
            Add(371, "Payback", PokemonType.Dark, 50);
            Add(372, "Assurance", PokemonType.Dark, 50);
            Add(373, "Embargo", PokemonType.Dark, 0);
            Add(374, "Fling", PokemonType.Dark, 0); // variable (item-based)
            Add(375, "Psycho Shift", PokemonType.Psychic, 0);
            Add(376, "Trump Card", PokemonType.Normal, 0); // variable (PP-based)
            Add(377, "Heal Block", PokemonType.Psychic, 0);
            Add(378, "Wring Out", PokemonType.Normal, 0); // variable (HP-based)
            Add(379, "Power Trick", PokemonType.Psychic, 0);
            Add(380, "Gastro Acid", PokemonType.Poison, 0);
            Add(381, "Lucky Chant", PokemonType.Normal, 0);
            Add(382, "Me First", PokemonType.Normal, 0);
            Add(383, "Copycat", PokemonType.Normal, 0);
            Add(384, "Power Swap", PokemonType.Psychic, 0);
            Add(385, "Guard Swap", PokemonType.Psychic, 0);
            Add(386, "Punishment", PokemonType.Dark, 0); // variable
            Add(387, "Last Resort", PokemonType.Normal, 140);
            Add(388, "Worry Seed", PokemonType.Grass, 0);
            Add(389, "Sucker Punch", PokemonType.Dark, 80);
            Add(390, "Toxic Spikes", PokemonType.Poison, 0);
            Add(391, "Heart Swap", PokemonType.Psychic, 0);
            Add(392, "Aqua Ring", PokemonType.Water, 0);
            Add(393, "Magnet Rise", PokemonType.Electric, 0);
            Add(394, "Flare Blitz", PokemonType.Fire, 120);
            Add(395, "Force Palm", PokemonType.Fighting, 60);
            Add(396, "Aura Sphere", PokemonType.Fighting, 90);
            Add(397, "Rock Polish", PokemonType.Rock, 0);
            Add(398, "Poison Jab", PokemonType.Poison, 80);
            Add(399, "Dark Pulse", PokemonType.Dark, 80);
            Add(400, "Night Slash", PokemonType.Dark, 70);
            Add(401, "Aqua Tail", PokemonType.Water, 90);
            Add(402, "Seed Bomb", PokemonType.Grass, 80);
            Add(403, "Air Slash", PokemonType.Flying, 75);
            Add(404, "X-Scissor", PokemonType.Bug, 80);
            Add(405, "Bug Buzz", PokemonType.Bug, 90);
            Add(406, "Dragon Pulse", PokemonType.Dragon, 90);
            Add(407, "Dragon Rush", PokemonType.Dragon, 100);
            Add(408, "Power Gem", PokemonType.Rock, 70);
            Add(409, "Drain Punch", PokemonType.Fighting, 60);
            Add(410, "Vacuum Wave", PokemonType.Fighting, 40);
            Add(411, "Focus Blast", PokemonType.Fighting, 120);
            Add(412, "Energy Ball", PokemonType.Grass, 80);
            Add(413, "Brave Bird", PokemonType.Flying, 120);
            Add(414, "Earth Power", PokemonType.Ground, 90);
            Add(415, "Switcheroo", PokemonType.Dark, 0);
            Add(416, "Giga Impact", PokemonType.Normal, 150);
            Add(417, "Nasty Plot", PokemonType.Dark, 0);
            Add(418, "Bullet Punch", PokemonType.Steel, 40);
            Add(419, "Avalanche", PokemonType.Ice, 60);
            Add(420, "Ice Shard", PokemonType.Ice, 40);
            Add(421, "Shadow Claw", PokemonType.Ghost, 70);
            Add(422, "Thunder Fang", PokemonType.Electric, 65);
            Add(423, "Ice Fang", PokemonType.Ice, 65);
            Add(424, "Fire Fang", PokemonType.Fire, 65);
            Add(425, "Shadow Sneak", PokemonType.Ghost, 40);
            Add(426, "Mud Bomb", PokemonType.Ground, 65);
            Add(427, "Psycho Cut", PokemonType.Psychic, 70);
            Add(428, "Zen Headbutt", PokemonType.Psychic, 80);
            Add(429, "Mirror Shot", PokemonType.Steel, 65);
            Add(430, "Flash Cannon", PokemonType.Steel, 80);
            Add(431, "Rock Climb", PokemonType.Normal, 90);
            Add(432, "Defog", PokemonType.Flying, 0);
            Add(433, "Trick Room", PokemonType.Psychic, 0);
            Add(434, "Draco Meteor", PokemonType.Dragon, 140);
            Add(435, "Discharge", PokemonType.Electric, 80);
            Add(436, "Lava Plume", PokemonType.Fire, 80);
            Add(437, "Leaf Storm", PokemonType.Grass, 140);
            Add(438, "Power Whip", PokemonType.Grass, 120);
            Add(439, "Rock Wrecker", PokemonType.Rock, 150);
            Add(440, "Cross Poison", PokemonType.Poison, 70);
            Add(441, "Gunk Shot", PokemonType.Poison, 120);
            Add(442, "Iron Head", PokemonType.Steel, 80);
            Add(443, "Magnet Bomb", PokemonType.Steel, 60);
            Add(444, "Stone Edge", PokemonType.Rock, 100);
            Add(445, "Captivate", PokemonType.Normal, 0);
            Add(446, "Stealth Rock", PokemonType.Rock, 0);
            Add(447, "Grass Knot", PokemonType.Grass, 0); // variable (weight-based)
            Add(448, "Chatter", PokemonType.Flying, 60);
            Add(449, "Judgment", PokemonType.Normal, 100); // variable (type from Plate)
            Add(450, "Bug Bite", PokemonType.Bug, 60);
            Add(451, "Charge Beam", PokemonType.Electric, 50);
            Add(452, "Wood Hammer", PokemonType.Grass, 120);
            Add(453, "Aqua Jet", PokemonType.Water, 40);
            Add(454, "Attack Order", PokemonType.Bug, 90);
            Add(455, "Defend Order", PokemonType.Bug, 0);
            Add(456, "Heal Order", PokemonType.Bug, 0);
            Add(457, "Head Smash", PokemonType.Rock, 150);
            Add(458, "Double Hit", PokemonType.Normal, 35);
            Add(459, "Roar of Time", PokemonType.Dragon, 150);
            Add(460, "Spacial Rend", PokemonType.Dragon, 100);
            Add(461, "Lunar Dance", PokemonType.Psychic, 0);
            Add(462, "Crush Grip", PokemonType.Normal, 0); // variable (HP-based)
            Add(463, "Magma Storm", PokemonType.Fire, 120);
            Add(464, "Dark Void", PokemonType.Dark, 0);
            Add(465, "Seed Flare", PokemonType.Grass, 120);
            Add(466, "Ominous Wind", PokemonType.Ghost, 60);
            Add(467, "Shadow Force", PokemonType.Ghost, 120);
        }
    }
}