#!/bin/bash
#Author: Andrei Ianus
#StudentID: 20114847
#Description: This program can hold, edit and delete details about albums

#Start of script

#####################################
###DefaultGenres.txt file creation###
#####################################

###Avoid the first test failing (checking wether an album already exists) if the file does not exist.
if ! [ -f albumslist.csv]
	then touch albumslist.csv
fi

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
Nu Metal
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
		printf "\n\033[1:36m=====================================================\033[0m\n"
		printf "\033[1:33m                ALBUM MANAGEMENT SYSTEM              \033[0m\n"
		printf "\033[1:36m=====================================================\033[0m\n\n"
		printf "\033[1m%s\033[0m\n" \
		" 1) Add Album" \
		" 2) View Albums" \
		" 3) Delete Albums" \
		" 4) Search Albums" \
		" 5) Display and edit genres.txt" \
		" 6) Add testing albums" \
		" 0) Exit" \
		" " \
		" Select option "

	read -s -n1 CHOICE

	case "$CHOICE" in
		1) addAlbum ;;
		2) viewAlbums ;;
		3) editAlbumSubmenu ;;
		4) searchAlbumSubmenu ;;
		5) editGenres ;;
		6) addTestingAlbums;;
		0) printf "\n\033[1:31m Goodbye!\033[0m"
		sleep 1
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

		###If the user will pres ESC the read will be aborted.

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
  
		###Test if the album already exists.


			elif awk ' BEGIN {FS=","} { print $2 } ' albumslist.csv | grep -iwq "^$ALBUMNAME$"
				then
				printf "\nAnother record was identified for \033[1:31m$ALBUMNAME\033[0m :\n\n"
					awk -v albumName="$ALBUMNAME" -F, '
					{ if (tolower($2) == tolower(albumName))
						 printf "\033[1:31m%s by %s\n%s %s\nTracks: %s\nLabel: %s\nUPC: %s\033[0m", $2, $3, $4, $5, $6, $7, $8 
					}' albumslist.csv 
					printf "\n\nPress any key to return to main menu."
					read -sn1
					break 2
			else
				break
			fi
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
			
			if [ "${#LABELNAME}" -lt 3 ]
			then
				printf "\nLabel name cannot be shorter than 3 characters."\n
				continue
			fi

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

###VISUAL CONFIRMATION FOR USER

		printf "\nDo you want to add the following record?(Y/N)\n\n"
		printf "\033[1:33mAlbum ID: $ALBUMID\nAlbum Name: $ALBUMNAME\nArtist Name: $ARTISTNAME\nAlbum Year of Release: $ALBUMYOR\nGenre: $ALBUMGENRE\nNumber of Tracks: $TRACKSNUMBER\nRecord Label: $LABELNAME\nUPC: $UPC\n\033[0m\n"

###Save or discard record

		read -sn1 YESNO
		YESNO="${YESNO,,}"
			if [ -z "$YESNO"  ] || [ "$YESNO" != "y" ] && [ "$YESNO" != "n" ]
			then
				printf "\nInvalid answer."
				read -sn1
			fi
			if [ "$YESNO" = "y" ] || [ "$YESNO" = "Y" ]
			then
				printf "\nAlbum record added!\n\n"

###Need to have comma separation.
###Using printf to have a comma inserted after each value.

			printf "%s,%s,%s,%s,%s,%s,%s,%s\n"  "$ALBUMID" "$ALBUMNAME" "$ARTISTNAME" "$ALBUMYOR" "$ALBUMGENRE" "$TRACKSNUMBER" "$LABELNAME" "$UPC" >> albumslist.csv
			printf "\nPress any key to continue."
			read -sn1
			break
			else
				printf "\nAlbumd record discarded!\nPress any key to continue.\n"
				read -sn1
				break
			fi
done
}

#################
###VIEW ALBUMS###
#################

