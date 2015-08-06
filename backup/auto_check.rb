#! /usr/bin/ruby

## Old methods: use '/bin/sh'
# touch -cm ${SRCROOT}/../../../version.dat
# touch -cm ${SRCROOT}/../../../project.json
# find ${SRCROOT}/../../../src -name '*' -exec touch -cm {} \;
# find ${SRCROOT}/../../../res -name '*' -exec touch -cm {} \;

require 'digest'
require 'pathname'

def compare_file(file1, file2)
	if not File.exist?(file1)
		puts "😡  File not exist: #{file1}"
		return
	end

	if not File.exist?(file2)
		puts "😡  File not exist: #{file2}"
		return
	end

	if Digest::MD5.file(file1) == Digest::MD5.file(file2)
		puts "😍  Touch: #{file2}"
		system("touch -cm #{file2}")
	end
end

def compare_dir(dir1, dir2)
	path1 = Pathname.new(dir1)
	path2 = Pathname.new(dir2)

	if not path1.exist?
		puts "😡  Directory not exist: #{path1}"
		return
	end

	if not path2.exist?
		puts "😡  Directory not exist: #{path2}"
		return
	end

	sig1 = Dir[path1 + '**/*'].map do |filepath|
		if File.file?(filepath)
			[filepath, Digest::MD5.file(filepath)]
		end
	end.compact!

	sig2 = Dir[path2 + '**/*', path2 + '*'].map do |filepath|
		if File.file?(filepath)
			[filepath, Digest::MD5.file(filepath)]
		end
	end.compact!

	sig2.each do |a|	
		modified = true

		sig1.each do |b|
			if a[1] == b[1]
				modified = false
				break
			end
		end

		if modified
			puts "😍  Touch: '#{a[0]}'"
			system("touch -cm #{a[0]}")
		end
	end
end


def main(args)
	configuration = ENV['CONFIGURATION'] # Debug or Release
	target_build_dir = ENV['TARGET_BUILD_DIR'] # /Users/gaofei/Projects/jssanguo/runtime/mac
	wrapper_name = ENV['WRAPPER_NAME'].to_s # jssanguo Mac.app
	tmp = wrapper_name.split(" ")
	wrapper_name = tmp.join("\ ")

	project_path = args[0] || Pathname.new("#{ENV['SRCROOT']}/../../../")
	target_path = nil
	if wrapper_name =~ /Mac/
		puts "😡  Seems mac doesn't need this ..."
		return
	elsif wrapper_name =~ /iOS/
		target_path = Pathname.new(target_build_dir) + wrapper_name
	else
		puts "😡  Unrecorgnized wrapper name: #{wrapper_name}"
		return
	end

	puts "😚  Mode: #{configuration}"
	puts "😚  Project Path: #{project_path}"
	puts "😚  Target Path: #{target_path}"
	puts "😚  Wrapper Name: #{wrapper_name}"
	puts ""

	test = target_path+'project.json'
	if not (test).exist?
		puts "test not exist: #{test}"
	end

	if not target_path.exist?
		puts "😡  Target Path not exist."
		return
	end


	case configuration
	when 'Debug'
		# 1. 'project.json'
		puts "👀  Comparing project.json ..."
		compare_file(target_path + 'project.json', project_path + 'project.json')
		# 2. 'version.dat'
		puts "👀  Comparing version.dat ..."
		compare_file(target_path + 'version.dat', project_path + 'version.dat')
		# 3. *.js
		puts "👀  Comparing js file in root ..."
		Dir[project_path + '*.js'].each do |file|
			pn = Pathname.new(file)
			target_file = target_path + pn.basename
			if File.exist?(target_file)
				compare_file(target_file, file)
			end
		end
		# 4. /res
		puts "👀  Comparing 'res' ..."
		compare_dir(target_path + 'res', project_path + 'res')
		# 5. /src
		puts "👀  Comparing 'src' ..."
		compare_dir(target_path + 'src', project_path + 'src')
		
		puts "😃  Done!"
	when 'Release'
		puts "😡  TODO: Copy jsc files..."
	else
		puts "😡  Undefined mode: #{configuration}"
	end
end

main(ARGV)




