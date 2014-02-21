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
      hash = process_hash hash, options
      keys = hash.keys
      model = Struct.new(*keys)
      out = model.new
      hash.each do |key, value|
        out.send("#{key}=", self.from_object(value, options))
      end
      out
    end

    private

    def self.process_hash hash, options
      remap = hash.map do |key, value|
        key = underscore_key key unless options[:to_snake_keys] == false
        [key.to_sym, value]
      end
      Hash[remap]
    end

    def self.underscore_key(key)
      if key.is_a? Symbol
        underscore(key.to_s)
      elsif key.is_a? String
        underscore(key)
      else
        key
      end
    end

    def self.underscore(string)
      string.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
    end
  end
end
