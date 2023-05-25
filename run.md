# How to evaluate trackers using TrackEval
Assuming you already 
1) git cloned this repository, installed all the requirements 
2) have a tracker that outputs a text file with the following format:
    ```
    [frame_num, bb_left, bb_top, bb_right, bb_bottom, track_id] (coordinates order: x1, y1, x2, y2)
    ```
## 0. Setup
- Install all the requirements in `TrackEval/requirements.txt`
- Make sure you have all the ground-truth data ready in `TrackEval/data/gt`
- Note that `duck_6` is removed from the train set. 


## 1. Convert the tracker output to required format
- Convert the tracker output to the MOTChallenge format using `TrackEval/utils/convert_tracker_format.py`:
    ```
    python convert_tracker_format.py --raw_tracker_path <path-to-tracker-output> --convert_path <path-to-conversion-output>
    ```
    This script runs for each video, and I'm planning to make a wrapper script that runs it for all videos in a test/train set.
- For now, the convert_path should be like `TrackEval/data/trackers/mot_challenge/AnimalTrack-<test/train>/<tracker-model>/data/<seq-name>`.
    ex. `TrackEval/data/trackers/mot_challenge/AnimalTrack-test/DeepSORT/data/chicken_1.txt`

## 2. Run TrackEval
``` 
# Usage
python ./TrackEval/scripts/run_mot_challenge.py --BENCHMARK AnimalTrack --SPLIT_TO_EVAL <train/test> --USE_PARALLEL False --DO_PREPROC False

# ex. 
python /home/n0/xxxx/Programs/TrackEval/scripts/run_mot_challenge.py --BENCHMARK AnimalTrack --SPLIT_TO_EVAL train --USE_PARALLEL False --DO_PREPROC False 
```
- more options available in `TrackEval/scripts/run_mot_challenge.py`

- What it does
    - evaluate the tracker output in `TrackEval/data/trackers/mot_challenge/AnimalTrack-<test/train>/<tracker-model>/data` 
    - can set the evaluation mode to train or test. The sequence names are specified in `TrackEval/data/gt/mot_challenge/seqmaps`
    - if not specified, will run evaluation for all trackers (ex. DeepSORT)
    - save the results for each tracker in tracker data folder (`TrackEval/data/trackers/mot_challenge/AnimalTrack-<test/train>/<tracker-model>`)