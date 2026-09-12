-- AUTO-GENERATED. Edit files in DeSmuMe/src and run build_bundle.ps1

-- >>> BEGIN 00_header.lua
-- Module Index: 00_header
-- Owns: runtime aliases, large static data tables, early startup/version bootstrap (`printGameInfo`).
-- Note: intentionally keeps very-early declarations needed before later modules load.

read32Bit = memory.readdwordunsigned
read16Bit = memory.readword
read8Bit = memory.readbyte
write16Bit = memory.writeword
rshift = bit.rshift
lshift = bit.lshift
band = bit.band
bxor = bit.bxor
bor = bit.bor
floor = math.floor

local JUMP_DATA = {
 {0x41C64E6D, 0x6073}, {0xC2A29A69, 0xE97E7B6A}, {0xEE067F11, 0x31B0DDE4}, {0xCFDDDF21, 0x67DBB608},
 {0x5F748241, 0xCBA72510}, {0x8B2E1481, 0x1D29AE20}, {0x76006901, 0xBA84EC40}, {0x1711D201, 0x79F01880},
 {0xBE67A401, 0x8793100}, {0xDDDF4801, 0x6B566200}, {0x3FFE9001, 0x803CC400}, {0x90FD2001, 0xA6B98800},
 {0x65FA4001, 0xE6731000}, {0xDBF48001, 0x30E62000}, {0xF7E90001, 0xF1CC4000}, {0xEFD20001, 0x23988000},
 {0xDFA40001, 0x47310000}, {0xBF480001, 0x8E620000}, {0x7E900001, 0x1CC40000}, {0xFD200001, 0x39880000},
 {0xFA400001, 0x73100000}, {0xF4800001, 0xE6200000}, {0xE9000001, 0xCC400000}, {0xD2000001, 0x98800000},
 {0xA4000001, 0x31000000}, {0x48000001, 0x62000000}, {0x90000001, 0xC4000000}, {0x20000001, 0x88000000},
 {0x40000001, 0x10000000}, {0x80000001, 0x20000000}, {0x1, 0x40000000}, {0x1, 0x80000000}}

local natureNamesList = {
 "Hardy", "Lonely", "Brave", "Adamant", "Naughty",
 "Bold", "Docile", "Relaxed", "Impish", "Lax",
 "Timid", "Hasty", "Serious", "Jolly", "Naive",
 "Modest", "Mild", "Quiet", "Bashful", "Rash",
 "Calm", "Gentle", "Sassy", "Careful", "Quirky"}

local HPTypeNamesList = {
 "Fighting", "Flying", "Poison", "Ground",
 "Rock", "Bug", "Ghost", "Steel",
 "Fire", "Water", "Grass", "Electric",
 "Psychic", "Ice", "Dragon", "Dark"}

local speciesNamesList = {
 -- Gen 1
 "Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard", "Squirtle", "Wartortle", "Blastoise",
 "Caterpie", "Metapod", "Butterfree", "Weedle", "Kakuna", "Beedrill", "Pidgey", "Pidgeotto", "Pidgeot", "Rattata",
 "Raticate", "Spearow", "Fearow", "Ekans", "Arbok", "Pikachu", "Raichu", "Sandshrew", "Sandslash", "Nidoran♀",
 "Nidorina", "Nidoqueen", "Nidoran♂", "Nidorino", "Nidoking", "Clefairy", "Clefable", "Vulpix", "Ninetales",
 "Jigglypuff", "Wigglytuff", "Zubat", "Golbat", "Oddish", "Gloom", "Vileplume", "Paras", "Parasect", "Venonat",
 "Venomoth", "Diglett", "Dugtrio", "Meowth", "Persian", "Psyduck", "Golduck", "Mankey", "Primeape", "Growlithe",
 "Arcanine", "Poliwag", "Poliwhirl", "Poliwrath", "Abra", "Kadabra", "Alakazam", "Machop", "Machoke", "Machamp",
 "Bellsprout", "Weepinbell", "Victreebel", "Tentacool", "Tentacruel", "Geodude", "Graveler", "Golem", "Ponyta",
 "Rapidash", "Slowpoke", "Slowbro", "Magnemite", "Magneton", "Farfetch'd", "Doduo", "Dodrio", "Seel", "Dewgong",
 "Grimer", "Muk", "Shellder", "Cloyster", "Gastly", "Haunter", "Gengar", "Onix", "Drowzee", "Hypno", "Krabby",
 "Kingler", "Voltorb", "Electrode", "Exeggcute", "Exeggutor", "Cubone", "Marowak", "Hitmonlee", "Hitmonchan",
 "Lickitung", "Koffing", "Weezing", "Rhyhorn", "Rhydon", "Chansey", "Tangela", "Kangaskhan", "Horsea", "Seadra",
 "Goldeen", "Seaking", "Staryu", "Starmie", "Mr. Mime", "Scyther", "Jynx", "Electabuzz", "Magmar", "Pinsir",
 "Tauros", "Magikarp", "Gyarados", "Lapras", "Ditto", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Porygon",
 "Omanyte", "Omastar", "Kabuto", "Kabutops", "Aerodactyl", "Snorlax", "Articuno", "Zapdos", "Moltres", "Dratini",
 "Dragonair", "Dragonite", "Mewtwo", "Mew",
 -- Gen 2
 "Chikorita", "Bayleef", "Meganium", "Cyndaquil", "Quilava", "Typhlosion", "Totodile", "Croconaw", "Feraligatr",
 "Sentret", "Furret", "Hoothoot", "Noctowl", "Ledyba", "Ledian", "Spinarak", "Ariados", "Crobat", "Chinchou",
 "Lanturn", "Pichu", "Cleffa", "Igglybuff", "Togepi", "Togetic", "Natu", "Xatu", "Mareep", "Flaaffy", "Ampharos",
 "Bellossom", "Marill", "Azumarill", "Sudowoodo", "Politoed", "Hoppip", "Skiploom", "Jumpluff", "Aipom", "Sunkern",
 "Sunflora", "Yanma", "Wooper", "Quagsire", "Espeon", "Umbreon", "Murkrow", "Slowking", "Misdreavus", "Unown",
 "Wobbuffet", "Girafarig", "Pineco", "Forretress", "Dunsparce", "Gligar", "Steelix", "Snubbull", "Granbull",
 "Qwilfish", "Scizor", "Shuckle", "Heracross", "Sneasel", "Teddiursa", "Ursaring", "Slugma", "Magcargo", "Swinub",
 "Piloswine", "Corsola", "Remoraid", "Octillery", "Delibird", "Mantine", "Skarmory", "Houndour", "Houndoom",
 "Kingdra", "Phanpy", "Donphan", "Porygon2", "Stantler", "Smeargle", "Tyrogue", "Hitmontop", "Smoochum", "Elekid",
 "Magby", "Miltank", "Blissey", "Raikou", "Entei", "Suicune", "Larvitar", "Pupitar", "Tyranitar", "Lugia", "Ho-Oh",
 "Celebi",
 -- Gen 3
 "Treecko", "Grovyle", "Sceptile", "Torchic", "Combusken", "Blaziken", "Mudkip", "Marshtomp", "Swampert",
 "Poochyena", "Mightyena", "Zigzagoon", "Linoone", "Wurmple", "Silcoon", "Beautifly", "Cascoon", "Dustox", "Lotad",
 "Lombre", "Ludicolo", "Seedot", "Nuzleaf", "Shiftry", "Taillow", "Swellow", "Wingull", "Pelipper", "Ralts",
 "Kirlia", "Gardevoir", "Surskit", "Masquerain", "Shroomish", "Breloom", "Slakoth", "Vigoroth", "Slaking",
 "Nincada", "Ninjask", "Shedinja", "Whismur", "Loudred", "Exploud", "Makuhita", "Hariyama", "Azurill", "Nosepass",
 "Skitty", "Delcatty", "Sableye", "Mawile", "Aron", "Lairon", "Aggron", "Meditite", "Medicham", "Electrike",
 "Manectric", "Plusle", "Minun", "Volbeat", "Illumise", "Roselia", "Gulpin", "Swalot", "Carvanha", "Sharpedo",
 "Wailmer", "Wailord", "Numel", "Camerupt", "Torkoal", "Spoink", "Grumpig", "Spinda", "Trapinch", "Vibrava",
 "Flygon", "Cacnea", "Cacturne", "Swablu", "Altaria", "Zangoose", "Seviper", "Lunatone", "Solrock", "Barboach",
 "Whiscash", "Corphish", "Crawdaunt", "Baltoy", "Claydol", "Lileep", "Cradily", "Anorith", "Armaldo", "Feebas",
 "Milotic", "Castform", "Kecleon", "Shuppet", "Banette", "Duskull", "Dusclops", "Tropius", "Chimecho", "Absol",
 "Wynaut", "Snorunt", "Glalie", "Spheal", "Sealeo", "Walrein", "Clamperl", "Huntail", "Gorebyss", "Relicanth",
 "Luvdisc", "Bagon", "Shelgon", "Salamence", "Beldum", "Metang", "Metagross", "Regirock", "Regice", "Registeel",
 "Latias", "Latios",  "Kyogre", "Groudon", "Rayquaza", "Jirachi", "Deoxys",
 -- Gen 4
 "Turtwig", "Grotle", "Torterra", "Chimchar", "Monferno", "Infernape", "Piplup", "Prinplup", "Empoleon", "Starly",
 "Staravia", "Staraptor", "Bidoof", "Bibarel", "Kricketot", "Kricketune", "Shinx", "Luxio", "Luxray", "Budew",
 "Roserade", "Cranidos", "Rampardos", "Shieldon", "Bastiodon", "Burmy", "Wormadam", "Mothim", "Combee", "Vespiquen",
 "Pachirisu", "Buizel", "Floatzel", "Cherubi", "Cherrim", "Shellos", "Gastrodon", "Ambipom", "Drifloon", "Drifblim",
 "Buneary", "Lopunny", "Mismagius", "Honchkrow", "Glameow", "Purugly", "Chingling", "Stunky", "Skuntank", "Bronzor",
 "Bronzong", "Bonsly", "Mime Jr.", "Happiny", "Chatot", "Spiritomb", "Gible", "Gabite", "Garchomp", "Munchlax",
 "Riolu", "Lucario", "Hippopotas", "Hippowdon", "Skorupi", "Drapion", "Croagunk", "Toxicroak", "Carnivine", "Finneon",
 "Lumineon", "Mantyke", "Snover", "Abomasnow", "Weavile", "Magnezone", "Lickilicky", "Rhyperior", "Tangrowth",
 "Electivire", "Magmortar", "Togekiss", "Yanmega", "Leafeon", "Glaceon", "Gliscor", "Mamoswine", "Porygon-Z",
 "Gallade", "Probopass", "Dusknoir", "Froslass", "Rotom", "Uxie", "Mesprit", "Azelf", "Dialga", "Palkia", "Heatran",
 "Regigigas", "Giratina", "Cresselia", "Phione", "Manaphy", "Darkrai", "Shaymin", "Arceus"}

local abilityNamesList = {
 -- Gen 3
 "Stench", "Drizzle", "Speed Boost", "Battle Armor", "Sturdy", "Damp", "Limber", "Sand Veil", "Static",
 "Volt Absorb", "Water Absorb", "Oblivious", "Cloud Nine", "Compound Eyes", "Insomnia", "Color Change", "Immunity",
 "Flash Fire", "Shield Dust", "Own Tempo", "Suction Cups", "Intimidate", "Shadow Tag", "Rough Skin", "Wonder Guard",
 "Levitate", "Effect Spore", "Synchronize", "Clear Body", "Natural Cure", "Lightning Rod", "Serene Grace",
 "Swift Swim", "Chlorophyll", "Illuminate", "Trace", "Huge Power", "Poison Point", "Inner Focus", "Magma Armor",
 "Water Veil", "Magnet Pull", "Soundproof", "Rain Dish", "Sand Stream", "Pressure", "Thick Fat", "Early Bird",
 "Flame Body", "Run Away", "Keen Eye", "Hyper Cutter", "Pickup", "Truant", "Hustle", "Cute Charm", "Plus", "Minus",
 "Forecast", "Sticky Hold", "Shed Skin", "Guts", "Marvel Scale", "Liquid Ooze", "Overgrow", "Blaze", "Torrent",
 "Swarm", "Rock Head", "Drought", "Arena Trap", "Vital Spirit", "White Smoke", "Pure Power", "Shell Armor",
 "Air Lock",
 -- Gen 4
 "Tangled Feet", "Motor Drive", "Rivalry", "Steadfast", "Snow Cloak", "Gluttony", "Anger Point", "Unburden",
 "Heatproof", "Simple", "Dry Skin", "Download", "Iron Fist", "Poison Heal", "Adaptability", "Skill Link", "Hydration",
 "Solar Power", "Quick Feet", "Normalize", "Sniper", "Magic Guard", "No Guard", "Stall", "Technician", "Leaf Guard",
 "Klutz", "Mold Breaker", "Super Luck", "Aftermath", "Anticipation", "Forewarn", "Unaware", "Tinted Lens", "Filter",
 "Slow Start", "Scrappy", "Storm Drain", "Ice Body", "Solid Rock", "Snow Warning", "Honey Gather", "Frisk", "Reckless",
 "Multitype", "Flower Gift", "Bad Dreams"}

local pokemonAbilities = {
 [1] = {65}, [2] = {65}, [3] = {65}, [4] = {66}, [5] = {66}, [6] = {66}, [7] = {67}, [8] = {67},
 [9] = {67}, [10] = {19}, [11] = {61}, [12] = {14}, [13] = {19}, [14] = {61}, [15] = {68}, [16] = {51, 77},
 [17] = {51, 77}, [18] = {51, 77}, [19] = {50, 62}, [20] = {50, 62}, [21] = {51}, [22] = {51}, [23] = {22, 61},
 [24] = {22, 61}, [25] = {9}, [26] = {9}, [27] = {8}, [28] = {8}, [29] = {38, 79}, [30] = {38, 79},
 [31] = {38, 79}, [32] = {38, 79}, [33] = {38, 79}, [34] = {38, 79}, [35] = {56, 98}, [36] = {56, 98}, [37] = {18},
 [38] = {18}, [39] = {56}, [40] = {56}, [41] = {39}, [42] = {39}, [43] = {34}, [44] = {34}, [45] = {34},
 [46] = {27, 87}, [47] = {27, 87}, [48] = {14, 110}, [49] = {19, 110}, [50] = {8, 71}, [51] = {8, 71}, [52] = {53, 101},
 [53] = {7, 101}, [54] = {6, 13}, [55] = {6, 13}, [56] = {72, 83}, [57] = {72, 83}, [58] = {22, 18}, [59] = {22, 18},
 [60] = {11, 6}, [61] = {11, 6}, [62] = {11, 6}, [63] = {28, 39}, [64] = {28, 39}, [65] = {28, 39}, [66] = {62, 99},
 [67] = {62, 99}, [68] = {62, 99}, [69] = {34}, [70] = {34}, [71] = {34}, [72] = {29, 64}, [73] = {29, 64}, [74] = {69, 5},
 [75] = {69, 5}, [76] = {69, 5}, [77] = {50, 18}, [78] = {50, 18}, [79] = {12, 20}, [80] = {12, 20}, [81] = {42, 5},
 [82] = {42, 5}, [83] = {51, 39}, [84] = {50, 48}, [85] = {50, 48}, [86] = {47, 93}, [87] = {47, 93}, [88] = {1, 60},
 [89] = {1, 60}, [90] = {75, 92}, [91] = {75, 92}, [92] = {26}, [93] = {26}, [94] = {26}, [95] = {69, 5}, [96] = {15, 108},
 [97] = {15, 108}, [98] = {52, 75}, [99] = {52, 75}, [100] = {43, 9}, [101] = {43, 9}, [102] = {34}, [103] = {34}, [104] = {69, 31},
 [105] = {69, 31}, [106] = {7, 120}, [107] = {51, 89}, [108] = {20, 12}, [109] = {26}, [110] = {26}, [111] = {31, 69}, [112] = {31, 69},
 [113] = {30, 32}, [114] = {34, 102}, [115] = {48, 113}, [116] = {33, 97}, [117] = {38, 97}, [118] = {33, 41}, [119] = {33, 41},
 [120] = {35, 30}, [121] = {35, 30}, [122] = {43, 111}, [123] = {68, 101}, [124] = {12, 108}, [125] = {9}, [126] = {49}, [127] = {52, 104},
 [128] = {22, 83}, [129] = {33}, [130] = {22}, [131] = {11, 75}, [132] = {7}, [133] = {50, 91}, [134] = {11}, [135] = {10}, [136] = {18},
 [137] = {36, 88}, [138] = {33, 75}, [139] = {33, 75}, [140] = {33, 4}, [141] = {33, 4}, [142] = {69, 46}, [143] = {17, 47}, [144] = {46},
 [145] = {46}, [146] = {46}, [147] = {61}, [148] = {61}, [149] = {39}, [150] = {46}, [151] = {28}, [152] = {65}, [153] = {65}, [154] = {65},
 [155] = {66}, [156] = {66}, [157] = {66}, [158] = {67}, [159] = {67}, [160] = {67}, [161] = {50, 51}, [162] = {50, 51}, [163] = {15, 51},
 [164] = {15, 51}, [165] = {68, 48}, [166] = {68, 48}, [167] = {68, 15}, [168] = {68, 15}, [169] = {39}, [170] = {10, 35}, [171] = {10, 35},
 [172] = {9}, [173] = {56, 98}, [174] = {56}, [175] = {55, 32}, [176] = {55, 32}, [177] = {28, 48}, [178] = {28, 48}, [179] = {9},
 [180] = {9}, [181] = {9}, [182] = {34}, [183] = {47, 37}, [184] = {47, 37}, [185] = {5, 69}, [186] = {11, 6}, [187] = {34, 102},
 [188] = {34, 102}, [189] = {34, 102}, [190] = {50, 53}, [191] = {34, 94}, [192] = {34, 94}, [193] = {3, 14}, [194] = {6, 11}, [195] = {6, 11},
 [196] = {28}, [197] = {28}, [198] = {15, 105}, [199] = {12, 20}, [200] = {26}, [201] = {26}, [202] = {23}, [203] = {39, 48}, [204] = {5},
 [205] = {5}, [206] = {32, 50}, [207] = {52, 8}, [208] = {69, 5}, [209] = {22, 50}, [210] = {22, 95}, [211] = {38, 33}, [212] = {68, 101},
 [213] = {5, 82}, [214] = {68, 62}, [215] = {39, 51}, [216] = {53, 95}, [217] = {62, 95}, [218] = {40, 49}, [219] = {40, 49}, [220] = {12, 81},
 [221] = {12, 81}, [222] = {55, 30}, [223] = {55, 97}, [224] = {21, 97}, [225] = {72, 55}, [226] = {33, 11}, [227] = {51, 5}, [228] = {48, 18},
 [229] = {48, 18}, [230] = {33, 97}, [231] = {53}, [232] = {5}, [233] = {36, 88}, [234] = {22, 119}, [235] = {20, 101}, [236] = {62, 80},
 [237] = {22, 101}, [238] = {12, 108}, [239] = {9}, [240] = {49}, [241] = {47, 113}, [242] = {30, 32}, [243] = {46}, [244] = {46}, [245] = {46},
 [246] = {62}, [247] = {61}, [248] = {45}, [249] = {46}, [250] = {46}, [251] = {30}, [252] = {65}, [253] = {65}, [254] = {65}, [255] = {66},
 [256] = {66}, [257] = {66}, [258] = {67}, [259] = {67}, [260] = {67}, [261] = {50, 95}, [262] = {22, 95}, [263] = {53, 82}, [264] = {53, 82},
 [265] = {19}, [266] = {61}, [267] = {68}, [268] = {61}, [269] = {19}, [270] = {33, 44}, [271] = {33, 44}, [272] = {33, 44}, [273] = {34, 48},
 [274] = {34, 48}, [275] = {34, 48}, [276] = {62}, [277] = {62}, [278] = {51}, [279] = {51}, [280] = {28, 36}, [281] = {28, 36}, [282] = {28, 36},
 [283] = {33}, [284] = {22}, [285] = {27, 90}, [286] = {27, 90}, [287] = {54}, [288] = {72}, [289] = {54}, [290] = {14}, [291] = {3}, [292] = {25},
 [293] = {43}, [294] = {43}, [295] = {43}, [296] = {47, 62}, [297] = {47, 62}, [298] = {47, 37}, [299] = {5, 42}, [300] = {56, 96}, [301] = {56, 96},
 [302] = {51, 100}, [303] = {52, 22}, [304] = {5, 69}, [305] = {5, 69}, [306] = {5, 69}, [307] = {74}, [308] = {74}, [309] = {9, 31}, [310] = {9, 31},
 [311] = {57}, [312] = {58}, [313] = {35, 68}, [314] = {12, 110}, [315] = {30, 38}, [316] = {64, 60}, [317] = {64, 60}, [318] = {24}, [319] = {24},
 [320] = {41, 12}, [321] = {41, 12}, [322] = {12, 86}, [323] = {40, 116}, [324] = {73}, [325] = {47, 20}, [326] = {47, 20}, [327] = {20, 77},
 [328] = {52, 71}, [329] = {26}, [330] = {26}, [331] = {8}, [332] = {8}, [333] = {30}, [334] = {30}, [335] = {17}, [336] = {61}, [337] = {26},
 [338] = {26}, [339] = {12, 107}, [340] = {12, 107}, [341] = {52, 75}, [342] = {52, 75}, [343] = {26}, [344] = {26}, [345] = {21}, [346] = {21},
 [347] = {4}, [348] = {4}, [349] = {33}, [350] = {63}, [351] = {59}, [352] = {16}, [353] = {15, 119}, [354] = {15, 119}, [355] = {26}, [356] = {46},
 [357] = {34, 94}, [358] = {26}, [359] = {46, 105}, [360] = {23}, [361] = {39, 115}, [362] = {39, 115}, [363] = {47, 115}, [364] = {47, 115},
 [365] = {47, 115}, [366] = {75}, [367] = {33}, [368] = {33}, [369] = {33, 69}, [370] = {33}, [371] = {69}, [372] = {69}, [373] = {22}, [374] = {29},
 [375] = {29}, [376] = {29}, [377] = {29}, [378] = {29}, [379] = {29}, [380] = {26}, [381] = {26}, [382] = {2}, [383] = {70}, [384] = {76},
 [385] = {32}, [386] = {46}, [387] = {65}, [388] = {65}, [389] = {65}, [390] = {66}, [391] = {66}, [392] = {66}, [393] = {67}, [394] = {67},
 [395] = {67}, [396] = {51}, [397] = {22}, [398] = {22}, [399] = {86, 109}, [400] = {86, 109}, [401] = {61}, [402] = {68}, [403] = {79, 22},
 [404] = {79, 22}, [405] = {79, 22}, [406] = {30, 38}, [407] = {30, 38}, [408] = {104}, [409] = {104}, [410] = {5}, [411] = {5}, [412] = {61},
 [413] = {107}, [414] = {68}, [415] = {118}, [416] = {46}, [417] = {50, 53}, [418] = {33}, [419] = {33}, [420] = {34}, [421] = {122},
 [422] = {60, 114}, [423] = {60, 114}, [424] = {101, 53}, [425] = {106, 84}, [426] = {106, 84}, [427] = {50, 103}, [428] = {56, 103}, [429] = {26},
 [430] = {15, 105}, [431] = {7, 20}, [432] = {47, 20}, [433] = {26}, [434] = {1, 106}, [435] = {1, 106}, [436] = {26, 85}, [437] = {26, 85},
 [438] = {5, 69}, [439] = {43, 111}, [440] = {30, 32}, [441] = {51, 77}, [442] = {46}, [443] = {8}, [444] = {8}, [445] = {8}, [446] = {53, 47},
 [447] = {80, 39}, [448] = {80, 39}, [449] = {45}, [450] = {45}, [451] = {4, 97}, [452] = {4, 97}, [453] = {107, 87}, [454] = {107, 87}, [455] = {26},
 [456] = {33, 114}, [457] = {33, 114}, [458] = {33, 11}, [459] = {117}, [460] = {117}, [461] = {46}, [462] = {42, 5}, [463] = {20, 12},
 [464] = {31, 116}, [465] = {34, 102}, [466] = {78}, [467] = {49}, [468] = {55, 32}, [469] = {3, 110}, [470] = {102}, [471] = {81}, [472] = {52, 8},
 [473] = {12, 81}, [474] = {91, 88}, [475] = {80}, [476] = {5, 42}, [477] = {46}, [478] = {81}, [479] = {26}, [480] = {26}, [481] = {26}, [482] = {26},
 [483] = {46}, [484] = {46}, [485] = {18}, [486] = {112}, [487] = {46}, [488] = {26}, [489] = {93}, [490] = {93}, [491] = {123}, [492] = {30},
 [493] = {121}}

local moveNamesList = {
 -- Gen 1
 "--", "Pound", "Karate Chop", "Double Slap", "Comet Punch", "Mega Punch", "Pay Day", "Fire Punch", "Ice Punch",
 "Thunder Punch", "Scratch", "Vice Grip", "Guillotine", "Razor Wind", "Swords Dance", "Cut", "Gust", "Wing Attack",
 "Whirlwind", "Fly", "Bind", "Slam", "Vine Whip", "Stomp", "Double Kick", "Mega Kick", "Jump Kick", "Rolling Kick",
 "Sand Attack", "Headbutt", "Horn Attack", "Fury Attack", "Horn Drill", "Tackle", "Body Slam", "Wrap", "Take Down",
 "Thrash", "Double-Edge", "Tail Whip", "Poison Sting", "Twineedle", "Pin Missile", "Leer", "Bite", "Growl", "Roar",
 "Sing", "Supersonic", "Sonic Boom", "Disable", "Acid", "Ember", "Flamethrower", "Mist", "Water Gun", "Hydro Pump",
 "Surf", "Ice Beam", "Blizzard", "Psybeam", "Bubble Beam", "Aurora Beam", "Hyper Beam", "Peck", "Drill Peck",
 "Submission", "Low Kick", "Counter", "Seismic Toss", "Strength", "Absorb", "Mega Drain", "Leech Seed", "Growth",
 "Razor Leaf", "Solar Beam", "Poison Powder", "Stun Spore", "Sleep Powder", "Petal Dance", "String Shot",
 "Dragon Rage", "Fire Spin", "Thunder Shock", "Thunderbolt", "Thunder Wave", "Thunder", "Rock Throw", "Earthquake",
 "Fissure", "Dig", "Toxic", "Confusion", "Psychic", "Hypnosis", "Meditate", "Agility", "Quick Attack", "Rage",
 "Teleport", "Night Shade", "Mimic", "Screech", "Double Team", "Recover", "Harden", "Minimize", "Smokescreen",
 "Confuse Ray", "Withdraw", "Defense Curl", "Barrier", "Light Screen", "Haze", "Reflect", "Focus Energy", "Bide",
 "Metronome", "Mirror Move", "Self-Destruct", "Egg Bomb", "Lick", "Smog", "Sludge", "Bone Club", "Fire Blast",
 "Waterfall", "Clamp", "Swift", "Skull Bash", "Spike Cannon", "Constrict", "Amnesia", "Kinesis", "Soft-Boiled",
 "High Jump Kick", "Glare", "Dream Eater", "Poison Gas", "Barrage", "Leech Life", "Lovely Kiss", "Sky Attack",
 "Transform", "Bubble", "Dizzy Punch", "Spore", "Flash", "Psywave", "Splash", "Acid Armor", "Crabhammer",
 "Explosion", "Fury Swipes", "Bonemerang", "Rest", "Rock Slide", "Hyper Fang", "Sharpen", "Conversion", "Tri Attack",
 "Super Fang", "Slash", "Substitute", "Struggle",
 -- Gen 2
 "Sketch", "Triple Kick", "Thief", "Spider Web", "Mind Reader",
 "Nightmare", "Flame Wheel", "Snore", "Curse", "Flail", "Conversion 2", "Aeroblast", "Cotton Spore", "Reversal",
 "Spite", "Powder Snow", "Protect", "Mach Punch", "Scary Face", "Feint Attack", "Sweet Kiss", "Belly Drum",
 "Sludge Bomb", "Mud-Slap", "Octazooka", "Spikes", "Zap Cannon", "Foresight", "Destiny Bond", "Perish Song",
 "Icy Wind", "Detect", "Bone Rush", "Lock-On", "Outrage", "Sandstorm", "Giga Drain", "Endure", "Charm", "Rollout",
 "False Swipe", "Swagger", "Milk Drink", "Spark", "Fury Cutter", "Steel Wing", "Mean Look", "Attract", "Sleep Talk",
 "Heal Bell", "Return", "Present", "Frustration", "Safeguard", "Pain Split", "Sacred Fire", "Magnitude",
 "Dynamic Punch", "Megahorn", "Dragon Breath", "Baton Pass", "Encore", "Pursuit", "Rapid Spin", "Sweet Scent",
 "Iron Tail", "Metal Claw", "Vital Throw", "Morning Sun", "Synthesis", "Moonlight", "Hidden Power", "Cross Chop",
 "Twister", "Rain Dance", "Sunny Day", "Crunch", "Mirror Coat", "Psych Up", "Extreme Speed", "Ancient Power",
 "Shadow Ball", "Future Sight", "Rock Smash", "Whirlpool", "Beat Up",
 -- Gen 3
 "Fake Out", "Uproar", "Stockpile", "Spit Up", "Swallow", "Heat Wave", "Hail", "Torment", "Flatter", "Will-O-Wisp",
 "Memento", "Facade", "Focus Punch", "Smelling Salts", "Follow Me", "Nature Power", "Charge", "Taunt", "Helping Hand",
 "Trick", "Role Play", "Wish", "Assist", "Ingrain", "Superpower", "Magic Coat", "Recycle", "Revenge", "Brick Break",
 "Yawn", "Knock Off", "Endeavor", "Eruption", "Skill Swap", "Imprison", "Refresh", "Grudge", "Snatch", "Secret Power",
 "Dive", "Arm Thrust", "Camouflage", "Tail Glow", "Luster Purge", "Mist Ball", "Feather Dance", "Teeter Dance",
 "Blaze Kick", "Mud Sport", "Ice Ball", "Needle Arm", "Slack Off", "Hyper Voice", "Poison Fang", "Crush Claw",
 "Blast Burn", "Hydro Cannon", "Meteor Mash", "Astonish", "Weather Ball", "Aromatherapy", "Fake Tears", "Air Cutter",
 "Overheat", "Odor Sleuth", "Rock Tomb", "Silver Wind", "Metal Sound", "Grass Whistle", "Tickle", "Cosmic Power",
 "Water Spout", "Signal Beam", "Shadow Punch", "Extrasensory", "Sky Uppercut", "Sand Tomb", "Sheer Cold", "Muddy Water",
 "Bullet Seed", "Aerial Ace", "Icicle Spear", "Iron Defense", "Block", "Howl", "Dragon Claw", "Frenzy Plant", "Bulk Up",
 "Bounce", "Mud Shot", "Poison Tail", "Covet", "Volt Tackle", "Magical Leaf", "Water Sport", "Calm Mind", "Leaf Blade",
 "Dragon Dance", "Rock Blast", "Shock Wave", "Water Pulse", "Doom Desire", "Psycho Boost",
 -- Gen 4
 "Roost", "Gravity", "Miracle Eye", "Wake-Up Slap", "Hammer Arm", "Gyro Ball", "Healing Wish", "Brine", "Natural Gift",
 "Feint", "Pluck", "Tailwind", "Acupressure", "Metal Burst", "U-turn", "Close Combat", "Payback", "Assurance", "Embargo",
 "Fling", "Psycho Shift", "Trump Card", "Heal Block", "Wring Out", "Power Trick", "Gastro Acid", "Lucky Chant", "Me First",
 "Copycat", "Power Swap", "Guard Swap", "Punishment", "Last Resort", "Worry Seed", "Sucker Punch", "Toxic Spikes",
 "Heart Swap", "Aqua Ring", "Magnet Rise", "Flare Blitz", "Force Palm", "Aura Sphere", "Rock Polish", "Poison Jab",
 "Dark Pulse", "Night Slash", "Aqua Tail", "Seed Bomb", "Air Slash", "X-Scissor", "Bug Buzz", "Dragon Pulse", "Dragon Rush",
 "Power Gem", "Drain Punch", "Vacuum Wave", "Focus Blast", "Energy Ball", "Brave Bird", "Earth Power", "Switcheroo",
 "Giga Impact", "Nasty Plot", "Bullet Punch", "Avalanche", "Ice Shard", "Shadow Claw", "Thunder Fang", "Ice Fang",
 "Fire Fang", "Shadow Sneak", "Mud Bomb", "Psycho Cut", "Zen Headbutt", "Mirror Shot", "Flash Cannon", "Rock Climb",
 "Defog", "Trick Room", "Draco Meteor", "Discharge", "Lava Plume", "Leaf Storm", "Power Whip", "Rock Wrecker",
 "Cross Poison", "Gunk Shot", "Iron Head", "Magnet Bomb", "Stone Edge", "Captivate", "Stealth Rock", "Grass Knot", "Chatter",
 "Judgment", "Bug Bite", "Charge Beam", "Wood Hammer", "Aqua Jet", "Attack Order", "Defend Order", "Heal Order", "Head Smash",
 "Double Hit", "Roar of Time", "Spacial Rend", "Lunar Dance", "Crush Grip", "Magma Storm", "Dark Void", "Seed Flare",
 "Ominous Wind", "Shadow Force"}

