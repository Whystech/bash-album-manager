# Album Management System
 
A terminal-based album management application written in Bash.
 
The application stores album information in a CSV file and provides interactive options for adding, viewing, searching, and deleting album records. It also maintains a customizable list of music genres.
 
## Features
 
- Add new album records
- View all albums in a formatted terminal table
- Search for albums by:
- Album name
- Artist
- Year of release
- Delete:
- A specific album
- All albums by an artist
- All album records
- View the available music genres
- Add custom genres
- Populate the database with testing records
- Validate album information before saving
- Prevent duplicate album names
- Display color-formatted terminal menus and results
- Abort data entry by pressing `Esc`
 
## Album Information
 
Each album record contains the following fields:
 
| Field | Description |
|---|---|
| Album ID | Automatically generated numeric identifier |
| Album Name | Name of the album |
| Artist | Album artist |
| Year | Year of release |
| Genre | Genre selected from `genres.txt` |
| Tracks | Number of tracks |
| Record Label | Name of the record label |
| UPC | 12-digit Universal Product Code |
 
Records are stored in `albumslist.csv` using the following format:
 
```text
AlbumID,AlbumName,Artist,Year,Genre,Tracks,RecordLabel,UPC
```
 
Example:
 
```text
1,Hybrid Theory,Linkin Park,2000,Nu Metal,12,Warner Bros,123456789012
```
 
## Requirements
 
The script is intended to run on a Linux or Unix-like system with Bash.
 
The following commands must be available:
 
- `awk`
- `grep`
- `less`
- `sort`
- `tail`
- `touch`
- `wc`
- `mv`
- `rm`
 
Most Linux distributions provide these commands by default.
 
## Files
 
The application uses the following files:
 
### `album-management.sh`
 
The main Bash script containing the application logic.
 
### `albumslist.csv`
 
Stores the album records.
 
The script creates this file automatically if it does not already exist.
 
### `genres.txt`
 
Stores the supported music genres.
 
The script creates this file automatically and populates it with a default genre list if it does not already exist.
 
## Installation
 
Clone the repository:
 
```bash
git clone https://github.com/your-username/album-management-system.git
```
 
Navigate to the project directory:
 
```bash
cd album-management-system
```
 
Make the script executable:
 
```bash
chmod +x album-management.sh
```
 
Run the application:
 
```bash
./album-management.sh
```
 
Alternatively, run it directly with Bash:
 
```bash
bash album-management.sh
```
 
## Main Menu
 
When the application starts, the following menu is displayed:
 
```text
=====================================================
ALBUM MANAGEMENT SYSTEM
=====================================================
 
1) Add Album
2) View Albums
3) Delete Albums
4) Search Albums
5) Display and edit genres.txt
6) Add testing albums
0) Exit
```
 
Select an option using the corresponding number key.
 
## Adding an Album
 
Select `1` from the main menu and provide the requested information:
 
1. Album name
2. Artist name
3. Year of release
4. Genre
5. Number of tracks
6. Record label
7. UPC
 
The application displays the completed record before saving it.
 
Press `Y` to save the album or `N` to discard it.
 
Press `Esc` during data entry to abandon the operation.
 
### Input validation
 
The application performs several validation checks:
 
- Album names cannot be empty.
- Album names cannot exceed 20 characters.
- Duplicate album names are detected.
- Artist names cannot be empty.
- Release years must contain three or four digits.
- Release years cannot be later than 2025.
- Genres must exist in `genres.txt`.
- Track counts must be between 1 and 200.
- Record label names must contain at least three characters.
- UPC values must contain exactly 12 digits.
 
## Viewing Albums
 
Select `2` from the main menu to display all album records.
 
Albums are displayed in a color-formatted table containing:
 
- Album ID
- Album name
- Artist
- Release year
- Genre
- Number of tracks
- Record label
- UPC
 
Press any key to return to the main menu.
 
## Deleting Albums
 
Select `3` from the main menu.
 
The deletion submenu provides the following options:
 
```text
1) Delete by Album Name
2) Delete all Albums by Artist
3) Delete all Albums
0) Back to main menu
```
 
### Delete by album name
 
Search for an album using its name.
 
If multiple records match the search, the application displays the matching records and requests the specific album ID.
 
A confirmation prompt is displayed before deletion.
 
### Delete albums by artist
 
Enter an exact artist name to display all matching albums.
 
After confirmation, all records belonging to that artist are removed.
 
### Delete all albums
 
This option deletes all records from `albumslist.csv`.
 
Confirmation is required before the records are removed.
 
## Searching for Albums
 
Select `4` from the main menu.
 
The search submenu provides the following options:
 
```text
1) Search by Album Name
2) Search Albums by Artist
3) Search Albums by Year
0) Return to main menu
```
 
### Search by album name
 
Returns albums containing the supplied text in the album name.
 
### Search by artist
 
Returns albums whose artist field contains the supplied text.
 
### Search by year
 
Returns albums whose release year exactly matches the supplied year.
 
Search results are displayed in a formatted terminal table.
 
## Managing Genres
 
Select `5` from the main menu.
 
The genre submenu provides the following options:
 
```text
1) View Genres
2) Add Genre
0) Back to main menu
```
 
### View genres
 
Displays the contents of `genres.txt` in alphabetical order using `less`.
 
Use the arrow keys to navigate and press `Q` to exit.
 
### Add a genre
 
Adds a new genre to `genres.txt`.
 
The application checks that:
 
- The genre is not empty.
- The genre contains at least three characters.
- The genre does not already exist.
 
Genre names are saved with the first character capitalized.
 
## Adding Test Data
 
Select `6` from the main menu to append a collection of sample albums to `albumslist.csv`.
 
The sample data includes albums from artists such as:
 
- Linkin Park
- AC/DC
- Michael Jackson
- Metallica
- Pink Floyd
- Nirvana
- The Beatles
- Green Day
- Daft Punk
- Radiohead
 
This option is intended for testing and demonstration purposes.
 
Running it multiple times appends the same sample records again.
 
## Default Genres
 
The initial `genres.txt` file includes genres such as:
 
```text
Alternative
Ambient
Blues
Classical
Country
Dance
Disco
Drum and Bass
Dubstep
Electronic
Folk
Funk
Hard Rock
Heavy Metal
Hip Hop
House
Indie
Jazz
K-Pop
Metalcore
Nu Metal
Pop
Punk
R&B
Rap
Reggae
Rock
Soul
Synthwave
Techno
Trance
Trap
World
```
 
Additional genres can be added through the application.
 
## Data Persistence
 
Album records and genres are stored as plain-text files in the directory from which the script is executed.
 
To preserve the data, retain the following files:
 
```text
albumslist.csv
genres.txt
```
 
To reset the application, remove these files before starting the script. The script will create new empty or default files as required.
 
## Repository Structure
 
```text
album-management-system/
├── album-management.sh
├── albumslist.csv
├── genres.txt
└── README.md
```
 
Only `album-management.sh` is required initially because the application can create the other data files automatically.
 
## Known Considerations
 
- The application uses a fixed maximum release year of `2025`.
- Data fields are separated by commas, so commas inside album names, artist names, or record labels may affect CSV parsing.
- The testing option appends records and does not check whether the sample records already exist.
- The script uses ANSI escape sequences for colors and terminal formatting.
- The album table is designed for a wide terminal window.
- The application is intended for local terminal use.
 
## License
 
This project is available for educational and demonstration purposes.
