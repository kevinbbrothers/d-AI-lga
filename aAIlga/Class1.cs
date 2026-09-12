using System;
using System.Collections.Generic;

namespace dAIlga
{
    public enum PokemonType
    {
        Normal, Fire, Water, Electric, Grass, Ice, Fighting, Poison, Ground,
        Flying, Psychic, Bug, Rock, Ghost, Dragon, Dark, Steel
    }

    public readonly struct PokemonTypeInfo
    {
        public string Species { get; init; }
        public PokemonType Type1 { get; init; }
        public PokemonType? Type2 { get; init; }

        public override string ToString() =>
            Type2 is null ? Type1.ToString() : $"{Type1}/{Type2}";
    }

    /// <summary>
    /// Species -> type lookup for National Dex #1-493 (everything through Gen 4 / Arceus),
    /// as of Platinum's type chart (pre-Fairy type — Clefairy, Togekiss, Mr. Mime, etc. are
    /// Normal/Psychic as they were in-game, not their modern-gen typing).
    /// Species names match Plat_Qol.lua's speciesNamesList exactly (including "Nidoran♀/♂",
    /// "Farfetch'd", "Mr. Mime", "Ho-Oh", "Porygon-Z", "Mime Jr.") so you can look up directly
    /// from either a resolved name or the raw Dex number you read from BattleMon.
    /// Note: Wormadam/Shellos/Gastrodon/Rotom/Giratina/Shaymin forms other than the base/default
    /// are not distinguished here — this is base/default-form typing only.
    /// </summary>
    public static class PokemonTypes
    {
        private static readonly PokemonTypeInfo?[] ById = new PokemonTypeInfo?[495];
        private static readonly Dictionary<string, PokemonTypeInfo> ByName =
            new(StringComparer.OrdinalIgnoreCase);

        private static void Add(int id, string name, PokemonType t1, PokemonType? t2 = null)
        {
            var info = new PokemonTypeInfo { Species = name, Type1 = t1, Type2 = t2 };
            ById[id] = info;
            ByName[name] = info;
        }

        /// <summary>Look up by species name (case-insensitive). Returns null if not found.</summary>
        public static PokemonTypeInfo? GetTypes(string speciesName) =>
            ByName.TryGetValue(speciesName, out var info) ? info : null;

        /// <summary>Look up by National Dex number (1-494, where 494 = "None"). Returns null if out of range.</summary>
        public static PokemonTypeInfo? GetTypes(int speciesId) =>
            (speciesId >= 1 && speciesId <= 495) ? ById[speciesId] : null;

