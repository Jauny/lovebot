desc "Spread the love for all active accounts"
task :spread_all_the_love  => :environment do
  Rails.logger.info message: "Starting :spread_all_the_love task"
	Account.where(active: true) do |account|
    account.spread_all_the_love
  end
end