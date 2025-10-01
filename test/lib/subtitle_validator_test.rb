require 'test_helper'

class SubtitleValidatorTest < ActiveSupport::TestCase
  VALID_SUBTITLE = <<~SUBTITLE
    1
    00:01:26,013 --> 00:01:31,559
    What do they call it ?
    They call it a Royale with Cheese.

    2
    00:01:32,502 --> 00:01:40,971
    Royale with Cheese.
    That's right.
  SUBTITLE

  BLANK_CUE = <<~SUBTITLE
    1
    00:01:26,013 --> 00:01:31,559

    2
    00:01:32,502 --> 00:01:40,971
    Royale with Cheese.
    That's right.
  SUBTITLE

  test 'for valid subtitle returns empty array' do
    skip
    assert_empty SubtitleValidator.new(VALID_SUBTITLE).errors
  end

  test 'returns error messages when the subtitles contain errors' do
    skip
    assert_equal ['Cue#1 is empty'], SubtitleValidator.new(BLANK_CUE).errors
  end

  test 'returns all error messages when the subtitles contain multiple errors' do
    skip
    two_empty_cues = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559

      2
      00:01:32,502 --> 00:01:40,971
    SUBTITLE

    assert_equal ['Cue#1 is empty', 'Cue#2 is empty'], SubtitleValidator.new(two_empty_cues).errors
  end

  test '.validate! raises with errors when any errors exist' do
    skip
    e = assert_raises SubtitleValidator::ValidationError do
      SubtitleValidator.new(BLANK_CUE).validate!
    end
    assert_equal 'Cue#1 is empty', e.message
  end

  test 'returns errors for cues with more than 2 lines of text' do
    skip
    cue_2_has_three_lines = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      What do they call it ?
      They call it a Royale with Cheese.

      2
      00:01:32,502 --> 00:01:40,971
      Royale with Cheese.
      That's right.
      Very.
    SUBTITLE
    assert_equal ['Cue#2 has 3 or more lines'], SubtitleValidator.new(cue_2_has_three_lines).errors
  end

  test 'returns errors on invalid SRT structure' do
    skip
    cue_2_doesnt_start_with_index_digits = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      What do they call it ?
      They call it a Royale with Cheese.

      SECOND
      00:01:32,502 --> 00:01:40,971
      Royale with Cheese.
      That's right.
    SUBTITLE

    assert_equal ['Failed to match group of lines 2 starting: SECOND'],
                 SubtitleValidator.new(cue_2_doesnt_start_with_index_digits).errors
  end

  test 'returns errors for cues with non incrementing timecodes per cue' do
    skip
    cue_2_starts_before_cue_1_ends = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      What do they call it ?
      They call it a Royale with Cheese.

      2
      00:01:30,559 --> 00:01:32,971
      Royale with Cheese.
      That's right.
    SUBTITLE
    assert_equal ['Cue#2 has a non-incrementing timecode'], SubtitleValidator.new(cue_2_starts_before_cue_1_ends).errors
  end

  test 'returns errors if the final cue extends beyond the film duration' do
    skip
    assert_equal ['Subtitle duration (100.971) is longer than film duration (4 seconds)'],
                 SubtitleValidator.new(VALID_SUBTITLE, expected_film_duration: 4).errors
  end

  test 'returns errors for cues with invalid timecodes' do
    skip
    assert_equal ['Timecode 00:001:26,013 is badly formed'],
                 SubtitleValidator.new(
                   <<~SUBTITLE
                     1
                     00:001:26,013 --> 00:01:31,559
                     foo
                   SUBTITLE
                 ).errors,
                 'should check for errors in the minutes segment of the timecode'

    assert_equal ['Timecode 00:00:126,013 is badly formed'],
                 SubtitleValidator.new(
                   <<~SUBTITLE
                     1
                     00:00:126,013 --> 00:01:31,559
                     foo
                   SUBTITLE
                 ).errors,
                 'should check for errors in the seconds segment of the timecode'

    assert_equal ['Timecode 00:00:26,13 is badly formed'],
                 SubtitleValidator.new(
                   <<~SUBTITLE
                     1
                     00:00:26,13 --> 00:01:31,559
                     foo
                   SUBTITLE
                 ).errors,
                 'should check for errors in the milliseconds segment of the timecode'

    assert_equal ['Timecode 00:00: 26,013 is badly formed'],
                 SubtitleValidator.new(
                   <<~SUBTITLE
                     1
                     00:00: 26,013 --> 00:01:31,559
                     foo
                   SUBTITLE
                 ).errors,
                 'should not accept spaces in the middle of a timestamp'
  end

  test 'raises no errors for cues with supported HTML tags' do
    skip
    subtitle_with_supported_html_tags = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      What do they call it ?
      They call it a <i>Royale with Cheese.</i>

      2
      00:01:32,502 --> 00:01:40,971
      Royale with <b>Cheese</b>.
      That's right.
    SUBTITLE

    assert_empty SubtitleValidator.new(subtitle_with_supported_html_tags).errors
  end

  test 'returns errors for cues with unsupported HTML tags' do
    skip
    subtitle_with_unsupported_html_tags = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      What do they call it ?
      They call it a <marquee>Royale with Cheese.</marquee>

      2
      00:01:32,502 --> 00:01:40,971
      Royale with Cheese.
      That's right.
    SUBTITLE

    assert_equal ['Cue#1 contains invalid HTML tags'], SubtitleValidator.new(subtitle_with_unsupported_html_tags).errors
  end

  test 'returns errors for cues with badly formed HTML like unclosed or unopened tags' do
    skip
    subtitle_with_unsupported_html_tags = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      What do they call it ?
      They call it a <i>Royale with Cheese.

      2
      00:01:32,502 --> 00:01:40,971
      Royale with Cheese.
      That's right.

      3
      00:01:42,125 --> 00:01:45,732
      What do they call a Big Mac?</i>
    SUBTITLE

    assert_equal ['Cue#1 contains badly formed HTML', 'Cue#3 contains badly formed HTML'], SubtitleValidator.new(subtitle_with_unsupported_html_tags).errors
  end

  test 'returns errors for cues with empty HTML tags' do
    skip
    subtitle_with_empty_html_tags = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      What do they call it ?
      They call it a <i></i>Royale with Cheese.

      2
      00:01:32,502 --> 00:01:40,971
      Royale with Cheese.
      That's right.
    SUBTITLE

    assert_equal ['Cue#1 contains empty HTML tags'], SubtitleValidator.new(subtitle_with_empty_html_tags).errors
  end

  test 'returns errors for cues with HTML tags without content' do
    skip
    subtitle_with_contentless_html_tags = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      They call it a <i>
      </i>Royale with Cheese.

      2
      00:01:32,502 --> 00:01:40,971
      Royale with Cheese.
      That's right.
    SUBTITLE

    assert_equal ['Cue#1 contains empty HTML tags'], SubtitleValidator.new(subtitle_with_contentless_html_tags).errors
  end

  test 'returns errors for cues with a duration less than one frame' do
    skip
    subtitle_with_short_cue = <<~SUBTITLE
      1
      00:01:26,013 --> 00:01:31,559
      What do they call it ?
      They call it a Royale with Cheese.

      2
      00:01:32,502 --> 00:01:32,543
      Royale with Cheese.
      That's right.
    SUBTITLE

    assert_equal ['Cue#2 has a too short duration'], SubtitleValidator.new(subtitle_with_short_cue).errors
  end

  test 'returns an error message if the encoding is not UTF-8' do
    skip
    string_that_is_not_valid_utf8 = "\xFE\xFF\x00\x52"
    assert_equal ["Invalid file encoding. UTF-8 required."],
                 SubtitleValidator.new(string_that_is_not_valid_utf8).errors
  end
end
