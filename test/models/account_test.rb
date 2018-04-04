require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  @@new_auth_hash = {
    info: {
      nickname: 'new_account'
    },
    credentials: {
      token: 'lkjh',
      secret: 'hkjkl'
    }
  }

  @@active_auth_hash = {
    info: {
      nickname: 'active'
    },
    credentials: {
      token: 'lkjh',
      secret: 'hkjkl'
    }
  }

  @@not_active_auth_hash = {
    info: {
      nickname: 'not_active'
    },
    credentials: {
      token: 'lkjh',
      secret: 'hkjkl'
    }
  }

  test "create default to active" do
    account = Account.create
    assert account.active
  end

  test "update_or_create_from_auth_hash should create new account" do
    new_account = Account.find_by_name('new_account')
    assert_not new_account, 'new_account not found'

    Account.update_or_create_from_auth_hash(@@new_auth_hash)
    new_account = Account.find_by_name('new_account')
    assert new_account, 'new account found'

    assert new_account.active, 'new account is active'
    assert_equal new_account.access_token, @@new_auth_hash[:credentials][:token]
    assert_equal new_account.access_token_secret, @@new_auth_hash[:credentials][:secret]
  end

  test "update_or_create_from_auth_hash should update existing account" do
    existing = Account.find_by_name('active')
    assert existing, 'existing account found'
    refute_equal existing.access_token, @@active_auth_hash[:credentials][:token]
    refute_equal existing.access_token_secret, @@active_auth_hash[:credentials][:secret]

    Account.update_or_create_from_auth_hash(@@active_auth_hash)
    existing.reload
    assert_equal existing.access_token, @@active_auth_hash[:credentials][:token]
    assert_equal existing.access_token_secret, @@active_auth_hash[:credentials][:secret]
  end

  test "update_or_create_from_auth_hash should update activate inactive account" do
    not_active = Account.find_by_name('not_active')
    refute not_active.active, 'account is not active'

    Account.update_or_create_from_auth_hash(@@not_active_auth_hash)
    not_active.reload
    assert not_active.active, 'account is now active'
  end
end
