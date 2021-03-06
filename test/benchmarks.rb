require 'whoopee_cushion'
require 'byebug'
require 'benchmark'
require 'recursive-open-struct'

def benchmarks
  puts 'Benchmarking 10000 operations on deep hash:'

  hash = {:aaaaBbbb => 'ccccDDDD',
          :a => 2, :b => 2, :c => 2, :d => 2, :e => 2,
          :f => 2, :g => 2, :h => 2, :i => 2, :j => 2,
          :k => 2, :l => 2, :m => 2, :n => 2, :o => 2,
          :p => 2, :q => 2, :r => 2, :s => 2, :t => 2,
          'eeeeEeee' =>[{'NameThe1' => {'CamelName' => 4444},
                         'NameThe3' => [4,5,6]}, '3', '4']}
  puts 'whoopee-cushion'
  puts Benchmark.measure {
    10000.times do
      a = WhoopeeCushion::Inflate.from_hash hash, :convert_keys => false
      raise 'Incorrect value found' if a.eeeeEeee.first.NameThe3[0] != 4
    end
  }

  puts 'whoopee-cushion with camel to snake case conversion'
  puts Benchmark.measure {
    10000.times do
      a = WhoopeeCushion::Inflate.from_hash hash
      raise 'Incorrect value found' if a.eeee_eeee.first.name_the3[0] != 4
    end
  }

  puts 'recursive-open-struct gem for comparison'
  puts Benchmark.measure {
    10000.times do
      a = RecursiveOpenStruct.new hash, :recurse_over_arrays => true
      raise 'Incorrect value found' if a.eeeeEeee.first.NameThe3[0] != 4
    end
  }

  puts ''
  puts 'Benchmarking 10000 whoopee-cushion conversions of a shallow hash:'

  hash = {:a => 2, :b => 2, :c => 2, :d => 2, :e => 2,
          :f => 2, :g => 2, :h => 2, :i => 2, :j => 2,
          :k => 2, :l => 2, :m => 2, :n => 2, :camelBackCase => "Lorem Ipsum"}


  puts Benchmark.measure {
    10000.times do
      x = WhoopeeCushion::Inflate.from_hash hash, :convert_keys => false
      x.camelBackCase
    end
  }

  puts 'Benchmarking 10000 whoopee-cushion conversions of a shallow hash with camel case conversion:'
  puts Benchmark.measure {
    10000.times do
      x = WhoopeeCushion::Inflate.from_hash hash
      x.camel_back_case
    end
  }

  puts "Benchmarking 10000 OpenStruct creates with a shallow hash"

  puts Benchmark.measure {
    10000.times do
      x = OpenStruct.new(hash)
      x.camelBackCase
    end
  }
end
