require 'twitter'
require 'yaml'

# config load
config_info = Psych.load_file('config/twitter.yaml')
config_info = Psych.load(config_info)

desc 'Find competitions on twitter retweet and follow'
task :Scrape => :environment do

  # config setup
  client = Twitter::REST::Client.new do |config |
    config.consumer_key = config_info['twitter_consumer_key']
    config.consumer_secret = config_info['twitter_consumer_secret']
    config.access_token = config_info['twitter_access_token']
    config.access_token_secret = config_info['twitter_access_token_secret']
  end

  log = ActiveSupport::Logger.new('log/tweets.log')
  start_time = Time.now
  log.info "Service started at #{start_time}"

# can only take 15 tweets at a time due to rate limits
  client.search('retweet #win', result_type: 'popular', include_rts: false, lang: 'en', count: 100).take(15).collect do |tweet |
    begin "#{client.follow(tweet.user.id)}: #{client.retweet(tweet)}"
    rescue Twitter::Error => error
      puts "ERROR: #{error} - #{tweet.id} - #{tweet.text}"
      log.info "ERROR: #{error} - #{tweet.id} - #{tweet.text}"
    else
      puts "SUCCESS: Retweeted successfully - #{tweet.id} - #{tweet.text}"
      log.info "SUCCESS: Retweeted successfully - #{tweet.id}"
      next
    end
  end

# rate limit resets after 15 minutes
  sleep 960

  client.search('rt #win', result_type: 'popular', include_rts: false, lang: 'en', count: 100).take(15).collect do |tweet |
    begin "#{client.follow(tweet.user.id)}: #{client.retweet(tweet)}"
    rescue Twitter::Error => error
      puts "ERROR: #{error} - #{tweet.id} - #{tweet.text}"
      log.info "ERROR: #{error} - #{tweet.id} - #{tweet.text}"
    else
      puts "SUCCESS: Retweeted successfully - #{tweet.id} - #{tweet.text}"
      log.info "SUCCESS: Retweeted successfully - #{tweet.id}"
      next
    end
  end

  sleep 960

  client.search('retweet #competitions', result_type: 'popular', include_rts: false, lang: 'en', count: 100).take(15).collect do |tweet |
    begin "#{client.follow(tweet.user.id)}: #{client.retweet(tweet)}"
    rescue Twitter::Error => error
      puts "ERROR: #{error} - #{tweet.id} - #{tweet.text}"
      log.info "ERROR: #{error} - #{tweet.id} - #{tweet.text}"
    else
      puts "SUCCESS: Retweeted successfully - #{tweet.id} - #{tweet.text}"
      log.info "SUCCESS: Retweeted successfully - #{tweet.id}"
      next
    end
  end

  sleep 960

  client.search('rt #competitions', result_type: 'popular', include_rts: false, lang: 'en', count: 100).take(15).collect do |tweet |
    begin "#{client.follow(tweet.user.id)}: #{client.retweet(tweet)}"
    rescue Twitter::Error => error
      puts "ERROR: #{error} - #{tweet.id} - #{tweet.text}"
      log.info "ERROR: #{error} - #{tweet.id} - #{tweet.text}"
    else
      puts "SUCCESS: Retweeted successfully - #{tweet.id} - #{tweet.text}"
      log.info "SUCCESS: Retweeted successfully - #{tweet.id}"
      next
    end
  end

  end_time = Time.now
  duration = (start_time - end_time) / 1. minute
  log.info "Task finished at #{end_time} and last #{duration} minutes."
  log.close

end