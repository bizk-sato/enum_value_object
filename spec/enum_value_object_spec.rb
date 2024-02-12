RSpec.describe EnumValueObject do
  before(:all) do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
    ActiveRecord::Schema.define do
      create_table :users do |t|
        t.integer :status
      end
    end

    class Disabled; def can_login?; false; end; end
    class Enabled; def can_login?; true; end; end

    class User < ActiveRecord::Base
      include EnumValueObject
      enum status: { disabled: 0, enabled: 1, no_klass: 2 }, value_object: true, _prefix: true
    end
  end

  it "has a version number" do
    expect(EnumValueObject::VERSION).not_to be nil
  end

  it "extends enum with value object behavior" do
    user = User.new(status: :enabled)
    expect(user.status_object.can_login?).to be true

    user.status = :disabled
    expect(user.status_object.can_login?).to be false
  end

  it "raises an error unless Class for enum key is defined" do
    user = User.new(status: :no_klass)
    expect { user.status_object }.to raise_error(EnumValueObject::Error)
  end

  it "returns the correct enum value object" do
    user = User.new(status: :enabled)
    expect(user.status_object).to be_an_instance_of(Enabled)
    expect(user.status_object.can_login?).to be true

    user.status = :disabled
    expect(user.status_object).to be_an_instance_of(Disabled)
    expect(user.status_object.can_login?).to be false
  end
end
