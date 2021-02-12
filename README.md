# MUBI Rails Technical Test

Hey, thanks for agreeing to take our technical test. We've tried to give you an
interesting problem that's related to our domain (films and film streaming),
without being too overwhelming with all the many concepts that a
nearly-15-year-old application brings.

That said, if anything is confusing at all, please do ask your contact at MUBI.
This test is relatively new and so it's very possible that something which seems
obvious to us is actually quite confusing! We will get you back on track, and
you'll also be helping us make this test better.

## What we are looking for

This test has several parts, which we will outline below. The purpose of the
test is for us to be able to see how you think and how you approach software
development, so please take whatever opportunities you can to show your
approach, or even ideas you considered but didn't use, or things that still
aren't clear. 

A great way to do this is by using small commits with detailed messages. Another
great way is by writing tests.

We don't want you to spend days on this, but please do take the time to produce
a solution you would be comfortable deploying. That way, we will learn as much
as possible about your approach to development.

## Getting started

You should have the codebase associated with this README. It is a bare Rails
application, with nothing significant inside it except a couple of test files.
However, you'll still want to get your environment set up.

You may wish to fork this repository into your local github account, but for
privacy reasons you may also wish to simply clone it and then either work on it
privately, or in a private repository you control. As long as we can see your
work, whatever you prefer is fine, but please coordinate this with your contact
at the start of the exerise.

For reference, the test was build against Ruby 2.7.2, and the application is set
up for a MySQL database. If you would prefer to run it against Postgres, that's
fine too.

## Background

In this test, we're going to be validating subtitle files, which we use quite a
lot in MUBI since our films come from all over the world.

Subtitle files are simple text files that contain a list of "cues", which
contain timecodes and some text to display on the screen.

Here's a sample of a subtitle file, with two cues:

    1
    00:01:26,013 --> 00:01:31,559
    What do they call it ?
    They call it a Royale with <b>Cheese</b>.

    2
    00:01:32,502 --> 00:01:40,971
    Royale with <i>Cheese</i>. That's right

For each cue:

* It starts with a number, starting at 1 and incrementing for each cue;
* The timecode line has a start and finish, and describe a time in hours,
  minutes, seconds and milliseconds, which are the timestamps within the film
  where these subtitles should be displayed. Note that the first subtitle
  typically doesn't start at "0" -- there are a couple of minutes of title
  screens before the dialogue, normally;
* Cues can have one or two lines of text, but no more or less than that;
* Cue contents can contain the simple italic and bold HTML tags, but nothing
  else;
* Each cue must have a duration of at least one frame, given 24 frames per
  second;
* Between each cue is a blank line.

There are some other properties which are described in more detail in the test
file you'll be looking at in Part 1.

## Part 1

In the first part of the test, we'll just be writing Ruby code, without much
thought about Rails itself. We will be writing a simple module to validate the
contents of subtitle files.

Take a look at the file `test/lib/subtitle_validator.rb`. The first part of
this test is to make all those tests pass. Right now, they are almost all
skipped. You will need to create the `SubtitleValidator` class (I suggest you
put it in `app/lib`, but you don't have to), and then add any methods or other
code to make the tests pass.

You do not need to make all the tests pass at once. I suggest you work through
them one at a time, and once you have one test passing, remove the `skip` from
the next one and make whatever changes are required to get it to also pass. This
step-by-step approach is a good opportunity for you to communicate your approach
(see "What we are looking for" above).

You will know you've finished Part 1 when you can run `rake` to run all the
tests, and there are no failures, and no skipped tests. Good job!

If you're struggling with some of the tests, that's OK. Don't stall there; just
leave them commented out and move on to Part 2.

## Part 2

Next, we want to start using this module with Rails. We would like you to build
a simple interface that lets us upload subtitle files and have them stored in
the database.

Typically in production we would actually store data like this using some
storage service, but for the purposes of this task you can store the contents
directly in the database as an attribute.

We expect:

* A way to upload new subtitle contents, storing the filename along side the
  subtitle contents themselves
* A listing of all uploaded subtitles, with a way to view them, and other
  typical CRUD actions
* Communication of any errors when we try to upload files that don't pass the
  validations

We will be looking for Rails' best practice approaches to this. If you haven't
used Rails in a while, or are tightly focussed on niche practices like API-only
development, we suggest you spend a little time refreshing yourself.

Feel free to use any gems or libraries that you would like. If you prefer
PostgreSQL to MySQL, or RSpec to MiniTest, or any other library, please do feel
free to use them - whatever helps you build a solution that you are confident
in.

Don't worry too much about the visual aspect.

A longer sample subtitles file is included in the fixtures within the Rails
application. You can also find others on the internet, if you like.
