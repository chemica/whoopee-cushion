require 'test_helper'

describe 'Inflating complex JSON' do
  before do
    @json = '{"one": 1, "two": "2", "three": "three", "recurse": {"z":1000, "y": "999"}, "array": [1,2,{"foo": "bar"}]}'
  end

  it 'should generate objects' do
    obj = WhoopeeCushion::Inflate.from_json @json
    assert_equal 1, obj.one
    assert_equal 'three', obj.three
    assert obj.recurse.is_a?(Struct), 'Hash not available'
    assert obj.array.is_a?(Array), 'Array not available'
    assert_equal 1000, obj.recurse.z
    assert_equal 1, obj.array[0]
    assert_equal "bar", obj.array[2].foo
  end
end

describe 'converting keys to snake case' do
  before do
    @json = { 'CaseOne' => 'FirstCase', 'caseTwo' => 'secondCase', 'case_three' => 'third_case', 'CASEFour' => '4' }
  end

  it 'should convert CamelCase' do
    obj = WhoopeeCushion::Inflate.from_hash @json
    assert_equal 'FirstCase', obj.case_one
  end

  it 'should convert camelBack' do
    obj = WhoopeeCushion::Inflate.from_hash @json
    assert_equal 'secondCase', obj.case_two
  end

  it 'should convert CAMELCase with acronyms' do
    obj = WhoopeeCushion::Inflate.from_hash @json
    assert_equal '4', obj.case_four, "Could not find case_four: #{obj.inspect}"
  end

  it 'should not convert camel case with snake keys option false' do
    obj = WhoopeeCushion::Inflate.from_hash @json, :convert_keys => false
    assert_equal 'FirstCase', obj.CaseOne
  end

  it 'should not convert camel back with snake keys option false' do
    obj = WhoopeeCushion::Inflate.from_hash @json, :convert_keys => false
    assert_equal 'secondCase', obj.caseTwo
  end

  it 'should leave snake case alone with snake keys option false' do
    obj = WhoopeeCushion::Inflate.from_hash @json, :convert_keys => false
    assert_equal 'third_case', obj.case_three
  end

  it 'should leave snake case alone without snake keys option false' do
    obj = WhoopeeCushion::Inflate.from_hash @json
    assert_equal 'third_case', obj.case_three
  end
end

describe 'converting recursive hashes' do
  before do
    @json = { 'CaseOne' => {'caseTwo' => { 'ThisIsCaseThree' => 'value' } } }
  end

  it 'should convert keys to snake case and get the value' do
    obj = WhoopeeCushion::Inflate.from_hash @json
    assert_equal 'value', obj.case_one.case_two.this_is_case_three
  end

  it 'should not convert keys to snake case with snake keys option false' do
    obj = WhoopeeCushion::Inflate.from_hash @json, :convert_keys => false
    assert_equal 'value', obj.CaseOne.caseTwo.ThisIsCaseThree
  end
end

describe 'converting deep arrays' do
  before do
    @json = { 'CaseOne' => [ { 'caseTwo' => 2, 'CaseThree' => [ { 'CaseFour' => 'four'}, 5 ] } ] }
  end

  it 'should get deep array values correctly' do
    obj = WhoopeeCushion::Inflate.from_hash @json
    assert_equal 2, obj.case_one[0].case_two
    assert_equal 'four', obj.case_one[0].case_three[0].case_four
    assert_equal 5, obj.case_one[0].case_three[1]
  end

  it 'should get deep array values correctly with snake keys option false' do
    obj = WhoopeeCushion::Inflate.from_hash @json, :convert_keys => false
    assert_equal 2, obj.CaseOne[0].caseTwo
    assert_equal 'four', obj.CaseOne[0].CaseThree[0].CaseFour
    assert_equal 5, obj.CaseOne[0].CaseThree[1]
  end
end

describe 'converting from array' do
  it "should return plain values unchanged" do
    obj = WhoopeeCushion::Inflate.from_array [1, 2, 3, 'four', 'FiveFive', 'sixSix']
    assert_equal 1, obj[0]
    assert_equal 2, obj[1]
    assert_equal 3, obj[2]
    assert_equal 'four', obj[3]
    assert_equal 'FiveFive', obj[4]
    assert_equal 'sixSix', obj[5]
  end

  describe 'with an embedded hash' do
    before do
      @array = [1,2,3,'four',{'power' => 'to', 'ThePeople' => 'now'}]
    end

    it 'should convert an embedded hash' do
      obj = WhoopeeCushion::Inflate.from_array @array
      assert_equal 1, obj[0]
      assert_equal 'to', obj[4].power
      assert_equal 'now', obj[4].the_people
    end

    it 'should convert an embedded hash without changing keys with snake keys option false' do
      obj = WhoopeeCushion::Inflate.from_array @array, :convert_keys => false
      assert_equal 'now', obj[4].ThePeople
    end
  end
end

describe 'converting keys' do
  it 'should use the lambda if possible' do
    hash = {'power' => 'to', 'the_people' => 'now', 'bar' => {'interesting' => 'times'}}
    obj = WhoopeeCushion::Inflate.from_hash hash, :convert_keys => lambda {|s| "#{s}_foo"}
    assert_equal 'to', obj.power_foo
    assert_equal 'times', obj.bar_foo.interesting_foo
  end
end