function viewAlbums {
	while true
	do
		clear
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
		" \033[1m| \033[0m\033[1:31m%-10s\033[0m||" \
		" \033[93;1m%-25s\033[0m||" \
		" \033[93;1m%-20s\033[0m||" \
		" \033[93;1m%-15s\033[0m||" \
		" \033[93;1m%-20s\033[0m||" \
		" \033[93;1m%-15s\033[0m||" \
		" \033[93;1m%-15s\033[0m||" \
		" \033[93;1m%-25s\033[0m\033[1m|\033[0m\n"
		valuesFormat = " \033[1m| \033[0m\033[1:31m%-10s\033[0m|| %-25s|| %-20s|| %-16s|| %-20s|| %-15s|| %-15s|| %-24s\033[1m|\033[0m\n"
		
		###Table top frame for column titles
		
		printf "\n"
		printf "\n\033[1m  Press any key to return.\033[0m\n"
		printf "  "
		 for (i = 0; i < 167; i++)
			printf "\033[1m_\033[0m"
	
		###A savage solution but my for loops would not behave as intended.	
		printf "\033[1m\n |                                                                                                                                                                       |\n\033[0m"
	

		###Column title
		printf titlesFormat , "Album ID", "Album Name", "Artist" , "Year" , "Genre" , "No. of Tracks" , "Record Label", "Universal Product Code"

		###Table bottom frame for column titles
		printf "\033[1m |\033[0m"
		for (i = 0; i < 167; i++)
			printf "\033[1m_\033[0m"
		printf "\033[1m|\n |                                                                                                                                                                       |\033[0m  "		

				}
		#########END OF BEGIN

		###Field printing
		{	
		printf valuesFormat , $1, $2, $3, $4, $5, $6, $7, $8 
		}	


		###Bottom frame for table
		END {
		printf " \033[1m|\033[0m"
		for (i = 0; i < 167; i++)
			printf "\033[1m_\033[0m"
			
	###Filling holes in the table
	
		printf "\033[1m|\033[0m \n"
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
###DELETE ALBUMSUBMENU###
##############################

function editAlbumSubmenu {
	while true
	do
		clear
		printf "\n\033[1:36m=====================================================\033[0m\n"
		printf "\033[1:33m                Delete Albums                          \033[0m\n"
		printf "\033[1:36m=====================================================\033[0m\n\n"

		printf "\033[1m%s\033[0m \n" \
			" 1) Delete by Album Name" \
			" 2) Delete all Albums by Artist" \
			" 3) Delete all Albums" \
			" 0) Back to main menu" \
			" "\
			" Select an option "
			

		read -s -n1 CHOICE

		case "$CHOICE" in
			1) deleteByName;;
			2) deleteByArtist;;
			3) deleteAllAlbums;;
			0) break;;
			*) printf "INVALID OPTION SELECTED"
		esac
	done
}

