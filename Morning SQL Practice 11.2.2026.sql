-- Problem 1: Which credited performers have at least 5 Top 20 songs,
-- with those songs averaging at least 25 weeks on the chart?
-- Include performer, song count, and average chart weeks.
-- Sort by longest average chart stay, then highest song count.

select performer, count(*) as Songs, avg(weeks_on_chart) as AvgWeeks
from dbo.hot100_clean
where peak_position <= 20
group by performer
having count(*) >= 5
and avg(weeks_on_chart) >= 25
order by AvgWeeks desc, Songs desc;

-- Problem 2: Excluding Drake and Glee Cast, which credited performers
-- have at least 8 songs with a nonmissing Spotify track ID
-- and an average peak position of 30 or better?
-- Include performer, song count, average peak, and longest chart stay.
-- Sort by best average peak, then highest song count.

select performer, count(*) as Songs, avg(peak_position) as Peakzilla, max(weeks_on_chart) as LongestStay
from dbo.hot100_clean
where spotify_track_id is not null
and performer <> 'Drake' and performer <> 'Glee Cast'
group by performer
having count(*) >= 8
and avg(peak_position) <= 30
order by Peakzilla asc, Songs desc;

-- Problem 3: We're putting together a report on artists with staying power.
-- Which performers have at least 6 songs that each lasted 20 weeks or more
-- on the chart? I'd like their song count, average chart stay, and best
-- peak position, with the longest averages first. If there's a tie,
-- put whoever has more qualifying songs first.
-- Use dbo.hot100_clean.

select performer, count(*) as Songs, avg(weeks_on_chart) as AvgWeeks, min(peak_position) as Topp
from dbo.hot100_clean
where weeks_on_chart >= 20
group by performer
having count(*) >= 6
order by AvgWeeks desc, Songs desc;

-- Problem 4: We're reviewing artists for a promotional campaign.
-- Which artists appear on at least 2 Top 20 songs?
-- Only consider songs whose titles contain neither 'Summer' nor 'Rain'.
-- Include artist, qualifying song count, average peak, and best peak.
-- Put the strongest average peak first, then the highest song count.

select a.artist, count(*) as Songs, avg(s.peak_position) as AvgPeak, min(s.peak_position) as Best
from dbo.SongArtists as a
inner join dbo.songs as s
on a.song_id = s.song_id
where s.peak_position <= 20
and s.song not like '%Summer%' and s.song not like '%Rain%'
group by a.artist
having count(*) >= 2
order by AvgPeak asc, Songs desc;

-- Problem 5: We need to check how complete our artist credits are.
-- For every Top 40 song, show its ID, title, peak position,
-- and number of credited artists. Include songs with no artist mapping,
-- showing an artist count of zero.
-- Put songs with the fewest artists first, then best peak position,
-- then title alphabetically.

select s.song_id, s.song, s.peak_position, count(a.artist) as ArtistCount
from songs as s
left join SongArtists as a
on s.song_id = a.song_id
where s.peak_position <= 40
group by s.song_id, s.song, s.peak_position
order by count(a.artist) asc, s.peak_position asc, s.song asc;

-- Problem 6: We want to promote Top 40 songs with smaller artist lineups.
-- Find songs with fewer than 2 credited artists, including songs
-- that have no artist mapping.
-- Include song ID, title, peak position, and artist count.
-- Put the best peak position first, then title alphabetically.

select s.song_id, s.song, s.peak_position, count(a.artist) as ArtistCount
from dbo.songs as s
left join SongArtists as a
on s.song_id = a.song_id
where s.peak_position <= 40
group by s.song_id, s.song, s.peak_position
having count(a.artist) < 2
order by s.peak_position asc, s.song asc;