#!/bin/bash

ITEM_File="u.item"
DATA_File="u.data"
USER_File="u.user"


echo "--------------------------"
echo "User Name: Kwon Shin-Beom"
echo "Student Number: 12223693"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.data'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release data' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"



while :
do 
	echo -n "Enter your choice [ 1~9 ] "
	read order

	case $order in 
		1) 
			echo -e -n "\nPlease enter 'movie id'(1~1682):"
		        read movieId
			echo 
			echo $movieId | awk -F"|" -v id="$movieId" '$1 == id { print }' "$ITEM_File"
			echo 

			;;
		2) 
			echo -e -n "\nDo you want to get the data of 'action' genre movies from 'u.item'? (y/n):"
			read ans
			echo 
			if [ "$ans" = "y" ]; then
				awk -F "|" '$7 == 1 { print $1 " " $2}' "$ITEM_File" | sort -n | head -n 10
				echo 
			fi

			;;
		3)
			echo -e -n "\nPlease enter the 'movie id' (1~1682):"
			read movieId
			echo 
			rating=$(awk -F "\t" -v id="$movieId" '$2 == id {sum += $3; n++} END {printf "%.5f", sum / n}' "$DATA_File")
			echo -e "average rating of $movieId: $rating\n"

			;;
		4)
			echo -e -n  "\nDo you want to delete the 'IMDb URL' from 'u.item'?(y/n):"
			read ans
			echo 
			if [ "$ans" = "y" ]; then
				sed -n '1,10 s/http[^|]*//p' "$ITEM_File"
				echo 
			fi

			;;
		5) 
			echo -e -n "\nDo you want to get the data about users from 'u.user'?(y/n):"
			read ans
			echo
			if [ "$ans" = "y" ]; then 
				sed -n '1,10 { 
					s/^\([0-9]*\)|\([0-9]*\)|\(M\)|\([^|]*\)|.*/User \1 is \2 years old Male \4/;
					s/^\([0-9]*\)|\([0-9]*\)|\(F\)|\([^|]*\)|.*/User \1 is \2 years old Female \4/;
					p}' "$USER_File"
				echo
			fi

			;;
		6)		
			echo -e -n  "\nDo you want to Modify teh format of 'release data' in 'u.item'?(y/n):"
			read ans
			echo 
			if [ "$ans" = "y" ]; then
				sed -n '1673,1682 {
					s/\([0-9]\{2\}\)-Jan-\([0-9]\{4\}\)/\201\1/;
					s/\([0-9]\{2\}\)-Feb-\([0-9]\{4\}\)/\202\1/;
					s/\([0-9]\{2\}\)-Mar-\([0-9]\{4\}\)/\203\1/;
					s/\([0-9]\{2\}\)-Apr-\([0-9]\{4\}\)/\204\1/;
					s/\([0-9]\{2\}\)-May-\([0-9]\{4\}\)/\205\1/;
					s/\([0-9]\{2\}\)-jun-\([0-9]\{4\}\)/\206\1/;
					s/\([0-9]\{2\}\)-Jul-\([0-9]\{4\}\)/\207\1/;
					s/\([0-9]\{2\}\)-Aug-\([0-9]\{4\}\)/\208\1/;
					s/\([0-9]\{2\}\)-Sep-\([0-9]\{4\}\)/\209\1/;
					s/\([0-9]\{2\}\)-Oct-\([0-9]\{4\}\)/\210\1/;
					s/\([0-9]\{2\}\)-Nov-\([0-9]\{4\}\)/\211\1/;
					s/\([0-9]\{2\}\)-Dec-\([0-9]\{4\}\)/\212\1/;
				p}' "$ITEM_File"
				echo
			fi

			;;
		7) 
			echo -e -n "\nPlease enter the 'user id' (1~943):"
			read userId
			echo
			
			rating=$(awk -F "\t" -v id="$userId" '$1 == id { print $2 }' "$DATA_File" | sort -n | tr "\n" "|")
			movieIds=$(awk -F "\t" -v id="$userId" '$1 == id { print $2 }' "$DATA_File" | sort -n | tr "\n" " ")

			echo -e "$rating\n"

			for movieId in $movieIds; do 
				movieTitle=$(awk -F "|" -v id="$movieId" '$1 == id { print $2 }' "$ITEM_File")
				echo -e "$movieId|$movieTitle"
			done | head -n 10

			echo

			;;
		8)
			echo -e -n "\nDo you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):"
			read ans
			echo

			if [ "$ans" = "y" ]; then
				result=$(awk -F "|" '$2 >= 20 && $2 <= 29 && $4 == "programmer" { print $1 }' "$USER_File" | tr "\n" " ")
					
				for userId in $result; do 
					awk -F "\t" -v id="$userId" '$1 == id { print $2 "|" $3 }' "$DATA_File" >> info.txt
				done 

				awk -F "|" '{
					sum[ $1 ] += $2
					count[ $1 ]++
				} END {
					for ( movieId in sum ) {
						avg = sum[ movieId ] / count [ movieId ]
						printf("%d %.5f\n", movieId, avg)
					}
				}' info.txt | sort -n
				echo	

				rm info.txt				
			fi 
			;;
		9)
			echo -e "Bye!\n"
			exit 0
			;;

	esac
done