##########################
###DELETE ALBUM BY NAME###
##########################
function deleteByName {
	while true
	do
		printf "\nEnter the name of the album which you want to delete:\n"
		read NAMETODELETE
	###Check if empty or chars less than 3.
		if [ -z "$NAMETODELETE" ] || [ "${#NAMETODELETE}" -lt 3 ]
		then
			printf "\nName cannot be empty or have less than 3 characters."
			read -sn1
			break
		fi

	###Search only in field 2 - name of the album.
	
		if !  awk 'BEGIN {FS="," } { print $2 }' albumslist.csv | grep -iwq "$NAMETODELETE"
		then
			printf "\nNo matches found."
			read -sn1
			break
	
		fi

	###If there is more than one result (e.g. searching for "American" could return "American Idiot" or "American beauty"
	###The user then has to input the specific id of the record he wants to remove.
	
		if [ $( awk 'BEGIN {FS="," } { print $2 }' albumslist.csv | grep -iw "$NAMETODELETE" | wc -l ) -gt 1 ]
		then
			clear
			printf "\nMultiple records found for \033[1:31m$NAMETODELETE\033[0m\n"

	###Save only the found albums to be piped in awk.
	###This awk is pretty much the same as the one in the viewAlbums function.
	###The albums will be approximated.
	
			ALBUMSFOUND=$(awk -v nameToDelete="$NAMETODELETE" -F, '{ if (tolower($2) ~ tolower(nameToDelete)) print }' albumslist.csv)
			echo "$ALBUMSFOUND" | \
				awk '
				BEGIN {FS=","
				###Formatting variables
				###Used ANSII codes to give the table some colour.
				titlesFormat = \
				" \033[1m| \033[0m\033[1:31m%-10s\033[0m||" \
				" \033[93;1m%-25s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-25s\033[0m\033[1m|\033[0m\n"
				valuesFormat = " \033[1m|\033[0m \033[1:31m%-10s\033[0m|| %-25s|| %-20s|| %-15s|| %-20s|| %-15s|| %-15s|| %-25s\033[1m|\033[0m\n"


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
		printf "\nInput the ID of the album you wish to remove, press \033[1:33mENTER\033[0m to abort.\n"
		
		###User will need to specify the ID###
		###There is an error check here so the user cannot mistakenly delete another record.

		read IDTODELETE

			if [ -z "${IDTODELETE}" ]
				then
					printf "\nAborted. Press any key to continue.\n"
					read -sn1
					break
			fi

			if ! echo "$ALBUMSFOUND" | awk 'BEGIN {FS="," } { print $1 }' | grep -iq "$IDTODELETE" 
			then
				printf "\nInvalid ID. Press any key to continue.\n"
				read -sn1
				break 1
			fi

			printf "\nAre you sure you want to delete the following record(Y/N): \n\n"
	
		###Display the record about to be deleted.

		awk -v ID="$IDTODELETE" '
		BEGIN{  FS="," }
		{
		if ($1==ID)
			printf "\033[1:31m%s by %s\n%s %s\nTracks: %s\nLabel: %s\nUPC: %s\033[0m", $2, $3, $4, $5, $6, $7, $8 
		}' albumslist.csv

		###User confirmation for deletion.

		read -sn1 YESNO
		YESNO="${YESNO,,}"
			if [ -z "$YESNO"  ] || [ "$YESNO" != "y" ] && [ "$YESNO" != "n" ]
			then
				printf "\nInvalid answer."
				read -sn1
			fi			
			if [ "$YESNO" = "y" ] || [ "$YESNO" = "Y" ]
			then

		###Print all records that do not match the specified Id, put the new results in a temporary file, then replace the original list file.
		###The output will not have the record with the specified Id.

				awk -v ID="$IDTODELETE" '
				BEGIN { FS ="," }
				{
				if ($1!=ID)
					print
				}' albumslist.csv > tmp ; 
				sleep 0.25
				mv tmp albumslist.csv
				 
				printf "\n\nAlbum deleted successfully.\nPress any key to continue.\n"
				read -sn1
			else
				printf "\n\nDeletion procedure aborted. Press any key to continue.\n"
				read -sn1

			fi
			else
				
	###Extract Id from first field for easier deletion - avoid using regex within awk - the functionality before is used only if there is only one match found.
	
	ALBUMFOUND=$(grep -i "$NAMETODELETE" albumslist.csv)
	ALBUMFOUNDID=$(echo "$ALBUMFOUND" | awk ' BEGIN {FS=","} {printf $1}')

		printf "\nYou sure you want do delete the following record (Y/N): \n\n"
		echo "$ALBUMFOUND" | \
			awk '
		       	BEGIN {FS =","}  { printf "\033[1:31m%s by %s\n%s %s\nTracks: %s\nLabel: %s\nUPC: %s\033[0m", $2, $3, $4, $5, $6, $7, $8 }
			'
			read -sn1 YESNO
			YESNO="${YESNO,,}"
			if [ -z "$YESNO"  ] || [ "$YESNO" != "y" ] && [ "$YESNO" != "n" ] 
			then
				printf "\nInvalid response.\n"
				read -sn1
			fi
		        if [ "$YESNO" = "y" ] || [ "$YESNO" = "Y" ]
			then
				awk -v ID="$ALBUMFOUNDID" '
				BEGIN { FS ="," }
				{
				if ($1!=ID)
					print
				}' albumslist.csv > tmp
			
			###Added sleep here as sometimes mv would give an error that albumslist.csv is busy.
	
				sleep 0.25
			       	mv tmp albumslist.csv
				 
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


#################################
###DELETE ALL ALBUMS BY ARTIST###
#################################
function deleteByArtist {
	while true
	do
		printf "\nInsert artist name:\n\n"
		read ARTISTTODELETE
		if [ -z "${ARTISTTODELETE}" ] || [ "${#ARTISTTODELETE}" -lt 3 ] 
			then
				printf "\nName cannot be empty or have less thian 3 characters. Press any key to continue.\n"
				read -sn1
				break
		fi

	###Searches for artist name in field 3.

		if ! awk 'BEGIN { FS="," } { print $3 }' albumslist.csv | grep -iwq "^$ARTISTTODELETE$"
			then
				printf "\nNo matches found for \033[1:31m$ARTISTTODELETE\033[0m.\nPress any key to continue.\n"
				read -sn1
				break
		fi	
		clear	

	###Stores the found albums to be displayed to the user.
	
		ALBUMSBYARTIST=$(awk -v artistToDelete="$ARTISTTODELETE" -F, '
				{ if (tolower($3) == tolower(artistToDelete))  print }
					' albumslist.csv)

		echo "$ALBUMSBYARTIST" | \
			awk '
			BEGIN {FS=","
				###Formatting variables
				###Used ANSII codes to give the table some colour.
				titlesFormat = \
				" \033[1m| \033[0m\033[1:31m%-10s\033[0m||" \
				" \033[93;1m%-25s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-25s\033[0m\033[1m|\033[0m\n"
				valuesFormat = " \033[1m|\033[0m \033[1:31m%-10s\033[0m|| %-25s|| %-20s|| %-15s|| %-20s|| %-15s|| %-15s|| %-25s\033[1m|\033[0m\n"



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
				}'
				printf "\nYou sure you want to delete these records?(Y/N)\n"
				read -sn1 YESNO
				YESNO="${YESNO,,}"
				if [ -z "$YESNO" ] || [ "$YESNO" != "y"  ] && [ "$YESNO" != "n" ]
					then	
					printf "\nInvalid response.\n"
					read -sn1
					break
				fi
				if [ "$YESNO" = "y" ]
					then
				
				###Lowers the field and the variable used to search for a specific artist.
				###It then prints all the records that are not matching the artist

						awk -F, -v artistToDelete="$ARTISTTODELETE" '
						tolower($3) !~ tolower(artistToDelete) { print }	
						' albumslist.csv > tmp
						sleep 0.25
						mv tmp albumslist.csv
						 
						printf "\nRecords deleted! Press any key to continue.\n"
				read -sn1
				else
					printf "\n\nDeletion procedure aborted. Press any key to continue.\n"
				read -sn1


				fi
				break
	done
}

function deleteAllAlbums {
	while true
	do
		printf "\nYou sure you want to delete \033[1:33mALL\033[0m albums?(Y/N)\n"
		read -sn1 YESNO		
		YESNO="${YESNO,,}"
				if [ -z "$YESNO" ] || [ "$YESNO" != "y"  ] && [ "$YESNO" != "n" ]
					then	
					printf "\nInvalid response.\n"
					read -sn1
					break
				fi
				if [ "$YESNO" = "y" ]
					then
					rm albumslist.csv
					sleep 0.25
					touch albumslist.csv
					printf "\n\033[1:33mALL albums deleted successfully.\033[0m"
					sleep 1
					ALBUMID=0;
				else
						printf "\n\nDeletion procedure aborted. Press any key to continue.\n"
				read -sn1
				fi
				break

	done
}


##########################
###SEARCH ALBUM SUBMENU###
##########################

function searchAlbumSubmenu {
	while true
	do
		clear

		printf "\n\033[1:36m=====================================================\033[0m\n"
		printf "\033[1:33m                Search Albums                          \033[0m\n"
		printf "\033[1:36m=====================================================\033[0m\n\n"
		printf "\033[1m%s\033[0m \n" \
			 " 1) Search by Album Name " \
			 " 2) Search Albums by Artist"  \
			 " 3) Search Albums by Year" \
			 " 0) Return to main menu" \
			 " "\
			 " Select an option "
		
		read -sn1 CHOICE
		case "$CHOICE" in
			1)searchByAlbumName;;
			2)searchByArtist;;
			3)searchByYear;;
			0)break;;
			*)printf"\nINVALID SELECTION"
		esac
	done
}

