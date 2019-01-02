use v6;
use WWW;

sub get-show-info($show_stub) {
    my $response = jget "https://www.tunefind.com/api/frontend/show/$show_stub?fields=seasons&metatags=1";
    return $response<seasons>.list;
}


sub get-season-info($season) {
    my $response = jget "https://www.tunefind.com/api/frontend/show/the-leftovers/season/$season?fields=episodes,theme-song,music-supervisors,hot-songs,top-users,related-questions-season&metatags=1";
    return $response<episodes>.list;
}


sub get-episode-songs($episode_id) {
    my $response = jget "https://www.tunefind.com/api/frontend/episode/$episode_id?fields=song-events,questions";
    my @songs = $response<song_events>.list;
    for @songs -> $song {
        put "$song<song><name>\t\t\t--$song<song><artist><name>";
    }
}


# retrieve show info including season links
my @seasons = get-show-info('the-leftovers');

# split out season ids for further fetching
for @seasons -> $s {
    my @episodes = get-season-info($s<group_sequence>);
    for @episodes -> $e {
        get-episode-songs($e<id>);
        sleep(5);
    }
}





