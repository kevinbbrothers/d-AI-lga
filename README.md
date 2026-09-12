<img width="2330" height="2231" alt="dAIlga_logo" src="https://github.com/user-attachments/assets/5f745bed-b3d4-46a2-8b94-26461741a801" />

Pronounced Dialga, d-AI-lga is a tool designed to play pokemon platinum completely autonomously.

dAIlga utilizes parts of the memory reading functionality of https://github.com/hzla/Pokemon-Lua.git, grabbing real-time battle information from in game RAM. This information is written JSON which is parsed by the C#-based console program, dAIlga itself. This program uses the information provided from Pokémon-Lua and it's own screen based pixel game-sense to determine the best action to take while in a trainer battle, executing them via user32.dll calls.

dAIlga was built to run using the DeSMUme GBA/NDS emulator, running Pokémon Platinum English edition.

dAIlga contains a full database of gen IV Pokemon and moves, allowing it to calculate the most effective attack for a given situation using type matchups and ---. This program is also capable of basic strategy, switching out Pokemon that are below 5HP, and switching new Pokemon in on the situation in which they faint.

Limitations: dAIlga is unable to engage in wild Pokémon encounters, as the information regarding Pokémon moves and stats is unavalible due to limitations of Pokemon-lua. It also is unable to autonomously traverse the map of the gen IV world, but that functionality would not be difficult to implement. Due to the way in which the emulator used for this program is run, switching save files will cause the program to fail.

dAIlga was built during the 2026 KYX Hackathon in about 24 hours.