local itemNamesList = {
 "None", "Master Ball", "Ultra Ball", "Great Ball", "Poké Ball", "Safari Ball", "Net Ball", "Dive Ball",
 "Nest Ball", "Repeat Ball", "Timer Ball", "Luxury Ball", "Premier Ball", "Dusk Ball", "Heal Ball",
 "Quick Ball", "Cherish Ball", "Potion", "Antidote", "Burn Heal", "Ice Heal", "Awakening", "Parlyz Heal",
 "Full Restore", "Max Potion", "Hyper Potion", "Super Potion", "Full Heal", "Revive", "Max Revive",
 "Fresh Water", "Soda Pop", "Lemonade", "Moomoo Milk", "EnergyPowder", "Energy Root", "Heal Powder",
 "Revival Herb", "Ether", "Max Ether", "Elixir", "Max Elixir", "Lava Cookie", "Berry Juice",
 "Sacred Ash", "HP Up", "Protein", "Iron", "Carbos", "Calcium", "Rare Candy", "PP Up", "Zinc",
 "PP Max", "Old Gateau", "Guard Spec.", "Dire Hit", "X Attack", "X Defend", "X Speed", "X Accuracy",
 "X Special", "X Sp. Def", "Poké Doll", "Fluffy Tail", "Blue Flute", "Yellow Flute", "Red Flute",
 "Black Flute", "White Flute", "Shoal Salt", "Shoal Shell", "Red Shard", "Blue Shard", "Yellow Shard",
 "Green Shard", "Super Repel", "Max Repel", "Escape Rope", "Repel", "Sun Stone", "Moon Stone",
 "Fire Stone", "Thunderstone", "Water Stone", "Leaf Stone", "TinyMushroom", "Big Mushroom", "Pearl",
 "Big Pearl", "Stardust", "Star Piece", "Nugget", "Heart Scale", "Honey", "Growth Mulch",
 "Damp Mulch", "Stable Mulch", "Gooey Mulch", "Root Fossil", "Claw Fossil", "Helix Fossil", "Dome Fossil",
 "Old Amber", "Armor Fossil", "Skull Fossil", "Rare Bone", "Shiny Stone", "Dusk Stone", "Dawn Stone",
 "Oval Stone", "Odd Keystone", "Griseous Orb", "unknown1", "unknown2", "unknown3", "unknown4", "unknown5",
 "unknown6", "unknown7", "unknown8", "unknown9", "unknown10", "unknown11", "unknown12", "unknown13",
 "unknown14", "unknown15", "unknown16", "unknown17", "unknown18", "unknown19", "unknown20", "unknown21",
 "unknown22", "Adamant Orb", "Lustrous Orb", "Grass Mail", "Flame Mail", "Bubble Mail", "Bloom Mail",
 "Tunnel Mail", "Steel Mail", "Heart Mail", "Snow Mail", "Space Mail", "Air Mail", "Mosaic Mail", "Brick Mail",
 "Cheri Berry", "Chesto Berry", "Pecha Berry", "Rawst Berry", "Aspear Berry", "Leppa Berry", "Oran Berry",
 "Persim Berry", "Lum Berry", "Sitrus Berry", "Figy Berry", "Wiki Berry", "Mago Berry", "Aguav Berry",
 "Iapapa Berry", "Razz Berry", "Bluk Berry", "Nanab Berry", "Wepear Berry", "Pinap Berry", "Pomeg Berry",
 "Kelpsy Berry", "Qualot Berry", "Hondew Berry", "Grepa Berry", "Tamato Berry", "Cornn Berry", "Magost Berry",
 "Rabuta Berry", "Nomel Berry", "Spelon Berry", "Pamtre Berry", "Watmel Berry", "Durin Berry",
 "Belue Berry", "Occa Berry", "Passho Berry", "Wacan Berry", "Rindo Berry", "Yache Berry",
 "Chople Berry", "Kebia Berry", "Shuca Berry", "Coba Berry", "Payapa Berry", "Tanga Berry",
 "Charti Berry", "Kasib Berry", "Haban Berry", "Colbur Berry", "Babiri Berry", "Chilan Berry", "Liechi Berry",
 "Ganlon Berry", "Salac Berry", "Petaya Berry", "Apicot Berry", "Lansat Berry", "Starf Berry",
 "Enigma Berry", "Micle Berry", "Custap Berry", "Jaboca Berry", "Rowap Berry", "BrightPowder",
 "White Herb", "Macho Brace", "Exp. Share", "Quick Claw", "Soothe Bell", "Mental Herb", "Choice Band",
 "King's Rock", "SilverPowder", "Amulet Coin", "Cleanse Tag", "Soul Dew", "DeepSeaTooth",
 "DeepSeaScale", "Smoke Ball", "Everstone", "Focus Band", "Lucky Egg", "Scope Lens", "Metal Coat",
 "Leftovers", "Dragon Scale", "Light Ball", "Soft Sand", "Hard Stone", "Miracle Seed", "BlackGlasses",
 "Black Belt", "Magnet", "Mystic Water", "Sharp Beak", "Poison Barb", "NeverMeltIce", "Spell Tag",
 "TwistedSpoon", "Charcoal", "Dragon Fang", "Silk Scarf", "Up-Grade", "Shell Bell", "Sea Incense",
 "Lax Incense", "Lucky Punch", "Metal Powder", "Thick Club", "Stick", "Red Scarf", "Blue Scarf",
 "Pink Scarf", "Green Scarf", "Yellow Scarf", "Wide Lens", "Muscle Band", "Wise Glasses", "Expert Belt",
 "Light Clay", "Life Orb", "Power Herb", "Toxic Orb", "Flame Orb", "Quick Powder", "Focus Sash",
 "Zoom Lens", "Metronome", "Iron Ball", "Lagging Tail", "Destiny Knot", "Black Sludge", "Icy Rock",
 "Smooth Rock", "Heat Rock", "Damp Rock", "Grip Claw", "Choice Scarf", "Sticky Barb", "Power Bracer",
 "Power Belt", "Power Lens", "Power Band", "Power Anklet", "Power Weight", "Shed Shell",
 "Big Root", "Choice Specs", "Flame Plate", "Splash Plate", "Zap Plate", "Meadow Plate", "Icicle Plate",
 "Fist Plate", "Toxic Plate", "Earth Plate", "Sky Plate", "Mind Plate", "Insect Plate",
 "Stone Plate", "Spooky Plate", "Draco Plate", "Dread Plate", "Iron Plate", "Odd Incense",
 "Rock Incense", "Full Incense", "Wave Incense", "Rose Incense", "Luck Incense", "Pure Incense",
 "Protector", "Electirizer", "Magmarizer", "Dubious Disc", "Reaper Cloth", "Razor Claw", "Razor Fang",
 "TM01", "TM02", "TM03", "TM04", "TM05", "TM06", "TM07", "TM08", "TM09", "TM10", "TM11", "TM12",
 "TM13", "TM14", "TM15", "TM16", "TM17", "TM18", "TM19", "TM20", "TM21", "TM22", "TM23", "TM24",
 "TM25", "TM26", "TM27", "TM28", "TM29", "TM30", "TM31", "TM32", "TM33", "TM34", "TM35", "TM36",
 "TM37", "TM38", "TM39", "TM40", "TM41", "TM42", "TM43", "TM44", "TM45", "TM46", "TM47", "TM48",
 "TM49", "TM50", "TM51", "TM52", "TM53", "TM54", "TM55", "TM56", "TM57", "TM58", "TM59", "TM60",
 "TM61", "TM62", "TM63", "TM64", "TM65", "TM66", "TM67", "TM68", "TM69", "TM70", "TM71", "TM72",
 "TM73", "TM74", "TM75", "TM76", "TM77", "TM78", "TM79", "TM80", "TM81", "TM82", "TM83", "TM84",
 "TM85", "TM86", "TM87", "TM88", "TM89", "TM90", "TM91", "TM92", "HM01", "HM02", "HM03", "HM04",
 "HM05", "HM06", "HM07", "HM08", "Explorer Kit", "Loot Sack", "Rule Book", "Poké Radar", "Point Card",
 "Journal", "Seal Case", "Fashion Case", "Seal Bag", "Pal Pad", "Works Key", "Old Charm",
 "Galactic Key", "Red Chain", "Town Map", "Vs. Seeker", "Coin Case", "Old Rod", "Good Rod", "Super Rod",
 "Sprayduck", "Poffin Case", "Bicycle", "Suite Key", "Oak's Letter", "Lunar Wing", "Member Card",
 "Azure Flute", "S.S. Ticket", "Contest Pass", "Magma Stone", "Parcel", "Coupon 1", "Coupon 2",
 "Coupon 3", "Storage Key", "SecretPotion", "Vs. Recorder", "Gracidea", "Secret Key",
 "Apricorn Box", "Unown Report", "Berry Pots", "Dowsing MCHN", "Blue Card", "Slowpoke Tail",
 "Clear Bell", "Card Key", "Basement Key", "SquirtBottle", "Red Scale", "Lost Item", "Pass",
 "Machine Part", "Silver Wing", "Rainbow Wing", "Mystery Egg", "Red Apricorn", "Yellow Apricorn",
 "Blue Apricorn", "Green Apricorn", "Pink Apricorn", "White Apricorn", "Black Apricorn", "Fast Ball",
 "Level Ball", "Lure Ball", "Heavy Ball", "Love Ball", "Friend Ball", "Moon Ball",
 "Sport Ball", "Park Ball", "Photo Album", "GB Sounds", "Tidal Bell", "RageCandyBar", "Data Card 01",
 "Data Card 02", "Data Card 03", "Data Card 04", "Data Card 05", "Data Card 06", "Data Card 07",
 "Data Card 08", "Data Card 09", "Data Card 10", "Data Card 11", "Data Card 12", "Data Card 13",
 "Data Card 14", "Data Card 15", "Data Card 16", "Data Card 17", "Data Card 18", "Data Card 19",
 "Data Card 20", "Data Card 21", "Data Card 22", "Data Card 23", "Data Card 24", "Data Card 25",
 "Data Card 26", "Data Card 27", "Jade Orb", "Lock Capsule", "Red Orb", "Blue Orb", "Enigma Stone"}

local locationNamesList = {
 "Mystery Zone", "Mystery Zone", "Mystery Zone", "Jubilife City", "Jubilife City", "Jubilife City",
 "Jubilife City", "Jubilife City", "Pokétch Co.", "Pokétch Co.", "Pokétch Co.", "Jubilife TV",
 "Jubilife TV", "Jubilife TV", "Jubilife TV", "Jubilife TV", "Jubilife TV", "Jubilife TV",
 "Jubilife TV", "Jubilife City", "Jubilife City", "Jubilife City", "Jubilife City", "Jubilife City",
 "Jubilife City", "Jubilife City", "Jubilife City", "Jubilife City", "Global Terminal",
 "Trainers’ School", "Jubilife City", "Jubilife City", "Jubilife City", "Canalave City",
 "Canalave City", "Canalave City", "Canalave City", "Canalave City", "Canalave Library",
 "Canalave Library", "Canalave Library", "Canalave City", "Canalave City", "Canalave City",
 "Canalave City", "Oreburgh City", "Oreburgh City", "Oreburgh City", "Oreburgh City", "Oreburgh City",
 "Oreburgh City", "Oreburgh City", "Oreburgh City", "Oreburgh City", "Oreburgh City", "Oreburgh City",
 "Oreburgh City", "Oreburgh City", "Oreburgh City", "Mining Museum", "Oreburgh City", "Oreburgh City",
 "Oreburgh City", "Oreburgh City", "Oreburgh City", "Eterna City", "Eterna City", "Eterna City",
 "Eterna City", "Eterna City", "Eterna City", "Cycle Shop", "T.G. Eterna Bldg", "T.G. Eterna Bldg",
 "T.G. Eterna Bldg", "T.G. Eterna Bldg", "Eterna City", "Eterna City", "Eterna City", "Eterna City",
 "Route 206", "Eterna City", "Eterna City", "Eterna City", "Eterna City", "Eterna City", "Hearthome City",
 "Hearthome City", "Hearthome City", "Hearthome City", "Hearthome City", "Hearthome City",
 "Hearthome City", "Hearthome City", "Hearthome City", "Hearthome City", "Hearthome City",
 "Hearthome City", "Hearthome City", "Hearthome City", "Hearthome City", "Hearthome City",
 "Hearthome City", "Hearthome City", "Hearthome City", "Hearthome City", "Hearthome City",
 "Hearthome City", "Hearthome City", "Route 208", "Route 209", "Route 212", "Hearthome City",
 "Hearthome City", "Hearthome City", "Hearthome City", "Poffin House", "Contest Hall", "Contest Hall",
 "Foreign Building", "Pastoria City", "Pastoria City", "Pastoria City", "Pastoria City", "Pastoria City",
 "Pastoria City", "Pastoria City", "Pastoria City", "Pastoria City", "Pastoria City", "Pastoria City",
 "Pastoria City", "Veilstone City", "Veilstone City", "Veilstone City", "Veilstone City", "Game Corner",
 "Veilstone Store", "Veilstone Store", "Veilstone Store", "Veilstone Store", "Veilstone Store",
 "Veilstone Store", "Veilstone City", "Veilstone City", "Veilstone City", "Veilstone City", "Veilstone City",
 "Veilstone City", "Route 215", "Sunyshore City", "Sunyshore City", "Sunyshore City", "Sunyshore City",
 "Sunyshore City", "Sunyshore City", "Sunyshore City", "Sunyshore Market", "Sunyshore City", "Sunyshore City",
 "Sunyshore City", "Sunyshore City", "Sunyshore City", "Sunyshore City", "Vista Lighthouse", "Snowpoint City",
 "Snowpoint City", "Snowpoint City", "Snowpoint City", "Snowpoint City", "Snowpoint City", "Snowpoint City",
 "Pokémon League", "Pokémon League", "Pokémon League", "Pokémon League", "Pokémon League", "Pokémon League",
 "Pokémon League", "Pokémon League", "Pokémon League", "Pokémon League", "Pokémon League", "Pokémon League",
 "Pokémon League", "Pokémon League", "Pokémon League", "Pokémon League", "Fight Area", "Fight Area",
 "Fight Area", "Fight Area", "Battle Park", "Route 225", "Fight Area", "Fight Area", "Mystery Zone",
 "Oreburgh Mine", "Oreburgh Mine", "Oreburgh Mine", "Valley Windworks", "Valley Windworks", "Eterna Forest",
 "Eterna Forest", "Fuego Ironworks", "Fuego Ironworks", "Mystery Zone", "Mt. Coronet", "Mt. Coronet",
 "Mt. Coronet", "Mt. Coronet", "Mt. Coronet", "Mt. Coronet", "Mt. Coronet", "Mt. Coronet", "Mt. Coronet",
 "Mt. Coronet", "Mt. Coronet", "Mt. Coronet", "Mt. Coronet", "Spear Pillar", "Spear Pillar", "Mystery Zone",
 "Pastoria City", "Mystery Zone", "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins",
 "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins",
 "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins", "Solaceon Ruins",
 "Solaceon Ruins", "Solaceon Ruins", "Mystery Zone", "Victory Road", "Victory Road", "Victory Road",
 "Victory Road", "Victory Road", "Victory Road", "Mystery Zone", "Pal Park", "Mystery Zone", "Amity Square",
 "Ravaged Path", "Mystery Zone", "Floaroma Meadow", "Floaroma Meadow", "Oreburgh Gate", "Oreburgh Gate",
 "Fullmoon Island", "Fullmoon Island", "Stark Mountain", "Stark Mountain", "Stark Mountain", "Stark Mountain",
 "Mystery Zone", "Sendoff Spring", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave",
 "Turnback Cave", "Turnback Cave", "Flower Paradise", "Mystery Zone", "Mystery Zone", "Mystery Zone",
 "Snowpoint Temple", "Snowpoint Temple", "Snowpoint Temple", "Snowpoint Temple", "Snowpoint Temple",
 "Snowpoint Temple", "Wayward Cave", "Wayward Cave", "Ruin Maniac Cave", "Trophy Garden", "Iron Island",
 "Iron Island", "Iron Island", "Iron Island", "Iron Island", "Iron Island", "Iron Island", "Old Chateau",
 "Old Chateau", "Old Chateau", "Old Chateau", "Old Chateau", "Old Chateau", "Old Chateau", "Old Chateau",
 "Old Chateau", "Mystery Zone", "Galactic HQ", "Galactic HQ", "Galactic HQ", "Galactic HQ", "Galactic HQ",
 "Galactic HQ", "Lake Verity", "Lake Verity", "Verity Cavern", "Lake Valor", "Lake Valor", "Valor Cavern",
 "Lake Acuity", "Lake Acuity", "Acuity Cavern", "Newmoon Island", "Newmoon Island", "Battle Park", "Battle Park",
 "Mystery Zone", "Mystery Zone", "Battle Tower", "Battle Tower", "Battle Tower", "Battle Tower", "Battle Tower",
 "Battle Tower", "Mystery Zone", "Mystery Zone", "Verity Lakefront", "Verity Lakefront", "Valor Lakefront",
 "Restaurant", "Grand Lake", "Grand Lake", "Acuity Lakefront", "Spring Path", "Route 201", "Route 202",
 "Route 203", "Route 204", "Route 204", "Route 205", "Route 205", "Route 205", "Route 206", "Route 206",
 "Mystery Zone", "Route 207", "Route 208", "Route 208", "Route 209", "Route 209", "Route 209", "Route 209",
 "Route 209", "Route 209", "Route 210", "Route 210", "Route 210", "Route 211", "Route 211", "Route 212",
 "Pokémon Mansion", "Pokémon Mansion", "Pokémon Mansion", "Route 212", "Route 212", "Route 213", "Route 213",
 "Footstep House", "Grand Lake", "Grand Lake", "Grand Lake", "Grand Lake", "Route 214", "Route 214", "Route 215",
 "Route 216", "Route 216", "Route 217", "Route 217", "Route 217", "Route 218", "Route 218", "Route 218",
 "Route 219", "Route 221", "Pal Park", "Route 221", "Route 222", "Route 222", "Route 222", "Route 222",
 "Route 224", "Route 225", "Mystery Zone", "Mystery Zone", "Route 227", "Mystery Zone", "Mystery Zone",
 "Route 228", "Route 229", "Mystery Zone", "Mystery Zone", "Mystery Zone", "Twinleaf Town", "Twinleaf Town",
 "Twinleaf Town", "Twinleaf Town", "Twinleaf Town", "Twinleaf Town", "Twinleaf Town", "Sandgem Town",
 "Sandgem Town", "Sandgem Town", "Sandgem Town", "Sandgem Town", "Sandgem Town", "Sandgem Town", "Sandgem Town",
 "Floaroma Town", "Floaroma Town", "Floaroma Town", "Floaroma Town", "Flower Shop", "Floaroma Town",
 "Floaroma Town", "Solaceon Town", "Solaceon Town", "Solaceon Town", "Solaceon Town", "Pokémon Day Care",
 "Solaceon Town", "Solaceon Town", "Solaceon Town", "Solaceon Town", "Celestic Town", "Celestic Town",
 "Celestic Town", "Celestic Town", "Celestic Town", "Celestic Town", "Celestic Town", "Celestic Town",
 "Survival Area", "Survival Area", "Survival Area", "Survival Area", "Battleground", "Survival Area",
 "Survival Area", "Resort Area", "Resort Area", "Resort Area", "Resort Area", "Resort Area", "Resort Area",
 "Resort Area", "Villa", "Resort Area", "Mystery Zone", "Route 220", "Route 223", "Route 226", "Mystery Zone",
 "Route 230", "Seabreak Path", "Mystery Zone", "Jubilife City", "Canalave City", "Oreburgh City", "Eterna City",
 "Hearthome City", "Pastoria City", "Veilstone City", "Sunyshore City", "Snowpoint City", "Pokémon League",
 "Fight Area", "Sandgem Town", "Floaroma Town", "Solaceon Town", "Celestic Town", "Survival Area", "Resort Area",
 "Canalave City", "Café", "Battle Tower", "Galactic HQ", "Pokémon League", "Pokémon League", "Galactic HQ",
 "Route 225", "Route 226", "Route 227", "Route 228", "Route 228", "Route 228", "Great Marsh", "Great Marsh",
 "Great Marsh", "Great Marsh", "Great Marsh", "Great Marsh", "Hall of Origin", "Hall of Origin",
 "Ruin Maniac Cave", "Maniac Tunnel", "Iron Island", "Solaceon Ruins", "Vista Lighthouse", "Jubilife City",
 "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave",
 "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave",
 "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave",
 "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave",
 "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave",
 "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave",
 "Turnback Cave", "Turnback Cave", "Turnback Cave", "Turnback Cave", "Contest Hall", "Battle Frontier",
 "Battle Frontier", "Battle Tower", "Battle Factory", "Battle Hall", "Battle Castle", "Battle Arcade",
 "Veilstone Store", "Global Terminal", "Global Terminal", "Galactic HQ", "Distortion World", "ROTOM’s Room",
 "T.G. Eterna Bldg", "Distortion World", "Distortion World", "Distortion World", "Distortion World",
 "Distortion World", "Distortion World", "Distortion World", "Distortion World", "Distortion World",
 "Distortion World", "Distortion World", "Spear Pillar", "Spear Pillar", "Jubilife City", "Iron Island",
 "Iron Ruins", "Mt. Coronet", "Iceberg Ruins", "Route 228", "Rock Peak Ruins"}

local statusConditionNamesList = {"None", "SLP", "PSN", "BRN", "FRZ", "PAR", "PSN"}

local mapAttributeData = {
 0, 0, 2, 2, 0, 2, 2, 0, 2, 0, 0, 2, 0, 0, 0, 0,
 3, 3, 3, 1, 1, 3, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
 0, 0, 3, 0, 2, 2, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 2, 1, 0, 0, 0, 2, 1, 0, 0, 2, 1, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

emu.reset()

local gameCode = read32Bit(0x2FFFE0C)
local gameVersionCode = band(gameCode, 0xFFFFFF)
local gameVersion = ""
local gameLanguageCode = rshift(gameCode, 24)
local gameLanguage = ""
local wrongGameVersion = true

if gameVersionCode == 0x414441 then  -- Check game version
 gameVersion = "Diamond"
elseif gameVersionCode == 0x415041 then
 gameVersion = "Pearl"
elseif gameVersionCode == 0x555043 then
 gameVersion = "Platinum"
elseif gameVersionCode == 0x475049 then
 gameVersion = "SoulSilver"
elseif gameVersionCode == 0x4B5049 then
 gameVersion = "HeartGold"
end

local mtIndexAddr, pidPointerAddr, delayAddr, currentSeedAddr, mtSeedAddr, trainerIDsPointerAddr, tempCurrentSeedDuringBattleAddr
local koreanOffset = 0

if gameLanguageCode == 0x44 then  -- Check game language and set addresses
 gameLanguage = "GER"
 mtIndexAddr = 0x21009D0
 pidPointerAddr = 0x2101ECC
 delayAddr = 0x21BF848
 currentSeedAddr = 0x21BFCB4
 mtSeedAddr = 0x21BFCB8
 trainerIDsPointerAddr = 0x21C0934
 tempCurrentSeedDuringBattleAddr = 0x27E3634
elseif gameLanguageCode == 0x45 then
 gameLanguage = "EUR/USA"
 mtIndexAddr = 0x2100834
 pidPointerAddr = 0x2101D2C
 delayAddr = 0x21BF6A8
 currentSeedAddr = 0x21BFB14
 mtSeedAddr = 0x21BFB18
 trainerIDsPointerAddr = 0x21C0794
 tempCurrentSeedDuringBattleAddr = 0x27E3634
elseif gameLanguageCode == 0x46 then
 gameLanguage = "FRE"
 mtIndexAddr = 0x2100A10
 pidPointerAddr = 0x2101F0C
 delayAddr = 0x21BF888
 currentSeedAddr = 0x21BFCF4
 mtSeedAddr = 0x21BFCF8
 trainerIDsPointerAddr = 0x21C0974
 tempCurrentSeedDuringBattleAddr = 0x27E3634
elseif gameLanguageCode == 0x49 then
 gameLanguage = "ITA"
 mtIndexAddr = 0x2100990
 pidPointerAddr = 0x2101E8C
 delayAddr = 0x21BF808
 currentSeedAddr = 0x21BFC74
 mtSeedAddr = 0x21BFC78
 trainerIDsPointerAddr = 0x21C08F4
 tempCurrentSeedDuringBattleAddr = 0x27E3634
elseif gameLanguageCode == 0x4A then
 gameLanguage = "JPN"
 mtIndexAddr = 0x20FFC28
 pidPointerAddr = 0x210112C
 delayAddr = 0x21BEAA8
 currentSeedAddr = 0x21BEF14
 mtSeedAddr = 0x21BEF18
 trainerIDsPointerAddr = 0x21BFB94
 tempCurrentSeedDuringBattleAddr = 0x27E3634
elseif gameLanguageCode == 0x4B then
 gameLanguage = "KOR"
 koreanOffset = 0x44
 mtIndexAddr = 0x2101710
 pidPointerAddr = 0x2102C2C
 delayAddr = 0x21C05A8
 currentSeedAddr = 0x21C0A14
 mtSeedAddr = 0x21C0A18
 trainerIDsPointerAddr = 0x21C1694
 tempCurrentSeedDuringBattleAddr = 0x27E3634
elseif gameLanguageCode == 0x53 then
 gameLanguage = "SPA"
 mtIndexAddr = 0x2100A30
 pidPointerAddr = 0x2101F2C
 delayAddr = 0x21BF8A8
 currentSeedAddr = 0x21BFD14
 mtSeedAddr = 0x21BFD18
 trainerIDsPointerAddr = 0x21C0994
 tempCurrentSeedDuringBattleAddr = 0x27E3634
end

function printGameInfo()
 if gameVersion == "" then  -- Print game info
  print("Version: Unknown game")
 elseif gameVersion ~= "Platinum" then
  print(string.format("Version: %s - Wrong game version! Use Platinum instead\n", gameVersion))
 elseif gameLanguage == "" then
  print("Version: "..gameVersion)
  print("Language: Unknown language\n")
 else
  wrongGameVersion = false
 end
end

printGameInfo()

local mode, index = {"Capture"}, 1
local captureMinimalUI = true
local battleLoggingOnlyMode = true
local allowManualLogToggleHotkey = false -- Dev-only: set true to re-enable Q/q log toggle
local allowPartyHpEditor = true
local partyHpEditorOpenHotkey = "h"
local partyHpEditorAllowInBattle = false
local partyHpEditorClampToMax = true
local partyHpEditorAllowZero = true
local allowPartyStatusEditor = true
local partyStatusEditorOpenHotkey = "j"
local partyStatusEditorAllowInBattle = false
local copyBoxDumpJsonToClipboard = true
local updateMasterTrainerFileOnBoxDump = true
local allowAiIntentOverlay = false
local aiIntentOverlayToggleHotkey = "y"

local PARTY_MON_STRIDE = 0xEC
local PARTY_COUNT_OFFSET = 0xD090
local PARTY_BASE_OFFSET = 0xD094
local PARTY_MON_CURRENT_HP_OFFSET = 0x8E
local PARTY_MON_MAX_HP_OFFSET = 0x90

local partyHpEditorState = {
 open = false,
 selectedSlot = 1, -- 1-based
 inputBuffer = "",
 lastStableSummariesBySlot = {}
}

local partyStatusEditorStatuses = {
 {label = "Healthy", raw = 0x00000000},
 {label = "Poison", raw = 0x00000008},
 {label = "Sleep (1)", raw = 0x00000001}, -- default 1 turn remaining
 {label = "Burn", raw = 0x00000010},
 {label = "Paralysis", raw = 0x00000040},
 {label = "Freeze", raw = 0x00000020},
 {label = "Badly Poisoned", raw = 0x00000080}
}

local partyStatusEditorState = {
 open = false,
 selectedSlot = 1, -- 1-based
 selectedStatusIndex = 1
}

local aiIntentOverlayState = {
 enabled = false,
 displayMode = "unknown"
}


-- <<< END 00_header.lua

-- >>> BEGIN 01_config.lua
-- Module Index: 01_config
-- Owns: shared battle layouts/offsets, battle control enums, battle logger config, scan tier config.
-- Note: early editor/startup flags still live in `00_header` to preserve startup call order.

local battleSystemLayout = {
 battleTypeOffset = 0x2C,
 battleCtxOffset = 0x30,
 maxBattlersOffset = 0x44,
 partiesOffset = 0x68,
 trainerIDsOffset = 0xA4}

local battleContextKnownOffsets = {
 curCommandStateOffset = 0x0,  -- u8[4]
 nextCommandStateOffset = 0x4, -- u8[4]
 commandOffset = 0x8,          -- int
 commandNextOffset = 0xC,      -- int
 attackerOffset = 0x64,        -- int
 defenderOffset = 0x6C,        -- int
 selectedPartySlotOffset = 0x219C,    -- u8[MAX_BATTLERS]
 switchedPartySlotOffset = 0x21A0,    -- u8[MAX_BATTLERS]
 aiSwitchedPartySlotOffset = 0x21A4,  -- u8[MAX_BATTLERS]
 battlerActionsOffset = 0x21A8,       -- u32[MAX_BATTLERS][MAX_BATTLE_ACTIONS]
 battlerActionOrderOffset = 0x21E8,   -- u8[MAX_BATTLERS]
 monSpeedOrderOffset = 0x21EC,        -- u8[MAX_BATTLERS]
 battleMonsOffset = 0x2D40,    -- BattleMon[MAX_BATTLERS]
 battleMonSize = 0xC0,         -- sizeof(BattleMon)
 moveSelectedOffset = 0x30B4,  -- u16[MAX_BATTLERS]
 moveSlotOffset = 0x30BC,      -- u16[MAX_BATTLERS]
 moveCurOffset = 0x3044,       -- u32
  moveTempOffset = 0x3040}      -- u32

local battleControl = {
 GET_BATTLE_MON = 0,
 START_ENCOUNTER = 1,
 TRAINER_MESSAGE = 2,
 SHOW_BATTLE_MON = 3,
 INIT_COMMAND_SELECTION = 4,
 COMMAND_SELECTION_INPUT = 5,
 CALC_TURN_ORDER = 6,
 TURN_END = 12,
 FIGHT = 13,
 ITEM = 14,
 PARTY = 15,
 RUN = 16,
 EXEC_SCRIPT = 21,
 BEFORE_MOVE = 22,
 TRY_MOVE = 23,
 PRIMARY_EFFECT = 24,
 MOVE_FAILED = 25,
 USE_MOVE = 26,
 UPDATE_HP = 27,
 AFTER_MOVE_MESSAGE = 28,
 AFTER_MOVE_EFFECT = 30,
 MOVE_END = 39,
 CHECK_ANY_FAINTED = 40,
 RESULT = 41,
 SCREEN_WIPE = 42,
 FIGHT_END = 43}

local battleLogConfig = {
 battleSystemAddr = nil,
 battleContextAddr = nil,
 usedMovesOnly = true,
 autoStartOnBattle = true,
 autoStartFramePollInterval = 10,
 autoStartScanRetryTicks = 240,
 frameHandlerPollInterval = 1,
 koSummaryOnly = true}


local battleLogState = {
 enabled = false,
 fileName = nil,
 debugFileName = nil,
 recoveryChecked = false,
 recoveryResult = nil,
 lastBattleMonsSnapshot = nil,
 lastAiKoEventKey = nil,
 lastPlayerKoEventKey = nil,
 mainLoopTick = 0,
 lastCommand = -1,
 lastCommandNext = -1,
 lastMoveSelectedSignature = nil,
 lastMoveSlotSignature = nil,
 turnPhase = "idle",
 derivedTurnIndex = 0,
 pendingTurnIntent = nil,
 pendingTurnIntentWritten = false,
 activeMoveExec = nil,
 turnMoveExecs = {},
 lastBeforeMoveKey = nil,
 lastMoveContextKey = nil,
 frameCounter = 0,
 lastAutoAcquireFrame = -999999,
 autoStartTick = 0,
 lastAutoStartAttemptTick = -999999,
 autoStartSuppressed = false,
 battleResultWritten = false,
 initialPlayerPartySnapshot = nil,
 sawValidBattleCtx = false,
 lastObservedEmuFrame = nil}

local battleLoggerVersion = 15

local battleSystemScanTiers = {
 preferredClusterEnabled = true,
 -- Aggressive first-pass window from observed samples (~0x022BF8E0..0x022BF968).
 preferredClusterStart = 0x022BF800,
 preferredClusterEnd = 0x022BFC00, -- exclusive
 preferredClusterRequireBattleCtxDelta = true,
 preferredClusterBattleCtxDelta = 0x307C,
 nearbyLastKnownEnabled = true,
 nearbyLastKnownRadius = 0x800,
 fullScanStart = 0x02200000,
 fullScanEnd = 0x02400000} -- exclusive


-- <<< END 01_config.lua

-- >>> BEGIN 02_util.lua
-- Module Index: 02_util
-- Owns: shared JSON/format helpers, file text helpers, append helpers, misc utility helpers.
-- Used by: battle logging, debug probes, overlays, and detection paths.

function LCRNG(s, mul, sum)
 local a = rshift(mul, 16) * (s % 0x10000) + rshift(s, 16) * (mul % 0x10000)
 local b = (mul % 0x10000) * (s % 0x10000) + (a % 0x10000) * 0x10000 + sum

 return b % 0x100000000
end

function getTrainerIDs()
 local trainerIDsAddr = read32Bit(trainerIDsPointerAddr) + 0x8C
 local trainerIDs = read32Bit(trainerIDsAddr)
 local TID = band(trainerIDs, 0xFFFF)
 local SID = rshift(trainerIDs, 16)

 return TID, SID
end

function getOutputDumpsDir()
 local baseDir = "dumps"
 os.execute(string.format("mkdir %s", baseDir))
 return baseDir
end

function fileExists(fileName)
 local f = io.open(fileName, "r")
 if f then
  f:close()
  return true
 end
 return false
end

function sanitizeFileComponent(text)
 local s = tostring(text or "Unknown")
 s = string.gsub(s, "[^%w%-_]", "_")
 s = string.gsub(s, "_+", "_")
 s = string.gsub(s, "^_+", "")
 s = string.gsub(s, "_+$", "")
 if s == "" then
  s = "Unknown"
 end
 return s
end

function getFullBattleLogsDir(playerTrainerTID)
 local baseDir = getOutputDumpsDir()
 local dirName = string.format("%s/Full_Battlelogs_%d", baseDir, playerTrainerTID or 0)
 os.execute(string.format("mkdir %s", dirName))
 return dirName
end

-- Restored dormant UI/data helpers for reading player party/PC box Pokemon.
-- These are not used in the battle-logging-only main loop, but kept for future extensions.
function drawArrowLeft(a, b, c)
 gui.line(a, b + 3, a + 2, b + 5, c)
 gui.line(a, b + 3, a + 2, b + 1, c)
 gui.line(a, b + 3, a + 6, b + 3, c)
end

function drawArrowRight(a, b, c)
 gui.line(a, b + 3, a - 2, b + 5, c)
 gui.line(a, b + 3, a - 2, b + 1, c)
 gui.line(a, b + 3, a - 6, b + 3, c)
end

local prevKeyInfo, infoIndex, infoMode = {}, 1, {"Gift", "Party", "Party Stats", "Box", "Box Stats"}

function getInfoInput()
 local leftInfoArrowColor = "gray"
 local rightInfoArrowColor = "gray"
 local key = input.get()

 if (key["3"] or key["numpad3"]) and (not prevKeyInfo["3"] and not prevKeyInfo["numpad3"]) then
  leftInfoArrowColor = "orange"
  infoIndex = infoIndex - 1 < 1 and 5 or infoIndex - 1
 elseif (key["4"] or key["numpad4"]) and (not prevKeyInfo["4"] and not prevKeyInfo["numpad4"]) then
  rightInfoArrowColor = "orange"
  infoIndex = infoIndex + 1 > 5 and 1 or infoIndex + 1
 end

 prevKeyInfo = key
 gui.box(1, 154, 134, 176, "#0000007F", "#0000007F")
 gui.text(2, 156, "Info Mode: "..infoMode[infoIndex])
 drawArrowLeft(2, 167, leftInfoArrowColor)
 gui.text(10, 167, "3 - 4")
 drawArrowRight(48, 167, rightInfoArrowColor)
end

function showPokemonInfo(pidAddr)
 local partyAddr = pidAddr + 0xD094
 local boxAddr = pidAddr + 0x19F24
 local currBoxIndexAddr = pidAddr + 0x19F20
 local currBoxIndex = read8Bit(currBoxIndexAddr)

 if infoMode[infoIndex] == "Gift" then
  local partySlotsCounterAddr = pidAddr + 0xD090
  local partySlotsCounter = read8Bit(partySlotsCounterAddr) - 1
  local lastPartySlotAddr = partyAddr + (partySlotsCounter * 0xEC)

  showInfo(lastPartySlotAddr)
 elseif infoMode[infoIndex] == "Party" then
  local partySelectedSlotIndexAddr = pidAddr + 0x4F379 + koreanOffset
  local partySelectedSlotIndex = read8Bit(partySelectedSlotIndexAddr)
  local partySelectedPokemonAddr = partyAddr + (partySelectedSlotIndex * 0xEC)

  showInfo(partySelectedPokemonAddr)
 elseif infoMode[infoIndex] == "Party Stats" then
  local partyStatsSelectedSlotIndexAddr = pidAddr + 0x35558 + koreanOffset
  local partyStatsSelectedSlotIndex = read8Bit(partyStatsSelectedSlotIndexAddr)
  local pokemonPartyStatsAddr = partyAddr + (partyStatsSelectedSlotIndex * 0xEC)

  showInfo(pokemonPartyStatsAddr)
 elseif infoMode[infoIndex] == "Box" then
  local boxSelectedSlotIndexAddr = pidAddr + 0x4E7EB + koreanOffset
  local boxSelectedSlotIndex = read8Bit(boxSelectedSlotIndexAddr)
  local boxSelectedPokemonAddr = boxAddr + (0x88 * boxSelectedSlotIndex) + ((0xFF0 * currBoxIndex))

  showInfo(boxSelectedPokemonAddr)
 elseif infoMode[infoIndex] == "Box Stats" then
  local boxStatsSelectedSlotIndexAddr = pidAddr + 0x4E91C + koreanOffset
  local boxStatsSelectedSlotIndex = read8Bit(boxStatsSelectedSlotIndexAddr)
  local pokemonBoxStatsAddr = boxAddr + (0x88 * boxStatsSelectedSlotIndex) + ((0xFF0 * currBoxIndex))

  showInfo(pokemonBoxStatsAddr)
 end
end

local prevKeyDump = {}
local dumpStatusText, dumpStatusFrames = "", 0

if not wrongGameVersion then
 dumpStatusText = "Lua Active"
 dumpStatusFrames = 180
end

function copyFileContentsToClipboard(fileName)
 if not (type(os) == "table" and type(os.execute) == "function") then
  return false, "os.execute unavailable"
 end

 local escapedFileName = string.gsub(tostring(fileName or ""), "'", "''")
 local inner = "Get-Content -LiteralPath ''"..escapedFileName.."'' -Raw | Set-Clipboard"
 local cmd = "powershell -NoProfile -WindowStyle Hidden -Command \"Start-Process -WindowStyle Hidden powershell -ArgumentList '-NoProfile','-WindowStyle','Hidden','-Command','"..inner.."'\""
 local ok, r1, r2, r3 = pcall(os.execute, cmd)

 if ok and (r1 == true or r1 == 0) then
  return true
 end

 return false, string.format("ok=%s r1=%s r2=%s r3=%s",
  tostring(ok), tostring(r1), tostring(r2), tostring(r3))
end

function copyTextToClipboard(text)
 if not (type(io) == "table" and type(io.popen) == "function") then
  return false, "io.popen unavailable"
 end

 local cmd = "powershell -NoProfile -Command \"[Console]::In.ReadToEnd() | Set-Clipboard\""
 local okOpen, pipe = pcall(io.popen, cmd, "w")
 if not okOpen or pipe == nil then
  return false, "clipboard pipe open failed"
 end

 local okWrite, writeErr = pcall(function()
  pipe:write(tostring(text or ""))
 end)
 local okClose, closeResult = pcall(function()
  return pipe:close()
 end)

 if okWrite and okClose and (closeResult == true or closeResult == nil) then
  return true
 end

 return false, string.format("writeOk=%s writeErr=%s closeOk=%s closeResult=%s",
  tostring(okWrite), tostring(writeErr), tostring(okClose), tostring(closeResult))
end

function getHexDumpLine(addr, bytesPerLine)
 local hexBytes = {}
 local asciiChars = {}

 for i = 0, bytesPerLine - 1 do
  local value = read8Bit(addr + i)
  hexBytes[i + 1] = string.format("%02X", value)
  asciiChars[i + 1] = (value >= 0x20 and value <= 0x7E) and string.char(value) or "."
 end

 return string.format("%08X  %s  |%s|", addr, table.concat(hexBytes, " "), table.concat(asciiChars))
end

function dumpMemoryRegion(fileHandle, startAddr, size, label)
 local bytesPerLine = 16

 fileHandle:write(string.format("[%s]\n", label))
 fileHandle:write(string.format("start=%08X size=%X end=%08X\n", startAddr, size, startAddr + size - 1))

 for addr = startAddr, startAddr + size - 1, bytesPerLine do
  fileHandle:write(getHexDumpLine(addr, bytesPerLine).."\n")
 end

 fileHandle:write("\n")
end

function dumpEnemyBattleMemory(pidAddr, enemyAddr, selectedSlotIndex)
 local selectedEnemyAddr = enemyAddr + (0xEC * selectedSlotIndex)
 local dumpStart = selectedEnemyAddr - 0x2000
 local dumpSize = 0x8000
 local fileName

 if dumpStart < 0 then
  dumpStart = 0
 end

 fileName = string.format("%s/Pt_enemy_dump_%08X_slot%d_%08X.txt", getOutputDumpsDir(), pidAddr, selectedSlotIndex + 1, selectedEnemyAddr)

 local dumpFile = io.open(fileName, "w")

 if not dumpFile then
  dumpStatusText = "Dump failed: could not open file"
  dumpStatusFrames = 240
  return
 end

 dumpFile:write(string.format("Game: Platinum (%s)\n", gameLanguage))
 dumpFile:write(string.format("pidPointerAddr=%08X\n", pidPointerAddr))
 dumpFile:write(string.format("pidAddr=%08X\n", pidAddr))
 dumpFile:write(string.format("enemyBaseAddr=%08X\n", enemyAddr))
 dumpFile:write(string.format("selectedSlot=%d\n", selectedSlotIndex + 1))
 dumpFile:write(string.format("selectedEnemyAddr=%08X\n", selectedEnemyAddr))
 dumpFile:write(string.format("slotStride=%X\n", 0xEC))
 dumpFile:write(string.format("partyBaseAddr=%08X\n", pidAddr + 0xD094))
 dumpFile:write(string.format("partyCountAddr=%08X value=%02X\n", pidAddr + 0xD090, read8Bit(pidAddr + 0xD090)))
 dumpFile:write(string.format("boxBaseAddr=%08X\n", pidAddr + 0x19F24))
 dumpFile:write(string.format("boxIndexAddr=%08X value=%02X\n\n", pidAddr + 0x19F20, read8Bit(pidAddr + 0x19F20)))

 dumpMemoryRegion(dumpFile, enemyAddr, 0x800, "Enemy battler table vicinity")
 dumpMemoryRegion(dumpFile, selectedEnemyAddr, 0x200, "Selected enemy battler (single slot)")
 dumpMemoryRegion(dumpFile, dumpStart, dumpSize, "Wide window around selected enemy battler")

 dumpFile:close()

 dumpStatusText = "Dump saved: "..fileName
 dumpStatusFrames = 240
 print("Saved enemy memory dump: "..fileName)
end

function handleEnemyDumpInput(pidAddr, enemyAddr, selectedSlotIndex)
 local key = input.get()

 if (key["9"] or key["numpad9"]) and (not prevKeyDump["9"] and not prevKeyDump["numpad9"]) then
  dumpEnemyBattleMemory(pidAddr, enemyAddr, selectedSlotIndex)
 end

 prevKeyDump = key
 if not (captureMinimalUI and mode[index] == "Capture") then
  gui.text(152, 171, "9 - Dump enemy mem")
 end
 updateDumpStatusText()
end

local prevKeyEnemyPartyLog = {}
local prevKeyBattleTools = {}

function jsonEscape(text)
 if text == nil then
  return ""
 end

 text = tostring(text)
 text = text:gsub("\\", "\\\\")
 text = text:gsub("\"", "\\\"")
 text = text:gsub("\n", "\\n")
 text = text:gsub("\r", "\\r")
 text = text:gsub("\t", "\\t")

 return text
end

function jsonNumberOrNull(value)
 return value == nil and "null" or tostring(value)
end

function jsonStringOrNull(value)
 if value == nil then
  return "null"
 end

 return "\"" .. jsonEscape(value) .. "\""
end

function formatHex8OrNil(value)
 if value == nil then
  return nil
 end

 local n = tonumber(value)
 if n == nil then
  return nil
 end

 if n < 0 then
  n = n + 0x100000000
 end

 return string.format("%08X", n % 0x100000000)
end

function trimString(value)
 if value == nil then
  return ""
 end

 return tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
end

function readFileAllText(fileName)
 local inFile = io.open(fileName, "r")
 if not inFile then
  return nil
 end

 local text = inFile:read("*a")
 inFile:close()
 return text
end

function appendJsonLineToFile(fileName, lineText)
 if not fileName then
  return false
 end

 local file = io.open(fileName, "a")
 if not file then
  return false
 end

 file:write(lineText)
 file:close()
 return true
end

function loadTextFileLines(fileName)
 if not fileName then
  return nil
 end

 local file = io.open(fileName, "r")
 if not file then
  return nil
 end

 local lines = {}
 for line in file:lines() do
  table.insert(lines, line)
 end
 file:close()
 return lines
end

function findLastIncompleteSessionStartLine(lines)
 if not lines or #lines == 0 then
  return nil
 end

 local lastSessionStartLine = nil
 local lastSessionOpen = false

 for i = 1, #lines do
  local line = lines[i]
  if line and line ~= "" then
   if string.find(line, "\"type\":\"session_start\"", 1, true) then
    lastSessionStartLine = i
    lastSessionOpen = true
   elseif string.find(line, "\"type\":\"session_end\"", 1, true) then
    if lastSessionOpen then
     lastSessionOpen = false
    end
   end
  end
 end

 if lastSessionOpen and lastSessionStartLine ~= nil then
  return lastSessionStartLine
 end

 return nil
end

function rewriteFileKeepingLineCount(fileName, keepLineCount)
 if not fileName then
  return false
 end

 local file = io.open(fileName, "r")
 if not file then
  return false
 end

 local kept = {}
 local lineIndex = 0
 for line in file:lines() do
  lineIndex = lineIndex + 1
  if lineIndex <= keepLineCount then
   table.insert(kept, line)
  else
   break
  end
 end
 file:close()

 file = io.open(fileName, "w")
 if not file then
  return false
 end

 for i = 1, #kept do
  file:write(kept[i], "\n")
 end
 file:close()
 return true
end

function truncateLastIncompleteSessionInFile(fileName)
 if not fileName then
  return "missing"
 end

 local lines = loadTextFileLines(fileName)
 if lines == nil then
  return "missing"
 end

 local startLine = findLastIncompleteSessionStartLine(lines)
 if startLine == nil then
  return "none"
 end

 local ok = rewriteFileKeepingLineCount(fileName, startLine - 1)
 if ok then
  return "truncated"
 end

 return "error"
end


-- <<< END 02_util.lua

-- >>> BEGIN 03_memory_decode.lua
-- Module Index: 03_memory_decode
-- Owns: memory sanity checks, decode/read helpers, battle context array readers, naming helpers.
-- Used by: battle detection, battle logging, overlays, party editors, snapshots/dumps.

function decodePartyMonBattleStatsWords(monAddr, wordsCount)
 local pokemonPID = read32Bit(monAddr)
 if pokemonPID == nil or pokemonPID == 0 then
  return nil
 end

 local words = {}
 local prng = pokemonPID
 for i = 0, wordsCount - 1 do
  prng = LCRNG(prng, 0x41C64E6D, 0x6073)
  words[i + 1] = bxor(read16Bit(monAddr + 0x88 + (i * 2)), rshift(prng, 16))
 end
 return words
end

function writePartyMonBattleStatsWord(monAddr, wordIndex, value)
 if monAddr == nil or monAddr == 0 then
  return false, "invalid mon addr"
 end
 if wordIndex == nil or wordIndex < 1 then
  return false, "invalid word index"
 end

 local pokemonPID = read32Bit(monAddr)
 if pokemonPID == nil or pokemonPID == 0 then
  return false, "invalid mon pid"
 end

 local prng = pokemonPID
 for i = 1, wordIndex do
  prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 end

 local rawValue = band((tonumber(value) or 0), 0xFFFF)
 local encrypted = bxor(rawValue, rshift(prng, 16))
 write16Bit(monAddr + 0x88 + ((wordIndex - 1) * 2), encrypted)
 return true
end

function isAnyBattleActiveForHpEditor(battleSysAddr, battleCtxAddr, battleTypeOffset)
 if isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  local battleType = read32Bit(battleSysAddr + (battleTypeOffset or 0x2C)) or 0
  return battleType ~= 0
 end
 return false
end

function setPartyMonCurrentHpBySlot(pidAddr, slotIndex, desiredHp)
 if pidAddr == nil or pidAddr == 0 then
  return false, "pidAddr unavailable"
 end

 local summary, err = getPartyMonEditorSummary(pidAddr, slotIndex)
 if not summary then
  return false, err or "invalid slot"
 end

 local maxHp = summary.maxHp or 0
 if maxHp <= 0 then
  return false, "max HP unavailable"
 end

 local value = tonumber(desiredHp)
 if value == nil then
  return false, "invalid HP value"
 end

 value = floor(value)
 local minHp = partyHpEditorAllowZero and 0 or 1
 if value < minHp then
  value = minHp
 end
 if partyHpEditorClampToMax and value > maxHp then
  value = maxHp
 end
 if value > 0xFFFF then
  value = 0xFFFF
 end

 local writeOk, writeErr = writePartyMonBattleStatsWord(summary.monAddr, 4, value)
 if not writeOk then
  return false, writeErr or "HP write failed"
 end

 local refreshedStats = decodePartyMonBattleStatsWords(summary.monAddr, 5)
 local appliedHp = (refreshedStats and refreshedStats[4]) or value

 return true, nil, appliedHp, summary
end

function setPartyMonStatusBySlot(pidAddr, slotIndex, statusRaw)
 if pidAddr == nil or pidAddr == 0 then
  return false, "pidAddr unavailable"
 end

 local summary, err = getPartyMonEditorSummary(pidAddr, slotIndex)
 if not summary then
  return false, err or "invalid slot"
 end

 local raw = tonumber(statusRaw)
 if raw == nil then
  return false, "invalid status"
 end
 raw = band(raw, 0xFFFFFFFF)

 local lowWord = band(raw, 0xFFFF)
 local highWord = band(rshift(raw, 16), 0xFFFF)

 local ok1, err1 = writePartyMonBattleStatsWord(summary.monAddr, 1, lowWord)
 if not ok1 then
  return false, err1 or "status write failed"
 end
 local ok2, err2 = writePartyMonBattleStatsWord(summary.monAddr, 2, highWord)
 if not ok2 then
  return false, err2 or "status write failed"
 end

 local refreshedSummary = getPartyMonEditorSummary(pidAddr, slotIndex) or summary
 return true, nil, refreshedSummary
end

function isMainRAMPointer(addr)
 return addr ~= nil and addr >= 0x02000000 and addr < 0x02400000 and (addr % 4) == 0
end

function isSaneBattleContextState(battleSysAddr, battleCtxAddr)
 if not isMainRAMPointer(battleCtxAddr) then
  return false
 end

 if isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.battleCtxOffset) ~= battleCtxAddr then
  return false
 end

 local command = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandOffset)
 local commandNext = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandNextOffset)
 local battleType = isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or 0

 if command < 0 or command > 128 or commandNext < 0 or commandNext > 128 then
  return false
 end

 if band(battleType, 0x800007FF) ~= battleType then
  return false
 end

 return true
