# frozen_string_literal: true

require_relative 'orchestrator'

include ActiveRecord::Tasks

class Seeder
  def initialize(seed)
    @seed = seed
  end

  def load_seed
    raise "Seed file '#{@seed}' does not exist" unless File.file? @seed

    load @seed_file
  end
end

DatabaseTasks.env = Orchestrator.env.to_sym
root = File.expand_path __dir__
config_path = File.join(root, 'config', 'database.yml')
file_data = File.read(config_path)
parsed_data = ERB.new(file_data).result
DatabaseTasks.database_configuration = YAML.safe_load(parsed_data, aliases: true)
DatabaseTasks.db_dir = File.join root, 'db'
DatabaseTasks.fixtures_path = File.join root, 'spec/fixtures'
DatabaseTasks.migrations_paths = [File.join(root, 'db/migrate')]
DatabaseTasks.seed_loader = Seeder.new File.join root, 'db/seeds.rb'
DatabaseTasks.root = root

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection Orchestrator.env.to_sym
end

load 'active_record/railties/databases.rake'
