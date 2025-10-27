#!/bin/bash
#Author: Andrei Ianus
#StudentID: 20114847
#Description: This program can hold, edit and delete details about albums

#Start of script

#####################################
###DefaultGenres.txt file creation###
#####################################
if ! [ -f genres.txt ]
then
	printf "creating genres.txt"
	printf "Alternative
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
	Gospel
	Hard Rock
	Heavy Metal
	Hip Hop
	House
	Indie
	Instrumental
	Jazz
	K-Pop
	Latin
	Lo-Fi
	Metalcore
	New Age
	Opera
	Pop
	Punk
	R&B
	Rap
	Reggae
	Rock
	Ska
	Soul
	Synthwave
	Techno
	Trance
	Trap
	World
	Acoustic
	Chillout
	Experimental
	Garage
	Grunge
	Industrial
	Progressive Rock
	Psychedelic
	Singer-Songwriter
	Soundtrack
	Swing\n" > genres.txt
	sleep 1
fi

###############
###MAIN MENU###
###############

function menu {
	clear

	printf "%s \n" \
		" 1) Add Album" \
		" 2) View Albums" \
		" 3) Edit/Delete Album" \
		" 4) Search Album" \
		" 5) Display and edit genres.txt" \
		" 0) Exit"

	read -s -n1 CHOICE

	case "$CHOICE" in
		1) addAlbum ;;
		2) viewAlbums ;;
		3) editAlbumSubmenu ;;
		4) searchAlbumSubmenu ;;
		5) editGenres ;;
		0) printf "Goodbye!"
			##REMEMBER TO REMOVE COMMENT	sleep 1
			clear
			exit ;;
		*) printf "INVALID OPTION SELECTED"
	esac
}

###############
###ADD ALBUM###
###############