end

function getMoveNameFromId(moveId)
 if moveId == nil or moveId <= 0 then
  return "None"
 end

 local listIndex = moveId + 1

 if listIndex < 1 or listIndex > 468 then
  return string.format("Move#%d", moveId)
 end

 return moveNamesList[listIndex]
end

function getSpeciesNameSafe(speciesDexIndex)
 if speciesDexIndex == nil or speciesDexIndex < 1 or speciesDexIndex > 493 then
  return "None"
 end

 return speciesNamesList[speciesDexIndex]
end

function getNatureNameSafe(natureIndex)
 if natureIndex == nil or natureIndex < 1 or natureIndex > 25 then
  return "None"
 end

 return natureNamesList[natureIndex]
end

function getAbilityNameSafe(abilityIndex)
 if abilityIndex == nil or abilityIndex <= 0 then
  return "None"
 end

 if abilityIndex > 123 then
  return string.format("Ability#%d", abilityIndex)
 end

 return abilityNamesList[abilityIndex]
end

function getHeldItemNameSafe(itemListIndex)
 if itemListIndex == nil or itemListIndex < 1 then
  return "None"
 end

 if itemListIndex > 537 then
  return string.format("Item#%d", itemListIndex - 1)
 end

 return itemNamesList[itemListIndex]
end

function getLocationNameSafe(locationIndex)
 if locationIndex == nil then
  return "Unknown"
 end

 local listIndex = locationIndex + 1
 if listIndex < 1 or listIndex > table.getn(locationNamesList) then
  return string.format("Location#%d", locationIndex)
 end

 return locationNamesList[listIndex]
end

function getMoveNameFromDecodedListIndex(moveListIndex)
 if moveListIndex == nil or moveListIndex < 1 or moveListIndex > 468 then
  return "--"
 end

 return moveNamesList[moveListIndex]
end

function getBattleControlName(control)
 local names = {
  [battleControl.GET_BATTLE_MON] = "GET_BATTLE_MON",
  [battleControl.START_ENCOUNTER] = "START_ENCOUNTER",
  [battleControl.TRAINER_MESSAGE] = "TRAINER_MESSAGE",
  [battleControl.SHOW_BATTLE_MON] = "SHOW_BATTLE_MON",
  [battleControl.INIT_COMMAND_SELECTION] = "INIT_COMMAND_SELECTION",
  [battleControl.COMMAND_SELECTION_INPUT] = "COMMAND_SELECTION_INPUT",
  [battleControl.CALC_TURN_ORDER] = "CALC_TURN_ORDER",
  [battleControl.TURN_END] = "TURN_END",
  [battleControl.FIGHT] = "FIGHT",
  [battleControl.ITEM] = "ITEM",
  [battleControl.PARTY] = "PARTY",
  [battleControl.RUN] = "RUN",
  [battleControl.EXEC_SCRIPT] = "EXEC_SCRIPT",
  [battleControl.BEFORE_MOVE] = "BEFORE_MOVE",
  [battleControl.TRY_MOVE] = "TRY_MOVE",
  [battleControl.PRIMARY_EFFECT] = "PRIMARY_EFFECT",
  [battleControl.MOVE_FAILED] = "MOVE_FAILED",
  [battleControl.USE_MOVE] = "USE_MOVE",
  [battleControl.UPDATE_HP] = "UPDATE_HP",
  [battleControl.AFTER_MOVE_MESSAGE] = "AFTER_MOVE_MESSAGE",
  [battleControl.AFTER_MOVE_EFFECT] = "AFTER_MOVE_EFFECT",
  [battleControl.MOVE_END] = "MOVE_END",
  [battleControl.CHECK_ANY_FAINTED] = "CHECK_ANY_FAINTED",
  [battleControl.RESULT] = "RESULT",
  [battleControl.SCREEN_WIPE] = "SCREEN_WIPE",
  [battleControl.FIGHT_END] = "FIGHT_END"}

 return names[control] or string.format("CMD_%d", control or -1)
end

function getActionCommandName(control)
 if control == battleControl.FIGHT then
  return "fight"
 elseif control == battleControl.ITEM then
  return "item"
 elseif control == battleControl.PARTY then
  return "party"
 elseif control == battleControl.RUN then
  return "run"
 elseif control == battleControl.MOVE_END then
  return "move_end"
 end

 return getBattleControlName(control)
end

function readBattleContextU16Array(battleCtxAddr, baseOffset, count)
 local values = {}

 for i = 0, count - 1 do
  values[i + 1] = read16Bit(battleCtxAddr + baseOffset + (i * 2))
 end

 return values
end

function readBattleContextU8Array(battleCtxAddr, baseOffset, count)
 local values = {}

 for i = 0, count - 1 do
  values[i + 1] = read8Bit(battleCtxAddr + baseOffset + i)
 end

 return values
end

function readBattleContextU32Array(battleCtxAddr, baseOffset, count)
 local values = {}

 for i = 0, count - 1 do
  values[i + 1] = read32Bit(battleCtxAddr + baseOffset + (i * 4))
 end

 return values
end

function readBattlerActionsMatrix(battleCtxAddr)
 local actions = {}

 for battler = 0, 3 do
  local row = {}
  local rowBase = battleCtxAddr + battleContextKnownOffsets.battlerActionsOffset + (battler * 16)

  for actionIndex = 0, 3 do
   row[actionIndex + 1] = read32Bit(rowBase + (actionIndex * 4))
  end

  actions[battler + 1] = row
 end

 return actions
end

function readBattleMonSummary(battleCtxAddr, battler)
 local monAddr = battleCtxAddr + battleContextKnownOffsets.battleMonsOffset + (battler * battleContextKnownOffsets.battleMonSize)
 local species = read16Bit(monAddr + 0x00)
 local moves = {
  read16Bit(monAddr + 0x0C),
  read16Bit(monAddr + 0x0E),
  read16Bit(monAddr + 0x10),
  read16Bit(monAddr + 0x12)}
 local level = read8Bit(monAddr + 0x34)
 local curHP = read32Bit(monAddr + 0x4C)
 local maxHP = read32Bit(monAddr + 0x50)
 local status = read32Bit(monAddr + 0x6C)

 return {
  battler = battler,
  side = (math.fmod(battler, 2) == 0) and "player" or "enemy",
  addr = monAddr,
  species = species,
  speciesName = getSpeciesNameSafe(species),
  level = level,
  curHP = curHP,
  maxHP = maxHP,
  status = status,
  moves = moves}
end

function readAllBattleMonSummaries(battleCtxAddr)
 local mons = {}

 for battler = 0, 3 do
  mons[battler + 1] = readBattleMonSummary(battleCtxAddr, battler)
 end

 return mons
end

function decodeEnemyPartyBattleStatsWords(monAddr, pokemonPID, wordsCount)
 local words = {}
 local prng = pokemonPID

 for i = 0, wordsCount - 1 do
  prng = LCRNG(prng, 0x41C64E6D, 0x6073)
  words[i + 1] = bxor(read16Bit(monAddr + 0x88 + (i * 2)), rshift(prng, 16))
 end

 return words
end

function decodeEnemyPartyMonSummary(monAddr)
 local pokemonPID = read32Bit(monAddr)

 if pokemonPID == 0 then
  return nil
 end

 local checksum = read16Bit(monAddr + 0x6)
 local orderIndex = (rshift(band(pokemonPID, 0x3E000), 0xD) % 24) + 1
 local growthOffset = getOffset("growth", orderIndex) * 32
 local attacksOffset = getOffset("attack", orderIndex) * 32

 local growthPrng = checksum
 for i = 1, getOffset("growth", orderIndex) do
  growthPrng = LCRNG(growthPrng, 0x5F748241, 0xCBA72510)
 end

 growthPrng = LCRNG(growthPrng, 0x41C64E6D, 0x6073)
 local speciesDexIndex = bxor(read16Bit(monAddr + growthOffset + 0x8), rshift(growthPrng, 16))

 local attacksPrng = checksum
 for i = 1, getOffset("attack", orderIndex) do
  attacksPrng = LCRNG(attacksPrng, 0x5F748241, 0xCBA72510)
 end

 local moveIndexes = {}
 attacksPrng = LCRNG(attacksPrng, 0x41C64E6D, 0x6073)
 moveIndexes[1] = bxor(read16Bit(monAddr + attacksOffset + 0x8), rshift(attacksPrng, 16)) + 1
 attacksPrng = LCRNG(attacksPrng, 0x41C64E6D, 0x6073)
 moveIndexes[2] = bxor(read16Bit(monAddr + attacksOffset + 0xA), rshift(attacksPrng, 16)) + 1
 attacksPrng = LCRNG(attacksPrng, 0x41C64E6D, 0x6073)
 moveIndexes[3] = bxor(read16Bit(monAddr + attacksOffset + 0xC), rshift(attacksPrng, 16)) + 1
 attacksPrng = LCRNG(attacksPrng, 0x41C64E6D, 0x6073)
 moveIndexes[4] = bxor(read16Bit(monAddr + attacksOffset + 0xE), rshift(attacksPrng, 16)) + 1

 local battleStats = decodeEnemyPartyBattleStatsWords(monAddr, pokemonPID, 10)
 local levelWord = battleStats[3] or 0
 local level = band(levelWord, 0xFF)
 local currentHP = battleStats[4] or 0
 local maxHP = battleStats[5] or 0

 return pokemonPID, speciesDexIndex, moveIndexes, level, currentHP, maxHP
end

