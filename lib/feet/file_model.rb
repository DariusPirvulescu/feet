require 'multi_json'

module Feet
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename

        # If filename is "dir/21.json", @id is 21
        basename = File.split(filename)[-1]
        @id = File.basename(basename, '.json').to_i

        row_object = File.read(filename)
        @hash = MultiJson.load(row_object)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue Errno::ENOENT
          nil
        end
      end

      def self.all
        files = Dir['db/quotes/*.json']
        files.map { |f| FileModel.new f }
      end

      def self.create(attrs)
        # Create hash
        hash = {}
        hash['attribution'] = attrs['attribution'] || ''
        hash['submitter'] = attrs['submitter'] || ''
        hash['quote'] = attrs['quote'] || ''

        # Find highest id
        files = Dir['db/quotes/*.json']
        names = files.map { |f| File.split(f)[-1] } # transform to_i here?
        highest = names.map(&:to_i).max
        id = highest + 1

        # Open and write the new file
        new_filename = "db/quotes/#{id}.json"
        File.open("db/quotes/#{id}.json", 'w') do |f|
          f.write <<~TEMPLATE
            {
                "submitter": "#{hash['submitter']}",
                "quote": "#{hash['quote']}",
                "attribution": "#{hash['attribution']}"
            }
          TEMPLATE
        end

        # Create new FileModel instance with the new file
        FileModel.new new_filename
      end
    end
  end
end
