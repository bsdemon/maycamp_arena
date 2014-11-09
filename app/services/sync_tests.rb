class SyncTests

  def initialize(tests_updated_at)
    @tests_updated_at = tests_updated_at
  end

  def call
    last_update = ::Configuration.get(::Configuration::TESTS_UPDATED_AT)
    if last_update > tests_updated_at
      puts "Tests changed at #{last_update}, while the current version is from #{tests_updated_at}. Syncing..."
      sync_tests(last_update)
    end

    tests_updated_at
  end

  private

  attr_reader :tests_updated_at

  def sync_tests(update_time)
    sync_sets(get_config)
    @tests_updated_at = update_time
    puts "Tests synced for time #{tests_updated_at} on #{Time.now}"
  end

  def sync_sets(configuration)
    from = File.join(configuration[:rsync], "/")
    to = File.join($config[:sets_root], "/")
  
    puts "Syncing tests from #{from} to #{to}"
    system "rsync -azv -e ssh --delete #{from} #{to}"
  end
end