function decodePokemonStorageSummary(monAddr)
 local pokemonPID = read32Bit(monAddr)

 if pokemonPID == 0 then
  return nil
 end

 local checksum = read16Bit(monAddr + 0x6)
 local orderIndex = (rshift(band(pokemonPID, 0x3E000), 0xD) % 24) + 1
 local growthOffset = getOffset("growth", orderIndex) * 32
 local attacksOffset = getOffset("attack", orderIndex) * 32
 local decryptedCoreWords = {}
 local corePrng = checksum
 for i = 0, 63 do
  corePrng = LCRNG(corePrng, 0x41C64E6D, 0x6073)
  local encWord = read16Bit(monAddr + 0x8 + (i * 2)) or 0
  decryptedCoreWords[i + 1] = bxor(encWord, rshift(corePrng, 16))
 end

 local function getDecryptedCoreWord(blockOffset, byteOffset)
  local wordIndex = ((blockOffset + byteOffset) / 2) + 1
  return decryptedCoreWords[wordIndex] or 0
 end

 -- Block-relative offsets in decrypted core (matches parsePKM's decryptedData indices)
 local speciesDexIndex = getDecryptedCoreWord(growthOffset, 0x0)   -- growth word 0
 local heldItemIndex = getDecryptedCoreWord(growthOffset, 0x2) + 1 -- growth word 1
 local abilityWord = getDecryptedCoreWord(growthOffset, 0xC)       -- growth word 6
 local abilityIndex = getBits(abilityWord, 8, 8)

 local moveIndexes = {}
 moveIndexes[1] = getDecryptedCoreWord(attacksOffset, 0x0) + 1 -- attack word 0
 moveIndexes[2] = getDecryptedCoreWord(attacksOffset, 0x2) + 1 -- attack word 1
 moveIndexes[3] = getDecryptedCoreWord(attacksOffset, 0x4) + 1 -- attack word 2
 moveIndexes[4] = getDecryptedCoreWord(attacksOffset, 0x6) + 1 -- attack word 3

 local moves = {}
 for i = 1, 4 do
  moves[i] = getMoveNameFromDecodedListIndex(moveIndexes[i])
 end

 local ivsLow = getDecryptedCoreWord(attacksOffset, 0x10)   -- attack word 8
 local ivsHigh = getDecryptedCoreWord(attacksOffset, 0x12)  -- attack word 9
 local ivsValue = lshift(ivsHigh, 16) + ivsLow
 local hpIV, atkIV, defIV, spAtkIV, spDefIV, spdIV = getIVs(ivsValue)

 -- Pt/HGSS: met location is move/attack block word 15 (`decryptedData[move_data_offset + 15]`)
 local metLocationIndex = getDecryptedCoreWord(attacksOffset, 0x1E) -- attack word 15

 return {
  pid = pokemonPID,
  speciesId = speciesDexIndex,
  species = getSpeciesNameSafe(speciesDexIndex),
  moves = moves,
  ability = getAbilityNameSafe(abilityIndex),
  nature = getNatureNameSafe((pokemonPID % 25) + 1),
  heldItem = getHeldItemNameSafe(heldItemIndex),
  metLocation = getLocationNameSafe(metLocationIndex),
  ivs = {
   hp = hpIV or 0,
   at = atkIV or 0,
   df = defIV or 0,
   sa = spAtkIV or 0,
   sd = spDefIV or 0,
   sp = spdIV or 0}
 }
end


-- <<< END 03_memory_decode.lua

-- >>> BEGIN 04_battle_detect.lua
-- Module Index: 04_battle_detect
-- Owns: battle acquisition/detection paths (anchor + scan tiers), lifecycle tracking, auto-start detection.
-- Also owns: detection-source metadata (`detectTier` / `detectTierDepth`) and anchor fallback policy.

local battleDetectionSourceState = {
 label = nil,
 depth = nil,
 battleSysAddr = nil,
 battleCtxAddr = nil,
 mainLoopTick = 0}

function getBattleDetectionTierDepth(label)
 if label == "anchor_pointer" then
  return 0
 elseif label == "preferred_cluster" then
  return 1
 elseif label == "nearby_last_known" then
  return 2
 elseif label == "full_ram" then
  return 3
 end
 return nil
end

function noteBattleDetectionSource(label, battleSysAddr, battleCtxAddr)
 battleDetectionSourceState.label = label
 battleDetectionSourceState.depth = getBattleDetectionTierDepth(label)
 battleDetectionSourceState.battleSysAddr = battleSysAddr
 battleDetectionSourceState.battleCtxAddr = battleCtxAddr
 battleDetectionSourceState.mainLoopTick = (battleLogState and battleLogState.mainLoopTick) or 0
end

function getBattleDetectionSourceForCurrentPointers(battleSysAddr, battleCtxAddr)
 if battleDetectionSourceState.battleSysAddr == battleSysAddr
    and battleDetectionSourceState.battleCtxAddr == battleCtxAddr then
  return battleDetectionSourceState.label, battleDetectionSourceState.depth
 end
 return nil, nil
end

function align4Down(value)
 if value == nil then
  return nil
 end
 local n = tonumber(value)
 if n == nil then
  return nil
 end
 return n - (n % 4)
end

function align4Up(value)
 if value == nil then
  return nil
 end
 local n = tonumber(value)
 if n == nil then
  return nil
 end
 local r = n % 4
 if r == 0 then
  return n
 end
 return n + (4 - r)
end

function scanBattleSystemCandidateRange(scanStart, scanEnd, opts)
 local ramStart = 0x02000000
 local ramEnd = 0x02400000 -- exclusive
 local startAddr = align4Up(math.max(tonumber(scanStart) or ramStart, ramStart))
 local endAddr = align4Down(math.min(tonumber(scanEnd) or ramEnd, ramEnd))
 local bestCandidate = nil
 local requireBattleCtxDelta = opts and opts.requireBattleCtxDelta
 local expectedBattleCtxDelta = tonumber(opts and opts.expectedBattleCtxDelta)

 if startAddr == nil or endAddr == nil then
  return nil
 end

 if endAddr <= startAddr then
  return nil
 end

 for addr = startAddr, endAddr - 4, 4 do
  local passesFastPrefilter = true
  if requireBattleCtxDelta and expectedBattleCtxDelta ~= nil then
   local rawBattleCtxAddr = read32Bit(addr + battleSystemLayout.battleCtxOffset)
   passesFastPrefilter = (rawBattleCtxAddr == (addr + expectedBattleCtxDelta))
  end

  if passesFastPrefilter then
   local score, battleType, battleCtxAddr, maxBattlers, partySummaries = scoreBattleSystemCandidate(addr)

   if score ~= nil then
    if bestCandidate == nil
       or score > bestCandidate.score
       or (score == bestCandidate.score and addr < bestCandidate.addr) then
     bestCandidate = {
      addr = addr,
      score = score,
      battleType = battleType,
      battleCtxAddr = battleCtxAddr,
      maxBattlers = maxBattlers,
      partySummaries = partySummaries}
    end
   end
  end
 end

 return bestCandidate
end

function autoSelectBattleSystemCandidate(silent)
 local bestCandidate = nil
 local selectedTierLabel = nil
 local scannedRanges = {}

 local function tryScanTier(tierLabel, scanStart, scanEnd, scanOpts)
  if scanStart == nil or scanEnd == nil then
   return nil
  end

  local normalizedStart = align4Up(scanStart)
  local normalizedEnd = align4Down(scanEnd)
  if normalizedStart == nil or normalizedEnd == nil or normalizedEnd <= normalizedStart then
   return nil
  end

  local rangeKey = string.format("%08X-%08X", normalizedStart, normalizedEnd)
  if scannedRanges[rangeKey] then
   return nil
  end
  scannedRanges[rangeKey] = true

  local candidate = scanBattleSystemCandidateRange(normalizedStart, normalizedEnd, scanOpts)
  if candidate ~= nil then
   selectedTierLabel = tierLabel
  end
  return candidate
 end

 if battleSystemScanTiers.preferredClusterEnabled then
  bestCandidate = tryScanTier("preferred_cluster",
                              battleSystemScanTiers.preferredClusterStart,
                              battleSystemScanTiers.preferredClusterEnd,
                              {
                               requireBattleCtxDelta = battleSystemScanTiers.preferredClusterRequireBattleCtxDelta,
                               expectedBattleCtxDelta = battleSystemScanTiers.preferredClusterBattleCtxDelta
                              })
 end

 if bestCandidate == nil and battleSystemScanTiers.nearbyLastKnownEnabled then
  local lastKnownAddr = battleLogConfig and battleLogConfig.battleSystemAddr or nil
  if isMainRAMPointer(lastKnownAddr) then
   local radius = tonumber(battleSystemScanTiers.nearbyLastKnownRadius) or 0x800
   if radius < 0 then
    radius = 0x800
   end
   bestCandidate = tryScanTier("nearby_last_known",
                               lastKnownAddr - radius,
                               lastKnownAddr + radius + 4)
  end
 end

 if bestCandidate == nil then
  bestCandidate = tryScanTier("full_ram",
                              battleSystemScanTiers.fullScanStart,
                              battleSystemScanTiers.fullScanEnd)
 end

 if bestCandidate ~= nil then
  battleLogConfig.battleSystemAddr = bestCandidate.addr
  battleLogConfig.battleContextAddr = bestCandidate.battleCtxAddr
  noteBattleDetectionSource(selectedTierLabel or "scan_unknown", bestCandidate.addr, bestCandidate.battleCtxAddr)

  if not silent then
   local tierSuffix = selectedTierLabel and (" ("..selectedTierLabel..")") or ""
   dumpStatusText = string.format("Auto-selected battleCtx: %08X%s", bestCandidate.battleCtxAddr, tierSuffix)
   dumpStatusFrames = 180
  end

  return true
 end

 if not silent then
  dumpStatusText = "Auto-scan found no battle candidates"
  dumpStatusFrames = 180
 end

 return false
end

local battleLifecycleMasterState = {
 tick = 0,
 inBattle = false,
 lastKnownBattleType = 0,
 lastScanTick = -999999}

local battleSysAnchorFastPathAddr = 0x021BF680 -- runtime-discovered stable anchor candidate (build-specific)
local allowBattleSystemScanFallbackWhenAnchorFails = false -- Set true to restore old scan fallback behavior.
function tryAdoptBattleSystemCandidateFromAnchor(requireActiveBattle)
 local anchorAddr = tonumber(battleSysAnchorFastPathAddr) or 0
 if anchorAddr < 0x02000000 or anchorAddr >= 0x02400000 then
  return false
 end

 local battleSysAddr = read32Bit(anchorAddr)
 if not isMainRAMPointer(battleSysAddr) then
  return false
 end

 local battleCtxAddr = read32Bit(battleSysAddr + battleSystemLayout.battleCtxOffset)
 local battleType = read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or 0
 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  return false
 end

 if requireActiveBattle and battleType == 0 then
  return false
 end

 battleLogConfig.battleSystemAddr = battleSysAddr
 battleLogConfig.battleContextAddr = battleCtxAddr
 noteBattleDetectionSource("anchor_pointer", battleSysAddr, battleCtxAddr)
 return true, battleSysAddr, battleCtxAddr, battleType
end

function maybeFallbackScanForBattleSystemCandidate()
 if not allowBattleSystemScanFallbackWhenAnchorFails then
  return false
 end
 return autoSelectBattleSystemCandidate(true)
end

function getMasterTrainerFileName(trainerId)
 return string.format("%s/Master_%d.json", getOutputDumpsDir(), trainerId or 0)
end

function writeMasterTrainerFile(trainerId)
 local tid = trainerId or select(1, getTrainerIDs()) or 0
 local sid = select(2, getTrainerIDs()) or 0
 local battleLogFile = buildRouteFileName("battlelog", tid)
 local boxFile = buildRouteFileName("box", tid)
 local battleSnapshotFile = buildRouteFileName("battlesnapshot", tid)
 local _, battleLogJson = buildBattleLogHttpJson(tid, battleLogFile)
 local _, boxJson = buildBoxOrSnapshotHttpJson("box", tid, boxFile)
 local _, battleSnapshotJson = buildBoxOrSnapshotHttpJson("battlesnapshot", tid, battleSnapshotFile)
 local masterFileName = getMasterTrainerFileName(tid)
 local outFile = io.open(masterFileName, "w")

 if not outFile then
  dumpStatusText = "Master file failed: open error"
  dumpStatusFrames = 240
  return false
 end

 outFile:write("{\n")
 outFile:write(string.format("  \"trainerId\": %d,\n", tid))
 outFile:write(string.format("  \"secretId\": %d,\n", sid))
 outFile:write("  \"battlelog\": ")
 outFile:write(battleLogJson)
 outFile:write(",\n")
 outFile:write("  \"box\": ")
 outFile:write(boxJson)
 outFile:write(",\n")
 outFile:write("  \"battleSnapshot\": ")
 outFile:write(battleSnapshotJson)
 outFile:write("\n}\n")
 outFile:close()

 return true
end

function maybeUpdateMasterTrainerFile(trainerId)
 local ok, result = pcall(writeMasterTrainerFile, trainerId)
 if not ok then
  print("Master file update failed")
  return false
 end

 return result and true or false
end

function isAnyBattleActiveForMasterTracking()
 local battleSysAddr = battleLogConfig.battleSystemAddr
 local battleCtxAddr = battleLogConfig.battleContextAddr
 local tick = battleLifecycleMasterState.tick or 0

 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  if tryAdoptBattleSystemCandidateFromAnchor(true) then
   battleSysAddr = battleLogConfig.battleSystemAddr
   battleCtxAddr = battleLogConfig.battleContextAddr
  end
 end

 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  if tick - (battleLifecycleMasterState.lastScanTick or -999999) >= 30 then
   battleLifecycleMasterState.lastScanTick = tick
   if not tryAdoptBattleSystemCandidateFromAnchor(true) then
    maybeFallbackScanForBattleSystemCandidate()
   end
   battleSysAddr = battleLogConfig.battleSystemAddr
   battleCtxAddr = battleLogConfig.battleContextAddr
  end
 end

 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  battleLifecycleMasterState.lastKnownBattleType = 0
  return false
 end

 local battleType = read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or 0
 battleLifecycleMasterState.lastKnownBattleType = battleType

 if battleType == 0 then
  return false
 end

 return true
end

function pollBattleLifecycleMasterUpdates()
 battleLifecycleMasterState.tick = (battleLifecycleMasterState.tick or 0) + 1
 debugWatchBattleSysAnchorPointer()

 local isInBattle = isAnyBattleActiveForMasterTracking()
 local wasInBattle = battleLifecycleMasterState.inBattle

 if wasInBattle and not isInBattle then
  dumpPlayerPartyAndBoxes()
 end

 battleLifecycleMasterState.inBattle = isInBattle
end

function buildRouteFileName(resourceName, trainerId)
 local dumpsDir = getOutputDumpsDir()

 if resourceName == "battlelog" then
  return string.format("%s/Battle_Log_%d.jsonl", dumpsDir, trainerId)
 elseif resourceName == "box" then
  return string.format("%s/Box-%d.json", dumpsDir, trainerId)
 elseif resourceName == "battlesnapshot" then
  return string.format("%s/BattleSnapshot-%d.json", dumpsDir, trainerId)
 end

 return nil
end

function handleHttpGetRequest(path)
 local routePath = normalizeHttpPath(path)
 local segments = splitHttpPathSegments(routePath)

 if #segments ~= 2 then
  return 404, buildHttpJsonError(404, "route not found")
 end

 local resourceName = string.lower(segments[1] or "")
 local trainerIdText = segments[2] or ""

 if not string.match(trainerIdText, "^%d+$") then
  return 400, buildHttpJsonError(400, "trainer id must be numeric")
 end

 local trainerId = tonumber(trainerIdText)
 if trainerId == nil then
  return 400, buildHttpJsonError(400, "invalid trainer id")
 end

 local fileName = buildRouteFileName(resourceName, trainerId)
 if fileName == nil then
  return 404, buildHttpJsonError(404, "route not found")
 end

 if resourceName == "battlelog" then
  return buildBattleLogHttpJson(trainerId, fileName)
 end

 return buildBoxOrSnapshotHttpJson(resourceName, trainerId, fileName)
end

function handleHttpRequest(method, path)
 local upperMethod = string.upper(method or "")

 if upperMethod == "OPTIONS" then
  return 204, ""
 elseif upperMethod == "GET" then
  return handleHttpGetRequest(path)
 end

 return 405, buildHttpJsonError(405, "method not allowed")
end

function makeSocketBindShim(socketModule)
 if not socketModule then
  return nil
 end

 local shim = {}

 shim.bind = function(host, port, backlog)
  local bindHost = host or "*"
  local listenBacklog = backlog or 16

  if socketModule.bind then
   return socketModule.bind(bindHost, port, listenBacklog)
  end

  -- Porygon's bundled socket helper binds via dns.getaddrinfo + tcp4/tcp6.
  if socketModule.dns and socketModule.dns.getaddrinfo and (socketModule.tcp4 or socketModule.tcp6) then
   local lookupHost = bindHost == "*" and "0.0.0.0" or bindHost
   local addrinfo, addrErr = socketModule.dns.getaddrinfo(lookupHost)
   if not addrinfo then
    return nil, addrErr
   end

   local lastErr = "no info on address"
   for _, alt in ipairs(addrinfo) do
    local sock, sockErr = nil, nil
    if alt.family == "inet" and socketModule.tcp4 then
     sock, sockErr = socketModule.tcp4()
    elseif alt.family ~= "inet" and socketModule.tcp6 then
     sock, sockErr = socketModule.tcp6()
    elseif socketModule.tcp4 then
     sock, sockErr = socketModule.tcp4()
    elseif socketModule.tcp then
     sock, sockErr = socketModule.tcp()
    end

    if sock then
     pcall(function() sock:setoption("reuseaddr", true) end)
     local okBind, bindErr = sock:bind(alt.addr, port)
     if okBind then
      local okListen, listenErr = sock:listen(listenBacklog)
      if okListen then
       return sock
      end
      lastErr = listenErr or lastErr
     else
      lastErr = bindErr or lastErr
     end
     pcall(function() sock:close() end)
    else
     lastErr = sockErr or lastErr
    end
   end

   return nil, lastErr
  end

  if socketModule.tcp then
   local sock, err = socketModule.tcp()
   if not sock then
    return nil, err
   end

   pcall(function() sock:setoption("reuseaddr", true) end)

   local okBind, bindErr = sock:bind(bindHost == "*" and "0.0.0.0" or bindHost, port)
   if not okBind then
    pcall(function() sock:close() end)
    return nil, bindErr
   end

   local okListen, listenErr = sock:listen(listenBacklog)
   if not okListen then
    pcall(function() sock:close() end)
    return nil, listenErr
   end

   return sock
  end

  return nil, "no supported socket bind API"
 end

 return shim
end

function tryLoadHttpSocketLib()
 local okSocket, socketLib = pcall(require, "socket")
 if okSocket and socketLib then
  local shim = makeSocketBindShim(socketLib)
  if shim and shim.bind then
   return shim
  end
 end

 local okCore, socketCore = pcall(require, "socket.core")
 if okCore and socketCore then
  local shim = makeSocketBindShim(socketCore)
  if shim and shim.bind then
   return shim
  end
 end

 local globalSocket = rawget(_G, "socket")
 if globalSocket ~= nil then
  local shim = makeSocketBindShim(globalSocket)
  if shim and shim.bind then
   return shim
  end
 end

 return nil
end

function httpAcceptLoop()
 if not httpApiState.enabled or not httpApiState.server then
  return
 end

 local client = httpApiState.server:accept()
 if client == nil then
  return
 end

 pcall(function() client:settimeout(0) end)
 httpApiState.clients[#httpApiState.clients + 1] = {
  sock = client,
  stage = "read_request_line",
  requestLine = nil,
  method = nil,
  path = nil,
 version = nil,
 headers = {},
  partialLine = "",
  responseBuffer = nil,
  responseIndex = 1}
end

function httpProcessClientState(clientState)
 if clientState.stage == "read_request_line" then
  local line, err, partial = clientState.sock:receive("*l")
  if err then
   if err == "timeout" then
    if partial and partial ~= "" then
     clientState.partialLine = (clientState.partialLine or "") .. partial
    end
    return "keep"
   end
   return "close"
  end

  if clientState.partialLine and clientState.partialLine ~= "" then
   line = clientState.partialLine .. (line or "")
   clientState.partialLine = ""
  end

  clientState.requestLine = line
  clientState.method, clientState.path, clientState.version = parseHttpRequestLine(line)

  if not clientState.method then
   queueHttpClientResponse(clientState, 400, buildHttpJsonError(400, "invalid http request line"), "application/json; charset=utf-8")
   return "keep"
  end

  clientState.stage = "read_headers"
  return "keep"
 end

 if clientState.stage == "read_headers" then
  while true do
   local line, err, partial = clientState.sock:receive("*l")
   if err then
    if err == "timeout" then
     if partial and partial ~= "" then
      clientState.partialLine = (clientState.partialLine or "") .. partial
     end
     return "keep"
    end
    return "close"
   end

   if clientState.partialLine and clientState.partialLine ~= "" then
    line = clientState.partialLine .. (line or "")
    clientState.partialLine = ""
   end

   if line == "" then
    local statusCode, body = handleHttpRequest(clientState.method, clientState.path)
    queueHttpClientResponse(clientState, statusCode, body, statusCode == 204 and nil or "application/json; charset=utf-8")
    return "keep"
   end

   local headerName, headerValue = string.match(line, "^([^:]+):%s*(.*)$")
   if headerName then
    clientState.headers[string.lower(headerName)] = headerValue
   end
  end
 end

 if clientState.stage == "write_response" then
  local buffer = clientState.responseBuffer or ""
  local startIndex = clientState.responseIndex or 1

  if startIndex > #buffer then
   return "close"
  end

  local sent, err, partial = clientState.sock:send(buffer, startIndex)

  if sent then
   clientState.responseIndex = sent + 1
   if clientState.responseIndex > #buffer then
    return "close"
   end
   return "keep"
  end

  if err == "timeout" then
   if partial and partial >= startIndex then
    clientState.responseIndex = partial + 1
   end
   return "keep"
  end

  return "close"
 end

 return "close"
end

function httpProcessLoop()
 if not httpApiState.enabled then
  return
 end

  if #httpApiState.clients == 0 then
  httpApiState.currentIndex = 1
  return
 end

 if httpApiState.currentIndex < 1 or httpApiState.currentIndex > #httpApiState.clients then
  httpApiState.currentIndex = 1
 end

 local index = httpApiState.currentIndex
 local clientState = httpApiState.clients[index]

 if not clientState then
  httpApiState.currentIndex = 1
  return
 end

 local ok, action = pcall(httpProcessClientState, clientState)
 if (not ok) or action == "close" then
  if not ok and (httpApiState.frameCounter - (httpApiState.lastErrorFrame or -999999)) > 60 then
   httpApiState.lastErrorFrame = httpApiState.frameCounter
   print("HTTP API client processing error")
  end
  closeHttpClientStateAt(index)
  return
 end

 httpApiState.currentIndex = httpApiState.currentIndex + 1
 if httpApiState.currentIndex > #httpApiState.clients then
  httpApiState.currentIndex = 1
 end
end

function httpServerLoop()
 if not httpApiState.enabled then
  return
 end

 httpApiState.frameCounter = (httpApiState.frameCounter or 0) + 1
 httpAcceptLoop()
 httpProcessLoop()
end


-- <<< END 04_battle_detect.lua

-- >>> BEGIN 05_battle_log.lua
-- Module Index: 05_battle_log
-- Owns: battle JSONL session lifecycle, recovery, event writers, auto-start gate checks.
-- Primary outputs: `session_start`, turn events, KO events, `session_end`.

function getFrameHandlerPollInterval()
 local n = tonumber(battleLogConfig.frameHandlerPollInterval) or 1
 n = floor(n)
 if n < 1 then
  n = 1
 end
 return n
end

function shouldRunFrameHandlersThisFrame()
 battleLogState.mainLoopTick = (battleLogState.mainLoopTick or 0) + 1
 local interval = getFrameHandlerPollInterval()
 return math.fmod(battleLogState.mainLoopTick - 1, interval) == 0
end

function isEmulationPausedForScriptWork()
 if not (type(emu) == "table" and type(emu.framecount) == "function") then
  return false
 end

 local ok, currentFrame = pcall(emu.framecount)
 if not ok or type(currentFrame) ~= "number" then
  return false
 end

 local lastFrame = battleLogState and battleLogState.lastObservedEmuFrame or nil
 battleLogState.lastObservedEmuFrame = currentFrame

 if lastFrame == nil then
  return false
 end

 return currentFrame == lastFrame
end

function maybeRecoverUnterminatedLastSession(primaryFileName, debugFileName)
 if battleLogState.recoveryChecked then
  return
 end
 battleLogState.recoveryChecked = true

 local primaryResult = truncateLastIncompleteSessionInFile(primaryFileName)
 local debugResult = truncateLastIncompleteSessionInFile(debugFileName)
 local truncatedPrimary = (primaryResult == "truncated")
 local truncatedDebug = (debugResult == "truncated")
 local erroredPrimary = (primaryResult == "error")
 local erroredDebug = (debugResult == "error")

 if truncatedPrimary or truncatedDebug then
  if truncatedPrimary and truncatedDebug then
   dumpStatusText = "Recovered logs: removed incomplete session"
  elseif truncatedPrimary then
   dumpStatusText = "Recovered primary log session"
  else
   dumpStatusText = "Recovered debug log session"
  end
  dumpStatusFrames = 240
  print(string.format("Recovered incomplete session (primary=%s, debug=%s)",
                      tostring(primaryResult), tostring(debugResult)))
  battleLogState.recoveryResult = "truncated"
  return
 end

 if erroredPrimary or erroredDebug then
  if erroredPrimary and erroredDebug then
   dumpStatusText = "Recovery failed: primary+debug"
  elseif erroredPrimary then
   dumpStatusText = "Recovery failed: primary"
  else
   dumpStatusText = "Recovery failed: debug"
  end
  dumpStatusFrames = 240
  print(string.format("Recovery failed (primary=%s, debug=%s)",
                      tostring(primaryResult), tostring(debugResult)))
  battleLogState.recoveryResult = "error"
  return
 end

 battleLogState.recoveryResult = "none"
end

function writeBattleLogRecord(recordType, payloadJson)
 if not battleLogState.enabled then
  return
 end
 local lineText = string.format("{\"type\":\"%s\",%s}\n", recordType, payloadJson)
 local primaryAllowed = true
 local primaryWriteOk = true

 if battleLogConfig.koSummaryOnly then
  primaryAllowed = (recordType == "pKo" or recordType == "aiKo" or recordType == "session_end")
 end

 if primaryAllowed and battleLogState.fileName then
  primaryWriteOk = appendJsonLineToFile(battleLogState.fileName, lineText)
 end

 if battleLogState.debugFileName then
  appendJsonLineToFile(battleLogState.debugFileName, lineText)
 end

 if primaryAllowed and (not primaryWriteOk) then
  dumpStatusText = "Battle log write failed"
  dumpStatusFrames = 240
 end
end

function startBattleLogFile()
 local pidAddr = read32Bit(pidPointerAddr)
 local battleSysAddr = battleLogConfig.battleSystemAddr
 local battleType = isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or 0
 local firstEnemyMonPid = nil
 local playerTrainerTID = nil

 playerTrainerTID = select(1, getTrainerIDs()) or 0
 battleLogState.fileName = string.format("%s/Battle_Log_%d.jsonl", getOutputDumpsDir(), playerTrainerTID)
 battleLogState.debugFileName = nil
 maybeRecoverUnterminatedLastSession(battleLogState.fileName, nil)
 battleLogState.lastCommand = -1
 battleLogState.lastCommandNext = -1
 battleLogState.lastMoveSelectedSignature = nil
 battleLogState.lastMoveSlotSignature = nil
 battleLogState.turnPhase = "idle"
 battleLogState.derivedTurnIndex = 0
 battleLogState.pendingTurnIntent = nil
 battleLogState.pendingTurnIntentWritten = false
 battleLogState.turnMoveExecs = {}
 battleLogState.lastBeforeMoveKey = nil
 battleLogState.lastMoveContextKey = nil
 battleLogState.frameCounter = 0
 battleLogState.lastAutoAcquireFrame = -999999
 battleLogState.autoStartTick = 0
 battleLogState.lastAutoStartAttemptTick = -999999
 battleLogState.battleResultWritten = false
 battleLogState.initialPlayerPartySnapshot = nil
 battleLogState.sawValidBattleCtx = false
 battleLogState.lastBattleMonsSnapshot = nil
 battleLogState.lastAiKoEventKey = nil
 battleLogState.lastPlayerKoEventKey = nil
 battleLogState.enabled = true

 if not isSaneBattleContextState(battleLogConfig.battleSystemAddr, battleLogConfig.battleContextAddr) then
  if not tryAdoptBattleSystemCandidateFromAnchor(true) then
   maybeFallbackScanForBattleSystemCandidate()
  end
  battleSysAddr = battleLogConfig.battleSystemAddr
  battleType = isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or 0
 end

 if not isSaneBattleContextState(battleLogConfig.battleSystemAddr, battleLogConfig.battleContextAddr) or not isTrainerBattleType(battleType) then
  battleLogState.enabled = false
  battleLogState.fileName = nil
  battleLogState.debugFileName = nil
  dumpStatusText = "Battle log skipped (not trainer battle)"
  dumpStatusFrames = 180
  return
 end

 battleLogState.debugFileName, firstEnemyMonPid = buildBattleDebugLogFileName(playerTrainerTID, pidAddr)
 if firstEnemyMonPid == nil then
  firstEnemyMonPid = getFirstEnemyTrainerMonPid(pidAddr)
 end

 -- Capture starting player party HP so battle_result can report newly fainted mons only.
 do
  local playerPartyPtr = isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.partiesOffset + 0x0) or nil
  if isMainRAMPointer(playerPartyPtr) then
   local currentCount = read32Bit(playerPartyPtr + 0x4)
   local snapshot = {}
   if currentCount ~= nil and currentCount >= 0 and currentCount <= 6 then
    for slot = 0, currentCount - 1 do
     local monAddr = playerPartyPtr + 0x8 + (slot * 0xEC)
     local pokemonPID, speciesDexIndex, _, level, currentHP, maxHP = decodeEnemyPartyMonSummary(monAddr)
     snapshot[slot + 1] = {
      slot = slot,
      pid = pokemonPID or 0,
      species = speciesDexIndex or 0,
      speciesName = getSpeciesNameSafe(speciesDexIndex or 0),
      level = level or 0,
      curHP = currentHP or 0,
      maxHP = maxHP or 0}
    end
    battleLogState.initialPlayerPartySnapshot = snapshot
   end
  end
 end

 local enemyTrainerId = getPrimaryEnemyTrainerId(battleSysAddr)
 local sessionStartLine = string.format("{\"type\":\"session_start\",\"trainerId\":%s,\"pParty\":%s}\n",
                                        jsonNumberOrNull(enemyTrainerId),
                                        buildPlayerPartySnapshotJson(pidAddr))
 appendJsonLineToFile(battleLogState.fileName, sessionStartLine)
 if battleLogState.debugFileName then
  appendJsonLineToFile(battleLogState.debugFileName, sessionStartLine)
 end

 initBattleCtxPointerProbeForBattle(battleSysAddr, battleLogConfig.battleContextAddr, battleType)

 dumpStatusText = "Battle log ON: "..battleLogState.fileName
 dumpStatusFrames = 240
end

function stopBattleLogFile(manualStop)
 if manualStop and isSaneBattleContextState(battleLogConfig.battleSystemAddr, battleLogConfig.battleContextAddr) then
  battleLogState.autoStartSuppressed = true
 end

 if battleLogState.enabled and battleLogState.fileName then
  local pidAddr = read32Bit(pidPointerAddr)
  writeBattleLogRecord("session_end", string.format("\"ok\":true,\"pBox\":%s", buildPlayerBoxSpeciesIdsJson(pidAddr)))
 end
 maybeUpdateMasterTrainerFile()

 battleLogState.enabled = false
 battleLogState.fileName = nil
 battleLogState.debugFileName = nil
 battleLogState.turnPhase = "idle"
 battleLogState.pendingTurnIntent = nil
 battleLogState.pendingTurnIntentWritten = false
 battleLogState.activeMoveExec = nil
 battleLogState.turnMoveExecs = {}
 battleLogState.lastBeforeMoveKey = nil
 battleLogState.lastMoveContextKey = nil
 battleLogState.battleResultWritten = false
 battleLogState.initialPlayerPartySnapshot = nil
 battleLogState.sawValidBattleCtx = false
 battleLogState.lastBattleMonsSnapshot = nil
 battleLogState.lastAiKoEventKey = nil
 battleLogState.lastPlayerKoEventKey = nil
 resetBattleCtxPointerProbeState()
 dumpStatusText = "Battle log OFF"
 dumpStatusFrames = 240
end

function buildPartyMonJson(slotIndex, monAddr, pokemonPID, speciesDexIndex, level, currentHP, maxHP)
 return string.format("{\"slot\":%d,\"addr\":%d,\"pid\":%d,\"species\":%d,\"speciesName\":\"%s\",\"level\":%d,\"curHP\":%d,\"maxHP\":%d}",
                      slotIndex,
                      monAddr,
                      pokemonPID or 0,
                      speciesDexIndex or 0,
                      jsonEscape(getSpeciesNameSafe(speciesDexIndex or 0)),
                      level or 0,
                      currentHP or 0,
                      maxHP or 0)
end

function writeBattleResultRecord(battleSysAddr, reason)
 if battleLogState.battleResultWritten then
  return
 end

 local playerPartyPtr = nil
 local currentCount = nil

 if isMainRAMPointer(battleSysAddr) then
  playerPartyPtr = read32Bit(battleSysAddr + battleSystemLayout.partiesOffset + 0x0)
 end

 if isMainRAMPointer(playerPartyPtr) then
  currentCount = read32Bit(playerPartyPtr + 0x4)
 else
  local pidAddr = read32Bit(pidPointerAddr)
  playerPartyPtr = pidAddr + 0xD094
  currentCount = read8Bit(pidAddr + 0xD090)
 end

 if not playerPartyPtr then
  return
 end
 local newlyFaintedJson = ""
 local newlyFaintedCount = 0
 local initialSnapshot = battleLogState.initialPlayerPartySnapshot or {}

 if currentCount == nil or currentCount < 0 or currentCount > 6 then
  return
 end

 for slot = 0, currentCount - 1 do
  local monAddr = playerPartyPtr + 0x8 + (slot * 0xEC)
  local pokemonPID, speciesDexIndex, _, level, currentHP, maxHP = decodeEnemyPartyMonSummary(monAddr)
  local startMon = initialSnapshot[slot + 1]
  local startHP = startMon and (startMon.curHP or 0) or 0

  if pokemonPID ~= nil and startHP > 0 and (currentHP or 0) <= 0 then
   if newlyFaintedJson ~= "" then
    newlyFaintedJson = newlyFaintedJson..","
   end
   newlyFaintedJson = newlyFaintedJson..jsonStringOrNull(getSpeciesNameSafe(speciesDexIndex or 0))
   newlyFaintedCount = newlyFaintedCount + 1
  end
 end

 writeBattleLogRecord("battle_result",
                      string.format("\"newlyFainted\":[%s]",
                                    newlyFaintedJson))
 battleLogState.battleResultWritten = true
end

function isBattleEndingCommand(command)
 return command == battleControl.FIGHT_END or command == battleControl.RESULT or command == battleControl.SCREEN_WIPE
end

function isTrainerBattleType(battleType)
 return battleType ~= nil and band(battleType, 0x1) == 0x1
end

function getPrimaryEnemyTrainerId(battleSysAddr)
 if not isMainRAMPointer(battleSysAddr) then
  return nil
 end

 -- Runtime build-specific field for enemy trainer NARC id (verified via live scans).
 local trainerId = read16Bit(battleSysAddr + 0xA2)
 return (trainerId ~= nil and trainerId ~= 0) and trainerId or nil
end

function getFirstEnemyTrainerMonPid(pidAddr)
 local enemyAddr = pidAddr + 0x58E3C + koreanOffset

 for slot = 0, 5 do
  local monPid = read32Bit(enemyAddr + (slot * 0xEC))
  if monPid ~= nil and monPid ~= 0 then
   return monPid
  end
 end

 return nil
end

function getFirstEnemyTrainerMonSummary(pidAddr)
 local enemyAddr = pidAddr + 0x58E3C + koreanOffset

 for slot = 0, 5 do
  local monAddr = enemyAddr + (slot * 0xEC)
  local pokemonPID, speciesDexIndex, _, level = decodeEnemyPartyMonSummary(monAddr)
  if pokemonPID ~= nil and pokemonPID ~= 0 then
   return pokemonPID, speciesDexIndex or 0, level or 0
  end
 end

 return nil, nil, nil
end

function buildBattleDebugLogFileName(playerTrainerTID, pidAddr)
 local debugDir = getFullBattleLogsDir(playerTrainerTID)
 local firstEnemyPid, firstEnemySpecies, firstEnemyLevel = getFirstEnemyTrainerMonSummary(pidAddr)
 local speciesName = sanitizeFileComponent(getSpeciesNameSafe(firstEnemySpecies or 0))
 local levelValue = tonumber(firstEnemyLevel) or 0
 local baseName = string.format("Vs-Level_%d_%s", levelValue, speciesName)
 local fileName = string.format("%s/%s.json", debugDir, baseName)
 local suffix = 2

 while fileExists(fileName) do
  fileName = string.format("%s/%s_%d.json", debugDir, baseName, suffix)
  suffix = suffix + 1
 end

 return fileName, firstEnemyPid
end

function getEnemyBattlerPartySlotIndexByBattler(battleCtxAddr, battler)
 if battler == nil or battler < 0 or battler > 3 or math.fmod(battler, 2) ~= 1 then
  return nil
 end

 local enemySlotIndex = nil
 local selectedPartySlot = nil

 if battleCtxAddr ~= nil and isMainRAMPointer(battleCtxAddr) then
  selectedPartySlot = read8Bit(battleCtxAddr + battleContextKnownOffsets.selectedPartySlotOffset + battler)
  if selectedPartySlot ~= nil and selectedPartySlot >= 0 and selectedPartySlot <= 5 then
   enemySlotIndex = selectedPartySlot
  end
 end

 if enemySlotIndex == nil then
  enemySlotIndex = (battler == 3) and 1 or 0
 end

 return enemySlotIndex
end

function getEnemyBattlerPidByBattler(pidAddr, battleCtxAddr, battler)
 if pidAddr == nil or battler == nil or battler < 0 or battler > 3 or math.fmod(battler, 2) ~= 1 then
  return nil
 end

 local enemyAddr = pidAddr + 0x58E3C + koreanOffset
 local enemySlotIndex = getEnemyBattlerPartySlotIndexByBattler(battleCtxAddr, battler)
 if enemySlotIndex == nil then
  return nil
 end

 local monPid = read32Bit(enemyAddr + (enemySlotIndex * 0xEC))

 if monPid == nil or monPid == 0 then
  return nil
 end

 return monPid
end

function canAutoStartFromCurrentBattleContext()
 local battleSysAddr = battleLogConfig.battleSystemAddr
 local battleCtxAddr = battleLogConfig.battleContextAddr

 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  return false
 end

 local command = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandOffset)
 local commandNext = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandNextOffset)
 local battleType = isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or 0

 if battleType == 0 then
  return false
 end

 if not isTrainerBattleType(battleType) then
  return false
 end

 if isBattleEndingCommand(command) and isBattleEndingCommand(commandNext) then
  return false
 end

 return true
end

function shouldRunAutoStartPollThisFrame()
 battleLogState.autoStartFrameTick = (battleLogState.autoStartFrameTick or 0) + 1
 local interval = tonumber(battleLogConfig.autoStartFramePollInterval) or 5
 interval = floor(interval)
 if interval < 1 then
  interval = 1
 end
 return math.fmod(battleLogState.autoStartFrameTick - 1, interval) == 0
end

function maybeAutoStartBattleLog()
 if battleLogState.enabled or not battleLogConfig.autoStartOnBattle then
  return
 end

 battleLogState.autoStartTick = (battleLogState.autoStartTick or 0) + 1
 local autoStartTick = battleLogState.autoStartTick
 tryAdoptBattleSystemCandidateFromAnchor(true)
 local canStartNow = canAutoStartFromCurrentBattleContext()

 if battleLogState.autoStartSuppressed then
  if not canStartNow then
   battleLogState.autoStartSuppressed = false
  else
   return
  end
 end

 if not canStartNow then
  local retryTicks = tonumber(battleLogConfig.autoStartScanRetryTicks) or 240
  retryTicks = floor(retryTicks)
  if retryTicks < 1 then
   retryTicks = 1
  end
  if autoStartTick - (battleLogState.lastAutoStartAttemptTick or -999999) >= retryTicks then
   battleLogState.lastAutoStartAttemptTick = autoStartTick
   if not tryAdoptBattleSystemCandidateFromAnchor(true) then
    maybeFallbackScanForBattleSystemCandidate()
   end
   canStartNow = canAutoStartFromCurrentBattleContext()
  end
 end

 if canStartNow then
  writeBattlePointerProbeRecord("autostart", "trainer_detected", "Auto-start gate passed before startBattleLogFile")
  startBattleLogFile()
  dumpStatusText = "Battle log AUTO ON: "..battleLogState.fileName
  dumpStatusFrames = 240
 end
end


-- <<< END 05_battle_log.lua

-- >>> BEGIN 06_party_editors.lua
-- Module Index: 06_party_editors
-- Owns: party HP/status editor state, input handling, writes, modal overlays, related hotkey toggles.
-- Note: includes some battle-log-era helpers still colocated due to load-order-safe staged migration.

function isPartyHpEditorTogglePressed(key)
 local hotkey = tostring(partyHpEditorOpenHotkey or "h")
 local lower = string.lower(hotkey)
 local upper = string.upper(hotkey)
 return (key[lower] or key[upper]) and true or false
end

function isPartyHpEditorTogglePressedPrev(prevKey)
 local hotkey = tostring(partyHpEditorOpenHotkey or "h")
 local lower = string.lower(hotkey)
 local upper = string.upper(hotkey)
 return (prevKey[lower] or prevKey[upper]) and true or false
end

function isPartyStatusEditorTogglePressed(key)
 local hotkey = tostring(partyStatusEditorOpenHotkey or "j")
 local lower = string.lower(hotkey)
 local upper = string.upper(hotkey)
 return (key[lower] or key[upper]) and true or false
end

function isPartyStatusEditorTogglePressedPrev(prevKey)
 local hotkey = tostring(partyStatusEditorOpenHotkey or "j")
 local lower = string.lower(hotkey)
 local upper = string.upper(hotkey)
 return (prevKey[lower] or prevKey[upper]) and true or false
end

function maskEditorModalDpadInput()
 if not ((partyHpEditorState and partyHpEditorState.open) or (partyStatusEditorState and partyStatusEditorState.open)) then
  return false
 end
 if not (type(joypad) == "table" and type(joypad.set) == "function") then
  return false
 end

 local neutralDpad = {up = false, down = false, left = false, right = false}
 local ok = pcall(joypad.set, neutralDpad)
 if not ok then
  pcall(joypad.set, 1, neutralDpad)
 end
 return true
end

function getPartyCountSafe(pidAddr)
 if pidAddr == nil or pidAddr == 0 then
  return 0
 end
 local count = read8Bit(pidAddr + PARTY_COUNT_OFFSET) or 0
 if count < 0 then count = 0 end
 if count > 6 then count = 6 end
 return count
end

function getPartyMonEditorSummaryOnce(pidAddr, slotIndex)
 if pidAddr == nil or pidAddr == 0 then
  return nil, "pidAddr unavailable"
 end
 if slotIndex == nil or slotIndex < 1 or slotIndex > 6 then
  return nil, "invalid slot"
 end

 local partyCount = getPartyCountSafe(pidAddr)
 if partyCount <= 0 then
  return nil, "party empty"
 end
 if slotIndex > partyCount then
  return nil, "slot not in party"
 end

 local monAddr = pidAddr + PARTY_BASE_OFFSET + ((slotIndex - 1) * PARTY_MON_STRIDE)
 local mon = decodePokemonStorageSummary(monAddr)
 if not mon then
  return nil, "empty/invalid mon"
 end

 local battleStatsWords = decodePartyMonBattleStatsWords(monAddr, 5)
 local currentHp = (battleStatsWords and battleStatsWords[4]) or 0
 local maxHp = (battleStatsWords and battleStatsWords[5]) or 0
 local statusLow = (battleStatsWords and battleStatsWords[1]) or 0
 local statusHigh = (battleStatsWords and battleStatsWords[2]) or 0
 local statusRaw = bor(statusLow, lshift(statusHigh, 16))

 return {
  slot = slotIndex,
  monAddr = monAddr,
  pid = mon.pid or 0,
  species = mon.species or "Unknown",
  speciesId = mon.speciesId or 0,
  currentHp = currentHp,
  maxHp = maxHp,
  statusRaw = statusRaw,
  statusLabel = getPartyStatusName(statusRaw)
 }
end

function getPartyStatusName(statusRaw)
 local value = tonumber(statusRaw or 0) or 0
 local sleepTurns = band(value, 0x7)
 if sleepTurns ~= 0 then
  return "Sleep("..tostring(sleepTurns)..")"
 elseif band(value, 0x80) ~= 0 then
  return "Badly Poisoned"
 elseif band(value, 0x40) ~= 0 then
  return "Paralysis"
 elseif band(value, 0x20) ~= 0 then
  return "Freeze"
 elseif band(value, 0x10) ~= 0 then
  return "Burn"
 elseif band(value, 0x8) ~= 0 then
  return "Poison"
 end
 return "Healthy"
end

function findPartyStatusEditorIndexForRaw(statusRaw)
 local raw = tonumber(statusRaw or 0) or 0
 for i = 1, #partyStatusEditorStatuses do
  if (partyStatusEditorStatuses[i].raw or 0) == raw then
   return i
  end
 end
 return 1
end

function isPartyHpEditorSummaryReasonable(summary)
 if not summary then
  return false
 end
 if (summary.pid or 0) == 0 then
  return false
 end
 if (summary.speciesId or 0) < 1 or (summary.speciesId or 0) > 493 then
  return false
 end
 local maxHp = tonumber(summary.maxHp or -1) or -1
 local currentHp = tonumber(summary.currentHp or -1) or -1
 if maxHp < 0 or maxHp > 999 then
  return false
 end
 if currentHp < 0 or currentHp > 999 then
  return false
 end
 if maxHp > 0 and currentHp > maxHp then
  return false
 end
 return true
