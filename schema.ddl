drop schema if exists Movie cascade;
create schema Movie;
set search_path to Movie;

create domain Department as varchar(20)
    default null
    check (value in ('Directing', 'Acting', 'Writing'));

create domain Award as varchar(20)
    default null
    check (value in ('Best Picture', 'Best Actor', 'Best Actress', 'Best Director'));

create domain Platform as varchar(20)
    default null
    check (value in ('Netflix', 'Hulu', 'Prime Video', 'IMDb', 'Rotten Tomatoes'));

create domain RatingScore as numeric(10, 2)
    default null
    check (value>=0 and value <=5.0);

create domain Year as smallint
    default null
    check (value>=1900 and value<=2020);

create table MoviePlatform(
    pID integer primary key,
    name varchar(25) not null,
    type varchar(25)
);

create table Title(
    tID integer primary key,
    name varchar(25) not null,
    platform integer,
    foreign key (platform) references MoviePlatform(pID),
    year Year,
    director integer,
    genre varchar(20),
    country varchar(20)
);

create table Crew(
    cID integer primary key,
    firstName varchar(25) not null,
    lastName varchar(25) not null,
    title integer not null,
    foreign key (title) references Title(tID),
    dept Department,
    country varchar(20)
);

create table Rating(
    title integer not null,
    platform integer not null,
    foreign key (platform) references MoviePlatform(pID),
    foreign key (title) references Title(tID),
    score RatingScore,
    type varchar(25),
    primary key (platform, title, score)
);

create table Oscars(
    award Award,
    year Year,
    title integer not null,
    winner integer,
    foreign key (title) references Title(tID),
    foreign key (winner) references Crew(cID),
    primary key (award, year, title, winner)
);

create table UserReview(
    uID integer primary key,
    username varchar(25) not null,
    platform integer,
    title integer,
    foreign key (platform) references MoviePlatform(pID),
    foreign key (title) references Title(tID),
    rating RatingScore
);

alter table Title add foreign key (director) references Crew(cID);
