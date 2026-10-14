# VALORANT Map Hypothesis Testing

The companion repository for my blog post in which I test the "fairness" of
the VALORANT unrated map selection system. Particularly, I statistically test
whether or not the unrated map selection process is:

1. **Uniform**, i.e. each map is equally likely to appear.
2. **Independent**, i.e. the previously selected maps have no impact on the next map to be selected.

## Data Collection
The data was generated from a single player's queue history which was recorded automatically by
[tracker.gg](https://tracker.gg/valorant/). Only unrated games played between the dates
25th June 2026 - 14th August 2026 (a subset of the in-game season V26: A4)
were included in the data set. The player's IGN will not be revealed for
anonymity

A chronological list of map names was compiled using the tracker.gg records.
That is, the very first map name in the list is the map played for the first unrated
match and the very last map name is the name of the map played for the last unrated
match in the dataset. This list can be found in `data/maps.csv`.
