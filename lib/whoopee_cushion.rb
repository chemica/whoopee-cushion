require 'whoopee_cushion/version'
require 'json'

module WhoopeeCushion

  class Inflate

    def self.from_json(string, options = {})
      value = JSON.parse string
      from_object value, options
    end

    def self.from_object(value, options = {})
      case value
      when Array
        from_array value, options
      when Hash
        from_hash value, options
      else
        value
      end
    end

    def self.from_array(value, options = {})
      value.map {|v| from_object v, options}
    end

    def self.from_hash(hash, options = {})
      @iter ||= 1
      keys, values = process_hash hash, options
      Struct.new(*keys).new(*values)
    end

    private

    def self.process_hash hash, options
      keys = []
      values = []
      hash.each do |k,v|
        keys << (options[:convert_keys] == false ? k : underscore_key(k, options)).to_sym
        values << from_object(v, options)
      end
      # Split the keys and values to arrays for 1: speed and 2: backwards compatibility with Ruby < 1.9
      # where hashes are unordered
      [keys, values]
    end

    def self.underscore_key(string, options)
      return options[:convert_keys].call(string) if options[:convert_keys]

      string.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
                  gsub(/([a-z\d])([A-Z])/,'\1_\2').
                  downcase
    end
  end
end
