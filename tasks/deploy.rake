# Based on https://gist.github.com/4253885 and https://gist.github.com/362873

namespace :deploy do
  STAGING_APP    = 'noitehoje-webapp-staging'
  PRODUCTION_APP = 'noitehoje-webapp'

  desc 'Deploy app to staging'
  task :staging           => [:set_staging_app, :off, :push, :on]
  task :staging_rollback  => [:set_staging_app, :off, :push_previous, :restart, :on]

  desc 'Deploy app to production'
  task :production            => [:set_production_app, :off, :push, :on, :tag]
  task :production_rollback   => [:set_production_app, :off, :push_previous, :restart, :on]

  task :set_staging_app do
    APP = STAGING_APP
  end

  task :set_production_app do
    APP = PRODUCTION_APP
  end

  task :push do
    puts 'Deploying site to Heroku ...'
    puts `git push git@heroku.com:#{APP}.git`
  end

  task :restart do
    puts 'Restarting app servers ...'
    puts `heroku restart --app #{APP}`
  end

  task :tag do
    release_name = "#{APP}_release-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    puts "Tagging release as '#{release_name}'"
    puts `git tag -a #{release_name} -m 'Tagged release'`
    puts `git push --tags git@heroku.com:#{APP}.git`
  end

  task :off do
    puts 'Putting the app into maintenance mode ...'
    puts `heroku maintenance:on --app #{APP}`
  end

  task :on do
    puts 'Taking the app out of maintenance mode ...'
    puts `heroku maintenance:off --app #{APP}`
  end

  task :push_previous do
    prefix = "#{APP}_release-"
    releases = `git tag`.split("\n").select { |t| t[0..prefix.length-1] == prefix }.sort
    current_release = releases.last
    previous_release = releases[-2] if releases.length >= 2
    if previous_release
      puts "Rolling back to '#{previous_release}' ..."

      puts "Checking out '#{previous_release}' in a new branch on local git repo ..."
      puts `git checkout #{previous_release}`
      puts `git checkout -b #{previous_release}`

      puts "Removing tagged version '#{previous_release}' (now transformed in branch) ..."
      puts `git tag -d #{previous_release}`
      puts `git push git@heroku.com:#{APP}.git :refs/tags/#{previous_release}`

      puts "Pushing '#{previous_release}' to Heroku master ..."
      puts `git push git@heroku.com:#{APP}.git +#{previous_release}:master --force`

      puts "Deleting rollbacked release '#{current_release}' ..."
      puts `git tag -d #{current_release}`
      puts `git push git@heroku.com:#{APP}.git :refs/tags/#{current_release}`

      puts "Retagging release '#{previous_release}' in case to repeat this process (other rollbacks)..."
      puts `git tag -a #{previous_release} -m 'Tagged release'`
      puts `git push --tags git@heroku.com:#{APP}.git`

      puts "Turning local repo checked out on master ..."
      puts `git checkout master`
      puts 'All done!'
    else
      puts "No release tags found - can't roll back!"
      puts releases
    end
  end
end
