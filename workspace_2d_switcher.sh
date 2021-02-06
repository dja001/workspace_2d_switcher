#!/bin/bash

#2D switcher for workspaces linux mint 20.1

#wraps around like in old NES games

#For some reason, mint cinnamon only supports a single row of workspaces
#The basic idea of this script is to find the 1d workspace assuming a 2D
#grid of size ni x nj

#2D layout for the workspaces is provided by the workspace grid (2D) and switcher
#xdotool  is used for switching to a specific workspace
#both must be instaled for this to work

#this script must be called with "up" "down" "left" "right" as a single argument
#
#  eg:      workspace_2d_switcher.sh left

#the script is then run through a custom keyboard shortcuts that you must set.
#
# eg:   <control>Left    calls the script as above


#grid size must be  hard coded as I have'nt figure out a way to read this info anywhere
#Any help wih this would be appreciated. 

#Here is the convention used to go from 1D workspace indices to i and j that must be 
#incremented

#          One D indices:
#  
#  0       0     1     2     3     4   
#  1       5     6     7     8     9    
#  2      10    11    12    13    14   
#  ^ 
#  j 
#     i >  0     1     2     3     4


set -ex

#number of columns
ni=5
#number of rows
nj=3

if [[ -z "$1" ]] ; then
    echo "Need one argument"
    exit 1
else
    direction="$1"
fi


#1D index of workspace where we are
oned_ind=$(xdotool get_desktop)

#i and j indices
j_ind=$(( $oned_ind / $ni ))
i_ind=$(( $oned_ind - ($j_ind * ni) ))

#i or j indices are incremented depending on argument
if [[ $direction == up ]] ; then
    if [[ $j_ind == 0 ]] ; then
        j_ind=$(( $nj - 1 ))
    else
        j_ind=$(( $j_ind - 1 ))
    fi

elif [[ $direction == down ]] ; then
    if [[ $j_ind == $(($nj - 1)) ]] ; then
        j_ind=0
    else
        j_ind=$(( $j_ind + 1 ))
    fi

elif [[ $direction == left ]] ; then
    if [[ $i_ind == 0 ]] ; then
        i_ind=$(( $ni - 1 ))
    else
        i_ind=$(( $i_ind - 1 ))
    fi

elif [[ $direction == right ]] ; then
    if [[ $i_ind == $(($ni - 1)) ]] ; then
        i_ind=0
    else
        i_ind=$(( $i_ind + 1 ))
    fi
else
    echo 'Argument may only be "up" "down" "left" "right"'
    exit 1
fi

new_oned_ind=$(( $j_ind * $ni + $i_ind ))

xdotool set_desktop $new_oned_ind


