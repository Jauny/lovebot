require 'twitter'

class Account < ApplicationRecord

  before_create :default_values

  def self.update_or_create_from_auth_hash(auth_hash)
    account = Account.where(name: auth_hash[:info][:nickname]).first_or_create
    account.update(
      active: true,
      access_token: auth_hash[:credentials][:token],
      access_token_secret: auth_hash[:credentials][:secret]
    )
    account
  end

  def spread_the_love
    logger.info(message: 'spreading the love', account: self.name)

    begin
      client = twitter_client

      since_id = self.last_loved || 1
      mentions = client.mentions_timeline :count => 1, since_id: since_id
      logger.info(message: 'got recent mentions', account: self.name, since_id: since_id, count: mentions.length)

      if mentions.any?
        logger.info(message: 'favoriting mentions', account: self.name)
        client.favorite(mentions)

        last_loved_id = mentions.first.id
        logger.info(message: 'updating last_loved', account: self.name, last_loved: last_loved_id)
        self.update last_loved: last_loved_id

        logger.info(message: 'done spreading the love', account: self.name, count: mentions.length)
      end
    rescue Twitter::Error::Unauthorized
      logger.error(message: 'Twitter::Error::Unauthorized happened', account: self.name)
      deactivate!
    end
  end

  def deactivate!
    self.active = false
    self.save
  end

  private
  def twitter_client
    begin
      @client || @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.secrets.twitter[:api_key]
        config.consumer_secret     = Rails.application.secrets.twitter[:secret]
        config.access_token        = self.access_token
        config.access_token_secret = self.access_token_secret
      end
    rescue => e
      logger.error(message: 'Something went wront while getting Twitter client', error: e, account: self.name)
    end
  end

  def default_values
    self.active = true
    self.last_loved = 1
  end
end