end

function arePartyHpEditorSummariesEquivalent(a, b)
 if not a or not b then
  return false
 end
 return (a.slot or 0) == (b.slot or 0)
    and (a.monAddr or 0) == (b.monAddr or 0)
    and (a.pid or 0) == (b.pid or 0)
    and (a.speciesId or 0) == (b.speciesId or 0)
    and (a.currentHp or -1) == (b.currentHp or -1)
    and (a.maxHp or -1) == (b.maxHp or -1)
end

function getPartyMonEditorSummary(pidAddr, slotIndex)
 local first, err1 = getPartyMonEditorSummaryOnce(pidAddr, slotIndex)
 local second, err2 = getPartyMonEditorSummaryOnce(pidAddr, slotIndex)
 local cache = partyHpEditorState.lastStableSummariesBySlot or {}

 if arePartyHpEditorSummariesEquivalent(first, second) and isPartyHpEditorSummaryReasonable(first) then
  cache[slotIndex] = first
  partyHpEditorState.lastStableSummariesBySlot = cache
  return first
 end

 if isPartyHpEditorSummaryReasonable(second) then
  cache[slotIndex] = second
  partyHpEditorState.lastStableSummariesBySlot = cache
  return second
 end
 if isPartyHpEditorSummaryReasonable(first) then
  cache[slotIndex] = first
  partyHpEditorState.lastStableSummariesBySlot = cache
  return first
 end

 local cached = cache[slotIndex]
 if cached then
  return cached
 end

 return first or second, err1 or err2
end

function openPartyHpEditor(pidAddr)
 partyHpEditorState.open = true
 partyHpEditorState.inputBuffer = ""
 local partyCount = getPartyCountSafe(pidAddr)
 if partyCount > 0 and partyHpEditorState.selectedSlot > partyCount then
  partyHpEditorState.selectedSlot = 1
 end
 dumpStatusText = string.format("HP Editor Open (Slot %d)", partyHpEditorState.selectedSlot)
 dumpStatusFrames = 180
end

function closePartyHpEditor()
 partyHpEditorState.open = false
 partyHpEditorState.inputBuffer = ""
 dumpStatusText = "HP Editor Closed"
 dumpStatusFrames = 120
end

function appendPartyHpEditorDigit(digitText)
 if digitText == nil or digitText == "" then
  return
 end
 if string.len(partyHpEditorState.inputBuffer or "") >= 5 then
  return
 end
 partyHpEditorState.inputBuffer = (partyHpEditorState.inputBuffer or "")..digitText
end

function clearPartyHpEditorInput()
 partyHpEditorState.inputBuffer = ""
end

function backspacePartyHpEditorInput()
 local text = partyHpEditorState.inputBuffer or ""
 if string.len(text) == 0 then
  return
 end
 partyHpEditorState.inputBuffer = string.sub(text, 1, string.len(text) - 1)
end

function movePartyHpEditorSlot(delta)
 local nextSlot = (partyHpEditorState.selectedSlot or 1) + delta
 if nextSlot < 1 then
  nextSlot = 6
 elseif nextSlot > 6 then
  nextSlot = 1
 end
 partyHpEditorState.selectedSlot = nextSlot
 partyHpEditorState.inputBuffer = ""
end

function getPartyEditorFrameCounter()
 if type(emu) == "table" and type(emu.framecount) == "function" then
  local ok, currentFrame = pcall(emu.framecount)
  if ok and type(currentFrame) == "number" then
   return currentFrame
  end
 end

 if battleLogState and battleLogState.frameCounter ~= nil then
  local frame = tonumber(battleLogState.frameCounter)
  if frame ~= nil then
   return frame
  end
 end

 return nil
end

function getExpectedPartyHpEditorAppliedValue(desiredHp, maxHp)
 local value = tonumber(desiredHp)
 if value == nil then
  return nil
 end

 value = floor(value)
 local minHp = partyHpEditorAllowZero and 0 or 1
 if value < minHp then
  value = minHp
 end
 if partyHpEditorClampToMax and (tonumber(maxHp or 0) or 0) > 0 and value > maxHp then
  value = maxHp
 end
 if value > 0xFFFF then
  value = 0xFFFF
 end
 return value
end

function queuePartyHpSlot0Verification(desiredHp, expectedHp, originalHp)
 local frameNow = getPartyEditorFrameCounter()
 partyHpEditorState.slot0PendingHpVerify = {
  slot = 1, -- first party slot ("slot 0" conceptually)
  desiredHp = tonumber(desiredHp or 0) or 0,
  expectedHp = tonumber(expectedHp or 0) or 0,
  originalHp = tonumber(originalHp or 0) or 0,
  retriesRemaining = 3,
  targetFrame = frameNow and (frameNow + 1) or nil,
  waitCalls = frameNow and nil or 1
 }
end

function queuePartyStatusSlot0Verification(statusRaw, originalStatusRaw)
 local frameNow = getPartyEditorFrameCounter()
 partyStatusEditorState.slot0PendingStatusVerify = {
  slot = 1, -- first party slot ("slot 0" conceptually)
  expectedStatusRaw = band((tonumber(statusRaw) or 0), 0xFFFFFFFF),
  originalStatusRaw = band((tonumber(originalStatusRaw) or 0), 0xFFFFFFFF),
  retriesRemaining = 3,
  targetFrame = frameNow and (frameNow + 1) or nil,
  waitCalls = frameNow and nil or 1
 }
end

function shouldRunPendingPartyEditorVerifyNow(pending)
 if not pending then
  return false
 end

 if pending.targetFrame ~= nil then
  local frameNow = getPartyEditorFrameCounter()
  if frameNow ~= nil and frameNow < pending.targetFrame then
   return false
  end
 end

 if pending.waitCalls ~= nil and pending.waitCalls > 0 then
  pending.waitCalls = pending.waitCalls - 1
  return false
 end

 return true
end

function reschedulePendingPartyEditorVerifyNextFrame(pending)
 local frameNow = getPartyEditorFrameCounter()
 pending.targetFrame = frameNow and (frameNow + 1) or nil
 pending.waitCalls = frameNow and nil or 1
 return pending
end

function writePartyMonBattleStatsWordDirectRaw(monAddr, wordIndex, value)
 if monAddr == nil or monAddr == 0 then
  return false, "invalid mon addr"
 end
 if wordIndex == nil or wordIndex < 1 then
  return false, "invalid word index"
 end
 write16Bit(monAddr + 0x88 + ((wordIndex - 1) * 2), band((tonumber(value) or 0), 0xFFFF))
 return true
end

function getPartyMonAddrBySlotIndex(pidAddr, slotIndex)
 if pidAddr == nil or pidAddr == 0 then
  return nil
 end
 if slotIndex == nil or slotIndex < 1 or slotIndex > 6 then
  return nil
 end
 return pidAddr + PARTY_BASE_OFFSET + ((slotIndex - 1) * PARTY_MON_STRIDE)
end

function processPendingSlot0PartyHpVerification(pidAddr)
 local pending = partyHpEditorState.slot0PendingHpVerify
 if not pending then
  return
 end
 if (pending.slot or 0) ~= 1 then
  partyHpEditorState.slot0PendingHpVerify = nil
  return
 end
 if not shouldRunPendingPartyEditorVerifyNow(pending) then
  partyHpEditorState.slot0PendingHpVerify = pending
  return
 end

 local summary = getPartyMonEditorSummary(pidAddr, 1)
 local currentHp = tonumber((summary and summary.currentHp) or -1) or -1
 local expectedHp = tonumber(pending.expectedHp or -1) or -1
 if currentHp == expectedHp then
  partyHpEditorState.slot0PendingHpVerify = nil
  return
 end

 local monAddr = getPartyMonAddrBySlotIndex(pidAddr, 1)
 local undoHp = tonumber(pending.originalHp or expectedHp) or expectedHp
 local okUndo, errUndo = writePartyMonBattleStatsWordDirectRaw(monAddr, 4, undoHp)
 local ok, err = false, nil
 if okUndo then
  ok, err = writePartyMonBattleStatsWordDirectRaw(monAddr, 4, expectedHp)
 end
 if not okUndo or not ok then
  partyHpEditorState.slot0PendingHpVerify = nil
  dumpStatusText = "HP slot 1 raw-write failed: "..tostring(errUndo or err)
  dumpStatusFrames = 180
  print(string.format("HP slot0 raw-write apply failed undoErr=%s redoErr=%s",
   tostring(errUndo), tostring(err)))
  return
 end

 partyHpEditorState.slot0PendingHpVerify = nil
 print(string.format("HP slot0 mismatch detected, raw undo+redo original=%d expected=%d current=%d",
  undoHp, expectedHp, currentHp))
end

function processPendingSlot0PartyStatusVerification(pidAddr)
 local pending = partyStatusEditorState.slot0PendingStatusVerify
 if not pending then
  return
 end
 if (pending.slot or 0) ~= 1 then
  partyStatusEditorState.slot0PendingStatusVerify = nil
  return
 end
 if not shouldRunPendingPartyEditorVerifyNow(pending) then
  partyStatusEditorState.slot0PendingStatusVerify = pending
  return
 end

 local summary = getPartyMonEditorSummary(pidAddr, 1)
 local currentStatusRaw = band((tonumber((summary and summary.statusRaw) or 0) or 0), 0xFFFFFFFF)
 local expectedStatusRaw = band((tonumber(pending.expectedStatusRaw) or 0), 0xFFFFFFFF)
 if currentStatusRaw == expectedStatusRaw then
  partyStatusEditorState.slot0PendingStatusVerify = nil
  return
 end

 local monAddr = getPartyMonAddrBySlotIndex(pidAddr, 1)
 local originalStatusRaw = band((tonumber(pending.originalStatusRaw) or 0), 0xFFFFFFFF)
 local undoLowWord = band(originalStatusRaw, 0xFFFF)
 local undoHighWord = band(rshift(originalStatusRaw, 16), 0xFFFF)
 local lowWord = band(expectedStatusRaw, 0xFFFF)
 local highWord = band(rshift(expectedStatusRaw, 16), 0xFFFF)
 local okUndo1, errUndo1 = writePartyMonBattleStatsWordDirectRaw(monAddr, 1, undoLowWord)
 local okUndo2, errUndo2 = false, nil
 if okUndo1 then
  okUndo2, errUndo2 = writePartyMonBattleStatsWordDirectRaw(monAddr, 2, undoHighWord)
 end
 local ok1, err1 = false, nil
 local ok2, err2 = false, nil
 if okUndo1 and okUndo2 then
  ok1, err1 = writePartyMonBattleStatsWordDirectRaw(monAddr, 1, lowWord)
 end
 if ok1 then
  ok2, err2 = writePartyMonBattleStatsWordDirectRaw(monAddr, 2, highWord)
 end
 if not okUndo1 or not okUndo2 or not ok1 or not ok2 then
  partyStatusEditorState.slot0PendingStatusVerify = nil
  dumpStatusText = "Status slot 1 raw-write failed: "..tostring(errUndo1 or errUndo2 or err1 or err2)
  dumpStatusFrames = 180
  print(string.format("Status slot0 raw-write apply failed undoErrs=%s/%s redoErrs=%s/%s",
   tostring(errUndo1), tostring(errUndo2), tostring(err1), tostring(err2)))
  return
 end

 partyStatusEditorState.slot0PendingStatusVerify = nil
 print(string.format("Status slot0 mismatch detected, raw undo+redo original=%d expected=%d current=%d",
  originalStatusRaw, expectedStatusRaw, currentStatusRaw))
end

function tryApplyPartyHpEditorValue(pidAddr, battleSysAddr, battleCtxAddr, battleTypeOffset)
 if not partyHpEditorAllowInBattle and isAnyBattleActiveForHpEditor(battleSysAddr, battleCtxAddr, battleTypeOffset) then
  dumpStatusText = "HP edit blocked during battle"
  dumpStatusFrames = 240
  return
 end

 local inputText = partyHpEditorState.inputBuffer or ""
 if inputText == "" then
  dumpStatusText = "HP edit failed: empty input"
  dumpStatusFrames = 180
  return
 end

 local desiredHp = tonumber(inputText)
 if desiredHp == nil then
  dumpStatusText = "HP edit failed: invalid input"
  dumpStatusFrames = 180
  return
 end

 local ok, err, appliedHp, summary = setPartyMonCurrentHpBySlot(pidAddr, partyHpEditorState.selectedSlot, desiredHp)
 if not ok then
  dumpStatusText = "HP edit failed: "..tostring(err)
  dumpStatusFrames = 240
  return
 end

 if (partyHpEditorState.selectedSlot or 1) == 1 then
  local expectedHp = getExpectedPartyHpEditorAppliedValue(desiredHp, summary and summary.maxHp)
  if expectedHp ~= nil then
   queuePartyHpSlot0Verification(expectedHp, expectedHp, summary and summary.currentHp)
  end
 end

 local refreshedSummary = getPartyMonEditorSummary(pidAddr, partyHpEditorState.selectedSlot) or summary
 dumpStatusText = string.format("HP set: %s %d/%d",
  tostring((refreshedSummary and refreshedSummary.species) or "Pokemon"),
  tonumber(appliedHp or 0) or 0,
  tonumber((refreshedSummary and refreshedSummary.maxHp) or 0) or 0)
 dumpStatusFrames = 240
 print(string.format("Set party HP slot=%d species=%s requested=%d applied=%d",
  partyHpEditorState.selectedSlot,
  tostring((refreshedSummary and refreshedSummary.species) or "Unknown"),
  tonumber(desiredHp) or -1,
  tonumber(appliedHp) or -1))
end

function handlePartyHpEditorInput(key, prevKey, pidAddr, battleSysAddr, battleCtxAddr, battleTypeOffset)
 if not allowPartyHpEditor then
  return false
 end
 processPendingSlot0PartyHpVerification(pidAddr)
 prevKey = prevKey or {}

 local hPressed = isPartyHpEditorTogglePressed(key)
 local hPrev = isPartyHpEditorTogglePressedPrev(prevKey)
 if hPressed and not hPrev then
  if partyHpEditorState.open then
   closePartyHpEditor()
  else
   openPartyHpEditor(pidAddr)
  end
  return true
 end

 if not partyHpEditorState.open then
  return false
 end

 local escPressed = (key["escape"] or key["Escape"])
 local escPrev = (prevKey["escape"] or prevKey["Escape"])
 if escPressed and not escPrev then
  closePartyHpEditor()
  return true
 end

 local leftPressed = key["left"]
 local rightPressed = key["right"]
 local leftPrev = prevKey["left"]
 local rightPrev = prevKey["right"]
 if leftPressed and not leftPrev then
  movePartyHpEditorSlot(-1)
  return true
 elseif rightPressed and not rightPrev then
  movePartyHpEditorSlot(1)
  return true
 end

 local backspacePressed = (key["backspace"] or key["Backspace"])
 local backspacePrev = (prevKey["backspace"] or prevKey["Backspace"])
 if backspacePressed and not backspacePrev then
  backspacePartyHpEditorInput()
  return true
 end

 local spacePressed = (key["space"] or key["Space"])
 local spacePrev = (prevKey["space"] or prevKey["Space"])
 if spacePressed and not spacePrev then
  tryApplyPartyHpEditorValue(pidAddr, battleSysAddr, battleCtxAddr, battleTypeOffset)
  return true
 end

 for digit = 0, 9 do
  local digitKey = tostring(digit)
  local numpadKey = "numpad"..digitKey
  local digitPressed = key[digitKey]
  local numpadPressed = key[numpadKey]
  local digitPrev = prevKey[digitKey]
  local numpadPrev = prevKey[numpadKey]
  if (digitPressed and not digitPrev) or (numpadPressed and not numpadPrev) then
   appendPartyHpEditorDigit(digitKey)
   return true
  end
 end

 return true -- Modal is open; consume unrelated keys.
end

function drawPartyHpEditorOverlay(pidAddr)
 if not allowPartyHpEditor or not partyHpEditorState.open then
  return
 end

 local summary, err = getPartyMonEditorSummary(pidAddr, partyHpEditorState.selectedSlot)
 local partyCount = getPartyCountSafe(pidAddr)
 local title = "Party HP Editor"
 local slotText = string.format("Slot: %d / PartyCount: %d", partyHpEditorState.selectedSlot, partyCount)
 local monText = summary and ("Mon: "..tostring(summary.species)) or ("Mon: "..tostring(err or "Invalid"))
 local hpText = summary and string.format("HP: %d / %d", summary.currentHp or 0, summary.maxHp or 0) or "HP: -- / --"
 local inputText = "Input: "..((partyHpEditorState.inputBuffer ~= "" and partyHpEditorState.inputBuffer) or "<empty>")

 gui.box(1, 92, 254, 191, "#000000C0", "#000000C0")
 gui.text(4, 94, title)
 gui.text(4, 105, slotText)
 gui.text(4, 116, monText)
 gui.text(4, 127, hpText)
 gui.text(4, 138, inputText)
 gui.text(4, 149, "Left/Right slot ")
 gui.text(4, 160, "Space apply  Esc/H close")
end

function openPartyStatusEditor(pidAddr)
 partyStatusEditorState.open = true
 local partyCount = getPartyCountSafe(pidAddr)
 if partyCount > 0 and partyStatusEditorState.selectedSlot > partyCount then
  partyStatusEditorState.selectedSlot = 1
 end
 local summary = getPartyMonEditorSummary(pidAddr, partyStatusEditorState.selectedSlot)
 if summary then
  partyStatusEditorState.selectedStatusIndex = findPartyStatusEditorIndexForRaw(summary.statusRaw)
 end
 dumpStatusText = string.format("Status Editor Open (Slot %d)", partyStatusEditorState.selectedSlot)
 dumpStatusFrames = 180
end

function closePartyStatusEditor()
 partyStatusEditorState.open = false
 dumpStatusText = "Status Editor Closed"
 dumpStatusFrames = 120
end

function movePartyStatusEditorSlot(delta)
 local nextSlot = (partyStatusEditorState.selectedSlot or 1) + delta
 if nextSlot < 1 then
  nextSlot = 6
 elseif nextSlot > 6 then
  nextSlot = 1
 end
 partyStatusEditorState.selectedSlot = nextSlot
end

function movePartyStatusEditorSelection(delta)
 local count = #partyStatusEditorStatuses
 if count <= 0 then
  return
 end
 local idx = (partyStatusEditorState.selectedStatusIndex or 1) + delta
 while idx < 1 do
  idx = idx + count
 end
 while idx > count do
  idx = idx - count
 end
 partyStatusEditorState.selectedStatusIndex = idx
end

function tryApplyPartyStatusEditorValue(pidAddr, battleSysAddr, battleCtxAddr, battleTypeOffset)
 if not partyStatusEditorAllowInBattle and isAnyBattleActiveForHpEditor(battleSysAddr, battleCtxAddr, battleTypeOffset) then
  dumpStatusText = "Status edit blocked during battle"
  dumpStatusFrames = 240
  return
 end

 local idx = partyStatusEditorState.selectedStatusIndex or 1
 local statusEntry = partyStatusEditorStatuses[idx]
 if not statusEntry then
  dumpStatusText = "Status edit failed: invalid status"
  dumpStatusFrames = 180
  return
 end

 local preSummary = nil
 if (partyStatusEditorState.selectedSlot or 1) == 1 then
  preSummary = getPartyMonEditorSummary(pidAddr, partyStatusEditorState.selectedSlot)
 end
 local ok, err, refreshedSummary = setPartyMonStatusBySlot(pidAddr, partyStatusEditorState.selectedSlot, statusEntry.raw)
 if not ok then
  dumpStatusText = "Status edit failed: "..tostring(err)
  dumpStatusFrames = 240
  return
 end

 if (partyStatusEditorState.selectedSlot or 1) == 1 then
  queuePartyStatusSlot0Verification(statusEntry.raw, preSummary and preSummary.statusRaw)
 end

 dumpStatusText = string.format("Status set: %s -> %s",
  tostring((refreshedSummary and refreshedSummary.species) or "Pokemon"),
  tostring((refreshedSummary and refreshedSummary.statusLabel) or statusEntry.label))
 dumpStatusFrames = 240
 print(string.format("Set party status slot=%d species=%s status=%s raw=%d",
  partyStatusEditorState.selectedSlot,
  tostring((refreshedSummary and refreshedSummary.species) or "Unknown"),
  tostring(statusEntry.label),
  tonumber(statusEntry.raw) or 0))
end

function handlePartyStatusEditorInput(key, prevKey, pidAddr, battleSysAddr, battleCtxAddr, battleTypeOffset)
 if not allowPartyStatusEditor then
  return false
 end
 processPendingSlot0PartyStatusVerification(pidAddr)
 prevKey = prevKey or {}

 local jPressed = isPartyStatusEditorTogglePressed(key)
 local jPrev = isPartyStatusEditorTogglePressedPrev(prevKey)
 if jPressed and not jPrev then
  if partyStatusEditorState.open then
   closePartyStatusEditor()
  else
   openPartyStatusEditor(pidAddr)
  end
  return true
 end

 if not partyStatusEditorState.open then
  return false
 end

 local escPressed = (key["escape"] or key["Escape"])
 local escPrev = (prevKey["escape"] or prevKey["Escape"])
 if escPressed and not escPrev then
  closePartyStatusEditor()
  return true
 end

 local leftPressed = key["left"]
 local rightPressed = key["right"]
 local leftPrev = prevKey["left"]
 local rightPrev = prevKey["right"]
 if leftPressed and not leftPrev then
  movePartyStatusEditorSlot(-1)
  return true
 elseif rightPressed and not rightPrev then
  movePartyStatusEditorSlot(1)
  return true
 end

 local upPressed = key["up"]
 local downPressed = key["down"]
 local upPrev = prevKey["up"]
 local downPrev = prevKey["down"]
 if upPressed and not upPrev then
  movePartyStatusEditorSelection(-1)
  return true
 elseif downPressed and not downPrev then
  movePartyStatusEditorSelection(1)
  return true
 end

 local spacePressed = (key["space"] or key["Space"])
 local spacePrev = (prevKey["space"] or prevKey["Space"])
 if spacePressed and not spacePrev then
  tryApplyPartyStatusEditorValue(pidAddr, battleSysAddr, battleCtxAddr, battleTypeOffset)
  return true
 end

 return true -- Modal is open; consume unrelated keys.
end

function drawPartyStatusEditorOverlay(pidAddr)
 if not allowPartyStatusEditor or not partyStatusEditorState.open then
  return
 end

 local summary, err = getPartyMonEditorSummary(pidAddr, partyStatusEditorState.selectedSlot)
 local partyCount = getPartyCountSafe(pidAddr)
 local selectedEntry = partyStatusEditorStatuses[partyStatusEditorState.selectedStatusIndex or 1]
 local selectedLabel = selectedEntry and selectedEntry.label or "Unknown"
 local monText = summary and ("Mon: "..tostring(summary.species)) or ("Mon: "..tostring(err or "Invalid"))
 local currentStatus = summary and tostring(summary.statusLabel or "Healthy") or "--"

 gui.box(1, 92, 254, 191, "#102000C0", "#102000C0")
 gui.text(4, 94, "Party Status Editor")
 gui.text(4, 105, string.format("Slot: %d / PartyCount: %d", partyStatusEditorState.selectedSlot, partyCount))
 gui.text(4, 116, monText)
 gui.text(4, 127, "Current: "..currentStatus)
 gui.text(4, 138, "Selected: "..selectedLabel)
 gui.text(4, 149, "Left/Right slot  Up/Down status")
 gui.text(4, 160, "Space apply  Esc/J close")
end

-- Still required for Gen 4 Pokemon/battle struct decryption in the logger.
function joinNumberArrayJson(values)
 local out = ""

 for i = 1, table.getn(values) do
  if i > 1 then
   out = out..","
  end

  out = out..tostring(values[i])
 end

 return "["..out.."]"
end

function buildBattlerIntentJson(battleCtxAddr, battler, moveSelected, moveSlot, selectedPartySlot, battlerActions)
 local row = battlerActions[battler + 1]
 local pickCommand = row[1] or 0
 local chooseTarget = row[2] or 0
 local tempValue = row[3] or 0
 local selectedCommand = row[4] or 0
 local moveId = moveSelected[battler + 1] or 0
 local slot = moveSlot[battler + 1] or 0

 return string.format("{\"battler\":%d,\"side\":\"%s\",\"activePartySlot\":%d,\"pickCommand\":%d,\"pickCommandName\":\"%s\",\"targetBattler\":%d,\"tempValue\":%d,\"selectedCommand\":%d,\"moveSlot\":%d,\"moveSelected\":%d,\"moveName\":%s}",
                      battler,
                      (math.fmod(battler, 2) == 0) and "player" or "enemy",
                      selectedPartySlot[battler + 1] or 0,
                      pickCommand,
                      jsonEscape(getActionCommandName(pickCommand)),
                      chooseTarget,
                      tempValue,
                      selectedCommand,
                      slot,
                      moveId,
                      jsonStringOrNull(moveId > 0 and getMoveNameFromId(moveId) or nil))
end

function buildTurnIntentSnapshot(battleSysAddr, battleCtxAddr, command, commandNext)
 local moveSelected = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSelectedOffset, 4)
 local moveSlot = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSlotOffset, 4)
 local selectedPartySlot = readBattleContextU8Array(battleCtxAddr, battleContextKnownOffsets.selectedPartySlotOffset, 4)
 local switchedPartySlot = readBattleContextU8Array(battleCtxAddr, battleContextKnownOffsets.switchedPartySlotOffset, 4)
 local battlerActionOrder = readBattleContextU8Array(battleCtxAddr, battleContextKnownOffsets.battlerActionOrderOffset, 4)
 local battlerActions = readBattlerActionsMatrix(battleCtxAddr)
 local intentsJson = ""

 for battler = 0, 3 do
  local intentJson = buildBattlerIntentJson(battleCtxAddr, battler, moveSelected, moveSlot, selectedPartySlot, battlerActions)

  if battler > 0 then
   intentsJson = intentsJson..","
  end

  intentsJson = intentsJson..intentJson
 end

 return {
  turnIndex = battleLogState.derivedTurnIndex + 1,
  command = command,
  commandNext = commandNext,
  attacker = read32Bit(battleCtxAddr + battleContextKnownOffsets.attackerOffset),
  defender = read32Bit(battleCtxAddr + battleContextKnownOffsets.defenderOffset),
  moveSelected = moveSelected,
  moveSlot = moveSlot,
  selectedPartySlot = selectedPartySlot,
  switchedPartySlot = switchedPartySlot,
  battlerActionOrder = battlerActionOrder,
  intentsJson = intentsJson}
end

function writeTurnIntentRecord(snapshot, battleSysAddr, battleCtxAddr)
 if battleLogConfig.usedMovesOnly then
  return
 end

 writeBattleLogRecord("turn_intent",
                      string.format("\"turnIndex\":%d,\"battleSys\":%s,\"battleCtx\":%s,\"battleType\":%d,\"command\":%d,\"commandName\":\"%s\",\"commandNext\":%d,\"commandNextName\":\"%s\",\"attacker\":%d,\"defender\":%d,\"moveSelected\":%s,\"moveSlot\":%s,\"selectedPartySlot\":%s,\"switchedPartySlot\":%s,\"turnOrder\":%s,\"actions\":[%s]",
                                    snapshot.turnIndex,
                                    jsonNumberOrNull(battleSysAddr),
                                    jsonNumberOrNull(battleCtxAddr),
                                    isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or -1,
                                    snapshot.command,
                                    jsonEscape(getBattleControlName(snapshot.command)),
                                    snapshot.commandNext,
                                    jsonEscape(getBattleControlName(snapshot.commandNext)),
                                    snapshot.attacker,
                                    snapshot.defender,
                                    joinNumberArrayJson(snapshot.moveSelected),
                                    joinNumberArrayJson(snapshot.moveSlot),
                                    joinNumberArrayJson(snapshot.selectedPartySlot),
                                    joinNumberArrayJson(snapshot.switchedPartySlot),
                                    joinNumberArrayJson(snapshot.battlerActionOrder),
                                    snapshot.intentsJson))
end

function writeTurnCommitRecord(battleSysAddr, battleCtxAddr, command, commandNext)
 local battleMonsJson = ""

 for battler = 0, 3 do
  local monJson = buildBattleMonJson(readBattleMonSummary(battleCtxAddr, battler))
  if battler > 0 then
   battleMonsJson = battleMonsJson..","
  end
  battleMonsJson = battleMonsJson..monJson
 end

 writeBattleLogRecord("turn_commit",
                      string.format("\"turnIndex\":%d,\"battleSys\":%s,\"battleCtx\":%s,\"command\":%d,\"commandName\":\"%s\",\"commandNext\":%d,\"commandNextName\":\"%s\",\"battleMons\":[%s]",
                                    battleLogState.derivedTurnIndex + 1,
                                    jsonNumberOrNull(battleSysAddr),
                                    jsonNumberOrNull(battleCtxAddr),
                                    command,
                                    jsonEscape(getBattleControlName(command)),
                                    commandNext,
                                    jsonEscape(getBattleControlName(commandNext)),
                                    battleMonsJson))
end

function appendTurnMoveExecSummary(execState, command, commandNext, reason, deltasJson)
 local turnIndex = execState.turnIndex or (battleLogState.derivedTurnIndex + 1)
 local list = battleLogState.turnMoveExecs[turnIndex]

 if list == nil then
  list = {}
  battleLogState.turnMoveExecs[turnIndex] = list
 end

 table.insert(list,
              string.format("{\"attacker\":%d,\"defender\":%d,\"moveId\":%d,\"moveName\":\"%s\",\"moveSlot\":%d,\"startFrame\":%d,\"endCommand\":%d,\"endCommandName\":\"%s\",\"endReason\":\"%s\",\"deltas\":[%s]}",
                            execState.attacker or 0,
                            execState.defender or 0,
                            execState.moveId or 0,
                            jsonEscape(getMoveNameFromId(execState.moveId or 0)),
                            execState.moveSlot or 0,
                            execState.startFrame or 0,
                            command or -1,
                            jsonEscape(getBattleControlName(command)),
                            jsonEscape(reason or "unknown"),
                            deltasJson or ""))
end

function joinJsonObjectArray(parts)
 local out = ""

 for i = 1, table.getn(parts) do
  if i > 1 then
   out = out..","
  end

  out = out..parts[i]
 end

 return "["..out.."]"
end

function writeTurnSummaryRecord(battleSysAddr, battleCtxAddr, command, commandNext, reason)
 local turnIndex = battleLogState.derivedTurnIndex + 1
 local execList = battleLogState.turnMoveExecs[turnIndex] or {}
 local execJson = joinJsonObjectArray(execList)
 local pending = battleLogState.pendingTurnIntent
 local pendingActionsJson = "[]"
 local pendingTurnOrderJson = "[0,0,0,0]"
 local pendingMoveSelectedJson = "[0,0,0,0]"
 local pendingMoveSlotJson = "[0,0,0,0]"

 if pending and pending.turnIndex == turnIndex then
  pendingActionsJson = "["..(pending.intentsJson or "").."]"
  pendingTurnOrderJson = joinNumberArrayJson(pending.battlerActionOrder or {0, 0, 0, 0})
  pendingMoveSelectedJson = joinNumberArrayJson(pending.moveSelected or {0, 0, 0, 0})
  pendingMoveSlotJson = joinNumberArrayJson(pending.moveSlot or {0, 0, 0, 0})
 end

 if battleLogConfig.usedMovesOnly then
  writeBattleLogRecord("turn_summary",
                       string.format("\"turnIndex\":%d,\"battleSys\":%s,\"battleCtx\":%s,\"commitCommand\":%d,\"commitCommandName\":\"%s\",\"commitCommandNext\":%d,\"commitCommandNextName\":\"%s\",\"commitReason\":%s,\"executedMoves\":%s",
                                     turnIndex,
                                     jsonNumberOrNull(battleSysAddr),
                                     jsonNumberOrNull(battleCtxAddr),
                                     command,
                                     jsonEscape(getBattleControlName(command)),
                                     commandNext,
                                     jsonEscape(getBattleControlName(commandNext)),
                                     jsonStringOrNull(reason),
                                     execJson))
 else
  writeBattleLogRecord("turn_summary",
                       string.format("\"turnIndex\":%d,\"battleSys\":%s,\"battleCtx\":%s,\"commitCommand\":%d,\"commitCommandName\":\"%s\",\"commitCommandNext\":%d,\"commitCommandNextName\":\"%s\",\"commitReason\":%s,\"plannedTurnOrder\":%s,\"plannedMoveSelected\":%s,\"plannedMoveSlot\":%s,\"plannedActions\":%s,\"executedMoves\":%s",
                                     turnIndex,
                                     jsonNumberOrNull(battleSysAddr),
                                     jsonNumberOrNull(battleCtxAddr),
                                     command,
                                     jsonEscape(getBattleControlName(command)),
                                     commandNext,
                                     jsonEscape(getBattleControlName(commandNext)),
                                     jsonStringOrNull(reason),
                                     pendingTurnOrderJson,
                                     pendingMoveSelectedJson,
                                     pendingMoveSlotJson,
                                     pendingActionsJson,
                                     execJson))
 end

 battleLogState.turnMoveExecs[turnIndex] = nil
end

function commitDerivedTurn(battleSysAddr, battleCtxAddr, command, commandNext, reason)
 if battleLogState.turnPhase ~= "turn_executing" then
  return
 end

 writeTurnCommitRecord(battleSysAddr, battleCtxAddr, command, commandNext)
 writeTurnSummaryRecord(battleSysAddr, battleCtxAddr, command, commandNext, reason)
 battleLogState.derivedTurnIndex = battleLogState.derivedTurnIndex + 1
 battleLogState.turnPhase = "turn_commit"

 if reason then
  writeBattleLogRecord("turn_phase", string.format("\"phase\":\"turn_commit\",\"turnIndex\":%d,\"reason\":\"%s\"",
                                                   battleLogState.derivedTurnIndex, jsonEscape(reason)))
 else
  writeBattleLogRecord("turn_phase", string.format("\"phase\":\"turn_commit\",\"turnIndex\":%d", battleLogState.derivedTurnIndex))
 end
end

function getMoveArraySignature(values)
 return string.format("%d,%d,%d,%d", values[1] or 0, values[2] or 0, values[3] or 0, values[4] or 0)
end

function buildBattleMonJson(mon)
 local moveNamesJson = string.format("[\"%s\",\"%s\",\"%s\",\"%s\"]",
                                     jsonEscape(getMoveNameFromId(mon.moves[1])),
                                     jsonEscape(getMoveNameFromId(mon.moves[2])),
                                     jsonEscape(getMoveNameFromId(mon.moves[3])),
                                     jsonEscape(getMoveNameFromId(mon.moves[4])))

 return string.format("{\"battler\":%d,\"side\":\"%s\",\"addr\":%d,\"species\":%d,\"speciesName\":\"%s\",\"level\":%d,\"curHP\":%d,\"maxHP\":%d,\"status\":%d,\"moves\":%s,\"moveNames\":%s}",
                      mon.battler,
                      mon.side,
                      mon.addr,
                      mon.species,
                      jsonEscape(mon.speciesName),
                      mon.level,
                      mon.curHP,
                      mon.maxHP,
                      mon.status,
                      joinNumberArrayJson(mon.moves),
                      moveNamesJson)
end

