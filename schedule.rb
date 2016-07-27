# 32 minutes just to be careful of rate limits
every 32.minutes do
  rake 'Scrape'
end