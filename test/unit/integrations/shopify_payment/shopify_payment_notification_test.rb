require 'test_helper'

class ShopifyPaymentNotificationTest < Test::Unit::TestCase
  include OffsitePayments::Integrations

  def setup
    @shopify_payment = ShopifyPayment::Notification.new(http_raw_data)
  end

  def test_accessors
    assert @shopify_payment.complete?
    assert_equal "", @shopify_payment.status
    assert_equal "", @shopify_payment.transaction_id
    assert_equal "", @shopify_payment.item_id
    assert_equal "", @shopify_payment.gross
    assert_equal "", @shopify_payment.currency
    assert_equal "", @shopify_payment.received_at
    assert @shopify_payment.test?
  end

  def test_compositions
    assert_equal Money.from_amount(31.66, 'USD'), @shopify_payment.amount
  end

  # Replace with real successful acknowledgement code
  def test_acknowledgement

  end

  def test_send_acknowledgement
  end

  def test_respond_to_acknowledge
    assert @shopify_payment.respond_to?(:acknowledge)
  end

  private
  def http_raw_data
    ""
  end
end