function buildBattleMonDeltaJson(beforeMon, afterMon)
 local beforeHP = beforeMon and beforeMon.curHP or 0
 local afterHP = afterMon and afterMon.curHP or 0
 local beforeStatus = beforeMon and beforeMon.status or 0
 local afterStatus = afterMon and afterMon.status or 0

 return string.format("{\"battler\":%d,\"side\":\"%s\",\"species\":%d,\"speciesName\":\"%s\",\"beforeHP\":%d,\"afterHP\":%d,\"hpDelta\":%d,\"beforeStatus\":%d,\"afterStatus\":%d}",
                      afterMon and afterMon.battler or (beforeMon and beforeMon.battler or 0),
                      (afterMon and afterMon.side) or (beforeMon and beforeMon.side) or "player",
                      (afterMon and afterMon.species) or (beforeMon and beforeMon.species) or 0,
                      jsonEscape((afterMon and afterMon.speciesName) or (beforeMon and beforeMon.speciesName) or "None"),
                      beforeHP,
                      afterHP,
                      afterHP - beforeHP,
                      beforeStatus,
                      afterStatus)
end

function isMoveExecutionCommand(command)
 return command == battleControl.BEFORE_MOVE
     or command == battleControl.TRY_MOVE
     or command == battleControl.PRIMARY_EFFECT
     or command == battleControl.MOVE_FAILED
     or command == battleControl.USE_MOVE
     or command == battleControl.UPDATE_HP
     or command == battleControl.AFTER_MOVE_MESSAGE
     or command == battleControl.AFTER_MOVE_EFFECT
     or command == battleControl.MOVE_END
     or command == battleControl.EXEC_SCRIPT
end

function isValidBattlerIndex(battler)
 return battler ~= nil and battler >= 0 and battler <= 3
end

function getMoveExecKey(attacker, defender, moveCur)
 if not isValidBattlerIndex(attacker) or not isValidBattlerIndex(defender) or moveCur == nil or moveCur <= 0 then
  return nil
 end

 return string.format("%d:%d:%d", attacker, defender, moveCur)
end

function buildMoveExecStartJson(execState, battleSysAddr, battleCtxAddr, command, commandNext)
 local beforeMonsJson = ""

 for i = 1, table.getn(execState.beforeMons) do
  if i > 1 then
   beforeMonsJson = beforeMonsJson..","
  end
  beforeMonsJson = beforeMonsJson..buildBattleMonJson(execState.beforeMons[i])
 end

 return string.format("\"battleSys\":%s,\"battleCtx\":%s,\"turnIndex\":%d,\"command\":%d,\"commandName\":\"%s\",\"commandNext\":%d,\"commandNextName\":\"%s\",\"attacker\":%d,\"defender\":%d,\"moveId\":%d,\"moveName\":\"%s\",\"moveSlot\":%d,\"beforeBattleMons\":[%s]",
                      jsonNumberOrNull(battleSysAddr),
                      jsonNumberOrNull(battleCtxAddr),
                      battleLogState.derivedTurnIndex + 1,
                      command,
                      jsonEscape(getBattleControlName(command)),
                      commandNext,
                      jsonEscape(getBattleControlName(commandNext)),
                      execState.attacker,
                      execState.defender,
                      execState.moveId,
                      jsonEscape(getMoveNameFromId(execState.moveId)),
                      execState.moveSlot or 0,
                      beforeMonsJson)
end

function writeMoveExecStartRecord(execState, battleSysAddr, battleCtxAddr, command, commandNext)
 writeBattleLogRecord("move_exec_start", buildMoveExecStartJson(execState, battleSysAddr, battleCtxAddr, command, commandNext))
end

function emitAiKoEventIfNew(turnIndex, playerMonName, opposingPokemonName, enemyPokemonPid, playerBattler)
 local dedupeKey = string.format("%d:%d:%s:%s",
                                 battleLogState.frameCounter or 0,
                                 playerBattler or -1,
                                 tostring(playerMonName or "None"),
                                 tostring(enemyPokemonPid or "nil"))

 if battleLogState.lastAiKoEventKey == dedupeKey then
  return
 end

 battleLogState.lastAiKoEventKey = dedupeKey
 writeBattleLogRecord("aiKo",
                      string.format("\"turn\":%d,\"pSpecies\":\"%s\",\"aiSpecies\":\"%s\",\"aiPid\":%s",
                                    turnIndex or (battleLogState.derivedTurnIndex + 1),
                                    jsonEscape(playerMonName or "None"),
                                    jsonEscape(opposingPokemonName or "None"),
                                    jsonNumberOrNull(enemyPokemonPid)))
end

function emitPlayerKoEventIfNew(turnIndex, playerPokemonName, targetName, moveName, enemyPartySlot, enemyBattler)
 local dedupeKey = string.format("%d:%d:%s:%s:%s",
                                 battleLogState.frameCounter or 0,
                                 enemyBattler or -1,
                                 tostring(targetName or "None"),
                                 tostring(moveName or "status"),
                                 tostring(enemyPartySlot or "nil"))

 if battleLogState.lastPlayerKoEventKey == dedupeKey then
  return
 end

 battleLogState.lastPlayerKoEventKey = dedupeKey
 writeBattleLogRecord("pKo",
                      string.format("\"turn\":%d,\"pSpecies\":\"%s\",\"aiSpecies\":\"%s\",\"move\":\"%s\",\"aiPartySlot\":%s",
                                    turnIndex or (battleLogState.derivedTurnIndex + 1),
                                    jsonEscape(playerPokemonName or "None"),
                                    jsonEscape(targetName or "None"),
                                    jsonEscape(moveName or "status"),
                                    jsonNumberOrNull(enemyPartySlot)))
end

function writeMoveExecEndRecord(execState, battleSysAddr, battleCtxAddr, command, commandNext, reason)
 local pidAddr = read32Bit(pidPointerAddr)
 local afterMons = readAllBattleMonSummaries(battleCtxAddr)
 local afterMonsJson = ""
 local deltasJson = ""

 for i = 1, table.getn(afterMons) do
  if i > 1 then
   afterMonsJson = afterMonsJson..","
   deltasJson = deltasJson..","
  end

  afterMonsJson = afterMonsJson..buildBattleMonJson(afterMons[i])
  deltasJson = deltasJson..buildBattleMonDeltaJson(execState.beforeMons[i], afterMons[i])
 end

 writeBattleLogRecord("move_exec_end",
                      string.format("\"battleSys\":%s,\"battleCtx\":%s,\"turnIndex\":%d,\"command\":%d,\"commandName\":\"%s\",\"commandNext\":%d,\"commandNextName\":\"%s\",\"reason\":\"%s\",\"attacker\":%d,\"defender\":%d,\"moveId\":%d,\"moveName\":\"%s\",\"moveSlot\":%d,\"beforeFrame\":%d,\"afterBattleMons\":[%s],\"deltas\":[%s]",
                                    jsonNumberOrNull(battleSysAddr),
                                    jsonNumberOrNull(battleCtxAddr),
                                    execState.turnIndex or (battleLogState.derivedTurnIndex + 1),
                                    command,
                                    jsonEscape(getBattleControlName(command)),
                                    commandNext,
                                    jsonEscape(getBattleControlName(commandNext)),
                                    jsonEscape(reason or "unknown"),
                                    execState.attacker,
                                    execState.defender,
                                    execState.moveId,
                                    jsonEscape(getMoveNameFromId(execState.moveId)),
                                    execState.moveSlot or 0,
                                    execState.startFrame or 0,
                                    afterMonsJson,
                                    deltasJson))

 local activeEnemyMon = afterMons[2] or execState.beforeMons[2]
 local opposingPokemonName = activeEnemyMon and activeEnemyMon.speciesName or "None"
 local playerAttackerMon = (execState and execState.attacker ~= nil and math.fmod(execState.attacker, 2) == 0)
                       and (execState.beforeMons[(execState.attacker or 0) + 1] or afterMons[(execState.attacker or 0) + 1])
                       or nil

 for i = 1, table.getn(afterMons) do
  local beforeMon = execState.beforeMons[i]
  local afterMon = afterMons[i]
  local targetMon = afterMon or beforeMon
  local beforeHP = beforeMon and beforeMon.curHP or 0
  local afterHP = afterMon and afterMon.curHP or 0

  if targetMon and beforeHP > 0 and afterHP == 0 then
   if targetMon.side == "enemy" and playerAttackerMon then
    local enemyPartySlotIndex = getEnemyBattlerPartySlotIndexByBattler(battleCtxAddr, targetMon.battler)
    emitPlayerKoEventIfNew(execState.turnIndex or (battleLogState.derivedTurnIndex + 1),
                           playerAttackerMon.speciesName or "None",
                           targetMon.speciesName or "None",
                           getMoveNameFromId(execState.moveId or 0),
                           enemyPartySlotIndex,
                           targetMon.battler)
   elseif targetMon.side == "player" then
    local enemyBattlerForPid = nil
    local enemyPokemonPid = nil

    if execState and execState.attacker ~= nil and math.fmod(execState.attacker, 2) == 1 then
     enemyBattlerForPid = execState.attacker
    elseif activeEnemyMon and activeEnemyMon.side == "enemy" then
     enemyBattlerForPid = activeEnemyMon.battler
    else
     enemyBattlerForPid = 1
    end

   enemyPokemonPid = getEnemyBattlerPidByBattler(pidAddr, battleCtxAddr, enemyBattlerForPid)
    emitAiKoEventIfNew(execState.turnIndex or (battleLogState.derivedTurnIndex + 1),
                       targetMon.speciesName or "None",
                       opposingPokemonName,
                       enemyPokemonPid,
                       targetMon.battler)
   end
  end
 end

 appendTurnMoveExecSummary(execState, command, commandNext, reason, deltasJson)
end

function updateMoveExecutionLogger(battleSysAddr, battleCtxAddr, command, commandNext, commandChanged, battleEnding, atTurnEnd, backToSelection)
 local attacker = read32Bit(battleCtxAddr + battleContextKnownOffsets.attackerOffset)
 local defender = read32Bit(battleCtxAddr + battleContextKnownOffsets.defenderOffset)
 local moveCur = read32Bit(battleCtxAddr + battleContextKnownOffsets.moveCurOffset)
 local moveSlots = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSlotOffset, 4)
 local currentKey = nil
 local canTrackMoveContext = isMoveExecutionCommand(command) and moveCur > 0 and isValidBattlerIndex(attacker) and isValidBattlerIndex(defender)
 local beforeMoveKeyChanged = false
 local moveContextKeyChanged = false
 local canStart = false
 local nextIsMoveStartLikeCommand = false
 local execScriptHandoffToMoveStart = false
 local endedByNextMoveStart = false

 if canTrackMoveContext then
  currentKey = getMoveExecKey(attacker, defender, moveCur)
 end

 if command == battleControl.BEFORE_MOVE and currentKey ~= nil and battleLogState.lastBeforeMoveKey ~= currentKey then
  beforeMoveKeyChanged = true
 end

 if currentKey ~= nil and battleLogState.lastMoveContextKey ~= currentKey then
  moveContextKeyChanged = true
 end

 if battleLogState.activeMoveExec then
  local shouldEnd = false
  local endReason = nil

  if atTurnEnd then
   shouldEnd = true
   endReason = "turn_end"
  elseif battleEnding then
   shouldEnd = true
   endReason = "battle_end"
  elseif backToSelection then
   shouldEnd = true
   endReason = "back_to_selection"
  elseif commandChanged and command == battleControl.MOVE_END then
   shouldEnd = true
   endReason = "move_end_state"
  elseif currentKey ~= nil and battleLogState.activeMoveExec.key ~= currentKey and
         (command == battleControl.BEFORE_MOVE or command == battleControl.TRY_MOVE
       or command == battleControl.USE_MOVE or command == battleControl.PRIMARY_EFFECT) then
   shouldEnd = true
   endReason = "next_move_started"
  end

  if shouldEnd then
   if endReason == "next_move_started" then
    endedByNextMoveStart = true
   end
   writeMoveExecEndRecord(battleLogState.activeMoveExec, battleSysAddr, battleCtxAddr, command, commandNext, endReason)
   battleLogState.activeMoveExec = nil
  end
 end

 local isMoveStartLikeCommand = (command == battleControl.BEFORE_MOVE
                             or command == battleControl.TRY_MOVE
                             or command == battleControl.USE_MOVE
                             or command == battleControl.PRIMARY_EFFECT)
 nextIsMoveStartLikeCommand = (commandNext == battleControl.BEFORE_MOVE
                           or commandNext == battleControl.TRY_MOVE
                           or commandNext == battleControl.USE_MOVE
                           or commandNext == battleControl.PRIMARY_EFFECT)
 execScriptHandoffToMoveStart = (command == battleControl.EXEC_SCRIPT and nextIsMoveStartLikeCommand)

 canStart = canTrackMoveContext and
            ((isMoveStartLikeCommand and
              ((command == battleControl.BEFORE_MOVE and (commandChanged or beforeMoveKeyChanged))
            or (command ~= battleControl.BEFORE_MOVE and (moveContextKeyChanged or endedByNextMoveStart))))
          or (execScriptHandoffToMoveStart and moveContextKeyChanged))

 if (not battleLogState.activeMoveExec) and canStart and currentKey then
  local moveSlot = 0

  if isValidBattlerIndex(attacker) then
   moveSlot = moveSlots[attacker + 1] or 0
  end

  battleLogState.activeMoveExec = {
   key = currentKey,
   attacker = attacker,
   defender = defender,
   moveId = moveCur,
   moveSlot = moveSlot,
   startFrame = battleLogState.frameCounter,
   turnIndex = battleLogState.derivedTurnIndex + 1,
   beforeMons = readAllBattleMonSummaries(battleCtxAddr)}

  writeMoveExecStartRecord(battleLogState.activeMoveExec, battleSysAddr, battleCtxAddr, command, commandNext)
 end

 if command == battleControl.BEFORE_MOVE and currentKey ~= nil then
  battleLogState.lastBeforeMoveKey = currentKey
 elseif command ~= battleControl.BEFORE_MOVE then
  battleLogState.lastBeforeMoveKey = nil
 end

 if canTrackMoveContext and currentKey ~= nil and not execScriptHandoffToMoveStart then
  battleLogState.lastMoveContextKey = currentKey
 else
  battleLogState.lastMoveContextKey = nil
 end
end

function writeBattleActionSnapshotRecord(battleSysAddr, battleCtxAddr, command, commandNext)
 local moveSelected = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSelectedOffset, 4)
 local moveSlot = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSlotOffset, 4)
 local battleMonsJson = ""

 for battler = 0, 3 do
  local monJson = buildBattleMonJson(readBattleMonSummary(battleCtxAddr, battler))

  if battler > 0 then
   battleMonsJson = battleMonsJson..","
  end

  battleMonsJson = battleMonsJson..monJson
 end

 local moveSelectedNamesJson = string.format("[\"%s\",\"%s\",\"%s\",\"%s\"]",
                                             jsonEscape(getMoveNameFromId(moveSelected[1])),
                                             jsonEscape(getMoveNameFromId(moveSelected[2])),
                                             jsonEscape(getMoveNameFromId(moveSelected[3])),
                                             jsonEscape(getMoveNameFromId(moveSelected[4])))

 writeBattleLogRecord("battlectx_action_snapshot",
                      string.format("\"battleSys\":%s,\"battleCtx\":%s,\"battleType\":%d,\"command\":%d,\"commandName\":\"%s\",\"commandNext\":%d,\"commandNextName\":\"%s\",\"attacker\":%d,\"defender\":%d,\"moveTemp\":%d,\"moveCur\":%d,\"moveSelected\":%s,\"moveSelectedNames\":%s,\"moveSlot\":%s,\"battleMons\":[%s]",
                                    jsonNumberOrNull(battleSysAddr),
                                    jsonNumberOrNull(battleCtxAddr),
                                    isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or -1,
                                    command,
                                    jsonEscape(getBattleControlName(command)),
                                    commandNext,
                                    jsonEscape(getBattleControlName(commandNext)),
                                    read32Bit(battleCtxAddr + battleContextKnownOffsets.attackerOffset),
                                    read32Bit(battleCtxAddr + battleContextKnownOffsets.defenderOffset),
                                    read32Bit(battleCtxAddr + battleContextKnownOffsets.moveTempOffset),
                                    read32Bit(battleCtxAddr + battleContextKnownOffsets.moveCurOffset),
                                    joinNumberArrayJson(moveSelected),
                                    moveSelectedNamesJson,
                                    joinNumberArrayJson(moveSlot),
                                    battleMonsJson))

 battleLogState.lastMoveSelectedSignature = getMoveArraySignature(moveSelected)
 battleLogState.lastMoveSlotSignature = getMoveArraySignature(moveSlot)
end

function getPartyCandidateSummary(partyPtr)
 if not isMainRAMPointer(partyPtr) then
  return nil
 end

 local capacity = read32Bit(partyPtr)
 local currentCount = read32Bit(partyPtr + 0x4)

 if capacity < 1 or capacity > 6 or currentCount < 0 or currentCount > 6 then
  return nil
 end

 local firstMonAddr = partyPtr + 0x8
 local firstPID = read32Bit(firstMonAddr)
 local speciesDexIndex = 0

 if firstPID ~= 0 then
  local _, decodedSpecies = decodeEnemyPartyMonSummary(firstMonAddr)

  speciesDexIndex = decodedSpecies or 0
 end

 return capacity, currentCount, firstPID, speciesDexIndex
end

function scoreBattleSystemCandidate(addr)
 local battleType = read32Bit(addr + battleSystemLayout.battleTypeOffset)
 local battleCtxAddr = read32Bit(addr + battleSystemLayout.battleCtxOffset)
 local maxBattlers = read32Bit(addr + battleSystemLayout.maxBattlersOffset)
 local score = 0

 if maxBattlers < 1 or maxBattlers > 4 then
  return nil
 end

 if not isMainRAMPointer(battleCtxAddr) then
  return nil
 end

 if band(battleType, 0x800007FF) ~= battleType then
  return nil
 end

 score = score + 2

 if band(battleType, 0x1) == 0x1 then  -- trainer battle
  score = score + 2
 end

 if band(battleType, 0x2) == 0x2 then  -- doubles
  score = score + 1
 end

 local partyHits = 0
 local partySummaries = {}

 for i = 0, 3 do
  local partyPtr = read32Bit(addr + battleSystemLayout.partiesOffset + (i * 4))
  local capacity, currentCount, firstPID, firstSpecies = getPartyCandidateSummary(partyPtr)

  partySummaries[i + 1] = {partyPtr, capacity, currentCount, firstPID, firstSpecies}

  if capacity ~= nil then
   partyHits = partyHits + 1
   score = score + 2

   if currentCount > 0 then
    score = score + 1
   end
  end
 end

 if partyHits < 2 then
  return nil
 end

 return score, battleType, battleCtxAddr, maxBattlers, partySummaries
end

function dumpBattleSystemCandidates()
 local fileName
 local scanStart = 0x02200000
 local scanEnd = 0x02400000
 local maxResults = 64
 local results = {}

 fileName = string.format("%s/Pt_battle_system_candidates_%08X.txt", getOutputDumpsDir(), read32Bit(pidPointerAddr))
 local outFile = io.open(fileName, "w")

 if not outFile then
  dumpStatusText = "Candidate dump failed"
  dumpStatusFrames = 240
  return
 end

 outFile:write(string.format("Platinum (%s) BattleSystem candidate scan\n", gameLanguage))
 outFile:write(string.format("scanRange=%08X-%08X\n", scanStart, scanEnd - 1))
 outFile:write(string.format("pidAddr=%08X enemyAddr=%08X\n\n", read32Bit(pidPointerAddr), read32Bit(pidPointerAddr) + 0x58E3C + koreanOffset))

 for addr = scanStart, scanEnd - 4, 4 do
  local score, battleType, battleCtxAddr, maxBattlers, partySummaries = scoreBattleSystemCandidate(addr)

  if score ~= nil then
   table.insert(results, {
    addr = addr,
    score = score,
    battleType = battleType,
    battleCtxAddr = battleCtxAddr,
    maxBattlers = maxBattlers,
    partySummaries = partySummaries})
  end
 end

 table.sort(results, function(a, b)
  if a.score == b.score then
   return a.addr < b.addr
  end

  return a.score > b.score
 end)

 outFile:write(string.format("candidateCount=%d\n\n", table.getn(results)))

 local written = 0

 for _, candidate in ipairs(results) do
  written = written + 1

  if written > maxResults then
   break
  end

  outFile:write(string.format("[%d] score=%d battleSys=%08X battleType=%08X maxBattlers=%d battleCtx=%08X\n",
                              written, candidate.score, candidate.addr, candidate.battleType, candidate.maxBattlers, candidate.battleCtxAddr))

  for i = 1, 4 do
   local summary = candidate.partySummaries[i]
   local partyPtr, capacity, currentCount, firstPID, firstSpecies = summary[1], summary[2], summary[3], summary[4], summary[5]
   local speciesName = speciesNamesList[(firstSpecies ~= nil and firstSpecies >= 1 and firstSpecies <= 493) and firstSpecies or 1]

   outFile:write(string.format("  party[%d] ptr=%08X cap=%s count=%s firstPID=%s firstSpecies=%s (%s)\n",
                               i - 1,
                               partyPtr or 0,
                               capacity ~= nil and tostring(capacity) or "nil",
                               currentCount ~= nil and tostring(currentCount) or "nil",
                               firstPID ~= nil and string.format("%08X", firstPID) or "nil",
                               firstSpecies ~= nil and tostring(firstSpecies) or "nil",
                               speciesName))
  end

  outFile:write(string.format("  battleCtx command=%d commandNext=%d curStates=%02X %02X %02X %02X nextStates=%02X %02X %02X %02X\n\n",
                              read32Bit(candidate.battleCtxAddr + battleContextKnownOffsets.commandOffset),
                              read32Bit(candidate.battleCtxAddr + battleContextKnownOffsets.commandNextOffset),
                              read8Bit(candidate.battleCtxAddr + battleContextKnownOffsets.curCommandStateOffset + 0),
                              read8Bit(candidate.battleCtxAddr + battleContextKnownOffsets.curCommandStateOffset + 1),
                              read8Bit(candidate.battleCtxAddr + battleContextKnownOffsets.curCommandStateOffset + 2),
                              read8Bit(candidate.battleCtxAddr + battleContextKnownOffsets.curCommandStateOffset + 3),
                              read8Bit(candidate.battleCtxAddr + battleContextKnownOffsets.nextCommandStateOffset + 0),
                              read8Bit(candidate.battleCtxAddr + battleContextKnownOffsets.nextCommandStateOffset + 1),
                              read8Bit(candidate.battleCtxAddr + battleContextKnownOffsets.nextCommandStateOffset + 2),
                              read8Bit(candidate.battleCtxAddr + battleContextKnownOffsets.nextCommandStateOffset + 3)))
  end

  if table.getn(results) > 0 then
   battleLogConfig.battleSystemAddr = results[1].addr
   battleLogConfig.battleContextAddr = results[1].battleCtxAddr
   outFile:write(string.format("AUTO_SELECTED_TOP_CANDIDATE battleSys=%08X battleCtx=%08X\n",
                               battleLogConfig.battleSystemAddr, battleLogConfig.battleContextAddr))
  else
   outFile:write("No candidates found.\n")
  end

 outFile:close()

 dumpStatusText = "BattleSystem candidates saved: "..fileName
 dumpStatusFrames = 240
end

function writeBattleContextDebugSnapshot()
 local battleCtxAddr = battleLogConfig.battleContextAddr
 local battleSysAddr = battleLogConfig.battleSystemAddr
 local fileName
 local outFile

 if not isMainRAMPointer(battleCtxAddr) then
  dumpStatusText = "No battleCtx candidate selected"
  dumpStatusFrames = 240
  return
 end

 fileName = string.format("%s/Pt_battlectx_debug_%08X.txt", getOutputDumpsDir(), battleCtxAddr)
 outFile = io.open(fileName, "w")

 if not outFile then
  dumpStatusText = "battleCtx debug dump failed"
  dumpStatusFrames = 240
  return
 end

 outFile:write(string.format("battleSys=%s\n", battleLogConfig.battleSystemAddr and string.format("%08X", battleLogConfig.battleSystemAddr) or "nil"))
 outFile:write(string.format("battleCtx=%08X\n", battleCtxAddr))
 outFile:write(string.format("command=%d\n", read32Bit(battleCtxAddr + battleContextKnownOffsets.commandOffset)))
 outFile:write(string.format("commandNext=%d\n", read32Bit(battleCtxAddr + battleContextKnownOffsets.commandNextOffset)))
 outFile:write(string.format("curCommandState=%02X %02X %02X %02X\n",
                             read8Bit(battleCtxAddr + 0x0), read8Bit(battleCtxAddr + 0x1),
                             read8Bit(battleCtxAddr + 0x2), read8Bit(battleCtxAddr + 0x3)))
 outFile:write(string.format("nextCommandState=%02X %02X %02X %02X\n\n",
                             read8Bit(battleCtxAddr + 0x4), read8Bit(battleCtxAddr + 0x5),
                             read8Bit(battleCtxAddr + 0x6), read8Bit(battleCtxAddr + 0x7)))

 if isMainRAMPointer(battleSysAddr) then
  outFile:write(string.format("battleSys.battleType=%08X\n", read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset)))
  outFile:write(string.format("battleSys.battleCtx =%08X\n", read32Bit(battleSysAddr + battleSystemLayout.battleCtxOffset)))
  outFile:write(string.format("battleSys.maxBattlers=%d\n", read32Bit(battleSysAddr + battleSystemLayout.maxBattlersOffset)))
  outFile:write(string.format("battleSys.parties[0..3]=%08X %08X %08X %08X\n\n",
                              read32Bit(battleSysAddr + battleSystemLayout.partiesOffset + 0x0),
                              read32Bit(battleSysAddr + battleSystemLayout.partiesOffset + 0x4),
                              read32Bit(battleSysAddr + battleSystemLayout.partiesOffset + 0x8),
                              read32Bit(battleSysAddr + battleSystemLayout.partiesOffset + 0xC)))

  dumpMemoryRegion(outFile, battleSysAddr, 0x300, "BattleSystem head (0x300 bytes)")
 end

 dumpMemoryRegion(outFile, battleCtxAddr, 0x1000, "BattleContext head (0x1000 bytes)")
 dumpMemoryRegion(outFile, battleCtxAddr + 0x1000, 0x2000, "BattleContext mid window (0x2000 bytes)")
 dumpMemoryRegion(outFile, battleCtxAddr + 0x3000, 0x3000, "BattleContext later window (0x3000 bytes)")
 dumpMemoryRegion(outFile, battleCtxAddr + 0x6000, 0x2000, "BattleContext far window (0x2000 bytes)")

 outFile:close()
 dumpStatusText = "battleCtx debug saved: "..fileName
 dumpStatusFrames = 240
end

function getOpposingEnemyMonForPlayerBattler(battleMons, playerBattler)
 if not battleMons then
  return nil
 end

 local preferredEnemyBattler = (playerBattler == 2) and 3 or 1
 local fallbackEnemyBattler = (preferredEnemyBattler == 1) and 3 or 1
 local preferred = battleMons[preferredEnemyBattler + 1]
 local fallback = battleMons[fallbackEnemyBattler + 1]

 if preferred and preferred.side == "enemy" and (preferred.species or 0) > 0 then
  return preferred
 end
 if fallback and fallback.side == "enemy" and (fallback.species or 0) > 0 then
  return fallback
 end

 for i = 1, table.getn(battleMons) do
  local mon = battleMons[i]
  if mon and mon.side == "enemy" and (mon.species or 0) > 0 then
   return mon
  end
 end

 return preferred or fallback
end

function getOpposingPlayerMonForEnemyBattler(battleMons, enemyBattler)
 if not battleMons then
  return nil
 end

 local preferredPlayerBattler = (enemyBattler == 3) and 2 or 0
 local fallbackPlayerBattler = (preferredPlayerBattler == 0) and 2 or 0
 local preferred = battleMons[preferredPlayerBattler + 1]
 local fallback = battleMons[fallbackPlayerBattler + 1]

 if preferred and preferred.side == "player" and (preferred.species or 0) > 0 then
  return preferred
 end
 if fallback and fallback.side == "player" and (fallback.species or 0) > 0 then
  return fallback
 end

 for i = 1, table.getn(battleMons) do
  local mon = battleMons[i]
  if mon and mon.side == "player" and (mon.species or 0) > 0 then
   return mon
  end
 end

 return preferred or fallback
end

function getResidualStatusMoveName(beforeMon, afterMon)
 local statusId = nil

 if afterMon and afterMon.status and afterMon.status > 0 then
  statusId = afterMon.status
 elseif beforeMon and beforeMon.status and beforeMon.status > 0 then
  statusId = beforeMon.status
 end

 if statusId ~= nil then
  return string.format("status-%d", statusId)
 end

 return "status"
end

function emitResidualPlayerFaintAiKoEvents(battleCtxAddr, battleMons)
 local prevMons = battleLogState.lastBattleMonsSnapshot
 local pidAddr = read32Bit(pidPointerAddr)

 if not prevMons or not battleMons then
  battleLogState.lastBattleMonsSnapshot = battleMons
  return
 end

 for i = 1, table.getn(battleMons) do
  local beforeMon = prevMons[i]
  local afterMon = battleMons[i]
  local beforeHP = beforeMon and beforeMon.curHP or 0
  local afterHP = afterMon and afterMon.curHP or 0
  local targetMon = afterMon or beforeMon

  if targetMon and targetMon.side == "player" and beforeHP > 0 and afterHP == 0 then
   local enemyMon = getOpposingEnemyMonForPlayerBattler(battleMons, targetMon.battler)
   local enemyBattler = (enemyMon and enemyMon.battler) or 1
   local enemyPokemonPid = getEnemyBattlerPidByBattler(pidAddr, battleCtxAddr, enemyBattler)
   local opposingPokemonName = (enemyMon and enemyMon.speciesName) or "None"

   emitAiKoEventIfNew(battleLogState.derivedTurnIndex + 1,
                      targetMon.speciesName or "None",
                      opposingPokemonName,
                      enemyPokemonPid,
                      targetMon.battler)
  end
 end

 battleLogState.lastBattleMonsSnapshot = battleMons
end

function emitResidualEnemyFaintPlayerKoEvents(battleCtxAddr, battleMons)
 local prevMons = battleLogState.lastBattleMonsSnapshot
 local pidAddr = read32Bit(pidPointerAddr)

 if not prevMons or not battleMons then
  return
 end

 for i = 1, table.getn(battleMons) do
  local beforeMon = prevMons[i]
  local afterMon = battleMons[i]
  local beforeHP = beforeMon and beforeMon.curHP or 0
  local afterHP = afterMon and afterMon.curHP or 0
  local targetMon = afterMon or beforeMon

  if targetMon and targetMon.side == "enemy" and beforeHP > 0 and afterHP == 0 then
   local playerMon = getOpposingPlayerMonForEnemyBattler(battleMons, targetMon.battler)
   local enemyPokemonPid = getEnemyBattlerPidByBattler(pidAddr, battleCtxAddr, targetMon.battler)

   emitPlayerKoEventIfNew(battleLogState.derivedTurnIndex + 1,
                          (playerMon and playerMon.speciesName) or "None",
                          targetMon.speciesName or "None",
                          getResidualStatusMoveName(beforeMon, afterMon),
                          enemyPokemonPid,
                          targetMon.battler)
  end
 end
end


-- <<< END 06_party_editors.lua

-- >>> BEGIN 07_ui_overlays.lua
-- Module Index: 07_ui_overlays
-- Owns: status text/indicators, AI intent overlay, overlay hotkey toggles, battle snapshot/dump UI helpers.
-- Note: some non-overlay display helpers remain here temporarily until final pass.

function isAiIntentOverlayTogglePressed(key)
 local hotkey = tostring(aiIntentOverlayToggleHotkey or "y")
 local lower = string.lower(hotkey)
 local upper = string.upper(hotkey)
 return (key[lower] or key[upper]) and true or false
end

function isAiIntentOverlayTogglePressedPrev(prevKey)
 local hotkey = tostring(aiIntentOverlayToggleHotkey or "y")
 local lower = string.lower(hotkey)
 local upper = string.upper(hotkey)
 return (prevKey[lower] or prevKey[upper]) and true or false
end

function updateDumpStatusText()
 if dumpStatusFrames > 0 then
  dumpStatusFrames = dumpStatusFrames - 1
  gui.box(1, 142, 254, 153, "#0000007F", "#0000007F")
  gui.text(2, 144, dumpStatusText)
 end
end

function toggleAiIntentOverlay()
 aiIntentOverlayState.enabled = not aiIntentOverlayState.enabled
 dumpStatusText = aiIntentOverlayState.enabled and "AI intent overlay ON" or "AI intent overlay OFF"
 dumpStatusFrames = 180
end

function drawAutoLogBattleOffIndicator()
 if battleLogConfig and battleLogConfig.autoStartOnBattle then
  return
 end

 gui.box(138, 180, 254, 191, "#0000007F", "#0000007F")
 gui.text(140, 182, "Auto Log Battle Off")
end
function getAiIntentOverlaySnapshot(battleSysAddr, battleCtxAddr)
 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  return nil
 end

 local battleType = isMainRAMPointer(battleSysAddr) and read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or 0
 if battleType == nil or battleType == 0 then
  return nil
 end

 local command = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandOffset) or 0
 local commandNext = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandNextOffset) or 0
 local moveSelected = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSelectedOffset, 4)
 local moveSlot = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSlotOffset, 4)
 local battlerActions = readBattlerActionsMatrix(battleCtxAddr)
 local rows = {}

 for _, battler in ipairs({1, 3}) do
  local mon = readBattleMonSummary(battleCtxAddr, battler)
  local species = mon and (mon.species or 0) or 0
  if species ~= nil and species > 0 and species <= 493 then
   local moveId = moveSelected[battler + 1] or 0
   local slot = moveSlot[battler + 1] or 0
   local actionRow = battlerActions[battler + 1] or {}
   local pickCommand = actionRow[1] or 0
   local available = (moveId ~= nil and moveId > 0)
   rows[#rows + 1] = {
    battler = battler,
    enemyIndex = (battler == 1) and 1 or 2,
    speciesName = mon.speciesName or "Unknown",
    moveId = moveId,
    moveName = available and getMoveNameFromId(moveId) or nil,
    moveSlot = slot,
    pickCommand = pickCommand,
    available = available
   }
  end
 end

 return {
  battleType = battleType,
  command = command,
  commandNext = commandNext,
  rows = rows
 }
end

