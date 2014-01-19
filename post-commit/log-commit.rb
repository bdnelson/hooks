#!/usr/bin/env ruby

require 'rubygems'
require 'git'

# Open git repository.  If it fails on the first try, go to the parent
# directory of the current location and try again (case where the project
# is in a subdirectory and the tool - e.g. IntelliJ IDEA - is using the 
# project directory as the root of execution).  
@git = Git.open(`pwd`.chomp) rescue nil
if @git.nil?
  @git = Git.open(`pwd`.chomp + "/../") rescue nil
  if @git.nil? 
    puts "ERROR: Unable to open git repository in '#{`pwd`}' or its parent directory."
    exit
  end
end

# Grab last commit
#   @git.dir - source directory
#   @git.branch.name - current branch name
#
#   @last_commit.sha - SHA
#   @last_commit.sha.slice(0,10) - Shortened SHA
#   @last_commit.message
#   @last_commit.author [.name, .email, .date]
#   @last_commit.committer [.name, .email, .date]
@last_commit = @git.log.first

# Other info we need
@snapshot_time = Time.now.to_i
@home_directory = "/Users/bdnelson"

# Break up repo path for tracking
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

# Vocalization of completion - handy for testing but annoying otherwise
#`say 'Commit logging complete'`

exit 0
