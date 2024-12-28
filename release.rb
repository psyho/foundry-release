#!/usr/bin/env ruby

require "fileutils"

if ARGV.length != 2
  puts "Usage: release.rb <path_to_foundry_zip> <version>"
  exit
end

foundry_zip = ARGV[0]
version = ARGV[1]

foundry_dir = "/tmp/foundry"
foundry_app_dir = "#{foundry_dir}/resources/app"
foundry_repo_dir = File.expand_path("../foundry-vtt", __dir__)

FileUtils.rm_rf(foundry_dir)
FileUtils.mkdir_p(foundry_dir)

puts "Unzipping #{foundry_zip} to #{foundry_dir}"
system("unzip -q #{foundry_zip} -d #{foundry_dir}")

puts "Checking out latest version of foundry-vtt"
system("cd #{foundry_repo_dir} && git reset --hard origin/main && git checkout main && git pull")

puts "Removing all tracked files from #{foundry_repo_dir}"
system("cd #{foundry_repo_dir} && git rm -r --cached .")

puts "Copying files from #{foundry_app_dir} to #{foundry_repo_dir}"
FileUtils.cp_r("#{foundry_app_dir}/.", foundry_repo_dir)

puts "Copying start.sh to #{foundry_repo_dir}"
FileUtils.cp("start.sh", foundry_repo_dir)

puts "Adding all files to git"
system("cd #{foundry_repo_dir} && git add --all .")

puts "Committing changes"
system("cd #{foundry_repo_dir} && git commit -m 'Release #{version}'")

puts "Tagging release"
system("cd #{foundry_repo_dir} && git tag -fa v#{version} -m 'Release #{version}'")

puts "Pushing changes and tags"
system("cd #{foundry_repo_dir} && git push origin main --tags")