function addAlbum {
	while true
	do
		clear
		printf '\n\e[1;33mPress ESC to abandon.\e[0m\n'
		while true
		do
			printf "\nPlease insert album name:\n\n"
			read -n1 TEST
			if [ "$TEST" = $'\e' ];
			then
				break 2
			fi
			if [ -z "$TEST" ]
			then 
				printf "Album name cannot be empty."
				continue
			fi
			###Sometimes, some albums have one character as first letter then followed by a space (e.g. "A Thousand Suns") IFS will take that first -space- literally.
			IFS= read REST
			ALBUMNAME="$TEST$REST"
			if [ ${#ALBUMNAME} -gt 20 ]
			then
				printf "\nYour Album name :\n$ALBUMNAME \nIs too long, consider an abbreviation. \n \n"
				continue
			fi
			break
		done

		while true
		do
			printf "\nPlease insert album artist:\n\n"
			read -n1 TEST
			if [ "$TEST" = $'\e' ]
			then
				break 2
			fi
			if [ -z "$TEST" ]
			then 
				printf "Album artist cannot be empty."
				continue
			fi
			read REST
			ARTISTNAME="$TEST$REST"
			break
		done

		while true
		do
			printf "\nPlease enter album year of release:\n\n"
			read -n1 TEST
			if [ "$TEST" = $'\e' ]
			then
				break 2
			fi
			if [ -z "$TEST" ]
			then 
				printf "Album YOR cannot be empty."
				continue
			fi
			read REST
			ALBUMYOR="$TEST$REST"

			if [ ${#ALBUMYOR} -gt 4 ] || [ ${#ALBUMYOR} -lt 3 ]
			then
				printf "\nInvalid year of release date, needs to have a mimimum 3 digits and a maximum of 4.\n"
				continue
			fi
			if ! echo "$ALBUMYOR" | egrep -oq '[0-9]'
			then
				printf "\nAlbum Year of Release cannot contain letters or other symbols.\n"
				continue
			fi
			if [ $ALBUMYOR -gt 2025 ]
			then
				printf "\nYear of release can't be in the future.\n"
				continue
			fi
			break
		done

		while true
		do
			printf "\nPlease insert album genre:\n\n"
			read -n1 TEST
			if [ "$TEST" = $'\e' ]
			then
				break 2
			fi
			if [ -z "$TEST" ]
			then 
				printf "Album genre cannot be empty.\n"
				continue
			fi
			read REST
			ALBUMGENRE="$TEST$REST"

			if [ ${#ALBUMGENRE} -lt 3 ]
			then
				printf "\nAlbum genre needs to have at least 3 letters.\n"
				continue
			fi

			if ! grep -ioq "$ALBUMGENRE" genres.txt 
			then
				printf "\nGenre not found in genres.txt file, consider using an exisiting genre or add in your file.\n"
				continue
			fi

			if ! [ $(grep -i "$ALBUMGENRE" genres.txt | wc -l) -gt 1 ]
			then
				ALBUMGENRE=$(grep -i "$ALBUMGENRE" genres.txt)
				printf "\033[A\033[2K"
				printf "\033[33m$ALBUMGENRE\033[0m found! Genre saved.\n"
				break
			fi

			printf "\nMultiple matches found for \"$ALBUMGENRE\"\n"
			FOUNDRESULTS=`grep -i "$ALBUMGENRE" genres.txt`
			printf "\n$FOUNDRESULTS\n\n"
			printf "Input your desired genre:\n"
			read SELECTION

			if grep -iqw "^$SELECTION$" genres.txt && printf "$FOUNDRESULTS" | grep -iqw "^$SELECTION$"
			then
				ALBUMGENRE=$(grep -iw "^$SELECTION$" genres.txt)
				printf "\033[A\033[2K"; printf "\033[A\033[2K"; printf "\033[A\033[2K"
				printf "\nGenre selected\n\033[33m$ALBUMGENRE\033[0m\n"
				sleep 1
			else
				printf "\nInvalid selection."
				continue
			fi
			break
		done

		while true
		do
			printf "\nPlease enter the number of tracks on the album:\n\n"
			read -n1 TEST
			if [ "$TEST" = $'\e' ]
			then
				break 2
			fi

			if [ -z "$TEST" ]
			then 
				printf "Tracks number cannot be empty."
				continue
			fi
			read REST
			TRACKSNUMBER="$TEST$REST"
			if echo "$TRACKSNUMBER" | grep -oq '[a-zA-Z!@#$%^&*()_+=<>?~.,-/\\]'
			then
				printf "\nTracks number cannot contain letters or other symbols.\n"
				continue
			fi
			if [ $TRACKSNUMBER -gt 200 ] || [ $TRACKSNUMBER -lt 1 ]
			then
				printf "\nTracks number must be between 0 and 201.\n"
				continue
			fi
			break
		done

		while true
		do
			printf "\nPlease enter record label name:\n\n"
			read -n1 TEST
			if [ "$TEST" = $'\e' ]
			then
				break 2
			fi
			if [ -z "$TEST" ]
			then 
				printf "Record label name cannot be empty."
				continue
			fi
			read REST
			LABELNAME="$TEST$REST"
			if echo "$LABELNAME" | grep -oq '[@^*~+=_<>`]'
			then	
				printf "\nRecord label name cannot contain forbidden symbols (@^*~+=_<>).\n"
				continue
			fi
			break
		done

		while true
		do
			printf "\nPlease enter Universal Product Code (UPC) - 12 digits.\n\n"
			read -n1 TEST
			if [ "$TEST" = $'\e' ]
			then
				break 2
			fi
			if [ -z "$TEST" ]
			then 
				printf "\nUPC cannot be empty.\n"
				continue
			fi
			read REST
			UPC="$TEST$REST"
			if echo "$UPC" | grep -Eq '[^0-9]'
			then		
				printf "\nPlease insert numbers only.\n"
				continue
			fi
			if ! [ "${#UPC}" -eq 12 ]
			then
				printf "\nUPC must be 12 digits only.\n"
				continue
			fi	
			break
		done

		clear

###ID increments with each album added.
ALBUMID=$(tail -n 1 albumslist.csv| awk -F, '{print $1}')
ALBUMID=$((ALBUMID + 1))

###Need to have comma separation.
###Using printf to be sure that after each value there is a comma inserted.
printf "%s,%s,%s,%s,%s,%s,%s,%s\n"  "$ALBUMID" "$ALBUMNAME" "$ARTISTNAME" "$ALBUMYOR" "$ALBUMGENRE" "$TRACKSNUMBER" "$LABELNAME" "$UPC" >> albumslist.csv
printf "\nAdding album record:\n\n"

###VISUAL CONFIRMATION FOR USER

printf "\033[33mAlbum ID: $ALBUMID\nAlbum Name: $ALBUMNAME\nArtist Name: $ARTISTNAME\nAlbum Year of Release: $ALBUMYOR\nGenre: $ALBUMGENRE\nNumber of Tracks: $TRACKSNUMBER\nRecord Label: $LABELNAME\nUPC: $UPC\n\033[39m\n"
printf "\nPress any key to continue."
read -sn1
break
done
}

#################
###VIEW ALBUMS###
#################

function viewAlbums {
	while true
	do
		if ! [ -f albumslist.csv ]
		then
			printf "\n\nAlbumslist  file missing, creating now.\n\n"
			touch albumslist.csv
			printf "Press any key to continue."
			read -sn1
			break
		fi
		if ! [ -s albumslist.csv ]
		then
			printf "\n\nNo albums added yet, nothing to view.\n\n"
			printf "Press any key to continue."
			read -sn1
			break
		fi
		###Using custom field separator to have comma as a field separator.
		awk '
		BEGIN {FS=","
		###Formatting variables
		###Used ANSII codes to give the table some colour.
		titlesFormat = \
		" \033[1m| %-10s\033[0m||" \
		" \033[93;1m%-25s\033[0m||" \
		" \033[93;1m%-20s\033[0m||" \
		" \033[93;1m%-15s\033[0m||" \
		" \033[93;1m%-20s\033[0m||" \
		" \033[93;1m%-15s\033[0m||" \
		" \033[93;1m%-15s\033[0m||" \
		" \033[93;1m%-25s\033[0m\033[1m|\033[0m\n"
		valuesFormat = " \033[1m|\033[0m %-10s|| %-25s|| %-20s|| %-15s|| %-20s|| %-15s|| %-15s|| %-25s\033[1m|\033[0m\n"
		
		###Table top frame for column titles
		
		printf "\n"
		printf "\nPress any key to return.\n"
		printf " "
		for (i = 0; i < 169; i++)
		printf "\033[1m_\033[0m"
		print "\n"


		###Column title
		printf titlesFormat , "Album ID", "Album Name", "Artist" , "Year" , "Genre" , "No. of Tracks" , "Record Label", "Universal Product Code"

		###Table bottom frame for column titles
		printf " "
		for (i = 0; i < 169; i++)
		printf "\033[1m_\033[0m"
		print "\n"}

		#########END OF BEGIN

		###Field printing
		{
		printf valuesFormat , $1, $2, $3, $4, $5, $6, $7, $8 
		}


		###Bottom frame for table
		END {
		printf " "
		for (i = 0; i < 169; i++)
		printf "\033[1m_\033[0m"
		printf "\n"
		###Hide cursor
		printf "\033[?25l"
		}
		' albumslist.csv

read -sn1
###Restore cursor
printf "\033[?25h"
break
done
}

##############################
###EDIT/DELETE ALBUMSUBMENU###
##############################

function editAlbumSubmenu {
	while true
	do
		clear

		printf "%s \n" \
			" 1) Delete by Album Name" \
			" 0) Back to main menu"

		read -s -n1 CHOICE

		case "$CHOICE" in
			1) deleteByName;;
			0) break;;
			*) printf "INVALID OPTION SELECTED"
		esac
	done
}

##########################
###Delete album by name###
##########################
function deleteByName {
	while true
	do
		printf "\nEnter the name of the album which you want to delete:\n"
		read NAMETODELETE
		NAMETODELETE=${NAMETODELETE,,}
		if [ -z "$NAMETODELETE" ] || [ "${#NAMETODELETE}" -lt 3 ]
		then
			printf "\nName cannot be empty or have less than 3 characters."
			read -sn1
			break
		fi
		if !  awk 'BEGIN {FS="," } { print $2 }' albumslist.csv | grep -iq "$NAMETODELETE"
		then
			printf "\nNo matches found."
			read -sn1
			break
		fi

		if [ $( awk 'BEGIN {FS="," } { print $2 }' albumslist.csv | grep -i "$NAMETODELETE" | wc -l ) -gt 1 ]
		then
			clear
			printf "\nMultiple records found for \033[1:31m$NAMETODELETE\033[0m\n"
			ALBUMSFOUND=$(grep -i "$NAMETODELETE" albumslist.csv)
			echo "$ALBUMSFOUND" | \
				awk '
				BEGIN {FS=","
				###Formatting variables
				###Used ANSII codes to give the table some colour.
				titlesFormat = \
				" \033[1m| %-10s\033[0m||" \
				" \033[93;1m%-25s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-25s\033[0m\033[1m|\033[0m\n"
				valuesFormat = " \033[1m|\033[0m %-10s|| %-25s|| %-20s|| %-15s|| %-20s|| %-15s|| %-15s|| %-25s\033[1m|\033[0m\n"


				###Table top frame for column titles
				printf "\n"
				printf " "
				for (i = 0; i < 169; i++)
				printf "\033[1m_\033[0m"
				print "\n"


				###Column title
				printf titlesFormat , "Album ID", "Album Name", "Artist" , "Year" , "Genre" , "No. of Tracks" , "Record Label", "Universal Product Code"

				###Table bottom frame for column titles
				printf " "
				for (i = 0; i < 169; i++)
				printf "\033[1m_\033[0m"
				print "\n"}

				#########END OF BEGIN

				###Field printing
				{
				printf valuesFormat , $1, $2, $3, $4, $5, $6, $7, $8 
				}


				###Bottom frame for table
				END {
				printf " "
				for (i = 0; i < 169; i++)
				printf "\033[1m_\033[0m"
				printf "\n"
				###Hide cursor
				printf "\033[?25l"
				}
				'
		printf "\nInput the ID of the album you wish to remove:\n"
		read IDTODELETE

			if ! echo "$ALBUMSFOUND" | awk 'BEGIN {FS="," } { print $1 }' | grep -iq "$IDTODELETE" 
			then
				printf "Invalid ID."
				read -sn1
				break 1
			fi

			printf "\nAre you sure you want to delete the following record(Y/N): \n\n"

		awk -v ID="$IDTODELETE" '
		BEGIN{  FS="," }
		{
		if ($1==ID)
			printf "\033[1:31m%s %s %s %s %s %s %s %s\033[0m", $1, $2, $3, $4, $5, $6, $7, $8 
		}' albumslist.csv
		read -sn1 YESNO
			
			if [ "$YESNO" = "y" ] || [ "$YESNO" = "Y" ]
			then
				awk -v ID="$IDTODELETE" '
				BEGIN { FS ="," }
				{
				if ($1!=ID)
					print
				}' albumslist.csv > albumslist.tmp ; 
				sleep 0.25
				mv albumslist.tmp  albumslist.csv
				printf "\n\nAlbum deleted successfully.\nPress any key to continue.\n"
				read -sn1
			else
				printf "\n\nDeletion procedure aborted. Press any key to continue.\n"
				read -sn1

			fi
			else
				
	###Extract Id for easier deletion - avoid using regex within awk.
	ALBUMFOUND=$(grep -i "$NAMETODELETE" albumslist.csv)
	ALBUMFOUNDID=$(echo "$ALBUMFOUND" | awk ' BEGIN {FS=","} {printf $1}')

		printf "\nYou sure you want do delete the following record (Y/N): \n\n"
		echo "$ALBUMFOUND" | \
			awk '
		       	BEGIN {FS =","}  { printf "\033[1:31m%s %s %s %s %s %s %s %s\033[0m", $1, $2, $3, $4, $5, $6, $7, $8 }
			'
		read -sn1 YESNO
		        if [ "$YESNO" = "y" ] || [ "$YESNO" = "Y" ]
			then
				awk -v ID="$ALBUMFOUNDID" '
				BEGIN { FS ="," }
				{
				if ($1!=ID)
					print
				}' albumslist.csv > albumslist.tmp
			
			###Added sleep here as sometimes mv would give an error that albumslist.csv is busy.
	
				sleep 0.25
			       	mv albumslist.tmp albumslist.csv
				printf "\n\nAlbum deleted successfully.\nPress any key to continue.\n"
				read -sn1
			else
				printf "\n\nDeletion procedure aborted. Press any key to continue.\n"
				read -sn1

			fi
	fi
	
break
done
}

##########################
###SEARCH ALBUM SUBMENU###
##########################

function searchAlbumSubmenu {
	printf "Search menu"
	read -sn1
	break
}

########################################
###Edit genres sub menu and functions###
########################################
###Please ignore this bit, I have read the feedback after I started working on the script.
function editGenres {
	while true 
	do
		clear
		printf "%s \n"\
			"1)View Genres" \
			"2)Add Genre" \
			"0)Back to main menu"

		read -sn1 CHOICE
		case $CHOICE in
			1) viewGenres ;;
			2) addGenre ;;
			0) break ;;
			*) printf "INVALID OPTION"
				read -sn1 ;;
		esac
	done
}

function viewGenres {
	while true
	do
		( printf "\e[1;33mPress Q to exit\n\n";
		printf "\e[1;32mUse UPARROW and DOWNARROW to navigate\n\n"
		cat genres.txt;
		printf "\n\e[1;33mPress Q to exit\n" ) | less -R

		printf "Press any key to continue."
		break
	done
}

function addGenre {
	printf '\n\e[1;33mPress ESC to abandon\e[0m\n'
	while true
	do
		printf "\nEnter your desired genre.\n"
		read -n1 TEST
		if [ "$TEST" = $'\e' ]
		then
			break
		fi
		if [ -z "$TEST" ]
		then 
			printf "\nGenre cannot be empty."
			continue
		fi
		read REST
		GENRE="$TEST$REST"
		if grep -iowq "$GENRE" genres.txt
		then
			printf "\nGenre already present."
			continue
		fi
		if [ "${#GENRE}" -lt 3  ]
		then
			printf "\nGenre needs to be at least 3 characters long."
			continue
		fi
		GENRE="${GENRE,,}"
		GENRE="${GENRE^}"
		echo "$GENRE" >> genres.txt
		break
	done
}

while true
do
	menu
done