##########################
###SEARCH BY ALBUM NAME###
##########################

function searchByAlbumName {
while true
	do
		printf "\nEnter the name of the album you are looking for:\n"
		read NAMETOSEARCH
	###Check if empty or chars less than 3.
		if [ -z "$NAMETOSEARCH" ] || [ "${#NAMETOSEARCH}" -lt 3 ]
		then
			printf "\nName cannot be empty or have less than 3 characters."
			read -sn1
			break
		fi

	###Search only in field 2 - name of the album.
	
		if !  awk 'BEGIN {FS="," } { print $2 }' albumslist.csv | grep -iq "$NAMETOSEARCH"
		then
			printf "\nNo matches found."
			read -sn1
			break
	
		fi

	###Again, fairly similar with the delete function. removed the specific parts that included deletion.
	
			ALBUMSFOUND=$(grep -i "$NAMETOSEARCH" albumslist.csv)
			echo "$ALBUMSFOUND" | \
				awk '
				BEGIN {FS=","
				###Formatting variables
				###Used ANSII codes to give the table some colour.
				titlesFormat = \
				" \033[1m| \033[0m\033[1:31m%-10s\033[0m||" \
				" \033[93;1m%-25s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-25s\033[0m\033[1m|\033[0m\n"
				valuesFormat = " \033[1m|\033[0m \033[1:31m%-10s\033[0m|| %-25s|| %-20s|| %-15s|| %-20s|| %-15s|| %-15s|| %-25s\033[1m|\033[0m\n"
				

				printf "\n\033[1m Press any key to return.\033[0m"

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
				read -sn1
				break
			done
}


#############################
####SEARCH BY ALBUM ARTIST###
#############################
###It is pretty similar to the search in the delete function - however - this search option is a bit more relaxed showing aproximate results, as compared to the delete function which must match words exactly.

function searchByArtist {
while true
do
	printf "\nPlease enter the artist name:\n"
	read ARTISTTOSEARCH
	if [ -z "${ARTISTTOSEARCH}" ] || [ "${#ARTISTTOSEARCH}" -lt 3 ]
		then
			printf "\nArtist name cannot be empty or shorter than 3 characters."
			read -sn1
			break
	fi

###SEARCH ONLY IN FIELD 3###
###Notification if there are no results in field #3.

	if [ -z "$(awk -F, -v artistToSearch="$ARTISTTOSEARCH" ' tolower($3) ~ tolower(artistToSearch) { print } ' albumslist.csv)" ]
		then
			printf "\nNo album identified for arist\033[1:33m $ARTISTTOSEARCH\033[0m.\n"
			printf "\n\nPress any key to continue.\n"
			read -sn1
			break
	fi

###Instead of piping into grep, I have tried to use the awk's built in regex. Different approach just to see how it behaves if I try something else. Seems a bit cleaner.


	awk -F, -v artistToSearch="$ARTISTTOSEARCH" ' 
	BEGIN	{
	titlesFormat = \
				" \033[1m| \033[0m\033[1:31m%-10s\033[0m||" \
				" \033[93;1m%-25s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-25s\033[0m\033[1m|\033[0m\n"
				valuesFormat = " \033[1m|\033[0m \033[1:31m%-10s\033[0m|| %-25s|| %-20s|| %-15s|| %-20s|| %-15s|| %-15s|| %-25s\033[1m|\033[0m\n"
				
				printf "\n\033[1m Press any key to return.\033[0m"

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
				
				###Field printing - if statement
				
				{
				if(tolower($3) ~ tolower(artistToSearch))
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
				}' albumslist.csv
	

read -sn1
break
	
done


}


###################
###SEARCH BY YOR###
###################

function searchByYear {
while true
do
	printf "\nInsert year of release:\n"
	read YORTOSEARCH
	if echo "${YORTOSEARCH}" | grep '[^0-9]' || [ "${#YORTOSEARCH}" -lt 3 ] || [ "${#YORTOSEARCH}" -gt 4 ]
	then
		printf "\nPlease use numbers only. Year must have at least 3 digits and a maximum of 4.\n"		   
		read -sn1
		break
	fi
	
	if [ -z "$(awk -F, -v yearToSearch="$YORTOSEARCH"  ' { if($4 == yearToSearch)  print } ' albumslist.csv)" ]
	then
		printf "\nNo matches found for \033[1:33m$YORTOSEARCH\033[0m as year of release.\n"
		read -sn1
		break
	fi


	awk -F, -v yearToSearch="$YORTOSEARCH" ' 
	BEGIN	{
	titlesFormat = \
				" \033[1m| \033[0m\033[1:31m%-10s\033[0m||" \
				" \033[93;1m%-25s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-20s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-15s\033[0m||" \
				" \033[93;1m%-25s\033[0m\033[1m|\033[0m\n"
				valuesFormat = " \033[1m|\033[0m \033[1:31m%-10s\033[0m|| %-25s|| %-20s|| %-15s|| %-20s|| %-15s|| %-15s|| %-25s\033[1m|\033[0m\n"
				
				printf "\n\033[1m Press any key to return.\033[0m"

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
				
				###Field printing - if statement
				
				{
				if($4 == yearToSearch)
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
				}' albumslist.csv
read -sn1
break
done
}


########################################
###Edit genres sub menu and functions###
########################################
###Please ignore this bit, I have read the feedback after I started working on the script.
function editGenres {
	while true 
	do
		clear
		printf "\n\033[1:36m=====================================================\033[0m\n"
		printf "\033[1:33m                Search Albums                          \033[0m\n"
		printf "\033[1:36m=====================================================\033[0m\n\n"
		printf "\033[1m%s\033[0m \n" \
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
		cat genres.txt | sort;
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


#########################################
###add testing albums - only for video###
#########################################

function addTestingAlbums {

printf "1,Hybrid Theory,Linkin Park,2000,Nu Metal,12,Warner Bros,123456789012\n2,Meteora,Linkin Park,2003,Nu Metal,13,Warner Bros,123456789013\n3,Back in Black,AC/DC,1980,Hard Rock,10,Atlantic,123456789014\n4,Thriller,Michael Jackson,1982,Pop,9,Epic,123456789015\n5,Master of Puppets,Metallica,1986,Metal,8,Elektra,123456789016\n6,The Dark Side of the Moon,Pink Floyd,1973,Progressive Rock,10,Harvest,123456789017\n7,Nevermind,Nirvana,1991,Grunge,12,DGC,123456789018\n8,Appetite for Destruction,Guns N' Roses,1987,Hard Rock,12,Geffen,123456789019\n9,The Eminem Show,Eminem,2002,Hip Hop,20,Shady,123456789020\n10,OK Computer,Radiohead,1997,Alternative Rock,12,Parlophone,123456789021\n11,1989,Taylor Swift,2014,Pop,13,Big Machine,123456789022\n12,Abbey Road,The Beatles,1969,Rock,17,Apple,123456789023\n13,American Idiot,Green Day,2004,Punk Rock,13,Reprise,123456789024\n14,Random Access Memories,Daft Punk,2013,Electronic,13,Columbia,123456789025\n15,Revolver,The Beatles,1966,Rock,14,Parlophone,123456789026\n16,Ten,Pearl Jam,1991,Grunge,11,Epic,123456789027\n17,The Wall,Pink Floyd,1979,Progressive Rock,26,Harvest,123456789028\n18,Born to Run,Bruce Springsteen,1975,Rock,8,Columbia,123456789029\n19,Hotel California,Eagles,1976,Rock,9,Asylum,123456789030\n20,Black Holes and Rev.,Muse,2006,Alternative Rock,11,Warner Bros,123456789031\n" >> albumslist.csv

printf "Testing albums added"
read -sn1
}

while true
do
	menu
done
