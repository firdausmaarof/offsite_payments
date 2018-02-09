module OffsitePayments
  module Integrations
    module ShopifyPayment

      mattr_accessor :recurring_charge_end_point
      self.recurring_charge_end_point = "/admin/recurring_application_charges"

      mattr_accessor :application_charge_end_point
      self.application_charge_end_point = "/admin/application_charges"

      def self.notification(params, options = {})
        Notification.new(params, options)
      end

      class Helper < OffsitePayments::Helper

      end

      class Notification < OffsitePayments::Notification
        include ActiveUtils::PostsData
        
        def charge_id
          params['charge_id']
        end

        def package
          params['package']
        end

        def shopify_token
          @options[:shopify_token]
        end

        def shopify_domain
          @options[:shopify_domain]
        end

        def charge_type
          @options[:charge_type]
        end

        def service_url
          if charge_type == "recurring"
            "https://#{shopify_domain}#{ShopifyPayment.recurring_charge_end_point}/#{charge_id}/activate.json"
          else
            "https://#{shopify_domain}#{ShopifyPayment.application_charge_end_point}/#{charge_id}/activate.json"
          end
        end

        # Acknowledge the transaction to ShopifyPayment. This method has to be called after a new
        # apc arrives. ShopifyPayment will verify that all the information we received are correct and will return a
        # ok or a fail.
        #
        # Example:
        #
        #   def ipn
        #     notify = ShopifyPaymentNotification.new(request.raw_post)
        #
        #     if notify.acknowledge
        #       ... process order ... if notify.complete?
        #     else
        #       ... log possible hacking attempt ...
        #     end
        def acknowledge
          uri = URI.parse(service_url)

          request = Net::HTTP::Post.new(uri.path)
          request['X-Shopify-Access-Token'] = shopify_token

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true

          response = http.request(request)
          response = JSON.parse(response.body)
          status = response["recurring_application_charge"]["status"]

          raise StandardError.new("Faulty ShopifyPayment result: #{response.body}") unless ["accepted", "active"].include?(status)

          ["accepted", "active"].include?(status)
        end

        private
        def parse(post)
          @raw = post.to_s
          @params = post
        end
      end
    end
  end
end