        static PokemonTypes()
        {
            // ---- Gen 1 (1-151) ----
            Add(1, "Bulbasaur", PokemonType.Grass, PokemonType.Poison);
            Add(2, "Ivysaur", PokemonType.Grass, PokemonType.Poison);
            Add(3, "Venusaur", PokemonType.Grass, PokemonType.Poison);
            Add(4, "Charmander", PokemonType.Fire);
            Add(5, "Charmeleon", PokemonType.Fire);
            Add(6, "Charizard", PokemonType.Fire, PokemonType.Flying);
            Add(7, "Squirtle", PokemonType.Water);
            Add(8, "Wartortle", PokemonType.Water);
            Add(9, "Blastoise", PokemonType.Water);
            Add(10, "Caterpie", PokemonType.Bug);
            Add(11, "Metapod", PokemonType.Bug);
            Add(12, "Butterfree", PokemonType.Bug, PokemonType.Flying);
            Add(13, "Weedle", PokemonType.Bug, PokemonType.Poison);
            Add(14, "Kakuna", PokemonType.Bug, PokemonType.Poison);
            Add(15, "Beedrill", PokemonType.Bug, PokemonType.Poison);
            Add(16, "Pidgey", PokemonType.Normal, PokemonType.Flying);
            Add(17, "Pidgeotto", PokemonType.Normal, PokemonType.Flying);
            Add(18, "Pidgeot", PokemonType.Normal, PokemonType.Flying);
            Add(19, "Rattata", PokemonType.Normal);
            Add(20, "Raticate", PokemonType.Normal);
            Add(21, "Spearow", PokemonType.Normal, PokemonType.Flying);
            Add(22, "Fearow", PokemonType.Normal, PokemonType.Flying);
            Add(23, "Ekans", PokemonType.Poison);
            Add(24, "Arbok", PokemonType.Poison);
            Add(25, "Pikachu", PokemonType.Electric);
            Add(26, "Raichu", PokemonType.Electric);
            Add(27, "Sandshrew", PokemonType.Ground);
            Add(28, "Sandslash", PokemonType.Ground);
            Add(29, "Nidoran♀", PokemonType.Poison);
            Add(30, "Nidorina", PokemonType.Poison);
            Add(31, "Nidoqueen", PokemonType.Poison, PokemonType.Ground);
            Add(32, "Nidoran♂", PokemonType.Poison);
            Add(33, "Nidorino", PokemonType.Poison);
            Add(34, "Nidoking", PokemonType.Poison, PokemonType.Ground);
            Add(35, "Clefairy", PokemonType.Normal);
            Add(36, "Clefable", PokemonType.Normal);
            Add(37, "Vulpix", PokemonType.Fire);
            Add(38, "Ninetales", PokemonType.Fire);
            Add(39, "Jigglypuff", PokemonType.Normal);
            Add(40, "Wigglytuff", PokemonType.Normal);
            Add(41, "Zubat", PokemonType.Poison, PokemonType.Flying);
            Add(42, "Golbat", PokemonType.Poison, PokemonType.Flying);
            Add(43, "Oddish", PokemonType.Grass, PokemonType.Poison);
            Add(44, "Gloom", PokemonType.Grass, PokemonType.Poison);
            Add(45, "Vileplume", PokemonType.Grass, PokemonType.Poison);
            Add(46, "Paras", PokemonType.Bug, PokemonType.Grass);
            Add(47, "Parasect", PokemonType.Bug, PokemonType.Grass);
            Add(48, "Venonat", PokemonType.Bug, PokemonType.Poison);
            Add(49, "Venomoth", PokemonType.Bug, PokemonType.Poison);
            Add(50, "Diglett", PokemonType.Ground);
            Add(51, "Dugtrio", PokemonType.Ground);
            Add(52, "Meowth", PokemonType.Normal);
            Add(53, "Persian", PokemonType.Normal);
            Add(54, "Psyduck", PokemonType.Water);
            Add(55, "Golduck", PokemonType.Water);
            Add(56, "Mankey", PokemonType.Fighting);
            Add(57, "Primeape", PokemonType.Fighting);
            Add(58, "Growlithe", PokemonType.Fire);
            Add(59, "Arcanine", PokemonType.Fire);
            Add(60, "Poliwag", PokemonType.Water);
            Add(61, "Poliwhirl", PokemonType.Water);
            Add(62, "Poliwrath", PokemonType.Water, PokemonType.Fighting);
            Add(63, "Abra", PokemonType.Psychic);
            Add(64, "Kadabra", PokemonType.Psychic);
            Add(65, "Alakazam", PokemonType.Psychic);
            Add(66, "Machop", PokemonType.Fighting);
            Add(67, "Machoke", PokemonType.Fighting);
            Add(68, "Machamp", PokemonType.Fighting);
            Add(69, "Bellsprout", PokemonType.Grass, PokemonType.Poison);
            Add(70, "Weepinbell", PokemonType.Grass, PokemonType.Poison);
            Add(71, "Victreebel", PokemonType.Grass, PokemonType.Poison);
            Add(72, "Tentacool", PokemonType.Water, PokemonType.Poison);
            Add(73, "Tentacruel", PokemonType.Water, PokemonType.Poison);
            Add(74, "Geodude", PokemonType.Rock, PokemonType.Ground);
            Add(75, "Graveler", PokemonType.Rock, PokemonType.Ground);
            Add(76, "Golem", PokemonType.Rock, PokemonType.Ground);
            Add(77, "Ponyta", PokemonType.Fire);
            Add(78, "Rapidash", PokemonType.Fire);
            Add(79, "Slowpoke", PokemonType.Water, PokemonType.Psychic);
            Add(80, "Slowbro", PokemonType.Water, PokemonType.Psychic);
            Add(81, "Magnemite", PokemonType.Electric, PokemonType.Steel);
            Add(82, "Magneton", PokemonType.Electric, PokemonType.Steel);
            Add(83, "Farfetch'd", PokemonType.Normal, PokemonType.Flying);
            Add(84, "Doduo", PokemonType.Normal, PokemonType.Flying);
            Add(85, "Dodrio", PokemonType.Normal, PokemonType.Flying);
            Add(86, "Seel", PokemonType.Water);
            Add(87, "Dewgong", PokemonType.Water, PokemonType.Ice);
            Add(88, "Grimer", PokemonType.Poison);
            Add(89, "Muk", PokemonType.Poison);
            Add(90, "Shellder", PokemonType.Water);
            Add(91, "Cloyster", PokemonType.Water, PokemonType.Ice);
            Add(92, "Gastly", PokemonType.Ghost, PokemonType.Poison);
            Add(93, "Haunter", PokemonType.Ghost, PokemonType.Poison);
            Add(94, "Gengar", PokemonType.Ghost, PokemonType.Poison);
            Add(95, "Onix", PokemonType.Rock, PokemonType.Ground);
            Add(96, "Drowzee", PokemonType.Psychic);
            Add(97, "Hypno", PokemonType.Psychic);
            Add(98, "Krabby", PokemonType.Water);
            Add(99, "Kingler", PokemonType.Water);
            Add(100, "Voltorb", PokemonType.Electric);
            Add(101, "Electrode", PokemonType.Electric);
            Add(102, "Exeggcute", PokemonType.Grass, PokemonType.Psychic);
            Add(103, "Exeggutor", PokemonType.Grass, PokemonType.Psychic);
            Add(104, "Cubone", PokemonType.Ground);
            Add(105, "Marowak", PokemonType.Ground);
            Add(106, "Hitmonlee", PokemonType.Fighting);
            Add(107, "Hitmonchan", PokemonType.Fighting);
            Add(108, "Lickitung", PokemonType.Normal);
            Add(109, "Koffing", PokemonType.Poison);
            Add(110, "Weezing", PokemonType.Poison);
            Add(111, "Rhyhorn", PokemonType.Ground, PokemonType.Rock);
            Add(112, "Rhydon", PokemonType.Ground, PokemonType.Rock);
            Add(113, "Chansey", PokemonType.Normal);
            Add(114, "Tangela", PokemonType.Grass);
            Add(115, "Kangaskhan", PokemonType.Normal);
            Add(116, "Horsea", PokemonType.Water);
            Add(117, "Seadra", PokemonType.Water);
            Add(118, "Goldeen", PokemonType.Water);
            Add(119, "Seaking", PokemonType.Water);
            Add(120, "Staryu", PokemonType.Water);
            Add(121, "Starmie", PokemonType.Water, PokemonType.Psychic);
            Add(122, "Mr. Mime", PokemonType.Psychic);
            Add(123, "Scyther", PokemonType.Bug, PokemonType.Flying);
            Add(124, "Jynx", PokemonType.Ice, PokemonType.Psychic);
            Add(125, "Electabuzz", PokemonType.Electric);
            Add(126, "Magmar", PokemonType.Fire);
            Add(127, "Pinsir", PokemonType.Bug);
            Add(128, "Tauros", PokemonType.Normal);
            Add(129, "Magikarp", PokemonType.Water);
            Add(130, "Gyarados", PokemonType.Water, PokemonType.Flying);
            Add(131, "Lapras", PokemonType.Water, PokemonType.Ice);
            Add(132, "Ditto", PokemonType.Normal);
            Add(133, "Eevee", PokemonType.Normal);
            Add(134, "Vaporeon", PokemonType.Water);
            Add(135, "Jolteon", PokemonType.Electric);
            Add(136, "Flareon", PokemonType.Fire);
            Add(137, "Porygon", PokemonType.Normal);
            Add(138, "Omanyte", PokemonType.Rock, PokemonType.Water);
            Add(139, "Omastar", PokemonType.Rock, PokemonType.Water);
            Add(140, "Kabuto", PokemonType.Rock, PokemonType.Water);
            Add(141, "Kabutops", PokemonType.Rock, PokemonType.Water);
            Add(142, "Aerodactyl", PokemonType.Rock, PokemonType.Flying);
            Add(143, "Snorlax", PokemonType.Normal);
            Add(144, "Articuno", PokemonType.Ice, PokemonType.Flying);
            Add(145, "Zapdos", PokemonType.Electric, PokemonType.Flying);
            Add(146, "Moltres", PokemonType.Fire, PokemonType.Flying);
            Add(147, "Dratini", PokemonType.Dragon);
            Add(148, "Dragonair", PokemonType.Dragon);
            Add(149, "Dragonite", PokemonType.Dragon, PokemonType.Flying);
            Add(150, "Mewtwo", PokemonType.Psychic);
            Add(151, "Mew", PokemonType.Psychic);

            // ---- Gen 2 (152-251) ----
            Add(152, "Chikorita", PokemonType.Grass);
            Add(153, "Bayleef", PokemonType.Grass);
            Add(154, "Meganium", PokemonType.Grass);
            Add(155, "Cyndaquil", PokemonType.Fire);
            Add(156, "Quilava", PokemonType.Fire);
            Add(157, "Typhlosion", PokemonType.Fire);
            Add(158, "Totodile", PokemonType.Water);
            Add(159, "Croconaw", PokemonType.Water);
            Add(160, "Feraligatr", PokemonType.Water);
            Add(161, "Sentret", PokemonType.Normal);
            Add(162, "Furret", PokemonType.Normal);
            Add(163, "Hoothoot", PokemonType.Normal, PokemonType.Flying);
            Add(164, "Noctowl", PokemonType.Normal, PokemonType.Flying);
            Add(165, "Ledyba", PokemonType.Bug, PokemonType.Flying);
            Add(166, "Ledian", PokemonType.Bug, PokemonType.Flying);
            Add(167, "Spinarak", PokemonType.Bug, PokemonType.Poison);
            Add(168, "Ariados", PokemonType.Bug, PokemonType.Poison);
            Add(169, "Crobat", PokemonType.Poison, PokemonType.Flying);
            Add(170, "Chinchou", PokemonType.Water, PokemonType.Electric);
            Add(171, "Lanturn", PokemonType.Water, PokemonType.Electric);
            Add(172, "Pichu", PokemonType.Electric);
            Add(173, "Cleffa", PokemonType.Normal);
            Add(174, "Igglybuff", PokemonType.Normal);
            Add(175, "Togepi", PokemonType.Normal);
            Add(176, "Togetic", PokemonType.Normal, PokemonType.Flying);
            Add(177, "Natu", PokemonType.Psychic, PokemonType.Flying);
            Add(178, "Xatu", PokemonType.Psychic, PokemonType.Flying);
            Add(179, "Mareep", PokemonType.Electric);
            Add(180, "Flaaffy", PokemonType.Electric);
            Add(181, "Ampharos", PokemonType.Electric);
            Add(182, "Bellossom", PokemonType.Grass);
            Add(183, "Marill", PokemonType.Water);
            Add(184, "Azumarill", PokemonType.Water);
            Add(185, "Sudowoodo", PokemonType.Rock);
            Add(186, "Politoed", PokemonType.Water);
            Add(187, "Hoppip", PokemonType.Grass, PokemonType.Flying);
            Add(188, "Skiploom", PokemonType.Grass, PokemonType.Flying);
            Add(189, "Jumpluff", PokemonType.Grass, PokemonType.Flying);
            Add(190, "Aipom", PokemonType.Normal);
            Add(191, "Sunkern", PokemonType.Grass);
            Add(192, "Sunflora", PokemonType.Grass);
            Add(193, "Yanma", PokemonType.Bug, PokemonType.Flying);
            Add(194, "Wooper", PokemonType.Water, PokemonType.Ground);
            Add(195, "Quagsire", PokemonType.Water, PokemonType.Ground);
            Add(196, "Espeon", PokemonType.Psychic);
            Add(197, "Umbreon", PokemonType.Dark);
            Add(198, "Murkrow", PokemonType.Dark, PokemonType.Flying);
            Add(199, "Slowking", PokemonType.Water, PokemonType.Psychic);
            Add(200, "Misdreavus", PokemonType.Ghost);
            Add(201, "Unown", PokemonType.Psychic);
            Add(202, "Wobbuffet", PokemonType.Psychic);
            Add(203, "Girafarig", PokemonType.Normal, PokemonType.Psychic);
            Add(204, "Pineco", PokemonType.Bug);
            Add(205, "Forretress", PokemonType.Bug, PokemonType.Steel);
            Add(206, "Dunsparce", PokemonType.Normal);
            Add(207, "Gligar", PokemonType.Ground, PokemonType.Flying);
            Add(208, "Steelix", PokemonType.Steel, PokemonType.Ground);
            Add(209, "Snubbull", PokemonType.Normal);
            Add(210, "Granbull", PokemonType.Normal);
            Add(211, "Qwilfish", PokemonType.Water, PokemonType.Poison);
            Add(212, "Scizor", PokemonType.Bug, PokemonType.Steel);
            Add(213, "Shuckle", PokemonType.Bug, PokemonType.Rock);
            Add(214, "Heracross", PokemonType.Bug, PokemonType.Fighting);
            Add(215, "Sneasel", PokemonType.Dark, PokemonType.Ice);
            Add(216, "Teddiursa", PokemonType.Normal);
            Add(217, "Ursaring", PokemonType.Normal);
            Add(218, "Slugma", PokemonType.Fire);
            Add(219, "Magcargo", PokemonType.Fire, PokemonType.Rock);
            Add(220, "Swinub", PokemonType.Ice, PokemonType.Ground);
            Add(221, "Piloswine", PokemonType.Ice, PokemonType.Ground);
            Add(222, "Corsola", PokemonType.Water, PokemonType.Rock);
            Add(223, "Remoraid", PokemonType.Water);
            Add(224, "Octillery", PokemonType.Water);
            Add(225, "Delibird", PokemonType.Ice, PokemonType.Flying);
            Add(226, "Mantine", PokemonType.Water, PokemonType.Flying);
            Add(227, "Skarmory", PokemonType.Steel, PokemonType.Flying);
            Add(228, "Houndour", PokemonType.Dark, PokemonType.Fire);
            Add(229, "Houndoom", PokemonType.Dark, PokemonType.Fire);
            Add(230, "Kingdra", PokemonType.Water, PokemonType.Dragon);
            Add(231, "Phanpy", PokemonType.Ground);
            Add(232, "Donphan", PokemonType.Ground);
            Add(233, "Porygon2", PokemonType.Normal);
            Add(234, "Stantler", PokemonType.Normal);
            Add(235, "Smeargle", PokemonType.Normal);
            Add(236, "Tyrogue", PokemonType.Fighting);
            Add(237, "Hitmontop", PokemonType.Fighting);
            Add(238, "Smoochum", PokemonType.Ice, PokemonType.Psychic);
            Add(239, "Elekid", PokemonType.Electric);
            Add(240, "Magby", PokemonType.Fire);
            Add(241, "Miltank", PokemonType.Normal);
            Add(242, "Blissey", PokemonType.Normal);
            Add(243, "Raikou", PokemonType.Electric);
            Add(244, "Entei", PokemonType.Fire);
            Add(245, "Suicune", PokemonType.Water);
            Add(246, "Larvitar", PokemonType.Rock, PokemonType.Ground);
            Add(247, "Pupitar", PokemonType.Rock, PokemonType.Ground);
            Add(248, "Tyranitar", PokemonType.Rock, PokemonType.Dark);
            Add(249, "Lugia", PokemonType.Psychic, PokemonType.Flying);
            Add(250, "Ho-Oh", PokemonType.Fire, PokemonType.Flying);
            Add(251, "Celebi", PokemonType.Psychic, PokemonType.Grass);

            // ---- Gen 3 (252-386) ----
            Add(252, "Treecko", PokemonType.Grass);
            Add(253, "Grovyle", PokemonType.Grass);
            Add(254, "Sceptile", PokemonType.Grass);
            Add(255, "Torchic", PokemonType.Fire);
            Add(256, "Combusken", PokemonType.Fire, PokemonType.Fighting);
            Add(257, "Blaziken", PokemonType.Fire, PokemonType.Fighting);
            Add(258, "Mudkip", PokemonType.Water);
            Add(259, "Marshtomp", PokemonType.Water, PokemonType.Ground);
            Add(260, "Swampert", PokemonType.Water, PokemonType.Ground);
            Add(261, "Poochyena", PokemonType.Dark);
            Add(262, "Mightyena", PokemonType.Dark);
            Add(263, "Zigzagoon", PokemonType.Normal);
            Add(264, "Linoone", PokemonType.Normal);
            Add(265, "Wurmple", PokemonType.Bug);
            Add(266, "Silcoon", PokemonType.Bug);
            Add(267, "Beautifly", PokemonType.Bug, PokemonType.Flying);
            Add(268, "Cascoon", PokemonType.Bug);
            Add(269, "Dustox", PokemonType.Bug, PokemonType.Poison);
            Add(270, "Lotad", PokemonType.Water, PokemonType.Grass);
            Add(271, "Lombre", PokemonType.Water, PokemonType.Grass);
            Add(272, "Ludicolo", PokemonType.Water, PokemonType.Grass);
            Add(273, "Seedot", PokemonType.Grass);
            Add(274, "Nuzleaf", PokemonType.Grass, PokemonType.Dark);
            Add(275, "Shiftry", PokemonType.Grass, PokemonType.Dark);
            Add(276, "Taillow", PokemonType.Normal, PokemonType.Flying);
            Add(277, "Swellow", PokemonType.Normal, PokemonType.Flying);
            Add(278, "Wingull", PokemonType.Water, PokemonType.Flying);
            Add(279, "Pelipper", PokemonType.Water, PokemonType.Flying);
            Add(280, "Ralts", PokemonType.Psychic);
            Add(281, "Kirlia", PokemonType.Psychic);
            Add(282, "Gardevoir", PokemonType.Psychic);
            Add(283, "Surskit", PokemonType.Bug, PokemonType.Water);
            Add(284, "Masquerain", PokemonType.Bug, PokemonType.Flying);
            Add(285, "Shroomish", PokemonType.Grass);
            Add(286, "Breloom", PokemonType.Grass, PokemonType.Fighting);
            Add(287, "Slakoth", PokemonType.Normal);
            Add(288, "Vigoroth", PokemonType.Normal);
            Add(289, "Slaking", PokemonType.Normal);
            Add(290, "Nincada", PokemonType.Bug, PokemonType.Ground);
            Add(291, "Ninjask", PokemonType.Bug, PokemonType.Flying);
            Add(292, "Shedinja", PokemonType.Bug, PokemonType.Ghost);
            Add(293, "Whismur", PokemonType.Normal);
            Add(294, "Loudred", PokemonType.Normal);
            Add(295, "Exploud", PokemonType.Normal);
            Add(296, "Makuhita", PokemonType.Fighting);
            Add(297, "Hariyama", PokemonType.Fighting);
            Add(298, "Azurill", PokemonType.Normal);
            Add(299, "Nosepass", PokemonType.Rock);
            Add(300, "Skitty", PokemonType.Normal);
            Add(301, "Delcatty", PokemonType.Normal);
            Add(302, "Sableye", PokemonType.Dark, PokemonType.Ghost);
            Add(303, "Mawile", PokemonType.Steel);
            Add(304, "Aron", PokemonType.Steel, PokemonType.Rock);
            Add(305, "Lairon", PokemonType.Steel, PokemonType.Rock);
            Add(306, "Aggron", PokemonType.Steel, PokemonType.Rock);
            Add(307, "Meditite", PokemonType.Fighting, PokemonType.Psychic);
            Add(308, "Medicham", PokemonType.Fighting, PokemonType.Psychic);
            Add(309, "Electrike", PokemonType.Electric);
            Add(310, "Manectric", PokemonType.Electric);
            Add(311, "Plusle", PokemonType.Electric);
            Add(312, "Minun", PokemonType.Electric);
            Add(313, "Volbeat", PokemonType.Bug);
            Add(314, "Illumise", PokemonType.Bug);
            Add(315, "Roselia", PokemonType.Grass, PokemonType.Poison);
            Add(316, "Gulpin", PokemonType.Poison);
            Add(317, "Swalot", PokemonType.Poison);
            Add(318, "Carvanha", PokemonType.Water, PokemonType.Dark);
            Add(319, "Sharpedo", PokemonType.Water, PokemonType.Dark);
            Add(320, "Wailmer", PokemonType.Water);
            Add(321, "Wailord", PokemonType.Water);
            Add(322, "Numel", PokemonType.Fire, PokemonType.Ground);
            Add(323, "Camerupt", PokemonType.Fire, PokemonType.Ground);
            Add(324, "Torkoal", PokemonType.Fire);
            Add(325, "Spoink", PokemonType.Psychic);
            Add(326, "Grumpig", PokemonType.Psychic);
            Add(327, "Spinda", PokemonType.Normal);
            Add(328, "Trapinch", PokemonType.Ground);
            Add(329, "Vibrava", PokemonType.Ground, PokemonType.Dragon);
            Add(330, "Flygon", PokemonType.Ground, PokemonType.Dragon);
            Add(331, "Cacnea", PokemonType.Grass);
            Add(332, "Cacturne", PokemonType.Grass, PokemonType.Dark);
            Add(333, "Swablu", PokemonType.Normal, PokemonType.Flying);
            Add(334, "Altaria", PokemonType.Dragon, PokemonType.Flying);
            Add(335, "Zangoose", PokemonType.Normal);
            Add(336, "Seviper", PokemonType.Poison);
            Add(337, "Lunatone", PokemonType.Rock, PokemonType.Psychic);
            Add(338, "Solrock", PokemonType.Rock, PokemonType.Psychic);
            Add(339, "Barboach", PokemonType.Water, PokemonType.Ground);
            Add(340, "Whiscash", PokemonType.Water, PokemonType.Ground);
            Add(341, "Corphish", PokemonType.Water);
            Add(342, "Crawdaunt", PokemonType.Water, PokemonType.Dark);
            Add(343, "Baltoy", PokemonType.Ground, PokemonType.Psychic);
            Add(344, "Claydol", PokemonType.Ground, PokemonType.Psychic);
            Add(345, "Lileep", PokemonType.Rock, PokemonType.Grass);
            Add(346, "Cradily", PokemonType.Rock, PokemonType.Grass);
            Add(347, "Anorith", PokemonType.Rock, PokemonType.Bug);
            Add(348, "Armaldo", PokemonType.Rock, PokemonType.Bug);
            Add(349, "Feebas", PokemonType.Water);
            Add(350, "Milotic", PokemonType.Water);
            Add(351, "Castform", PokemonType.Normal);
            Add(352, "Kecleon", PokemonType.Normal);
            Add(353, "Shuppet", PokemonType.Ghost);
            Add(354, "Banette", PokemonType.Ghost);
            Add(355, "Duskull", PokemonType.Ghost);
            Add(356, "Dusclops", PokemonType.Ghost);
            Add(357, "Tropius", PokemonType.Grass, PokemonType.Flying);
            Add(358, "Chimecho", PokemonType.Psychic);
            Add(359, "Absol", PokemonType.Dark);
            Add(360, "Wynaut", PokemonType.Psychic);
            Add(361, "Snorunt", PokemonType.Ice);
            Add(362, "Glalie", PokemonType.Ice);
            Add(363, "Spheal", PokemonType.Ice, PokemonType.Water);
            Add(364, "Sealeo", PokemonType.Ice, PokemonType.Water);
            Add(365, "Walrein", PokemonType.Ice, PokemonType.Water);
            Add(366, "Clamperl", PokemonType.Water);
            Add(367, "Huntail", PokemonType.Water);
            Add(368, "Gorebyss", PokemonType.Water);
            Add(369, "Relicanth", PokemonType.Water, PokemonType.Rock);
            Add(370, "Luvdisc", PokemonType.Water);
            Add(371, "Bagon", PokemonType.Dragon);
            Add(372, "Shelgon", PokemonType.Dragon);
            Add(373, "Salamence", PokemonType.Dragon, PokemonType.Flying);
            Add(374, "Beldum", PokemonType.Steel, PokemonType.Psychic);
            Add(375, "Metang", PokemonType.Steel, PokemonType.Psychic);
            Add(376, "Metagross", PokemonType.Steel, PokemonType.Psychic);
            Add(377, "Regirock", PokemonType.Rock);
            Add(378, "Regice", PokemonType.Ice);
            Add(379, "Registeel", PokemonType.Steel);
            Add(380, "Latias", PokemonType.Dragon, PokemonType.Psychic);
            Add(381, "Latios", PokemonType.Dragon, PokemonType.Psychic);
            Add(382, "Kyogre", PokemonType.Water);
            Add(383, "Groudon", PokemonType.Ground);
            Add(384, "Rayquaza", PokemonType.Dragon, PokemonType.Flying);
            Add(385, "Jirachi", PokemonType.Steel, PokemonType.Psychic);
            Add(386, "Deoxys", PokemonType.Psychic);

            // ---- Gen 4 (387-493) ----
            Add(387, "Turtwig", PokemonType.Grass);
            Add(388, "Grotle", PokemonType.Grass);
            Add(389, "Torterra", PokemonType.Grass, PokemonType.Ground);
            Add(390, "Chimchar", PokemonType.Fire);
            Add(391, "Monferno", PokemonType.Fire, PokemonType.Fighting);
            Add(392, "Infernape", PokemonType.Fire, PokemonType.Fighting);
            Add(393, "Piplup", PokemonType.Water);
            Add(394, "Prinplup", PokemonType.Water);
            Add(395, "Empoleon", PokemonType.Water, PokemonType.Steel);
            Add(396, "Starly", PokemonType.Normal, PokemonType.Flying);
            Add(397, "Staravia", PokemonType.Normal, PokemonType.Flying);
            Add(398, "Staraptor", PokemonType.Normal, PokemonType.Flying);
            Add(399, "Bidoof", PokemonType.Normal);
            Add(400, "Bibarel", PokemonType.Normal, PokemonType.Water);
            Add(401, "Kricketot", PokemonType.Bug);
            Add(402, "Kricketune", PokemonType.Bug);
            Add(403, "Shinx", PokemonType.Electric);
            Add(404, "Luxio", PokemonType.Electric);
            Add(405, "Luxray", PokemonType.Electric);
            Add(406, "Budew", PokemonType.Grass, PokemonType.Poison);
            Add(407, "Roserade", PokemonType.Grass, PokemonType.Poison);
            Add(408, "Cranidos", PokemonType.Rock);
            Add(409, "Rampardos", PokemonType.Rock);
            Add(410, "Shieldon", PokemonType.Rock, PokemonType.Steel);
            Add(411, "Bastiodon", PokemonType.Rock, PokemonType.Steel);
            Add(412, "Burmy", PokemonType.Bug);
            Add(413, "Wormadam", PokemonType.Bug, PokemonType.Grass); // Plant Cloak (default)
            Add(414, "Mothim", PokemonType.Bug, PokemonType.Flying);
            Add(415, "Combee", PokemonType.Bug, PokemonType.Flying);
            Add(416, "Vespiquen", PokemonType.Bug, PokemonType.Flying);
            Add(417, "Pachirisu", PokemonType.Electric);
            Add(418, "Buizel", PokemonType.Water);
            Add(419, "Floatzel", PokemonType.Water);
            Add(420, "Cherubi", PokemonType.Grass);
            Add(421, "Cherrim", PokemonType.Grass);
            Add(422, "Shellos", PokemonType.Water);
            Add(423, "Gastrodon", PokemonType.Water, PokemonType.Ground);
            Add(424, "Ambipom", PokemonType.Normal);
            Add(425, "Drifloon", PokemonType.Ghost, PokemonType.Flying);
            Add(426, "Drifblim", PokemonType.Ghost, PokemonType.Flying);
            Add(427, "Buneary", PokemonType.Normal);
            Add(428, "Lopunny", PokemonType.Normal);
            Add(429, "Mismagius", PokemonType.Ghost);
            Add(430, "Honchkrow", PokemonType.Dark, PokemonType.Flying);
            Add(431, "Glameow", PokemonType.Normal);
            Add(432, "Purugly", PokemonType.Normal);
            Add(433, "Chingling", PokemonType.Psychic);
            Add(434, "Stunky", PokemonType.Poison, PokemonType.Dark);
            Add(435, "Skuntank", PokemonType.Poison, PokemonType.Dark);
            Add(436, "Bronzor", PokemonType.Steel, PokemonType.Psychic);
            Add(437, "Bronzong", PokemonType.Steel, PokemonType.Psychic);
            Add(438, "Bonsly", PokemonType.Rock);
            Add(439, "Mime Jr.", PokemonType.Psychic);
            Add(440, "Happiny", PokemonType.Normal);
            Add(441, "Chatot", PokemonType.Normal, PokemonType.Flying);
            Add(442, "Spiritomb", PokemonType.Ghost, PokemonType.Dark);
            Add(443, "Gible", PokemonType.Dragon, PokemonType.Ground);
            Add(444, "Gabite", PokemonType.Dragon, PokemonType.Ground);
            Add(445, "Garchomp", PokemonType.Dragon, PokemonType.Ground);
            Add(446, "Munchlax", PokemonType.Normal);
            Add(447, "Riolu", PokemonType.Fighting);
            Add(448, "Lucario", PokemonType.Fighting, PokemonType.Steel);
            Add(449, "Hippopotas", PokemonType.Ground);
            Add(450, "Hippowdon", PokemonType.Ground);
            Add(451, "Skorupi", PokemonType.Poison, PokemonType.Bug);
            Add(452, "Drapion", PokemonType.Poison, PokemonType.Dark);
            Add(453, "Croagunk", PokemonType.Poison, PokemonType.Fighting);
            Add(454, "Toxicroak", PokemonType.Poison, PokemonType.Fighting);
            Add(455, "Carnivine", PokemonType.Grass);
            Add(456, "Finneon", PokemonType.Water);
            Add(457, "Lumineon", PokemonType.Water);
            Add(458, "Mantyke", PokemonType.Water, PokemonType.Flying);
            Add(459, "Snover", PokemonType.Grass, PokemonType.Ice);
            Add(460, "Abomasnow", PokemonType.Grass, PokemonType.Ice);
            Add(461, "Weavile", PokemonType.Dark, PokemonType.Ice);
            Add(462, "Magnezone", PokemonType.Electric, PokemonType.Steel);
            Add(463, "Lickilicky", PokemonType.Normal);
            Add(464, "Rhyperior", PokemonType.Ground, PokemonType.Rock);
            Add(465, "Tangrowth", PokemonType.Grass);
            Add(466, "Electivire", PokemonType.Electric);
            Add(467, "Magmortar", PokemonType.Fire);
            Add(468, "Togekiss", PokemonType.Normal, PokemonType.Flying);
            Add(469, "Yanmega", PokemonType.Bug, PokemonType.Flying);
            Add(470, "Leafeon", PokemonType.Grass);
            Add(471, "Glaceon", PokemonType.Ice);
            Add(472, "Gliscor", PokemonType.Ground, PokemonType.Flying);
            Add(473, "Mamoswine", PokemonType.Ice, PokemonType.Ground);
            Add(474, "Porygon-Z", PokemonType.Normal);
            Add(475, "Gallade", PokemonType.Psychic, PokemonType.Fighting);
            Add(476, "Probopass", PokemonType.Rock, PokemonType.Steel);
            Add(477, "Dusknoir", PokemonType.Ghost);
            Add(478, "Froslass", PokemonType.Ice, PokemonType.Ghost);
            Add(479, "Rotom", PokemonType.Electric, PokemonType.Ghost); // base form; appliance forms differ
            Add(480, "Uxie", PokemonType.Psychic);
            Add(481, "Mesprit", PokemonType.Psychic);
            Add(482, "Azelf", PokemonType.Psychic);
            Add(483, "Dialga", PokemonType.Steel, PokemonType.Dragon);
            Add(484, "Palkia", PokemonType.Water, PokemonType.Dragon);
            Add(485, "Heatran", PokemonType.Fire, PokemonType.Steel);
            Add(486, "Regigigas", PokemonType.Normal);
            Add(487, "Giratina", PokemonType.Ghost, PokemonType.Dragon); // Altered Forme
            Add(488, "Cresselia", PokemonType.Psychic);
            Add(489, "Phione", PokemonType.Water);
            Add(490, "Manaphy", PokemonType.Water);
            Add(491, "Darkrai", PokemonType.Dark);
            Add(492, "Shaymin", PokemonType.Grass); // Land Forme
            Add(493, "Arceus", PokemonType.Normal); // base form (Plate changes it)
            Add(494, "None", PokemonType.Normal); // base form (Plate changes it)
        }
    }
}