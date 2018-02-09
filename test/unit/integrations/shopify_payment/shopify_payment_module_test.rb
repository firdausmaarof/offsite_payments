require 'test_helper'

class ShopifyPaymentTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def test_notification_method
    assert_instance_of ShopifyPayment::Notification, ShopifyPayment.notification('name=cody')
  end
end
