require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  fixtures :countries

  test "fixtures are correctly loaded" do
    assert_equal 'France', countries(:france).name
    assert_equal "France", @france.name
  end

  test "name must be present" do
    country = Country.new
    country.save
    assert_equal 1, country.errors.count
  end
 
  test "country is created" do
    country = Country.create(:name => 'Utopia')
    assert_equal 'Utopia', country.name
  end

end
