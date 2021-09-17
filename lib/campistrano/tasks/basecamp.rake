namespace :basecamp do
  namespace :deploy do

    desc 'Notify about starting deploy'
    task :starting do
      Campistrano::Capistrano.new(self).run(:starting)
    end

    desc 'Notify about updating deploy'
    task :updating do
      Campistrano::Capistrano.new(self).run(:updating)
    end

    desc 'Notify about reverting deploy'
    task :reverting do
      Campistrano::Capistrano.new(self).run(:reverting)
    end

    desc 'Notify about updated deploy'
    task :updated do
      Campistrano::Capistrano.new(self).run(:updated)
    end

    desc 'Notify about reverted deploy'
    task :reverted do
      Campistrano::Capistrano.new(self).run(:reverted)
    end

    desc 'Notify about failed deploy'
    task :failed do
      Campistrano::Capistrano.new(self).run(:failed)
    end

    desc 'Test Basecamp integration'
    task :test => %i[starting updating updated reverting reverted failed] do
      # all tasks run as dependencies
    end

  end
end

before 'deploy:starting',           'basecamp:deploy:starting'
before 'deploy:updating',           'basecamp:deploy:updating'
before 'deploy:reverting',          'basecamp:deploy:reverting'
after  'deploy:finishing',          'basecamp:deploy:updated'
after  'deploy:finishing_rollback', 'basecamp:deploy:reverted'
after  'deploy:failed',             'basecamp:deploy:failed'
