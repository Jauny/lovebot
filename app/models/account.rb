require 'twitter'

class Account < ApplicationRecord
  def spread_the_love
    logger.info(message: 'spreading the love', account: self.name)

    client = self.twitter_client
    since_id = self.last_loved || 1
    mentions = client.mentions_timeline :count => 50, since_id: since_id
    logger.info(message: 'got recent mentions', account: self.name, since_id: since_id, count: mentions.length)

    if mentions.any?
      logger.info(message: 'favoriting mentions', account: self.name)
      client.favorite(mentions)

      last_loved_id = mentions.first.id
      logger.info(message: 'updating last_loved', account: self.name, last_loved: last_loved_id)
      self.update last_loved: last_loved_id

      logger.info(message: 'done spreading the love', account: self.name, count: mentions.length)
    end
  end

  def twitter_client
    @client || @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter[:api_key]
      config.consumer_secret     = Rails.application.secrets.twitter[:secret]
      config.access_token        = self.access_token
      config.access_token_secret = self.access_token_secret
    end
  end
end
