#!/bin/bash

# !! Make sure you replaced all 3 < path > in the for loop that fits your system !! 

# Usage: bash run_tracker.sh <video source folder> <output folder> <model name> <mode> 
# Example: bash run_tracker.sh /home/username/AnimalTrack/train/videos /home/username/AnimalTrack/train/result deepsort train 

# Check if all required arguments are provided
if [ $# -ne 4 ]; then
  echo "Usage: bash run_tracker.sh <video source folder> <output folder> <model name> <mode>"
  exit 1
fi

src=$1 # Folder with videos (ex. duck_5.mp4) to track
out=$2 # Folder to save results 
model=$3 # model name (ex. deepsort)
mode=$4 # train or test 
log="$out/log.txt" 


echo "Video source folder: $src" >> $log
echo "Output folder: $out" >> $log
echo "Model: $model" >> $log
echo "Mode: $mode" >> $log

# Create output folder for evaluation
mkdir -p "TrackEval/data/trackers/mot_challenge/AnimalTrack-$mode/$model/data"

for vid in $src/*; do
    echo "Analyzing $vid, starting at $(date)" >> $log
    vid_name=$(basename $vid .mp4) # ex. duck_5
    mkdir -p $out/$vid_name
    
    # Run tracker
    python3 < track.py > --source $vid --output $out/$vid_name --save-txt True # will be saved under $out/$vid_name/raw_tracker.csv

    # Convert to MOT format 
    python3 < TrackEval >/utils/convert_tracker_format.py \ 
    --raw_tracker_path $out/$vid_name/raw_tracker.csv \
    --convert_path < TrackEval >/data/trackers/mot_challenge/AnimalTrack-$mode/$model/data/$vid_name.txt
done

