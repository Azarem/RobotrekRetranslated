1. Make sure Node.js is installed on your local machine. For instructions go here [https://nodejs.org/en/download]
2. Edit the `.env.local` file and change `ROM_PATH` to the location of the Robotrek (USA) ROM on your local hard drive.
3. Open a terminal and run `npm run extract`. This will extract the ROM contents into the `./extracted` folder. You may use these for reference.
4. Add or make changes to files in the `./modules/base` folder. Most changes should occur from within a `chapter#.patch.asm` file. You may want to copy/paste the original strings and edit them instead of creating them from scratch.
5. When you add strings/text from a `new chunk_0#8000` file, make sure to add a corresponding `?INCLUDE 'chunk_0#8000'` entry in the patch file.
6. When you want to test your changes, open a terminal and run `npm run rebuild`. This will generate a new ROM and place it in the `./rebuilt` folder.
7. Open the rebuilt ROM in an emulator. Make sure to `Reload ROM` (if using Mesen).