function drawAiIntentOverlay()
 if not allowAiIntentOverlay or not (aiIntentOverlayState and aiIntentOverlayState.enabled) then
  return
 end

 local battleSysAddr = battleLogConfig and battleLogConfig.battleSystemAddr or nil
 local battleCtxAddr = battleLogConfig and battleLogConfig.battleContextAddr or nil
 local snapshot = getAiIntentOverlaySnapshot(battleSysAddr, battleCtxAddr)
 if not snapshot or not snapshot.rows or #snapshot.rows == 0 then
  return
 end

 local x1, y1 = 150, 2
 local lineHeight = 11
 local boxHeight = 14 + (#snapshot.rows * lineHeight) + 4
 local y2 = y1 + boxHeight

 gui.box(x1, y1, 254, y2, "#000000A0", "#000000A0")
 gui.text(x1 + 2, y1 + 2, "AI Intent")

 for i = 1, #snapshot.rows do
  local row = snapshot.rows[i]
  local moveLabel = row.available and tostring(row.moveName or "Unknown") or "Unknown"
  gui.text(x1 + 2, y1 + 2 + (i * lineHeight),
           string.format("E%d: %s", row.enemyIndex or i, moveLabel))
 end
end

function pollBattleLog()
 if not battleLogState.enabled then
  return
 end

 battleLogState.frameCounter = battleLogState.frameCounter + 1

 local battleCtxAddr = battleLogConfig.battleContextAddr
 local battleSysAddr = battleLogConfig.battleSystemAddr

 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  if battleLogState.frameCounter - (battleLogState.lastAutoAcquireFrame or -999999) >= 180 then
   battleLogState.lastAutoAcquireFrame = battleLogState.frameCounter
   autoSelectBattleSystemCandidate(true)
   battleCtxAddr = battleLogConfig.battleContextAddr
   battleSysAddr = battleLogConfig.battleSystemAddr
  end

  if isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
   writeBattleLogRecord("status",
                        string.format("\"message\":\"battleCtx auto-acquired\",\"battleSys\":%s,\"battleCtx\":%s",
                                      jsonNumberOrNull(battleSysAddr),
                                      jsonNumberOrNull(battleCtxAddr)))
  else
  if battleLogState.sawValidBattleCtx then
   writeBattleResultRecord(battleSysAddr, "context_lost")
   stopBattleLogFile(true)
   return
  end
  battleLogState.activeMoveExec = nil
  battleLogState.lastBattleMonsSnapshot = nil
  if math.fmod(battleLogState.frameCounter, 60) == 1 then
   writeBattleLogRecord("status", "\"message\":\"battleCtx unavailable or invalid\"")
  end

  return
  end
 end

 battleLogState.sawValidBattleCtx = true
 maybeRunBattleCtxPointerProbePass()

 local command = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandOffset)
 local commandNext = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandNextOffset)
 local currentBattleMons = readAllBattleMonSummaries(battleCtxAddr)
 local moveSelected = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSelectedOffset, 4)
 local moveSlot = readBattleContextU16Array(battleCtxAddr, battleContextKnownOffsets.moveSlotOffset, 4)
 local selectedPartySlot = readBattleContextU8Array(battleCtxAddr, battleContextKnownOffsets.selectedPartySlotOffset, 4)
 local moveSelectedSignature = getMoveArraySignature(moveSelected)
 local moveSlotSignature = getMoveArraySignature(moveSlot)
 local selectedPartySlotSignature = getMoveArraySignature(selectedPartySlot)
 local movesChanged = (moveSelectedSignature ~= battleLogState.lastMoveSelectedSignature) or (moveSlotSignature ~= battleLogState.lastMoveSlotSignature)
 local commandChanged = (command ~= battleLogState.lastCommand or commandNext ~= battleLogState.lastCommandNext)

 emitResidualPlayerFaintAiKoEvents(battleCtxAddr, currentBattleMons)
 emitResidualEnemyFaintPlayerKoEvents(battleCtxAddr, currentBattleMons)

 if commandChanged then
  writeBattleLogRecord("battlectx_command", string.format("\"battleSys\":%s,\"battleCtx\":%s,\"command\":%d,\"commandNext\":%d,\"curStates\":[%d,%d,%d,%d],\"nextStates\":[%d,%d,%d,%d]",
                       jsonNumberOrNull(battleSysAddr),
                       jsonNumberOrNull(battleCtxAddr),
                       command,
                       commandNext,
                       read8Bit(battleCtxAddr + 0x0), read8Bit(battleCtxAddr + 0x1), read8Bit(battleCtxAddr + 0x2), read8Bit(battleCtxAddr + 0x3),
                       read8Bit(battleCtxAddr + 0x4), read8Bit(battleCtxAddr + 0x5), read8Bit(battleCtxAddr + 0x6), read8Bit(battleCtxAddr + 0x7)))
  battleLogState.lastCommand = command
  battleLogState.lastCommandNext = commandNext
 end

 local inSelectionPhase = (command == battleControl.INIT_COMMAND_SELECTION or command == battleControl.COMMAND_SELECTION_INPUT
                       or commandNext == battleControl.INIT_COMMAND_SELECTION or commandNext == battleControl.COMMAND_SELECTION_INPUT)
 local enteringExecution = (command == battleControl.CALC_TURN_ORDER or commandNext == battleControl.CALC_TURN_ORDER)
 local atTurnEnd = (command == battleControl.TURN_END)
 local backToSelection = (command == battleControl.INIT_COMMAND_SELECTION and commandChanged)
 local battleEnding = (command == battleControl.FIGHT_END or command == battleControl.RESULT or command == battleControl.SCREEN_WIPE
                   or commandNext == battleControl.FIGHT_END or commandNext == battleControl.RESULT or commandNext == battleControl.SCREEN_WIPE)

 local pendingSnapshot = battleLogState.pendingTurnIntent
 local pendingMoveSelectedSignature = nil
 local pendingMoveSlotSignature = nil
 local pendingSelectedPartySlotSignature = nil
 local newTurnBeforeMoveBoundary = false

 if pendingSnapshot then
  pendingMoveSelectedSignature = getMoveArraySignature(pendingSnapshot.moveSelected or {0, 0, 0, 0})
  pendingMoveSlotSignature = getMoveArraySignature(pendingSnapshot.moveSlot or {0, 0, 0, 0})
  pendingSelectedPartySlotSignature = getMoveArraySignature(pendingSnapshot.selectedPartySlot or {0, 0, 0, 0})
 end

 if battleLogState.turnPhase == "turn_executing"
    and battleLogState.pendingTurnIntentWritten
    and pendingSnapshot ~= nil
    and battleLogState.activeMoveExec == nil
    and command == battleControl.BEFORE_MOVE
    and ((moveSelectedSignature ~= pendingMoveSelectedSignature)
      or (moveSlotSignature ~= pendingMoveSlotSignature)
      or (selectedPartySlotSignature ~= pendingSelectedPartySlotSignature)) then
  newTurnBeforeMoveBoundary = true
 end

 if newTurnBeforeMoveBoundary then
  commitDerivedTurn(battleSysAddr, battleCtxAddr, command, commandNext, "new_turn_before_move")
  battleLogState.turnPhase = "turn_executing"
  battleLogState.pendingTurnIntent = nil
  battleLogState.pendingTurnIntentWritten = false
 end

 updateMoveExecutionLogger(battleSysAddr, battleCtxAddr, command, commandNext, commandChanged, battleEnding, atTurnEnd, backToSelection)

 if inSelectionPhase and battleLogState.turnPhase == "idle" then
  battleLogState.turnPhase = "collecting_intents"
  battleLogState.pendingTurnIntent = nil
  battleLogState.pendingTurnIntentWritten = false
  writeBattleLogRecord("turn_phase", "\"phase\":\"collecting_intents\"")
 end

 if (battleLogState.turnPhase == "collecting_intents" or battleLogState.turnPhase == "turn_executing") and enteringExecution then
  battleLogState.turnPhase = "turn_executing"
 end

 if battleLogState.turnPhase == "turn_executing" and (not battleLogState.pendingTurnIntentWritten) and command ~= battleControl.CALC_TURN_ORDER then
  battleLogState.pendingTurnIntent = buildTurnIntentSnapshot(battleSysAddr, battleCtxAddr, command, commandNext)
  writeTurnIntentRecord(battleLogState.pendingTurnIntent, battleSysAddr, battleCtxAddr)
  battleLogState.pendingTurnIntentWritten = true
 end

 if battleLogState.turnPhase == "turn_executing" and atTurnEnd and commandChanged then
  commitDerivedTurn(battleSysAddr, battleCtxAddr, command, commandNext, "turn_end")
 end

 if battleLogState.turnPhase == "turn_executing" and backToSelection then
  commitDerivedTurn(battleSysAddr, battleCtxAddr, command, commandNext, "back_to_selection")
 end

 if battleLogState.turnPhase == "turn_executing" and battleEnding and commandChanged then
  commitDerivedTurn(battleSysAddr, battleCtxAddr, command, commandNext, "battle_end")
  stopBattleLogFile(true)
  return
 end

 if battleLogState.turnPhase == "turn_commit" and backToSelection then
  battleLogState.turnPhase = "collecting_intents"
  battleLogState.pendingTurnIntent = nil
  battleLogState.pendingTurnIntentWritten = false
  writeBattleLogRecord("turn_phase", "\"phase\":\"collecting_intents\"")
 end

 if commandChanged or movesChanged then
  writeBattleActionSnapshotRecord(battleSysAddr, battleCtxAddr, command, commandNext)
 end
end

function handleBattleToolsInput(pidAddr)
 local key = input.get()
 local yPressed = isAiIntentOverlayTogglePressed(key)
 local yPrev = isAiIntentOverlayTogglePressedPrev(prevKeyBattleTools or {})
 if yPressed and not yPrev then
  toggleAiIntentOverlay()
  prevKeyBattleTools = key
  return
 end
 local statusEditorConsumed = handlePartyStatusEditorInput(
  key,
  prevKeyBattleTools,
  pidAddr,
  battleLogConfig.battleSystemAddr,
  battleLogConfig.battleContextAddr,
  battleSystemLayout.battleTypeOffset)
 if statusEditorConsumed then
  prevKeyBattleTools = key
  return
 end
 local hpEditorConsumed = handlePartyHpEditorInput(
  key,
  prevKeyBattleTools,
  pidAddr,
  battleLogConfig.battleSystemAddr,
  battleLogConfig.battleContextAddr,
  battleSystemLayout.battleTypeOffset)
 if hpEditorConsumed then
  prevKeyBattleTools = key
  return
 end

 local qPressed = (key["q"] or key["Q"])
 local bPressed = (key["b"] or key["B"])
 local tPressed = (key["t"] or key["T"])
 local lPressed = (key["l"] or key["L"])
 local qPrev = (prevKeyBattleTools["q"] or prevKeyBattleTools["Q"])
 local bPrev = (prevKeyBattleTools["b"] or prevKeyBattleTools["B"])
 local tPrev = (prevKeyBattleTools["t"] or prevKeyBattleTools["T"])
 local lPrev = (prevKeyBattleTools["l"] or prevKeyBattleTools["L"])

 if lPressed and not lPrev then
  battleLogConfig.autoStartOnBattle = not not (not battleLogConfig.autoStartOnBattle)
  if battleLogConfig.autoStartOnBattle then
   print("Auto Log Battle ON, Searching for active battle every 60 frames")
  else
   print("Auto Log Battle OFF")
  end
 elseif tPressed and not tPrev then
  dumpTrainerBattleSnapshot()
 elseif bPressed and not bPrev then
  local boxFileName = dumpPlayerPartyAndBoxes()
  if boxFileName then
   if copyBoxDumpJsonToClipboard then
    local copied, copyErr = copyFileContentsToClipboard(boxFileName)
    if copied then
     dumpStatusText = "Box 1-4 Copy Queued!"
     dumpStatusFrames = 240
     print("Queued box dump JSON clipboard copy: "..boxFileName)
    else
     dumpStatusText = "Box dump saved (clipboard failed)"
     dumpStatusFrames = 240
     print("Box dump clipboard copy failed: "..tostring(copyErr))
    end
   end
  end
 elseif allowManualLogToggleHotkey and qPressed and not qPrev then
  if battleLogState.enabled then
   stopBattleLogFile(true)
  else
   startBattleLogFile()
  end
 elseif (not battleLoggingOnlyMode) then
  local enemyAddr = pidAddr + 0x58E3C + koreanOffset
  local wPressed = (key["w"] or key["W"])
  local ePressed = (key["e"] or key["E"])
  local rPressed = (key["r"] or key["R"])
  local wPrev = (prevKeyBattleTools["w"] or prevKeyBattleTools["W"])
  local ePrev = (prevKeyBattleTools["e"] or prevKeyBattleTools["E"])
  local rPrev = (prevKeyBattleTools["r"] or prevKeyBattleTools["R"])

  if wPressed and not wPrev then
   dumpBattleSystemCandidates()
  elseif ePressed and not ePrev then
   writeBattleContextDebugSnapshot()
  elseif rPressed and not rPrev then
   writeBattleLogRecord("enemy_party_snapshot", string.format("\"enemyAddr\":%d", enemyAddr))
   logEnemyTrainerParty(enemyAddr)
  end
 end

 prevKeyBattleTools = key

 if not battleLoggingOnlyMode and not (captureMinimalUI and mode[index] == "Capture") then
  if allowManualLogToggleHotkey then
   gui.text(152, 138, "Q/q - Toggle log")
   gui.text(152, 149, "W/w - Scan battleSys")
   gui.text(152, 160, "B/b - Dump boxes")
   gui.text(152, 171, "T/t - Snapshot")
   gui.text(152, 182, "E/e - Dump battleCtx")
  else
   gui.text(152, 138, "W/w - Scan battleSys")
   gui.text(152, 149, "B/b - Dump boxes")
   gui.text(152, 160, "T/t - Snapshot")
   gui.text(152, 171, "E/e - Dump battleCtx")
  end
 end
end

function buildPokemonDumpJson(mon, extraFieldsJson)
 local movesJson = {}
 for i = 1, 4 do
  movesJson[i] = jsonStringOrNull(mon.moves[i])
 end

 local extra = extraFieldsJson and (extraFieldsJson .. ",") or ""
 return string.format("{%s\"species\":%s,\"moves\":[%s],\"ability\":%s,\"nature\":%s,\"heldItem\":%s}",
                      extra,
                      jsonStringOrNull(mon.species),
                      table.concat(movesJson, ","),
                      jsonStringOrNull(mon.ability),
                      jsonStringOrNull(mon.nature),
                      jsonStringOrNull(mon.heldItem))
end

