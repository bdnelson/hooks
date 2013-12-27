#!/usr/bin/env ruby

require 'rubygems'
require 'git'

# Grab last commit
#   @git.dir - source directory
#   @git.branch.name - current branch name
#
#   @last_commit.sha - SHA
#   @last_commit.sha.slice(0,10) - Shortened SHA
#   @last_commit.message
#   @last_commit.author [.name, .email, .date]
#   @last_commit.committer [.name, .email, .date]
@git = Git.open(`pwd`.chomp)
@last_commit = @git.log.first
@snapshot_time = Time.now.to_i
@home_directory = "/Users/bdnelson"

# Break up repo 
@repo = @git.dir.path.gsub("#{@home_directory}/", "")
@repo = @repo.gsub("src/", "")

# Capture commit information
data_file = "#{@home_directory}/.gitcommits/#{@last_commit.committer.date.strftime("%Y%m%d")}.data"
File.open(data_file, "a+") do |fp|
  fp.puts "# #{@repo}: #{@last_commit.message}"
  fp.puts ""
  fp.puts "## Details"
  fp.puts " * *Commit:* #{@last_commit.sha}"
  fp.puts " * *Date:* #{@last_commit.author.date}"
  fp.puts " * *Author:* #{@last_commit.author.name}"
  fp.puts " * *Email:* #{@last_commit.author.email}"
  fp.puts ""
end

# Take camera snapshot
# From: https://coderwall.com/p/xlatfq
snapshot_file="#{@home_directory}/.gitshots/#{@snapshot_time}-#{@last_commit.sha}.jpg"
system "imagesnap -q -w 3 #{snapshot_file} &"

#`say 'Commit logging complete'`

exit 0