function buildMemoryBytesHexJsonString(startAddr, size)
 if startAddr == nil or startAddr == 0 or size == nil or size <= 0 then
  return "\"\""
 end

 local hex = {}
 for i = 0, size - 1 do
  hex[#hex + 1] = string.format("%02X", read8Bit(startAddr + i) or 0)
 end
 return "\"" .. table.concat(hex, "") .. "\""
end

function buildPlayerPartySnapshotJson(pidAddr)
 if pidAddr == nil or pidAddr == 0 then
  return "[]"
 end

 local partyCount = read8Bit(pidAddr + 0xD090)
 if partyCount == nil or partyCount < 0 then
  partyCount = 0
 elseif partyCount > 6 then
  partyCount = 6
 end

 local partyEntries = {}
 local partyBase = pidAddr + 0xD094

 for slot = 0, partyCount - 1 do
  local mon = decodePokemonStorageSummary(partyBase + (slot * 0xEC))
  if mon then
   partyEntries[#partyEntries + 1] = buildPokemonDumpJson(mon, string.format("\"slot\":%d", slot + 1))
  end
 end

 return "["..table.concat(partyEntries, ",").."]"
end

function buildPlayerBoxSpeciesIdsJson(pidAddr)
 if pidAddr == nil or pidAddr == 0 then
  return "[]"
 end

 local boxBase = pidAddr + 0x19F24
 local totalBoxes = 18
 local slotsPerBox = 30
 local maxSlots = 120
 local scannedSlots = 0
 local speciesIds = {}

 for boxIndex = 0, totalBoxes - 1 do
  local boxStart = boxBase + (boxIndex * 0xFF0)
  for slot = 0, slotsPerBox - 1 do
   if scannedSlots >= maxSlots then
    break
   end
   scannedSlots = scannedSlots + 1
   local mon = decodePokemonStorageSummary(boxStart + (slot * 0x88))
   if mon and mon.speciesId and mon.speciesId > 0 then
    speciesIds[#speciesIds + 1] = tostring(mon.speciesId)
   end
  end
  if scannedSlots >= maxSlots then
   break
  end
 end

 return "["..table.concat(speciesIds, ",").."]"
end

function dumpPlayerPartyAndBoxes()
 local pidAddr = read32Bit(pidPointerAddr)

 if pidAddr == nil or pidAddr == 0 then
  dumpStatusText = "Box dump failed: pidAddr unavailable"
  dumpStatusFrames = 240
  return nil
 end

 local trainerTID, trainerSID = getTrainerIDs()
 local fileName = string.format("%s/Box-%d.json", getOutputDumpsDir(), trainerTID or 0)
 local outFile = io.open(fileName, "w")

 if not outFile then
  dumpStatusText = "Box dump failed: could not open file"
  dumpStatusFrames = 240
  return nil
 end

 local partyCount = read8Bit(pidAddr + 0xD090)
 if partyCount < 0 then
  partyCount = 0
 elseif partyCount > 6 then
  partyCount = 6
 end

 local partyBase = pidAddr + 0xD094
 local partyStructSize = 0xEC
 local partyBytesSize = partyCount * partyStructSize
 local partyBytesJson = buildMemoryBytesHexJsonString(partyBase, partyBytesSize)

 local boxBase = pidAddr + 0x19F24
 local totalBoxes = 18
 local slotsPerBox = 30
 local maxBoxSnapshotSlots = 120
 local boxStructSize = 0x88
 local boxBytesSize = maxBoxSnapshotSlots * boxStructSize
 local boxBytesJson = buildMemoryBytesHexJsonString(boxBase, boxBytesSize)

 local jsonParts = {
  "{\n",
  string.format("  \"trainerId\": %d,\n", trainerTID or 0),
  string.format("  \"secretId\": %d,\n", trainerSID or 0),
  string.format("  \"partyCount\": %d,\n", partyCount),
  string.format("  \"partyStructSize\": %d,\n", partyStructSize),
  string.format("  \"boxStructSize\": %d,\n", boxStructSize),
  string.format("  \"boxSlotsDumped\": %d,\n", maxBoxSnapshotSlots),
  "  \"partyEncoding\": \"hex\",\n",
  "  \"boxesEncoding\": \"hex\",\n",
  "  \"party\": ",
  partyBytesJson,
  ",\n",
  "  \"boxes\": ",
  boxBytesJson,
  "\n}\n"
 }
 local boxJsonText = table.concat(jsonParts, "")
 outFile:write(boxJsonText)
 outFile:close()

 dumpStatusText = "Box Updated"
 dumpStatusFrames = 240
 print("Box Updated")
 if updateMasterTrainerFileOnBoxDump then
  maybeUpdateMasterTrainerFile(trainerTID)
 end
 return fileName, boxJsonText
end

function getBattleStatusName(statusValue)
 local status = statusValue or 0

 if band(status, 0x7) ~= 0 then
  return "SLP"
 elseif band(status, 0x8) ~= 0 then
  return "PSN"
 elseif band(status, 0x10) ~= 0 then
  return "BRN"
 elseif band(status, 0x20) ~= 0 then
  return "FRZ"
 elseif band(status, 0x40) ~= 0 then
  return "PAR"
 elseif band(status, 0x80) ~= 0 then
  return "TOX"
 end

 return "None"
end

function readBattleMonDetailedSummary(battleCtxAddr, battler)
 local mon = readBattleMonSummary(battleCtxAddr, battler)
 local monAddr = mon.addr

 mon.movePPs = {
  read8Bit(monAddr + 0x14),
  read8Bit(monAddr + 0x15),
  read8Bit(monAddr + 0x16),
  read8Bit(monAddr + 0x17)}
 mon.rawBattleStats = {
  attack = read32Bit(monAddr + 0x54),
  defense = read32Bit(monAddr + 0x58),
  speed = read32Bit(monAddr + 0x5C),
  spAttack = read32Bit(monAddr + 0x60),
  spDefense = read32Bit(monAddr + 0x64)}

 return mon
end

function tryDecodeActiveBattlerPartyMon(battleSysAddr, battleCtxAddr, battler, pidAddr)
 local selectedPartySlot = nil
 local partyPtr = nil
 local monAddr = nil
 local fallbackEnemyAddr = nil

 if isMainRAMPointer(battleCtxAddr) then
  selectedPartySlot = read8Bit(battleCtxAddr + battleContextKnownOffsets.selectedPartySlotOffset + battler)
  if selectedPartySlot ~= nil and (selectedPartySlot < 0 or selectedPartySlot > 5) then
   selectedPartySlot = nil
  end
 end

 if isMainRAMPointer(battleSysAddr) then
  partyPtr = read32Bit(battleSysAddr + battleSystemLayout.partiesOffset + (battler * 4))
 end

 if isMainRAMPointer(partyPtr) then
  local slot = selectedPartySlot or 0
  monAddr = partyPtr + 0x8 + (slot * 0xEC)
  return decodePokemonStorageSummary(monAddr), slot + 1, monAddr
 end

 if math.fmod(battler, 2) == 0 then
  local slot = selectedPartySlot or 0
  monAddr = pidAddr + 0xD094 + (slot * 0xEC)
  return decodePokemonStorageSummary(monAddr), slot + 1, monAddr
 end

 fallbackEnemyAddr = pidAddr + 0x58E3C + koreanOffset
 local enemySlot = selectedPartySlot
 if enemySlot == nil then
  enemySlot = (battler == 3) and 1 or 0
 end
 monAddr = fallbackEnemyAddr + (enemySlot * 0xEC)
 return decodePokemonStorageSummary(monAddr), enemySlot + 1, monAddr
end

function buildBattleSnapshotMonJson(battleMon, storageMon, activePartySlot, storageAddr)
 local movesJson = {}
 local movePPsJson = {}
 local moveNames = nil

 if storageMon and storageMon.moves then
  moveNames = storageMon.moves
 else
  moveNames = {
   getMoveNameFromId(battleMon.moves[1]),
   getMoveNameFromId(battleMon.moves[2]),
   getMoveNameFromId(battleMon.moves[3]),
   getMoveNameFromId(battleMon.moves[4])}
 end

 for i = 1, 4 do
  movesJson[i] = jsonStringOrNull(moveNames[i])
  movePPsJson[i] = tostring((battleMon.movePPs and battleMon.movePPs[i]) or 0)
 end

 return string.format("{\"battler\":%d,\"side\":%s,\"activePartySlot\":%d,\"battleMonAddr\":%d,\"partyMonAddr\":%s,\"pid\":%s,\"species\":%s,\"currentHp\":%d,\"moves\":[%s],\"ability\":%s,\"nature\":%s,\"heldItem\":%s,\"status\":%s,\"statusRaw\":%d,\"movePPs\":[%s],\"rawBattleStats\":{\"attack\":%d,\"defense\":%d,\"speed\":%d,\"spAttack\":%d,\"spDefense\":%d}}",
                      battleMon.battler,
                      jsonStringOrNull(battleMon.side),
                      activePartySlot or 0,
                      battleMon.addr or 0,
                      jsonNumberOrNull(storageAddr),
                      jsonNumberOrNull(storageMon and storageMon.pid or nil),
                      jsonStringOrNull((storageMon and storageMon.species) or battleMon.speciesName),
                      battleMon.curHP or 0,
                      table.concat(movesJson, ","),
                      jsonStringOrNull(storageMon and storageMon.ability or nil),
                      jsonStringOrNull(storageMon and storageMon.nature or nil),
                      jsonStringOrNull(storageMon and storageMon.heldItem or nil),
                      jsonStringOrNull(getBattleStatusName(battleMon.status)),
                      battleMon.status or 0,
                      table.concat(movePPsJson, ","),
                      (battleMon.rawBattleStats and battleMon.rawBattleStats.attack) or 0,
                      (battleMon.rawBattleStats and battleMon.rawBattleStats.defense) or 0,
                      (battleMon.rawBattleStats and battleMon.rawBattleStats.speed) or 0,
                      (battleMon.rawBattleStats and battleMon.rawBattleStats.spAttack) or 0,
                      (battleMon.rawBattleStats and battleMon.rawBattleStats.spDefense) or 0)
end


-- <<< END 07_ui_overlays.lua

-- >>> BEGIN 08_debug_probes.lua
-- Module Index: 08_debug_probes
-- Owns: pointer probe configs/state, BattleCtx pointer-source probe, anchor watch debug, diagnostic dump helpers.
-- Keep debug-only instrumentation here to avoid polluting hot-path modules.

local battlePointerProbeConfig = {
 enabled = false,
 dedupeSameSignature = true,
 printConsoleSummary = false}

local battlePointerProbeState = {
 nextRunId = 1,
 scriptSessionId = 1,
 templateInitialized = false,
 lastSignature = nil}

local battleCtxPointerProbeConfig = {
 enabled = false,
 scanForBattleCtx = true,
 scanForBattleSys = true,
 maxPassesPerBattle = 2,
 passFrames = {0, 2},
 scanStart = 0x02000000,
 scanEnd = 0x02400000,
 step = 4,
 logNearbyWords = true,
 nearbyWordRadius = 0x10,
 dedupeHitsWithinBattle = true,
 printConsoleSummary = false}

local battleCtxPointerProbeState = {
 currentBattleKey = nil,
 battleStartFrameCounter = nil,
 completedPasses = 0,
 nextPassIndex = 1,
 prevPassHitKeys = nil,
 seenHitKeys = nil,
 battleSysAddr = nil,
 battleCtxAddr = nil,
 battleType = nil,
 trainerId = nil,
 active = false}

function getBattlePointerProbeFileName(trainerId)
 return string.format("%s/BattleSystemProbe_%d.jsonl", getOutputDumpsDir(), trainerId or 0)
end

function getBattleCtxPointerProbeFileName(trainerId)
 return string.format("%s/BattleCtxPointerProbe_%d.jsonl", getOutputDumpsDir(), trainerId or 0)
end

function getBattlePointerProbeTemplateFileName()
 return string.format("%s/BattleSystemDebuggerRuns_TEMPLATE.csv", getOutputDumpsDir())
end

function getBattleKindLabelFromType(battleType)
 if battleType == nil or battleType == 0 then
  return "none"
 end

 if isTrainerBattleType and isTrainerBattleType(battleType) then
  return "trainer"
 end

 return "wild_or_other"
end

function resetBattleCtxPointerProbeState()
 battleCtxPointerProbeState.currentBattleKey = nil
 battleCtxPointerProbeState.battleStartFrameCounter = nil
 battleCtxPointerProbeState.completedPasses = 0
 battleCtxPointerProbeState.nextPassIndex = 1
 battleCtxPointerProbeState.prevPassHitKeys = {}
 battleCtxPointerProbeState.seenHitKeys = {}
 battleCtxPointerProbeState.battleSysAddr = nil
 battleCtxPointerProbeState.battleCtxAddr = nil
 battleCtxPointerProbeState.battleType = nil
 battleCtxPointerProbeState.trainerId = nil
 battleCtxPointerProbeState.active = false
end

resetBattleCtxPointerProbeState()

function buildBattleCtxPointerProbeBattleKey(battleSysAddr, battleCtxAddr, trainerId)
 return table.concat({
  tostring(battleSysAddr or 0),
  tostring(battleCtxAddr or 0),
  tostring(trainerId or 0)}, "|")
end

function initBattleCtxPointerProbeForBattle(battleSysAddr, battleCtxAddr, battleType)
 if not (battleCtxPointerProbeConfig and battleCtxPointerProbeConfig.enabled) then
  return false
 end
 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  return false
 end

 local trainerId = getPrimaryEnemyTrainerId(battleSysAddr)
 local battleKey = buildBattleCtxPointerProbeBattleKey(battleSysAddr, battleCtxAddr, trainerId)
 if battleCtxPointerProbeState.active and battleCtxPointerProbeState.currentBattleKey == battleKey then
  return false
 end

 resetBattleCtxPointerProbeState()
 battleCtxPointerProbeState.currentBattleKey = battleKey
 battleCtxPointerProbeState.battleStartFrameCounter = tonumber((battleLogState and battleLogState.frameCounter) or 0) or 0
 battleCtxPointerProbeState.completedPasses = 0
 battleCtxPointerProbeState.nextPassIndex = 1
 battleCtxPointerProbeState.prevPassHitKeys = {}
 battleCtxPointerProbeState.seenHitKeys = {}
 battleCtxPointerProbeState.battleSysAddr = battleSysAddr
 battleCtxPointerProbeState.battleCtxAddr = battleCtxAddr
 battleCtxPointerProbeState.battleType = battleType
 battleCtxPointerProbeState.trainerId = trainerId
 battleCtxPointerProbeState.active = true
 return true
end

function buildBattleCtxPointerProbeNearbyWordsJson(centerAddr)
 if not (battleCtxPointerProbeConfig and battleCtxPointerProbeConfig.logNearbyWords) then
  return "null"
 end
 local radius = tonumber(battleCtxPointerProbeConfig.nearbyWordRadius) or 0x10
 radius = floor(radius)
 if radius < 0 then
  radius = 0x10
 end
 radius = radius - math.fmod(radius, 4)
 local words = {}
 for rel = -radius, radius, 4 do
  local addr = centerAddr + rel
  if addr >= 0x02000000 and addr < 0x02400000 then
   words[#words + 1] = string.format("{\"off\":%d,\"addr\":%s,\"addrHex\":%s,\"value\":%s,\"valueHex\":%s}",
    rel,
    jsonNumberOrNull(addr),
    jsonStringOrNull(formatHex8OrNil(addr)),
    jsonNumberOrNull(read32Bit(addr)),
    jsonStringOrNull(formatHex8OrNil(read32Bit(addr))))
  end
 end
 return "["..table.concat(words, ",").."]"
end

function classifyBattleCtxPointerProbeHit(probeKind, hitAddr, battleSysAddr, battleCtxAddr)
 local classification = "mainram_pointer_copy"
 local rank = 10
 local step = tonumber(battleCtxPointerProbeConfig and battleCtxPointerProbeConfig.step) or 4
 if step < 1 then
  step = 4
 end

 if (hitAddr == nil) or (math.fmod(hitAddr, step) ~= 0) then
  return "invalid_or_unaligned", 99
 end

 if probeKind == "battleCtx" and isMainRAMPointer(battleSysAddr) and hitAddr == (battleSysAddr + battleSystemLayout.battleCtxOffset) then
  return "battleSys.battleCtx_field_exact", 1
 end

 if probeKind == "battleSys" and isMainRAMPointer(battleCtxAddr) and hitAddr >= (battleCtxAddr - 0x100) and hitAddr <= (battleCtxAddr + 0x100) then
  classification = "battleCtx_nearby_field"
  rank = 2
 elseif isMainRAMPointer(battleSysAddr) and hitAddr >= (battleSysAddr - 0x100) and hitAddr <= (battleSysAddr + 0x100) then
  classification = "battleSys_nearby_field"
  rank = 3
 end

 return classification, rank
end

function writeBattleCtxPointerProbeHitRecord(record)
 local trainerTID = select(1, getTrainerIDs()) or 0
 local fileName = getBattleCtxPointerProbeFileName(trainerTID)
 local payload = string.format(
  "\"type\":\"battlectx_pointer_probe_hit\",\"probeKind\":%s,\"battleSys\":%s,\"battleCtx\":%s,\"battleType\":%s,\"trainerId\":%s,\"targetValue\":%s,\"targetValueHex\":%s,\"hitAddr\":%s,\"hitAddrHex\":%s,\"hitArm9Offset\":%s,\"hitArm9OffsetHex\":%s,\"hitValue\":%s,\"hitValueHex\":%s,\"passIndex\":%d,\"battleLogFrame\":%d,\"mainLoopTick\":%d,\"autoStartTick\":%d,\"classification\":%s,\"rank\":%d,\"deltaToBattleSys\":%s,\"deltaToBattleCtx\":%s,\"persistedFromPreviousPass\":%s,\"nearbyWords\":%s",
  jsonStringOrNull(record.probeKind),
  jsonNumberOrNull(record.battleSys),
  jsonNumberOrNull(record.battleCtx),
  jsonNumberOrNull(record.battleType),
  jsonNumberOrNull(record.trainerId),
  jsonNumberOrNull(record.targetValue),
  jsonStringOrNull(formatHex8OrNil(record.targetValue)),
  jsonNumberOrNull(record.hitAddr),
  jsonStringOrNull(formatHex8OrNil(record.hitAddr)),
  jsonNumberOrNull(record.hitArm9Offset),
  jsonStringOrNull(formatHex8OrNil(record.hitArm9Offset)),
  jsonNumberOrNull(record.hitValue),
  jsonStringOrNull(formatHex8OrNil(record.hitValue)),
  tonumber(record.passIndex or 0) or 0,
  tonumber(record.battleLogFrame or 0) or 0,
  tonumber((battleLogState and battleLogState.mainLoopTick) or 0) or 0,
  tonumber((battleLogState and battleLogState.autoStartTick) or 0) or 0,
  jsonStringOrNull(record.classification),
  tonumber(record.rank or 10) or 10,
  jsonNumberOrNull(record.deltaToBattleSys),
  jsonNumberOrNull(record.deltaToBattleCtx),
  (record.persistedFromPreviousPass and "true" or "false"),
  record.nearbyWordsJson or "null")
 return appendJsonLineToFile(fileName, "{"..payload.."}\n")
end

function scanMainRamForPointerValue(targetValue, probeKind, context)
 if targetValue == nil then
  return 0, {}
 end
 local cfg = battleCtxPointerProbeConfig or {}
 local scanStart = align4Up(tonumber(cfg.scanStart) or 0x02000000)
 local scanEnd = align4Down(tonumber(cfg.scanEnd) or 0x02400000)
 local step = floor(tonumber(cfg.step) or 4)
 if step < 1 then
  step = 4
 end
 if math.fmod(step, 4) ~= 0 then
  step = step + (4 - math.fmod(step, 4))
 end
 if scanStart == nil or scanEnd == nil or scanEnd <= scanStart then
  return 0, {}
 end

 local state = battleCtxPointerProbeState or {}
 local passIndex = tonumber(context and context.passIndex or 0) or 0
 local prevPassHits = state.prevPassHitKeys or {}
 local emitted = 0
 local currentHitKeys = {}

 for addr = scanStart, scanEnd - 4, step do
  local value = read32Bit(addr)
  if value == targetValue then
   currentHitKeys[string.format("%s|%08X", tostring(probeKind or "unknown"), addr)] = true
   local dedupeKey = string.format("%s|%s|%08X|%d",
    tostring(state.currentBattleKey or ""),
    tostring(probeKind or "unknown"),
    addr,
    passIndex)
   local allowEmit = true
   if cfg.dedupeHitsWithinBattle and state.seenHitKeys and state.seenHitKeys[dedupeKey] then
    allowEmit = false
   end

   if allowEmit then
    local classification, rank = classifyBattleCtxPointerProbeHit(probeKind, addr, state.battleSysAddr, state.battleCtxAddr)
    local prevKey = string.format("%s|%08X", tostring(probeKind or "unknown"), addr)
    local persisted = prevPassHits[prevKey] and true or false
    local hitArm9Offset = addr - 0x02000000
    local record = {
     probeKind = probeKind,
     battleSys = state.battleSysAddr,
     battleCtx = state.battleCtxAddr,
     battleType = state.battleType,
     trainerId = state.trainerId,
     targetValue = targetValue,
     hitAddr = addr,
     hitArm9Offset = hitArm9Offset,
     hitValue = value,
     passIndex = passIndex,
     battleLogFrame = tonumber((battleLogState and battleLogState.frameCounter) or 0) or 0,
     classification = classification,
     rank = rank,
     deltaToBattleSys = (state.battleSysAddr ~= nil) and (addr - state.battleSysAddr) or nil,
     deltaToBattleCtx = (state.battleCtxAddr ~= nil) and (addr - state.battleCtxAddr) or nil,
     persistedFromPreviousPass = persisted,
     nearbyWordsJson = buildBattleCtxPointerProbeNearbyWordsJson(addr)}
    writeBattleCtxPointerProbeHitRecord(record)
    state.seenHitKeys[dedupeKey] = true
    emitted = emitted + 1
   end
  end
 end

 return emitted, currentHitKeys
end

function maybeRunBattleCtxPointerProbePass()
 local cfg = battleCtxPointerProbeConfig or nil
 local state = battleCtxPointerProbeState or nil
 if not cfg or not cfg.enabled or not state or not state.active then
  return false
 end

 local battleSysAddr = battleLogConfig and battleLogConfig.battleSystemAddr or nil
 local battleCtxAddr = battleLogConfig and battleLogConfig.battleContextAddr or nil
 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  return false
 end

 local maxPasses = floor(tonumber(cfg.maxPassesPerBattle) or 2)
 if maxPasses < 1 then
  maxPasses = 1
 end
 if (state.completedPasses or 0) >= maxPasses then
  return false
 end

 local passFrames = cfg.passFrames or {0, 2}
 local nextPassIndex = tonumber(state.nextPassIndex or 1) or 1
 local dueFrameOffset = tonumber(passFrames[nextPassIndex])
 if dueFrameOffset == nil then
  return false
 end
 local currentBattleFrame = tonumber((battleLogState and battleLogState.frameCounter) or 0) or 0
 local startFrame = tonumber(state.battleStartFrameCounter or 0) or 0
 if (currentBattleFrame - startFrame) < dueFrameOffset then
  return false
 end

 state.battleSysAddr = battleSysAddr
 state.battleCtxAddr = battleCtxAddr
 state.battleType = read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset) or state.battleType
 state.trainerId = getPrimaryEnemyTrainerId(battleSysAddr)

 local currentPassHitKeys = {}
 local totalHits = 0
 local ctx = {passIndex = nextPassIndex - 1}

 if cfg.scanForBattleCtx then
  local emitted, hitKeys = scanMainRamForPointerValue(state.battleCtxAddr, "battleCtx", ctx)
  totalHits = totalHits + (emitted or 0)
  for key, value in pairs(hitKeys or {}) do
   currentPassHitKeys[key] = value and true or nil
  end
 end
 if cfg.scanForBattleSys then
  local emitted, hitKeys = scanMainRamForPointerValue(state.battleSysAddr, "battleSys", ctx)
  totalHits = totalHits + (emitted or 0)
  for key, value in pairs(hitKeys or {}) do
   currentPassHitKeys[key] = value and true or nil
  end
 end

 state.prevPassHitKeys = currentPassHitKeys
 state.completedPasses = (state.completedPasses or 0) + 1
 state.nextPassIndex = nextPassIndex + 1

 if cfg.printConsoleSummary then
  print(string.format("BattleCtx pointer probe pass=%d hits=%d battleSys=%s battleCtx=%s",
   ctx.passIndex,
   totalHits,
   tostring(formatHex8OrNil(state.battleSysAddr)),
   tostring(formatHex8OrNil(state.battleCtxAddr))))
 end

 return true
end

function ensureBattlePointerProbeTemplateFile()
 if battlePointerProbeState.templateInitialized then
  return
 end

 battlePointerProbeState.templateInitialized = true
 local fileName = getBattlePointerProbeTemplateFileName()
 if fileExists and fileExists(fileName) then
  return
 end

 local outFile = io.open(fileName, "w")
 if not outFile then
  return
 end

 outFile:write("run_id,battle_kind,session_id,battleSystemAddr,battleContextAddr,battleType,watch_addr,pc,lr,r0,r1,r2,r3,written_value,candidate_function_entry,candidate_caller,overlay_id,overlay_offset,notes\n")
 outFile:close()
end

function buildBattlePointerProbeSignature(sourceTag, stageTag, battleSysAddr, battleCtxAddr, battleType, command, commandNext)
 return table.concat({
  tostring(sourceTag or ""),
  tostring(stageTag or ""),
  tostring(battleSysAddr or 0),
  tostring(battleCtxAddr or 0),
  tostring(battleType or 0),
  tostring(command or -1),
  tostring(commandNext or -1)}, "|")
end

function writeBattlePointerProbeRecord(sourceTag, stageTag, notes)
 if not (battlePointerProbeConfig and battlePointerProbeConfig.enabled) then
  return false
 end

 local battleSysAddr = battleLogConfig and battleLogConfig.battleSystemAddr or nil
 local battleCtxAddr = battleLogConfig and battleLogConfig.battleContextAddr or nil
 local battleType = nil
 local command = nil
 local commandNext = nil
 local battleTypeAddr = nil
 local battleCtxFieldAddr = nil

 if isMainRAMPointer and isMainRAMPointer(battleSysAddr) then
  battleTypeAddr = battleSysAddr + battleSystemLayout.battleTypeOffset
  battleCtxFieldAddr = battleSysAddr + battleSystemLayout.battleCtxOffset
  battleType = read32Bit(battleTypeAddr)
 end

 if isMainRAMPointer and isMainRAMPointer(battleCtxAddr) then
  command = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandOffset)
  commandNext = read32Bit(battleCtxAddr + battleContextKnownOffsets.commandNextOffset)
 end

 local signature = buildBattlePointerProbeSignature(sourceTag, stageTag, battleSysAddr, battleCtxAddr, battleType, command, commandNext)
 if battlePointerProbeConfig.dedupeSameSignature and signature == battlePointerProbeState.lastSignature then
  return false
 end
 battlePointerProbeState.lastSignature = signature

 local trainerTID, trainerSID = getTrainerIDs()
 local fileName = getBattlePointerProbeFileName(trainerTID or 0)
 local runId = battlePointerProbeState.nextRunId or 1
 local lifecycleTick = 0
 battlePointerProbeState.nextRunId = runId + 1
 ensureBattlePointerProbeTemplateFile()

 local payload = string.format(
  "\"run_id\":%d,\"battle_kind\":%s,\"session_id\":%d,\"source\":%s,\"stage\":%s,\"trainerId\":%d,\"secretId\":%d,\"battleSystemAddr\":%s,\"battleSystemAddrHex\":%s,\"battleContextAddr\":%s,\"battleContextAddrHex\":%s,\"battleType\":%s,\"battleTypeHex\":%s,\"command\":%s,\"commandNext\":%s,\"watchBattleTypeAddr\":%s,\"watchBattleTypeAddrHex\":%s,\"watchBattleCtxFieldAddr\":%s,\"watchBattleCtxFieldAddrHex\":%s,\"lifecycleTick\":%d,\"autoStartTick\":%d,\"mainLoopTick\":%d,\"notes\":%s",
  runId,
  jsonStringOrNull(getBattleKindLabelFromType(battleType)),
  battlePointerProbeState.scriptSessionId or 1,
  jsonStringOrNull(sourceTag),
  jsonStringOrNull(stageTag),
  trainerTID or 0,
  trainerSID or 0,
  jsonNumberOrNull(battleSysAddr),
  jsonStringOrNull(formatHex8OrNil(battleSysAddr)),
  jsonNumberOrNull(battleCtxAddr),
  jsonStringOrNull(formatHex8OrNil(battleCtxAddr)),
  jsonNumberOrNull(battleType),
  jsonStringOrNull(formatHex8OrNil(battleType)),
  jsonNumberOrNull(command),
  jsonNumberOrNull(commandNext),
  jsonNumberOrNull(battleTypeAddr),
  jsonStringOrNull(formatHex8OrNil(battleTypeAddr)),
  jsonNumberOrNull(battleCtxFieldAddr),
  jsonStringOrNull(formatHex8OrNil(battleCtxFieldAddr)),
  lifecycleTick,
  tonumber((battleLogState and battleLogState.autoStartTick) or 0) or 0,
  tonumber((battleLogState and battleLogState.mainLoopTick) or 0) or 0,
  jsonStringOrNull(notes))

 appendJsonLineToFile(fileName, string.format("{%s}\n", payload))

 return true
end

local httpApiPort = 8000
local httpApiState = {
 started = false,
 startAttempted = false,
 enabled = false,
 server = nil,
 clients = {},
 currentIndex = 1,
 socketLib = nil,
 lastErrorFrame = -999999,
 frameCounter = 0}

function getHttpStatusText(statusCode)
 local names = {
  [200] = "OK",
  [204] = "No Content",
  [400] = "Bad Request",
  [404] = "Not Found",
  [405] = "Method Not Allowed",
  [500] = "Internal Server Error"}

 return names[statusCode] or "OK"
end

function buildHttpJsonError(statusCode, message)
 return string.format("{\"ok\":false,\"status\":%d,\"error\":%s}",
                      statusCode or 500,
                      jsonStringOrNull(message or "unknown error"))
end

function buildEmptyHttpResourceJson(resourceName, trainerId)
 if resourceName == "battlelog" then
  return string.format("{\"ok\":true,\"resource\":\"battlelog\",\"trainerId\":%d,\"found\":false,\"file\":null,\"events\":[],\"eventCount\":0,\"parseErrors\":0}",
                       trainerId or 0)
 end

 return string.format("{\"ok\":true,\"resource\":%s,\"trainerId\":%d,\"found\":false,\"file\":null,\"data\":null}",
                      jsonStringOrNull(resourceName),
                      trainerId or 0)
end

function buildBoxOrSnapshotHttpJson(resourceName, trainerId, fileName)
 local rawText = readFileAllText(fileName)

 if rawText == nil then
  return 200, buildEmptyHttpResourceJson(resourceName, trainerId)
 end

 local trimmed = trimString(rawText)
 local firstChar = string.sub(trimmed, 1, 1)

 if trimmed == "" or (firstChar ~= "{" and firstChar ~= "[") then
  return 500, buildHttpJsonError(500, resourceName.." file is not valid JSON")
 end

 return 200, string.format("{\"ok\":true,\"resource\":%s,\"trainerId\":%d,\"found\":true,\"file\":%s,\"data\":%s}",
                            jsonStringOrNull(resourceName),
                            trainerId or 0,
                            jsonStringOrNull(fileName),
                            trimmed)
end

function buildBattleLogHttpJson(trainerId, fileName)
 local inFile = io.open(fileName, "r")

 if not inFile then
  return 200, buildEmptyHttpResourceJson("battlelog", trainerId)
 end

 local eventsJson = {}
 local eventCount = 0
 local parseErrors = 0

 for line in inFile:lines() do
  local trimmed = trimString(line)
  if trimmed ~= "" then
   local firstChar = string.sub(trimmed, 1, 1)
   local lastChar = string.sub(trimmed, -1)
   if (firstChar == "{" and lastChar == "}") or (firstChar == "[" and lastChar == "]") then
    eventsJson[#eventsJson + 1] = trimmed
    eventCount = eventCount + 1
   else
    parseErrors = parseErrors + 1
   end
  end
 end

 inFile:close()

 return 200, string.format("{\"ok\":true,\"resource\":\"battlelog\",\"trainerId\":%d,\"found\":true,\"file\":%s,\"events\":[%s],\"eventCount\":%d,\"parseErrors\":%d}",
                            trainerId or 0,
                            jsonStringOrNull(fileName),
                            table.concat(eventsJson, ","),
                            eventCount,
                            parseErrors)
end

local battleSysAnchorWatchDebug = {
 enabled = false, -- temporary debug
 addr = 0x021BF680}

local battleSysAnchorWatchState = {
 lastAnchorValue = nil,
 lastInferredBattle = nil}

function debugWatchBattleSysAnchorPointer()
 if not (battleSysAnchorWatchDebug and battleSysAnchorWatchDebug.enabled) then
  return
 end

 local watchAddr = tonumber(battleSysAnchorWatchDebug.addr) or 0
 if watchAddr < 0x02000000 or watchAddr >= 0x02400000 then
  return
 end

 local anchorValue = read32Bit(watchAddr)
 local inferredBattle = false
 local inferredBattleType = nil
 local inferredBattleCtx = nil
 local inferredSane = false

 if isMainRAMPointer(anchorValue) then
  inferredBattleType = read32Bit(anchorValue + battleSystemLayout.battleTypeOffset)
  inferredBattleCtx = read32Bit(anchorValue + battleSystemLayout.battleCtxOffset)
  inferredSane = isSaneBattleContextState(anchorValue, inferredBattleCtx)
  inferredBattle = inferredSane and ((inferredBattleType or 0) ~= 0) or false
 end

 local changed = (battleSysAnchorWatchState.lastAnchorValue ~= anchorValue)
 local stateChanged = (battleSysAnchorWatchState.lastInferredBattle ~= inferredBattle)
 if changed or stateChanged then
  print(string.format(
   "Anchor watch %08X -> ptr=%s battle=%s sane=%s battleType=%s battleCtx=%s",
   watchAddr,
   tostring(formatHex8OrNil(anchorValue)),
   tostring(inferredBattle),
   tostring(inferredSane),
   tostring(inferredBattleType),
   tostring(formatHex8OrNil(inferredBattleCtx))))
  battleSysAnchorWatchState.lastAnchorValue = anchorValue
  battleSysAnchorWatchState.lastInferredBattle = inferredBattle
 end
end

function dumpTrainerBattleSnapshot()
 local pidAddr = read32Bit(pidPointerAddr)
 local battleSysAddr = battleLogConfig.battleSystemAddr
 local battleCtxAddr = battleLogConfig.battleContextAddr

 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  autoSelectBattleSystemCandidate(true)
  battleSysAddr = battleLogConfig.battleSystemAddr
  battleCtxAddr = battleLogConfig.battleContextAddr
 end

 if not isSaneBattleContextState(battleSysAddr, battleCtxAddr) then
  dumpStatusText = "Snapshot failed: no battle context"
  dumpStatusFrames = 240
  return
 end

 local battleType = read32Bit(battleSysAddr + battleSystemLayout.battleTypeOffset)
 if not isTrainerBattleType(battleType) then
  dumpStatusText = "Snapshot failed: not trainer battle"
  dumpStatusFrames = 240
  return
 end

 local trainerTID, trainerSID = getTrainerIDs()
 local fileName = string.format("%s/BattleSnapshot-%d.json", getOutputDumpsDir(), trainerTID or 0)
 local outFile = io.open(fileName, "w")
 local maxBattlers = read32Bit(battleSysAddr + battleSystemLayout.maxBattlersOffset)
 local playerJsonParts = {}
 local enemyJsonParts = {}
 local selectedPartySlot = readBattleContextU8Array(battleCtxAddr, battleContextKnownOffsets.selectedPartySlotOffset, 4)

 if not outFile then
  dumpStatusText = "Snapshot failed: could not open file"
  dumpStatusFrames = 240
  return
 end

 if maxBattlers == nil or maxBattlers < 1 or maxBattlers > 4 then
  maxBattlers = 4
 end

 for battler = 0, maxBattlers - 1 do
  local battleMon = readBattleMonDetailedSummary(battleCtxAddr, battler)
  local storageMon, activePartySlot, storageAddr = tryDecodeActiveBattlerPartyMon(battleSysAddr, battleCtxAddr, battler, pidAddr)

  if battleMon and battleMon.species and battleMon.species > 0 then
   local monJson = buildBattleSnapshotMonJson(battleMon, storageMon, activePartySlot or (selectedPartySlot[battler + 1] and (selectedPartySlot[battler + 1] + 1) or 0), storageAddr)
   if battleMon.side == "player" then
    playerJsonParts[#playerJsonParts + 1] = monJson
   else
    enemyJsonParts[#enemyJsonParts + 1] = monJson
   end
  end
 end

 outFile:write("{\n")
 outFile:write(string.format("  \"trainerId\": %d,\n", trainerTID or 0))
 outFile:write(string.format("  \"secretId\": %d,\n", trainerSID or 0))
 outFile:write(string.format("  \"battleSys\": %d,\n", battleSysAddr or 0))
 outFile:write(string.format("  \"battleCtx\": %d,\n", battleCtxAddr or 0))
 outFile:write(string.format("  \"battleType\": %d,\n", battleType or 0))
 outFile:write("  \"playerActive\": [")
 outFile:write(table.concat(playerJsonParts, ","))
 outFile:write("],\n")
 outFile:write("  \"trainerActive\": [")
 outFile:write(table.concat(enemyJsonParts, ","))
 outFile:write("]\n")
 outFile:write("}\n")
 outFile:close()

 dumpStatusText = "Battle snapshot saved: "..fileName
 dumpStatusFrames = 240
 print("Saved battle snapshot: "..fileName)
 maybeUpdateMasterTrainerFile(trainerTID)
end

function logEnemyTrainerParty(enemyAddr)
 local pidAddr = read32Bit(pidPointerAddr)
 local fileName

 fileName = string.format("%s/Pt_enemy_party_%08X_%08X.txt", getOutputDumpsDir(), pidAddr, enemyAddr)

 local outFile = io.open(fileName, "w")

 if not outFile then
  dumpStatusText = "Party log failed: could not open file"
  dumpStatusFrames = 240
  return
 end

 outFile:write("==== Enemy Trainer Party Dump ====\n")
 outFile:write(string.format("Game: Platinum (%s)\n", gameLanguage))
 outFile:write(string.format("pidPointerAddr: %08X\n", pidPointerAddr))
 outFile:write(string.format("pidAddr: %08X\n", pidAddr))
 outFile:write(string.format("enemyAddr: %08X\n\n", enemyAddr))

 for slot = 0, 5 do
  local monAddr = enemyAddr + (0xEC * slot)
  local pokemonPID, speciesDexIndex, moveIndexes, level, currentHP, maxHP = decodeEnemyPartyMonSummary(monAddr)

  if not pokemonPID then
   outFile:write(string.format("Slot %d: <empty> (addr=%08X)\n", slot + 1, monAddr))
  else
   local speciesName = speciesNamesList[(speciesDexIndex > 493 or speciesDexIndex < 1) and 1 or speciesDexIndex]
   local move1 = moveNamesList[moveIndexes[1] > 468 and 1 or moveIndexes[1]]
   local move2 = moveNamesList[moveIndexes[2] > 468 and 1 or moveIndexes[2]]
   local move3 = moveNamesList[moveIndexes[3] > 468 and 1 or moveIndexes[3]]
   local move4 = moveNamesList[moveIndexes[4] > 468 and 1 or moveIndexes[4]]

   outFile:write(string.format("Slot %d @ %08X | PID %08X | %s | Lv %d | HP %d/%d\n", slot + 1, monAddr, pokemonPID, speciesName,
                               level, currentHP, maxHP))
   outFile:write(string.format("  Moves: %s / %s / %s / %s\n", move1, move2, move3, move4))
  end
 end

 outFile:close()
 dumpStatusText = "Enemy party saved: "..fileName
 dumpStatusFrames = 240
 print("Saved enemy party dump: "..fileName)
end

function handleEnemyPartyLogInput(enemyAddr)
 local key = input.get()

 if (key["0"] or key["numpad0"]) and (not prevKeyEnemyPartyLog["0"] and not prevKeyEnemyPartyLog["numpad0"]) then
  logEnemyTrainerParty(enemyAddr)
 end

 prevKeyEnemyPartyLog = key
 if not (captureMinimalUI and mode[index] == "Capture") then
  gui.text(152, 160, "0 - Save enemy party")
 end
end

function getOffset(offsetType, orderIndex)
 local offsets = {["growth"] = {0,0,0,0,0,0, 1,1,2,3,2,3, 1,1,2,3,2,3, 1,1,2,3,2,3},
                  ["attack"] = {1,1,2,3,2,3, 0,0,0,0,0,0, 2,3,1,1,3,2, 2,3,1,1,3,2},
                  ["misc"] = {3,2,3,2,1,1, 3,2,3,1,2,1, 3,2,3,1,2,1, 0,0,0,0,0,0}}

 return offsets[offsetType][orderIndex]
end

function shinyCheck(PID, trainerTID, trainerSID)
 trainerTID = trainerTID or nil
 trainerSID = trainerSID or nil

 if not trainerTID then
  trainerTID, trainerSID = getTrainerIDs()
 end

 local lowPID = band(PID, 0xFFFF)
 local highPID = rshift(PID, 16)
 local shinyTypeValue = bxor(bxor(trainerTID, trainerSID), bxor(lowPID, highPID))

 if shinyTypeValue < 8 then
  return "green", shinyTypeValue == 0 and " (Square)" or " (Star)"
 end

 return nil, ""
end

function getBits(a, b, d)
 return rshift(a, b) % lshift(1, d)
end

function getIVs(ivsValue)
 local hpIV  = getBits(ivsValue, 0, 5)
 local atkIV = getBits(ivsValue, 5, 5)
 local defIV = getBits(ivsValue, 10, 5)
 local spdIV = getBits(ivsValue, 15, 5)
 local spAtkIV = getBits(ivsValue, 20, 5)
 local spDefIV = getBits(ivsValue, 25, 5)

 return hpIV, atkIV, defIV, spAtkIV, spDefIV, spdIV
end

function getHPTypeAndPower(hpIV, atkIV, defIV, spAtkIV, spDefIV, spdIV)
 local hpType = floor(((band(hpIV, 1) + (2 * band(atkIV, 1)) + (4 * band(defIV, 1)) + (8 * band(spdIV, 1)) + (16 * band(spAtkIV, 1))
                + (32 * band(spDefIV, 1))) * 15) / 63)
 local hpPower = floor((((band(rshift(hpIV, 1), 1) + (2 * band(rshift(atkIV, 1), 1)) + (4 * band(rshift(defIV, 1), 1)) + (8 * band(rshift(spdIV, 1), 1))
                 + (16 * band(rshift(spAtkIV, 1), 1)) + (32 * band(rshift(spDefIV, 1), 1))) * 40) / 63)) + 30

 return hpType, hpPower
end

function getIVColor(value)
 if value >= 30 then
  return "green"
 elseif value >= 1 and value <= 5 then
  return "orange"
 elseif value < 1 then
  return "red"
 end

 return nil  -- IV value from 6 to 29
end

function showIVsAndHP(ivsValue)
 local hpIV, atkIV, defIV, spAtkIV, spDefIV, spdIV = getIVs(ivsValue)
 local hpType, hpPower = getHPTypeAndPower(hpIV, atkIV, defIV, spAtkIV, spDefIV, spdIV)

 gui.text(2, -145, "IVs:")
 gui.text(32, -145, string.format("%02d", hpIV), getIVColor(hpIV))
 gui.text(44, -145, "/")
 gui.text(50, -145, string.format("%02d", atkIV), getIVColor(atkIV))
 gui.text(62, -145, "/")
 gui.text(68, -145, string.format("%02d", defIV), getIVColor(defIV))
 gui.text(80, -145, "/")
 gui.text(86, -145, string.format("%02d", spAtkIV), getIVColor(spAtkIV))
 gui.text(98, -145, "/")
 gui.text(104, -145, string.format("%02d", spDefIV), getIVColor(spDefIV))
 gui.text(116, -145, "/")
 gui.text(122, -145, string.format("%02d", spdIV), getIVColor(spdIV))

 gui.text(2, -134, "HPower: "..HPTypeNamesList[hpType + 1].." "..hpPower)
end

function showMoves(moveIndexesList)
 gui.text(2, -101, "Move: "..moveNamesList[moveIndexesList[1] > 468 and 1 or moveIndexesList[1]])
 gui.text(2, -90, "Move: "..moveNamesList[moveIndexesList[2] > 468 and 1 or moveIndexesList[2]])
 gui.text(2, -79, "Move: "..moveNamesList[moveIndexesList[3] > 468 and 1 or moveIndexesList[3]])
 gui.text(2, -68, "Move: "..moveNamesList[moveIndexesList[4] > 468 and 1 or moveIndexesList[4]])
end

function showPP(movePPList)
 gui.text(120, -101, "PP: "..(movePPList[1] < 100 and movePPList[1] or 0))
 gui.text(120, -90, "PP: "..(movePPList[2] < 100 and movePPList[2] or 0))
 gui.text(120, -79, "PP: "..(movePPList[3] < 100 and movePPList[3] or 0))
 gui.text(120, -68, "PP: "..(movePPList[4] < 100 and movePPList[4] or 0))
end

function showPokemonIDs(trainerTID, trainerSID)
 gui.text(194, -22, string.format("TID: %d", trainerTID))
 gui.text(194, -11, string.format("SID: %d", trainerSID))
end

function showInfo(pidAddr)
 local pokemonPID = read32Bit(pidAddr)
 local checksum = read16Bit(pidAddr + 0x6)
 local orderIndex = (rshift(band(pokemonPID, 0x3E000), 0xD) % 24) + 1
 local move = {}
 local movePP = {}
 local ivsPart = {}

 local growthOffset = getOffset("growth", orderIndex) * 32
 local attacksOffset = getOffset("attack", orderIndex) * 32
 local prng = checksum

 for i = 1, getOffset("growth", orderIndex) do
  prng = LCRNG(prng, 0x5F748241, 0xCBA72510)  -- 16 cycles
 end

 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 local speciesDexIndex = bxor(read16Bit(pidAddr + growthOffset + 0x8), rshift(prng, 16))

 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 local heldItemIndex = bxor(read16Bit(pidAddr + growthOffset + 0xA), rshift(prng, 16)) + 1

 local OTID, OTSID = nil, nil

 if mode[index] == "Pokemon Info" then
  prng = LCRNG(prng, 0x41C64E6D, 0x6073)
  OTID = bxor(read16Bit(pidAddr + growthOffset + 0xC), rshift(prng, 16))
  prng = LCRNG(prng, 0x41C64E6D, 0x6073)
  OTSID = bxor(read16Bit(pidAddr + growthOffset + 0xE), rshift(prng, 16))
 else
  prng = LCRNG(prng, 0xC2A29A69, 0xE97E7B6A)  -- 2 cycles
 end

 local shinyTypeTextColor, shinyType = shinyCheck(pokemonPID, OTID, OTSID)

 prng = LCRNG(prng, 0x807DBCB5, 0x52713895)  -- 3 cycles
 local abilityIndex = bxor(read16Bit(pidAddr + growthOffset + 0x14), rshift(prng, 16))
 abilityIndex = getBits(abilityIndex, 8, 8)

 prng = checksum

 for i = 1, getOffset("attack", orderIndex) do
  prng = LCRNG(prng, 0x5F748241, 0xCBA72510)  -- 16 cycles
 end

 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 move[1] = bxor(read16Bit(pidAddr + attacksOffset + 0x8), rshift(prng, 16)) + 1
 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 move[2] = bxor(read16Bit(pidAddr + attacksOffset + 0xA), rshift(prng, 16)) + 1
 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 move[3] = bxor(read16Bit(pidAddr + attacksOffset + 0xC), rshift(prng, 16)) + 1
 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 move[4] = bxor(read16Bit(pidAddr + attacksOffset + 0xE), rshift(prng, 16)) + 1

 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 local movePPAux = bxor(read16Bit(pidAddr + attacksOffset + 0x10), rshift(prng, 16))
 movePP[1] = getBits(movePPAux, 0, 8)
 movePP[2] = getBits(movePPAux, 8, 8)
 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 movePPAux = bxor(read16Bit(pidAddr + attacksOffset + 0x12), rshift(prng, 16))
 movePP[3] = getBits(movePPAux, 0, 8)
 movePP[4] = getBits(movePPAux, 8, 8)

 prng = LCRNG(prng, 0x807DBCB5, 0x52713895)  -- 3 cycles
 ivsPart[1] = bxor(read16Bit(pidAddr + attacksOffset + 0x18), rshift(prng, 16))
 prng = LCRNG(prng, 0x41C64E6D, 0x6073)
 ivsPart[2] = bxor(read16Bit(pidAddr + attacksOffset + 0x1A), rshift(prng, 16))
 local ivsValue = lshift(ivsPart[2], 16) + ivsPart[1]

 local isEgg = getBits(ivsValue, 30, 1) == 1
 local natureIndex = (pokemonPID % 25) + 1
end



function getLeadAbility(pidAddr)
 local pokemonPID = read32Bit(pidAddr)
 local checksum = read16Bit(pidAddr + 0x6)
 local orderIndex = (rshift(band(pokemonPID, 0x3E000), 0xD) % 24) + 1

 local growthOffset = getOffset("growth", orderIndex) * 32
 local prng = checksum

 for i = 1, getOffset("growth", orderIndex) do
  prng = LCRNG(prng, 0x5F748241, 0xCBA72510)  -- 16 cycles
 end

 prng = LCRNG(prng, 0x9B355305, 0xAFC58AC9)  -- 7 cycles
 local abilityIndex = bxor(read16Bit(pidAddr + growthOffset + 0x14), rshift(prng, 16))

 return getBits(abilityIndex, 8, 8)
end

function getAbilityEffectType(pidAddr)
 local partyLeadAbility = getLeadAbility(pidAddr)

 if partyLeadAbility == 0x23 or partyLeadAbility == 0x47 or partyLeadAbility == 0x63 then  -- Illuminate / Arena Trap / No Guard
  return 2
 elseif partyLeadAbility == 0x8 then  -- Sand Veil
  local weatherIndex = read8Bit(read32Bit(pidPointerAddr) + 0xE2DA)

  if weatherIndex == 0xA then  -- Sand Veil effect is active only during the sandstorm
   return 1
  end
 elseif partyLeadAbility == 0x51 then  -- Snow Cloak
  local weatherIndex = read8Bit(read32Bit(pidPointerAddr) + 0xE2DA)

  if weatherIndex >= 0x5 and weatherIndex <= 0x7 then  -- Snow Cloak effect is active only during the snowing and the snowstorms
   return 1
  end
 elseif partyLeadAbility == 0x1 or partyLeadAbility == 0x49 or partyLeadAbility == 0x5F then  -- Stench / White Smoke / Quick Feet
  return 1
 end

 return 0
end

function getAbilityEffectMod(rate, pidAddr)
 local partyLeadAbilityEffectType = getAbilityEffectType(pidAddr)

 return partyLeadAbilityEffectType == 1 and floor(rate / 2) or partyLeadAbilityEffectType == 2 and rate * 2 or rate
end

function getActiveFluteType()
 local fluteFlagsAddr = read32Bit(pidPointerAddr) + 0x15069
 local fluteActiveEffectFlag = read8Bit(fluteFlagsAddr)

 return fluteActiveEffectFlag
end

function getFluteEffectMod(rate)
 local activeFluteType = getActiveFluteType()
 local isBlackFluteActive = activeFluteType == 1
 local isWhiteFluteActive = activeFluteType == 2

 return isBlackFluteActive and floor(rate / 2) or isWhiteFluteActive and rate + floor(rate / 2) or rate
end

function getLeadHeldItem(pidAddr)
 local pokemonPID = read32Bit(pidAddr)
 local checksum = read16Bit(pidAddr + 0x6)
 local orderIndex = (rshift(band(pokemonPID, 0x3E000), 0xD) % 24) + 1

 local growthOffset = getOffset("growth", orderIndex) * 32
 local prng = checksum

 for i = 1, getOffset("growth", orderIndex) do
  prng = LCRNG(prng, 0x5F748241, 0xCBA72510)  -- 16 cycles
 end

 prng = LCRNG(prng, 0xC2A29A69, 0xE97E7B6A)  -- 2 cycles
 return bxor(read16Bit(pidAddr + growthOffset + 0xA), rshift(prng, 16))
end

function getTagOrIncenseEffectMod(rate, pidAddr)
 local partyLeadHeldItem = getLeadHeldItem(pidAddr)
 local isPartyLeadHoldingCleanseTag = partyLeadHeldItem == 0xE0
 local isPartyLeadHoldingPureIncense = partyLeadHeldItem == 0x140

 return (isPartyLeadHoldingCleanseTag or isPartyLeadHoldingPureIncense) and floor((rate * 2) / 3) or rate
end

function setEncounterRate(matr, pidAddr)
 local partyAddr = pidAddr + 0xD094
 local rate = getTileRate(matr)
 rate = getAbilityEffectMod(rate, partyAddr)
 rate = getFluteEffectMod(rate)
 rate = getTagOrIncenseEffectMod(rate, partyAddr)

 return rate
end

function coolDownEndCheck(rate, steps, currentSteps)
 local mapRate = 8 - rshift(floor(lshift(rate, 8) / 10), 8)

 return steps + currentSteps >= mapRate and true or false
end

function getEncounterCheckValue(seed)
 return floor(rshift(seed, 16) / 0x290)
end

function getEncounterMissingSteps(movement, encounter)
 local currentCoolDownStepsAddr = read32Bit(pidPointerAddr) + 0x2E834 + koreanOffset
 local currentCoolDownSteps = read8Bit(currentCoolDownStepsAddr)
 local wildEncounterSeed = read32Bit(currentSeedAddr)
 local missingSteps, coolDownSteps = 0, 0

 while not battleStartJumpFlag do
  local isCoolDownEnded = true

  if not coolDownEndCheck(encounter, coolDownSteps, currentCoolDownSteps) then
   wildEncounterSeed = LCRNG(wildEncounterSeed, 0x41C64E6D, 0x6073)

   if getEncounterCheckValue(wildEncounterSeed) >= 5 then
    coolDownSteps = coolDownSteps + 1
    isCoolDownEnded = false
   end
  end

  if isCoolDownEnded then
   wildEncounterSeed = LCRNG(wildEncounterSeed, 0x41C64E6D, 0x6073)
   missingSteps = missingSteps + 1

   if getEncounterCheckValue(wildEncounterSeed) < movement then
    wildEncounterSeed = LCRNG(wildEncounterSeed, 0x41C64E6D, 0x6073)

    if getEncounterCheckValue(wildEncounterSeed) < encounter then
     break
    end
   end
  end
 end

 return missingSteps + coolDownSteps, coolDownSteps
end


-- <<< END 08_debug_probes.lua

-- >>> BEGIN 09_main.lua
-- Module Index: 09_main
-- Owns: startup hotkey help output and main frame-loop orchestration (`main`, `gui.register`).
-- Goal: remain thin and mostly wiring-only as migration continues.

function printHotkeyInfo()
 print("Hotkeys:")
 print("  b - Dump Box-<TRAINER_ID>.json and copy latest box JSON to clipboard (Box 1-4)")
 print("  t - Dump trainer battle snapshot")
 if allowPartyHpEditor then
  print("  h - Open/close party HP editor, best used on Party slot 2-6")
  print("      Spacebar to apply edits, if editing slot 1 you may have to press spacebar multiple times")
 end
 if allowPartyStatusEditor then
  print("  j - Open/close party status editor")
  print("      Left/Right slot, Up/Down status, Spacebar apply")
 end
 if allowAiIntentOverlay then
  print("  y - Toggle AI intent overlay (shows Unknown until available)")
 end
 if allowManualLogToggleHotkey then
  print("  Q/q - Toggle battle logging on/off (dev)")
 end
 if not battleLoggingOnlyMode then
  print("  W/w - Scan BattleSystem candidates")
  print("  E/e - Dump battleCtx debug snapshot")
  print("  R/r - Log enemy party snapshot")
 end
 print("")
end

printHotkeyInfo()
function main()
 if not wrongGameVersion then
  local pidAddr = read32Bit(pidPointerAddr)
  local emulationPaused = isEmulationPausedForScriptWork()
  index = 1
  maskEditorModalDpadInput()

  if (not emulationPaused) and shouldRunAutoStartPollThisFrame() then
   maybeAutoStartBattleLog()
  end

  if (not emulationPaused) and shouldRunFrameHandlersThisFrame() then
   pollBattleLog()
   pollBattleLifecycleMasterUpdates()
  end
  handleBattleToolsInput(pidAddr)
  drawPartyStatusEditorOverlay(pidAddr)
  drawPartyHpEditorOverlay(pidAddr)
  drawAutoLogBattleOffIndicator()
  updateDumpStatusText()
 end
end

gui.register(main)

-- <<< END 09_main.lua